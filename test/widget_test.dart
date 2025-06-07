import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:family_app/main.dart';
import 'package:family_app/presentation/controllers/family_controller.dart';
import 'package:family_app/presentation/controllers/main_controller.dart';

void main() {
  group('Family App Widget Tests', () {
    setUp(() {
      // Initialize GetX controllers for testing
      Get.put(FamilyController());
      Get.put(MainController());
    });

    tearDown(() {
      // Clean up GetX controllers after each test
      Get.reset();
    });

    testWidgets('App should start and display main screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      // Verify that the app starts with the main screen
      expect(find.text('The Smith Family Tree'), findsOneWidget);
      expect(find.text('Tree'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Events'), findsOneWidget);
    });

    testWidgets('Bottom navigation should work', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Tap on Gallery tab
      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();

      // Verify Gallery screen is displayed
      expect(find.text('Family Gallery'), findsOneWidget);

      // Tap on Map tab
      await tester.tap(find.text('Map'));
      await tester.pumpAndSettle();

      // Verify Map screen is displayed
      expect(find.text('Family Map'), findsOneWidget);
    });

    testWidgets('Family switcher should be present', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Look for family context banner
      expect(find.textContaining('Viewing:'), findsOneWidget);
      expect(find.textContaining('The Smith Family'), findsOneWidget);
    });

    testWidgets('Navigation drawer should open', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verify drawer items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });

  group('Family Controller Tests', () {
    late FamilyController familyController;

    setUp(() {
      familyController = FamilyController();
    });

    test('Should initialize with default family', () {
      expect(familyController.families.isNotEmpty, true);
      expect(familyController.selectedFamily, isNotNull);
      expect(familyController.selectedFamilyName.isNotEmpty, true);
    });

    test('Should switch family correctly', () {
      final initialFamily = familyController.selectedFamily;
      final newFamily = familyController.families.firstWhere(
        (family) => family.id != initialFamily?.id,
      );

      familyController.switchFamily(newFamily);

      expect(familyController.selectedFamily?.id, equals(newFamily.id));
      expect(familyController.selectedFamilyName, equals(newFamily.name));
    });

    test('Should not switch to same family', () {
      final currentFamily = familyController.selectedFamily;
      final initialFamilyId = currentFamily?.id;

      familyController.switchFamily(currentFamily!);

      expect(familyController.selectedFamily?.id, equals(initialFamilyId));
    });
  });

  group('Main Controller Tests', () {
    late MainController mainController;

    setUp(() {
      mainController = MainController();
    });

    test('Should initialize with first tab selected', () {
      expect(mainController.selectedIndex, equals(0));
    });

    test('Should change tab index correctly', () {
      mainController.changeTabIndex(2);
      expect(mainController.selectedIndex, equals(2));

      mainController.changeTabIndex(4);
      expect(mainController.selectedIndex, equals(4));
    });

    test('Should not change to invalid tab index', () {
      final initialIndex = mainController.selectedIndex;

      mainController.changeTabIndex(-1);
      expect(mainController.selectedIndex, equals(initialIndex));

      mainController.changeTabIndex(10);
      expect(mainController.selectedIndex, equals(initialIndex));
    });

    test('Should toggle drawer state', () {
      expect(mainController.isDrawerOpen, false);

      mainController.toggleDrawer();
      expect(mainController.isDrawerOpen, true);

      mainController.toggleDrawer();
      expect(mainController.isDrawerOpen, false);
    });
  });
}