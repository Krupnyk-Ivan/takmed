import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import the actual files you are testing
import 'package:takmed/medicine_pages/first_aid_category_screen.dart'; // Adjust the path
import 'package:takmed/database/medicine_db/medicine_database_helper.dart'; // Adjust the path
import 'package:takmed/database/medicine_db/medicine.dart'; // Adjust the path

// Generate a mock class for MedicineDatabaseHelper
// Run 'flutter pub run build_runner build' in your terminal after adding this.
@GenerateMocks([MedicineDatabaseHelper])
import 'first_aid_category_screen_test.mocks.dart';

void main() {
  // Create a mock instance of the database helper
  late MockMedicineDatabaseHelper mockDbHelper;

  setUp(() {
    // Initialize the mock before each test
    mockDbHelper = MockMedicineDatabaseHelper();
  });

  testWidgets('displays empty message when no medicines are found', (
    WidgetTester tester,
  ) async {
    // Arrange: Make the mock return an empty list
    when(mockDbHelper.getMedicinesByCategory(any)).thenAnswer((_) async => []);

    // Act: Build the widget and wait for the future to complete
    await tester.pumpWidget(
      MaterialApp(
        home: FirstAidCategoryScreen(
          category: 'TestCategory',
          dbHelper: mockDbHelper,
        ),
      ),
    );
    await tester.pumpAndSettle(); // Wait for the FutureBuilder to update

    // Assert: Check if the empty message Text widget is displayed and has the correct text
    // Find the Text widget by type
    final emptyMessageFinder = find.byType(Text);

    // Expect to find exactly one Text widget
    expect(emptyMessageFinder, findsOneWidget);

    // Get the Text widget instance and check its data property
    final textWidget = tester.widget<Text>(emptyMessageFinder);
    expect(
      textWidget.data,
      'Немає медицину в цій категорії.',
    ); // Assert the exact text content

    // Also assert that other widgets are not present
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('displays list of medicines when data is available', (
    WidgetTester tester,
  ) async {
    // Arrange: Create a list of fake medicines, including 'category' and 'note'
    final medicines = [
      Medicine(
        id: 1,
        name: 'Aspirin',
        expirationDate: DateTime.now().add(const Duration(days: 365)),
        iconCode: 0xe0b1, // Example icon code
        isDangerous: false,
        category: 'Pain Relief', // Added required parameter
        note: 'Take with food', // Added required parameter
      ),
      Medicine(
        id: 2,
        name: 'Ibuprofen',
        expirationDate: DateTime.now().subtract(const Duration(days: 30)),
        iconCode: 0xe0b1, // Example icon code
        isDangerous: true,
        category: 'Pain Relief', // Added required parameter
        note: 'Check expiry date', // Added required parameter
      ),
    ];
    // Make the mock return the list of medicines
    when(
      mockDbHelper.getMedicinesByCategory(any),
    ).thenAnswer((_) async => medicines);
    when(
      mockDbHelper.deleteMedicine(any),
    ).thenAnswer((_) async => 1); // Mock delete

    // Act: Build the widget and wait for the future to complete
    await tester.pumpWidget(
      MaterialApp(
        home: FirstAidCategoryScreen(
          category: 'TestCategory',
          dbHelper: mockDbHelper,
        ),
      ),
    );
    await tester.pumpAndSettle(); // Wait for the FutureBuilder to update

    // Assert: Check if the list and list tiles are displayed
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(medicines.length));

    // Verify the content of the list tiles
    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.text('Ibuprofen'), findsOneWidget);

    // Check for the subtitle format (simple check)
    expect(
      find.textContaining('Термін придатності:'),
      findsNWidgets(medicines.length),
    );

    // Check dangerous medicine styling (simple check for color presence)
    final ibuprofenListTile = find.widgetWithText(ListTile, 'Ibuprofen');
    final ibuprofenText = tester.widget<Text>(
      find.descendant(of: ibuprofenListTile, matching: find.text('Ibuprofen')),
    );
    expect(ibuprofenText.style?.color, Colors.red);
    expect(ibuprofenText.style?.fontWeight, FontWeight.bold);

    final aspirinListTile = find.widgetWithText(ListTile, 'Aspirin');
    final aspirinText = tester.widget<Text>(
      find.descendant(of: aspirinListTile, matching: find.text('Aspirin')),
    );
    expect(aspirinText.style?.color, isNull); // Should not be red
    expect(aspirinText.style?.fontWeight, isNull); // Should not be bold
  });

  testWidgets('calls deleteMedicine when delete icon is tapped', (
    WidgetTester tester,
  ) async {
    // Arrange: Create a list with one medicine, including 'category' and 'note'
    final medicines = [
      Medicine(
        id: 1,
        name: 'Aspirin',
        expirationDate: DateTime.now(),
        iconCode: 0xe0b1,
        isDangerous: false,
        category: 'Pain Relief', // Added required parameter
        note: 'Take as needed', // Added required parameter
      ),
    ];
    // Make the mock return the list initially
    when(
      mockDbHelper.getMedicinesByCategory('TestCategory'),
    ).thenAnswer((_) async => medicines);
    // Make the mock return an empty list after deletion (this second mock setup is important for the reload test below)
    when(
      mockDbHelper.getMedicinesByCategory('TestCategory'),
    ).thenAnswer((_) async => []);
    // Mock the delete method
    when(
      mockDbHelper.deleteMedicine(1),
    ).thenAnswer((_) async => 1); // Return the number of rows affected

    // Act: Build the widget and wait for the initial load
    await tester.pumpWidget(
      MaterialApp(
        home: FirstAidCategoryScreen(
          category: 'TestCategory',
          dbHelper: mockDbHelper,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert: Verify that the medicine is no longer displayed and the empty message appears
    expect(find.text('Aspirin'), findsNothing);
    expect(find.text('Немає медицину в цій категорії.'), findsOneWidget);
  });

  testWidgets('reloads medicines after deletion', (WidgetTester tester) async {
    // Arrange: Create initial and post-delete medicine lists, including 'category' and 'note'
    final initialMedicines = [
      Medicine(
        id: 1,
        name: 'Aspirin',
        expirationDate: DateTime.now(),
        iconCode: 0xe0b1,
        isDangerous: false,
        category: 'Pain Relief', // Added required parameter
        note: 'Initial note 1', // Added required parameter
      ),
      Medicine(
        id: 2,
        name: 'Ibuprofen',
        expirationDate: DateTime.now(),
        iconCode: 0xe0b1,
        isDangerous: false,
        category: 'Pain Relief', // Added required parameter
        note: 'Initial note 2', // Added required parameter
      ),
    ];
    final afterDeleteMedicines = [
      Medicine(
        id: 2,
        name: 'Ibuprofen',
        expirationDate: DateTime.now(),
        iconCode: 0xe0b1,
        isDangerous: false,
        category: 'Pain Relief', // Added required parameter
        note: 'Initial note 2', // Added required parameter
      ),
    ];

    // Configure the mock to return different lists on subsequent calls
    when(
      mockDbHelper.getMedicinesByCategory('TestCategory'),
    ).thenAnswer((_) async => initialMedicines);
    when(
      mockDbHelper.deleteMedicine(1),
    ).thenAnswer((_) async => 1); // Mock deletion of item with ID 1

    // Act: Build the widget and wait for the initial load
    await tester.pumpWidget(
      MaterialApp(
        home: FirstAidCategoryScreen(
          category: 'TestCategory',
          dbHelper: mockDbHelper,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify the initial state
    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.text('Ibuprofen'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));

    // Reconfigure the mock for the second call to getMedicinesByCategory
    // We need to set up the mock *before* the setState that triggers the reload
    when(
      mockDbHelper.getMedicinesByCategory('TestCategory'),
    ).thenAnswer((_) async => afterDeleteMedicines);

    // Tap the delete icon for Aspirin (assuming it's the first one)
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle(); // Wait for deletion and reload

    // Assert: Verify that Aspirin is gone and Ibuprofen is still there
    expect(find.text('Aspirin'), findsNothing);
    expect(find.text('Ibuprofen'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(1));

    // Verify that getMedicinesByCategory was called twice (initial load + after delete)
    verify(mockDbHelper.getMedicinesByCategory('TestCategory')).called(2);
    // Verify that deleteMedicine was called once for the correct ID
    verify(mockDbHelper.deleteMedicine(1)).called(1);
  });
}
