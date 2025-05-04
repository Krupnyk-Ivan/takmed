import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:takmed/medicine_pages/add_medicine_screen.dart';
import 'package:takmed/database/medicine_db/medicine_database_helper.dart';
import 'package:takmed/database/medicine_db/medicine.dart';
import 'package:takmed/app_navigator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';

// Mock classes
class MockMedicineDatabaseHelper extends Mock
    implements MedicineDatabaseHelper {}

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  group('AddMedicineScreen Tests', () {
    late MockMedicineDatabaseHelper mockDbHelper;
    late MockFlutterLocalNotificationsPlugin mockNotifications;

    setUp(() {
      mockDbHelper = MockMedicineDatabaseHelper();
      mockNotifications = MockFlutterLocalNotificationsPlugin();
    });

    testWidgets('Test form validation (all fields required)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => AppNavigator(),
            child: AddMedicineScreen(),
          ),
        ),
      );

      // Ensure the "Save" button is disabled when fields are empty
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      expect(saveButton, findsOneWidget);

      // Tap the save button without filling the form
      await tester.tap(saveButton);
      await tester.pump();

      // Verify that a SnackBar appears with an error message
      expect(find.text('Заповніть всі поля'), findsOneWidget);
    });

    testWidgets('Test saving medicine to the database', (
      WidgetTester tester,
    ) async {
      // Simulate filling the form
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => AppNavigator(),
            child: AddMedicineScreen(),
          ),
        ),
      );

      // Fill the form fields
      await tester.enterText(find.byType(TextField).first, 'Aspirin');
      await tester.enterText(find.byType(TextField).last, 'For pain relief');
      await tester.tap(find.byIcon(Icons.medical_services));
      await tester.tap(find.byIcon(Icons.calendar_today));

      // Simulate selecting a date (e.g., tomorrow)
      final date = DateTime.now().add(Duration(days: 1));
      await tester.pumpAndSettle();

      // Select category
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Знеболюючі').last);
      await tester.pumpAndSettle();

      // Ensure Save button is enabled
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      expect(saveButton, findsOneWidget);

      // Create a valid Medicine object
      Medicine medicine = Medicine(
        name: 'Aspirin',
        iconCode: 1234, // Provide an appropriate icon code
        note: 'For pain relief',
        expirationDate: DateTime.now().add(
          Duration(days: 30),
        ), // Set expiration date as 30 days later
        category: 'Знеболюючі',
        isDangerous: false,
      );

      // Mock the database insertion
      when(mockDbHelper.insertMedicine(medicine)).thenAnswer((_) async => 1);

      // Tap Save
      await tester.tap(saveButton);
      await tester.pump();

      // Verify that insertMedicine was called with a valid Medicine object
      verify(mockDbHelper.insertMedicine(medicine)).called(1);
    });

    testWidgets('Test notification scheduling', (WidgetTester tester) async {
      // Simulate filling the form and saving the medicine
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => AppNavigator(),
            child: AddMedicineScreen(),
          ),
        ),
      );

      // Fill the form and save the medicine
      await tester.enterText(find.byType(TextField).first, 'Aspirin');
      await tester.enterText(find.byType(TextField).last, 'For pain relief');
      await tester.tap(find.byIcon(Icons.medical_services));
      await tester.tap(find.byIcon(Icons.calendar_today));

      // Simulate selecting a date (e.g., tomorrow)
      final date = DateTime.now().add(Duration(days: 1));
      await tester.pumpAndSettle();

      // Select category
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Знеболюючі').last);
      await tester.pumpAndSettle();
      final androidDetails = AndroidNotificationDetails(
        'medicine_channel',
        'Medicine Notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      expect(saveButton, findsOneWidget);

      // Mock scheduling the notification
      when(
        mockNotifications.zonedSchedule(
          1,
          any,
          any,
          tz.TZDateTime.now(tz.local),
          NotificationDetails(android: androidDetails),
          payload: 'default_payload',
          androidScheduleMode: AndroidScheduleMode.exact,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        ),
      ).thenAnswer((_) async => true);

      // Tap Save
      await tester.tap(saveButton);
      await tester.pump();

      // Verify notification scheduling was called
      verify(
        mockNotifications.zonedSchedule(
          1,
          any,
          any,
          tz.TZDateTime.now(tz.local),
          NotificationDetails(android: androidDetails),
          payload: 'default_payload',
          androidScheduleMode: AndroidScheduleMode.exact,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        ),
      ).called(1);
    });
  });
}
