import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:takmed/app_navigator.dart';
import 'package:takmed/info_pages/military_page.dart';
import 'package:takmed/info_pages/civilian_page.dart';
import 'package:takmed/info_pages/march_protocol_page.dart';
import 'package:takmed/main.dart';

void main() {
  testWidgets('HomeContent widget test with AppNavigator', (
    WidgetTester tester,
  ) async {
    // Build the widget tree for testing with AppNavigator
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppNavigator(),
        child: MaterialApp(home: const MyHomePage(title: 'Tak!Med')),
      ),
    );

    // Check that the TextField and two buttons exist
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));

    // Tap on the "Для військових" button
    await tester.tap(find.text('Для військових'));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Check if we have navigated to MilitaryPage
    expect(find.byType(MilitaryPage), findsOneWidget);

    // Trigger a tap on the 'АСМ' card (or whatever widget navigates to MarchProtocolPage)
    await tester.tap(find.text('АСМ'));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Check if MarchProtocolPage is displayed after tapping the 'АСМ' card
    expect(find.byType(MarchProtocolPage), findsOneWidget);

    // Access the AppNavigator and call selectBottomNavTab for index 0 (Home tab)
    final appNav = Provider.of<AppNavigator>(
      tester.element(find.byType(MyHomePage)),
      listen: false,
    );
    appNav.selectBottomNavTab(0);
    await tester.pumpAndSettle(); // Wait for navigation to settle

    // Tap on the "Для цивільних" button
    await tester.tap(find.text('Для цивільних'));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Check if we have navigated to CivilianPage
    expect(find.byType(CivilianPage), findsOneWidget);
  });
}
