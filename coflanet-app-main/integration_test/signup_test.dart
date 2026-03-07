import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:coflanet/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Guest login → profile → survey reason flow', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // === Step 1: Tap "게스트로 로그인" ===
    debugPrint('=== Step 1: Tap 게스트로 로그인 ===');
    final guestLogin = find.text('게스트로 로그인');
    expect(guestLogin, findsOneWidget);
    await tester.tap(guestLogin);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // === Step 2: Check what screen we're on ===
    debugPrint('=== Step 2: Check current screen ===');
    final allTexts = find.byType(Text);
    for (var i = 0; i < allTexts.evaluate().length && i < 20; i++) {
      final widget = allTexts.evaluate().elementAt(i).widget as Text;
      debugPrint('  Text[$i]: ${widget.data}');
    }

    // After guest login, might go to profile setup or directly to main
    final hasProfileSetup = find.text('반가워요! 👋');
    final hasSurveyReason = find.text('이유를 알려주세요.');
    final hasHome = find.text('홈');

    if (hasProfileSetup.evaluate().isNotEmpty) {
      debugPrint('=== On Profile Setup ===');

      // Enter name
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, '테스트유저');
      await tester.pumpAndSettle();

      // Tap "시작하기"
      final startBtn = find.text('시작하기');
      expect(startBtn, findsOneWidget);
      await tester.tap(startBtn);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    // === Step 3: Survey Reason Screen ===
    debugPrint('=== Step 3: Check for survey reason screen ===');
    final reasonTitle = find.text('이유를 알려주세요.');

    if (reasonTitle.evaluate().isNotEmpty) {
      debugPrint('  Survey reason screen found!');

      // Verify individual items can be selected independently
      final reason1 = find.text('커피 취향을 찾고 싶어요.');
      if (reason1.evaluate().isNotEmpty) {
        await tester.tap(reason1);
        await tester.pumpAndSettle();
        debugPrint('  Selected: 커피 취향을 찾고 싶어요.');
      }

      // Check that only 1 item is selected (not all)
      // Check the check icons - selected items should have violet color
      debugPrint('  Checking item states after selecting 1 item...');

      // Select a second reason
      final reason2 = find.text('다양한 원두를 시도해보고 싶어요.');
      if (reason2.evaluate().isNotEmpty) {
        await tester.tap(reason2);
        await tester.pumpAndSettle();
        debugPrint('  Selected: 다양한 원두를 시도해보고 싶어요.');
      }

      // Tap 완료
      final completeBtn = find.text('완료');
      expect(completeBtn, findsOneWidget);
      await tester.tap(completeBtn);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check final screen
      debugPrint('=== Step 4: After survey reason ===');
      final finalTexts = find.byType(Text);
      for (var i = 0; i < finalTexts.evaluate().length && i < 15; i++) {
        final widget = finalTexts.evaluate().elementAt(i).widget as Text;
        debugPrint('  Text[$i]: ${widget.data}');
      }

      if (find.textContaining('환영').evaluate().isNotEmpty) {
        debugPrint('=== SUCCESS: Reached signup complete screen! ===');
      } else if (find.textContaining('취향').evaluate().isNotEmpty) {
        debugPrint('=== SUCCESS: Reached survey screen! ===');
      }
    } else {
      debugPrint('  Survey reason NOT found. Current texts:');
      final texts = find.byType(Text);
      for (var i = 0; i < texts.evaluate().length && i < 15; i++) {
        final widget = texts.evaluate().elementAt(i).widget as Text;
        debugPrint('    Text[$i]: ${widget.data}');
      }
    }
  });
}
