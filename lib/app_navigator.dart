import 'package:flutter/material.dart';

import 'profile_pages/profile_page.dart';
import 'test_pages/choose_test_page.dart';
import 'test_pages/test_screen.dart';

import 'main.dart';
import 'package:flutter/material.dart';

import 'profile_pages/profile_page.dart';
import 'test_pages/choose_test_page.dart';
import 'test_pages/test_screen.dart';
import './info_pages/march_protocol_page.dart';
import './info_pages/cls_page.dart';
import 'main.dart';

class AppNavigator with ChangeNotifier {
  int _bottomNavIndex = 0; // Index for bottom nav bar tabs
  final List<Widget> _navigationStack = []; // Navigation history stack

  // Initialize with HomeContent as the default page
  AppNavigator() {
    _navigationStack.add(const HomeContent());
  }

  // Pages for bottom navigation bar
  List<Widget> get bottomNavPages => [
    const HomeContent(),
    const ChooseTestPage(),
    const ProfilePage(),
  ];

  // Current index for bottom nav bar
  int get bottomNavIndex => _bottomNavIndex;

  // Current page being displayed
  Widget get currentPage => _navigationStack.last;

  // Set index for bottom navigation bar
  void selectBottomNavTab(int index) {
    if (index < 0 || index >= bottomNavPages.length) return;
    _bottomNavIndex = index;

    // Clear the navigation stack except for the bottom nav page
    _navigationStack.clear();
    _navigationStack.add(bottomNavPages[index]);

    notifyListeners();
  }

  // Navigate to a specific page
  void navigateTo(Widget page) {
    _navigationStack.add(page);
    notifyListeners();
  }

  // Go back to previous page in the stack
  void goBack() {
    if (_navigationStack.length > 1) {
      _navigationStack.removeLast();
      notifyListeners();
    } else {
      // If there's only one page in the stack, we're at the root
      // So we go to the current bottom nav tab
      _navigationStack.clear();
      _navigationStack.add(bottomNavPages[_bottomNavIndex]);
      notifyListeners();
    }
  }

  // For debugging: get the current stack size
  int get stackSize => _navigationStack.length;
}
