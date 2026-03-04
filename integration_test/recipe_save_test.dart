import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:coflanet/main.dart' as app;
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';

/// Recipe Save Integration Test
/// Tests the recipe edit and save functionality in a single continuous flow
/// to avoid GetX navigation context issues between tests
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Recipe save complete flow test', (tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    debugPrint('=== RECIPE SAVE COMPLETE FLOW TEST ===');
    debugPrint('');

    // ===== PART 1: Test error handling when beanId is null =====
    debugPrint('--- PART 1: Error handling test (no bean selected) ---');

    // Try guest login if available
    final guestLogin = find.text('게스트로 로그인');
    if (guestLogin.evaluate().isNotEmpty) {
      await tester.tap(guestLogin);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      debugPrint('1.1 Guest login tapped');
    }

    // Skip onboarding if needed
    for (int i = 0; i < 15; i++) {
      final currentRoute = Get.currentRoute;
      if (currentRoute.contains('survey') ||
          currentRoute.contains('onboarding') ||
          currentRoute.contains('profile-setup')) {
        final buttons = find.byType(ElevatedButton);
        if (buttons.evaluate().isNotEmpty) {
          await tester.tap(buttons.first);
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
        } else {
          break;
        }
      } else {
        break;
      }
    }
    debugPrint('1.2 Onboarding/setup completed. Route: ${Get.currentRoute}');

    // Navigate to RecipeEdit directly (without setting bean - should fail to save)
    Get.toNamed(Routes.recipeEdit);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    debugPrint('1.3 At RecipeEdit (without bean). Route: ${Get.currentRoute}');

    // Check controller state
    if (Get.isRegistered<CoffeeController>()) {
      final ctrl = Get.find<CoffeeController>();
      debugPrint(
        '1.4 Controller state: beanId=${ctrl.selectedBeanId}, name=${ctrl.selectedBeanName}',
      );
      expect(
        ctrl.selectedBeanId,
        isNull,
        reason: 'Bean should not be selected initially',
      );
    }

    // Try to save - should fail
    final saveBtn = find.text('저장하기');
    if (saveBtn.evaluate().isNotEmpty) {
      await tester.tap(saveBtn);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      debugPrint('1.5 Save button tapped (expected to fail)');
    }

    // Should still be on RecipeEdit (save failed)
    expect(
      Get.currentRoute,
      equals(Routes.recipeEdit),
      reason: 'Should stay on RecipeEdit when save fails',
    );
    debugPrint('1.6 Correctly stayed on RecipeEdit after failed save');
    debugPrint('');

    // ===== PART 2: Test successful save with bean selected =====
    debugPrint('--- PART 2: Successful save test (bean selected) ---');

    // Go back first
    Get.back();
    await tester.pumpAndSettle();

    // Set up bean selection properly
    if (!Get.isRegistered<CoffeeController>()) {
      Get.put<CoffeeController>(CoffeeController(), permanent: true);
    }
    final controller = Get.find<CoffeeController>();
    final originalHashCode = controller.hashCode;

    // Set the bean BEFORE navigating (simulating _onRecipePressed)
    await controller.setSelectedBean(
      id: 'test-bean-123',
      name: '테스트 에티오피아 예가체프',
    );
    debugPrint(
      '2.1 Bean set: id=${controller.selectedBeanId}, name=${controller.selectedBeanName}',
    );

    // Navigate to CoffeeSettings then RecipeEdit
    Get.toNamed(Routes.coffeeSettings);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    debugPrint('2.2 At CoffeeSettings. Route: ${Get.currentRoute}');

    // Verify controller instance is preserved (MainShellBinding fix)
    final afterNavController = Get.find<CoffeeController>();
    expect(
      afterNavController.hashCode,
      equals(originalHashCode),
      reason: 'CoffeeController should be same instance after navigation',
    );
    expect(
      afterNavController.selectedBeanId,
      equals('test-bean-123'),
      reason: 'selectedBeanId should be preserved after navigation',
    );
    debugPrint(
      '2.3 Controller preserved: hashCode match=${afterNavController.hashCode == originalHashCode}',
    );

    // Navigate to RecipeEdit
    Get.toNamed(Routes.recipeEdit);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    debugPrint('2.4 At RecipeEdit. Route: ${Get.currentRoute}');

    // Verify bean is still selected
    final editController = Get.find<CoffeeController>();
    expect(
      editController.selectedBeanId,
      equals('test-bean-123'),
      reason: 'selectedBeanId should be preserved in RecipeEdit',
    );
    debugPrint('2.5 Bean still selected: ${editController.selectedBeanId}');

    // Save with default steps - should succeed and navigate back
    final saveBtn2 = find.text('저장하기');
    if (saveBtn2.evaluate().isNotEmpty) {
      await tester.tap(saveBtn2);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      debugPrint('2.6 Save button tapped, current route: ${Get.currentRoute}');
    }

    // Should navigate back to CoffeeSettings (save succeeded)
    final routeAfterSave = Get.currentRoute;
    debugPrint('2.7 Route after save: $routeAfterSave');
    expect(
      routeAfterSave,
      equals(Routes.coffeeSettings),
      reason: 'Should navigate back to CoffeeSettings after successful save',
    );
    debugPrint('2.8 Correctly navigated back to CoffeeSettings');
    debugPrint('');

    // ===== PART 3: Test step deletion and save =====
    debugPrint('--- PART 3: Step deletion and save test ---');

    // Navigate to RecipeEdit
    Get.toNamed(Routes.recipeEdit);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final stepsController = Get.find<CoffeeController>();
    final initialStepCount = stepsController.extractionSteps.length;
    debugPrint('3.1 Initial steps count: $initialStepCount');

    // Delete all steps
    while (stepsController.extractionSteps.isNotEmpty) {
      final stepId = stepsController.extractionSteps.first.id;
      stepsController.deleteExtractionStep(stepId);
    }
    await tester.pumpAndSettle();
    debugPrint(
      '3.2 All steps deleted. Count: ${stepsController.extractionSteps.length}',
    );
    expect(
      stepsController.extractionSteps.length,
      equals(0),
      reason: 'All steps should be deleted',
    );

    // Tap save button in UI (tests the full button handler)
    final saveBtn3 = find.text('저장하기');
    expect(saveBtn3, findsOneWidget, reason: 'Save button should be visible');
    await tester.tap(saveBtn3);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Should navigate back to CoffeeSettings
    debugPrint('3.3 Route after empty-steps save: ${Get.currentRoute}');
    expect(
      Get.currentRoute,
      equals(Routes.coffeeSettings),
      reason: 'Should navigate back after saving with empty steps',
    );

    // Verify controller still has 0 steps
    expect(
      stepsController.extractionSteps.length,
      equals(0),
      reason: 'Steps should remain empty after save',
    );
    debugPrint(
      '3.4 Steps remain empty: ${stepsController.extractionSteps.length}',
    );
    debugPrint('');

    // ===== PART 4: Verify CoffeeSettings shows empty extraction steps =====
    debugPrint(
      '--- PART 4: Verify CoffeeSettings reflects empty extraction steps ---',
    );

    // We're at CoffeeSettings with 0 extraction steps
    // Verify the progress tracker shows only fixed steps (원두 분쇄, 예열, 추출 완료)
    expect(find.text('원두 분쇄'), findsOneWidget);
    expect(find.text('예열'), findsOneWidget);
    expect(find.text('추출 완료'), findsOneWidget);
    // Should NOT show extraction step titles
    expect(find.text('뜸 들이기'), findsNothing);
    expect(find.text('1차 추출'), findsNothing);
    expect(find.text('2차 추출'), findsNothing);
    debugPrint(
      '4.1 CoffeeSettings correctly shows only fixed steps (no extraction steps)',
    );
    debugPrint('');

    // ===== PART 5: Verify persistence - reload recipe and check empty steps =====
    debugPrint(
      '--- PART 5: Verify persistence - reload recipe from repository ---',
    );

    // Reload recipe from repository (simulates leaving and coming back)
    await stepsController.loadRecipeForBean('test-bean-123');
    await tester.pumpAndSettle();

    debugPrint(
      '5.1 Reloaded recipe, steps count: ${stepsController.extractionSteps.length}',
    );
    expect(
      stepsController.extractionSteps.length,
      equals(0),
      reason: 'Reloaded recipe should have empty steps',
    );

    // CoffeeSettings should still show correctly
    expect(find.text('원두 분쇄'), findsOneWidget);
    expect(find.text('예열'), findsOneWidget);
    expect(find.text('추출 완료'), findsOneWidget);
    expect(find.text('뜸 들이기'), findsNothing);
    debugPrint('5.2 After reload, CoffeeSettings still shows only fixed steps');

    debugPrint('');
    debugPrint('=== ALL TESTS PASSED ===');
  });
}
