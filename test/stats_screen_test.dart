import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Adjust these import paths to match your project structure
import 'package:takmed/profile_pages/stats_screen.dart'; // Path to your StatsScreen file
import 'package:takmed/database/stats_db_helper.dart'; // Path to your DbHelper file

// Regenerate mocks if you haven't:
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([StatsDatabaseHelper])
import 'stats_screen_test.mocks.dart'; // Ensure this file is generated/updated

void main() {
  // --- Test Setup ---
  late MockStatsDatabaseHelper mockDbHelper;

  setUp(() {
    // Create a fresh mock before each test
    mockDbHelper = MockStatsDatabaseHelper();
  });

  // Helper function to pump the widget tree, now injecting the mock
  Future<void> pumpStatsScreen(
    WidgetTester tester,
    MockStatsDatabaseHelper dbHelper,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        // Provide Directionality and other essential Material widgets
        home: StatsScreen(dbHelper: dbHelper), // <<< Inject the mock here
      ),
    );
  }

  // --- Test Cases ---

  testWidgets(
    'StatsScreen shows loading indicator initially and hides after load',
    (WidgetTester tester) async {
      // Arrange: Setup mock to return data after a slight delay (simulating async)
      when(mockDbHelper.getAllStats()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return [];
      });

      // Act: Pump the initial frame
      await pumpStatsScreen(tester, mockDbHelper);

      // Assert: Loading indicator should be present initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Кількість тестів'), findsNothing);

      // Act: Pump again to settle after the future completes
      await tester.pumpAndSettle();

      // Assert: Loading indicator should be gone, empty state shown
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Немає записів.'), findsOneWidget);
    },
  );

  testWidgets('StatsScreen displays empty state when no stats exist', (
    WidgetTester tester,
  ) async {
    // Arrange: Mock the DB call to return an empty list immediately
    when(mockDbHelper.getAllStats()).thenAnswer((_) async => []);

    // Act
    await pumpStatsScreen(tester, mockDbHelper);
    await tester.pumpAndSettle();

    // Assert
    expect(
      find.byType(CircularProgressIndicator),
      findsNothing,
    ); // Loading gone

    // --- Check header cards specifically ---
    // Find the 'Кількість тестів' card and check its value
    final testCountCardFinder = find.ancestor(
      of: find.text('Кількість тестів'),
      matching: find.byType(Card),
    );
    expect(testCountCardFinder, findsOneWidget);
    // *** FIX: Find '0' specifically within the test count card ***
    expect(
      find.descendant(of: testCountCardFinder, matching: find.text('0')),
      findsOneWidget,
    );

    // Find the 'Середній бал' card and check its value
    final avgScoreCardFinder = find.ancestor(
      of: find.text('Середній бал'),
      matching: find.byType(Card),
    );
    expect(avgScoreCardFinder, findsOneWidget);
    expect(
      find.descendant(of: avgScoreCardFinder, matching: find.text('-')),
      findsOneWidget,
    );

    // Find the 'Середній час' card and check its value
    final avgTimeCardFinder = find.ancestor(
      of: find.text('Середній час'),
      matching: find.byType(Card),
    );
    expect(avgTimeCardFinder, findsOneWidget);
    expect(
      find.descendant(of: avgTimeCardFinder, matching: find.text('-')),
      findsOneWidget,
    );

    // Check list state
    expect(find.text('Спроби:'), findsOneWidget); // List header
    expect(find.text('Немає записів.'), findsOneWidget); // Empty list message
  });

  testWidgets('StatsScreen displays stats correctly when data exists', (
    WidgetTester tester,
  ) async {
    // Arrange: Mock the DB call to return sample data
    final mockStats = [
      {'id': 1, 'testId': 'Test A', 'score': 85, 'timeTaken': 120},
      {'id': 2, 'testId': 'Test B', 'score': 95, 'timeTaken': 90},
    ];
    when(mockDbHelper.getAllStats()).thenAnswer((_) async => mockStats);

    // Act
    await pumpStatsScreen(tester, mockDbHelper);
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // --- Check Header Cards ---
    final testCountCardFinder = find.ancestor(
      of: find.text('Кількість тестів'),
      matching: find.byType(Card),
    );
    expect(
      find.descendant(of: testCountCardFinder, matching: find.text('2')),
      findsOneWidget,
    );

    final avgScoreCardFinder = find.ancestor(
      of: find.text('Середній бал'),
      matching: find.byType(Card),
    );
    expect(
      find.descendant(of: avgScoreCardFinder, matching: find.text('90')),
      findsOneWidget,
    );

    final avgTimeCardFinder = find.ancestor(
      of: find.text('Середній час'),
      matching: find.byType(Card),
    );
    expect(
      find.descendant(of: avgTimeCardFinder, matching: find.text('105 сек')),
      findsOneWidget,
    );

    // --- Check List ---
    expect(find.text('Спроби:'), findsOneWidget);
    expect(find.text('Немає записів.'), findsNothing);
  });

  testWidgets(
    'StatsScreen calculates averages correctly with multiple entries',
    (WidgetTester tester) async {
      // Arrange: Mock the DB call with data that requires calculation
      final mockStats = [
        {'id': 1, 'testId': 'T1', 'score': 10, 'timeTaken': 30},
        {'id': 2, 'testId': 'T2', 'score': 20, 'timeTaken': 40},
        {'id': 3, 'testId': 'T3', 'score': 30, 'timeTaken': 50},
      ];
      when(mockDbHelper.getAllStats()).thenAnswer((_) async => mockStats);

      // Act
      await pumpStatsScreen(tester, mockDbHelper);
      await tester.pumpAndSettle();

      // Assert UI reflects calculations
      final testCountCardFinder = find.ancestor(
        of: find.text('Кількість тестів'),
        matching: find.byType(Card),
      );
      expect(
        find.descendant(of: testCountCardFinder, matching: find.text('3')),
        findsOneWidget,
      );

      final totalTimeCardFinder = find.ancestor(
        of: find.text('Загальний час'),
        matching: find.byType(Card),
      );
      // This assertion assumes the widget displays "120 сек"
      expect(
        find.descendant(of: totalTimeCardFinder, matching: find.text('120')),
        findsOneWidget,
      );

      final avgScoreCardFinder = find.ancestor(
        of: find.text('Середній бал'),
        matching: find.byType(Card),
      );
      expect(
        find.descendant(of: avgScoreCardFinder, matching: find.text('20')),
        findsOneWidget,
      );

      final avgTimeCardFinder = find.ancestor(
        of: find.text('Середній час'),
        matching: find.byType(Card),
      );
      expect(
        find.descendant(of: avgTimeCardFinder, matching: find.text('40 сек')),
        findsOneWidget,
      );
    },
  );
}
