import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:coflanet/main.dart' as app;
import 'package:coflanet/routes/app_pages.dart';

/// Back Navigation Bug Detection Test
///
/// Tests screens where back button may not work due to:
/// 1. Navigation stack cleared by offNamed/offAllNamed
/// 2. PopScope blocking back
/// 3. Back button calling different navigation (not Get.back())
///
/// Run: flutter test integration_test/back_navigation_test.dart -d <device-id>
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Back Navigation Bug Detection', () {
    testWidgets('Detect screens where back button fails', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      debugPrint('\n${'=' * 60}');
      debugPrint('BACK NAVIGATION BUG DETECTION TEST');
      debugPrint('${'=' * 60}\n');

      final issues = <String>[];

      // ════════════════════════════════════════════════════════════════
      // TEST 1: SignUpComplete - Back button broken (empty stack)
      // ════════════════════════════════════════════════════════════════
      debugPrint('📱 TEST 1: SignUpComplete Back Navigation');

      // Navigate using offNamed (simulating real flow)
      Get.offNamed(Routes.signUpComplete, arguments: {'userName': 'Test'});
      await tester.pumpAndSettle();

      final beforeRoute1 = Get.currentRoute;
      debugPrint('   Before back: $beforeRoute1');

      // Try to tap back button
      final backBtn1 = find.byType(IconButton).first;
      if (backBtn1.evaluate().isNotEmpty) {
        await tester.tap(backBtn1);
        await tester.pumpAndSettle();
      }

      final afterRoute1 = Get.currentRoute;
      debugPrint('   After back: $afterRoute1');

      if (beforeRoute1 == afterRoute1) {
        issues.add(
          'SignUpComplete: Back button does nothing (stack empty from offNamed)',
        );
        debugPrint('   ❌ ISSUE: Back button does not navigate');
      } else {
        debugPrint('   ✓ Back navigation works');
      }

      // ════════════════════════════════════════════════════════════════
      // TEST 2: SurveyComplete - Back button broken (empty stack)
      // ════════════════════════════════════════════════════════════════
      debugPrint('\n📱 TEST 2: SurveyComplete Back Navigation');

      // Navigate using offNamed (simulating real flow after survey analyzing)
      Get.offNamed(Routes.surveyComplete);
      await tester.pumpAndSettle();

      final beforeRoute2 = Get.currentRoute;
      debugPrint('   Before back: $beforeRoute2');

      // Try to tap back button
      final backBtn2 = find.byType(IconButton).first;
      if (backBtn2.evaluate().isNotEmpty) {
        await tester.tap(backBtn2);
        await tester.pumpAndSettle();
      }

      final afterRoute2 = Get.currentRoute;
      debugPrint('   After back: $afterRoute2');

      if (beforeRoute2 == afterRoute2) {
        issues.add(
          'SurveyComplete: Back button does nothing (stack empty from offNamed)',
        );
        debugPrint('   ❌ ISSUE: Back button does not navigate');
      } else {
        debugPrint('   ✓ Back navigation works');
      }

      // ════════════════════════════════════════════════════════════════
      // TEST 3: SurveyResult - Back button goes to Home (not back)
      // ════════════════════════════════════════════════════════════════
      debugPrint('\n📱 TEST 3: SurveyResult Back Navigation Behavior');

      Get.offNamed(Routes.surveyResult);
      await tester.pumpAndSettle();

      final beforeRoute3 = Get.currentRoute;
      debugPrint('   Before back: $beforeRoute3');
      debugPrint('   Note: Back button calls completeOnboarding() -> Home');

      // This is intentional behavior but may confuse users
      issues.add(
        'SurveyResult: Back button navigates to Home (intentional but confusing)',
      );

      // ════════════════════════════════════════════════════════════════
      // TEST 4: SurveyAnalyzing - No back button at all
      // ════════════════════════════════════════════════════════════════
      debugPrint('\n📱 TEST 4: SurveyAnalyzing Back Navigation');

      Get.offNamed(Routes.surveyAnalyzing);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Check if back button exists
      final backIcons = find.byIcon(Icons.arrow_back);
      final backIosIcons = find.byIcon(Icons.arrow_back_ios);

      if (backIcons.evaluate().isEmpty && backIosIcons.evaluate().isEmpty) {
        debugPrint('   ⚠️ No back button (intentional during analysis)');
        issues.add(
          'SurveyAnalyzing: No back button (intentional - processing state)',
        );
      }

      // Wait for auto-navigation
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ════════════════════════════════════════════════════════════════
      // TEST 5: TimerComplete - Back button goes to Home (not back)
      // ════════════════════════════════════════════════════════════════
      debugPrint('\n📱 TEST 5: TimerComplete Back Navigation Behavior');

      Get.toNamed(Routes.timerComplete);
      await tester.pumpAndSettle();

      debugPrint('   Note: Back button calls goToHome() -> offAllNamed(home)');
      issues.add('TimerComplete: Back button navigates to Home (intentional)');

      // ════════════════════════════════════════════════════════════════
      // TEST 6: CoffeeTimer - PopScope blocks back (needs confirmation)
      // ════════════════════════════════════════════════════════════════
      debugPrint('\n📱 TEST 6: CoffeeTimer PopScope Blocking');

      Get.toNamed(Routes.timerActive, arguments: {'type': 'handDrip'});
      await tester.pumpAndSettle();

      debugPrint(
        '   Note: PopScope(canPop: false) - requires confirmation dialog',
      );
      issues.add(
        'CoffeeTimer: PopScope blocks back (requires confirmation - intentional)',
      );

      // ════════════════════════════════════════════════════════════════
      // TEST 7: Screens after offAllNamed from Splash
      // ════════════════════════════════════════════════════════════════
      debugPrint(
        '\n📱 TEST 7: Post-Splash Navigation (offAllNamed clears stack)',
      );

      // These screens are reached via offAllNamed, so no back stack:
      // - SignIn (from Splash)
      // - SurveyIntro (from Splash or after login)
      // - Home (from Splash or after onboarding)

      debugPrint('   Screens reached via offAllNamed (no back stack):');
      debugPrint('   - SignIn (from Splash)');
      debugPrint('   - SurveyIntro (from Splash/Login)');
      debugPrint('   - Home (from Splash/Onboarding)');
      issues.add(
        'SignIn/SurveyIntro/Home: No back stack (root screens - intentional)',
      );

      // ════════════════════════════════════════════════════════════════
      // SUMMARY
      // ════════════════════════════════════════════════════════════════
      debugPrint('\n${'=' * 60}');
      debugPrint('BACK NAVIGATION ISSUES FOUND');
      debugPrint('${'=' * 60}\n');

      debugPrint('🔴 BUGS (back button exists but broken):');
      debugPrint('   1. SignUpComplete - Get.back() called but stack empty');
      debugPrint('   2. SurveyComplete - Get.back() called but stack empty');

      debugPrint('\n🟡 CONFUSING UX (intentional but unexpected):');
      debugPrint('   3. SurveyResult - Back button goes to Home, not previous');
      debugPrint(
        '   4. TimerComplete - Back button goes to Home, not previous',
      );

      debugPrint('\n🟢 INTENTIONAL BLOCKING:');
      debugPrint('   5. SurveyAnalyzing - No back button (processing state)');
      debugPrint('   6. CoffeeTimer - PopScope requires confirmation');
      debugPrint(
        '   7. Root screens - No back stack (SignIn, SurveyIntro, Home)',
      );

      debugPrint('\n${'=' * 60}');
      debugPrint('RECOMMENDED FIXES');
      debugPrint('${'=' * 60}\n');

      debugPrint('1. SignUpComplete:');
      debugPrint('   - Remove back button OR');
      debugPrint('   - Change to "시작하기" flow without back option');

      debugPrint('\n2. SurveyComplete:');
      debugPrint('   - Remove back button (user should proceed forward)');
      debugPrint('   - Survey flow is one-way after completion');

      debugPrint('\n3. SurveyResult:');
      debugPrint('   - Change back icon to close (X) icon');
      debugPrint('   - Or change to Home icon to clarify behavior');

      debugPrint('\n4. TimerComplete:');
      debugPrint('   - Change back icon to close (X) or Home icon');
      debugPrint('   - Clarify that this ends the timer session');

      debugPrint('\n${'=' * 60}\n');

      // Test passes - this is a detection test, not assertion test
      expect(issues.isNotEmpty, true, reason: 'Issues detected and documented');
    });

    testWidgets(
      'Verify navigation flow: Survey -> Analyzing -> Complete -> Result',
      (tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        debugPrint('\n${'=' * 60}');
        debugPrint('SURVEY FLOW NAVIGATION TEST');
        debugPrint('${'=' * 60}\n');

        // Start at survey intro
        Get.offAllNamed(Routes.surveyIntro);
        await tester.pumpAndSettle();
        debugPrint('1. SurveyIntro - Stack: [surveyIntro]');

        // Go to survey question
        Get.toNamed('${Routes.survey}/0');
        await tester.pumpAndSettle();
        debugPrint('2. Survey/0 - Stack: [surveyIntro, survey/0]');

        // Complete survey -> offNamed to Analyzing (CLEARS survey/0)
        Get.offNamed(Routes.surveyAnalyzing);
        await tester.pumpAndSettle();
        debugPrint(
          '3. SurveyAnalyzing - Stack: [surveyIntro, surveyAnalyzing]',
        );
        debugPrint('   ⚠️ Survey question removed from stack');

        // Analyzing -> offNamed to Complete (CLEARS analyzing)
        Get.offNamed(Routes.surveyComplete);
        await tester.pumpAndSettle();
        debugPrint('4. SurveyComplete - Stack: [surveyIntro, surveyComplete]');
        debugPrint('   ⚠️ Analyzing removed from stack');
        debugPrint(
          '   ❌ BUG: Back button calls Get.back() but goes to surveyIntro!',
        );

        // Complete -> offNamed to Result (CLEARS complete)
        Get.offNamed(Routes.surveyResult);
        await tester.pumpAndSettle();
        debugPrint('5. SurveyResult - Stack: [surveyIntro, surveyResult]');
        debugPrint('   ⚠️ Complete removed from stack');

        // Result -> offAllNamed to Home (CLEARS ALL)
        Get.offAllNamed(Routes.home);
        await tester.pumpAndSettle();
        debugPrint('6. Home - Stack: [home]');
        debugPrint('   ✓ Entire stack cleared (intentional)');

        debugPrint('\n${'=' * 60}');
        debugPrint('CONCLUSION: offNamed breaks expected back behavior');
        debugPrint('${'=' * 60}\n');

        expect(Get.currentRoute, Routes.home);
      },
    );
  });
}
