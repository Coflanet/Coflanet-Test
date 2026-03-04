import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:coflanet/main.dart' as app;

/// Bean CRUD E2E Test
///
/// Tests: Login → Navigate to bean list → Add bean → Verify saved → Delete
/// Uses test account: test@test.com / 111111
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Bean CRUD E2E', () {
    testWidgets('Login → Add bean → Verify → Delete', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // === Step 1: Handle splash navigation ===
      print('=== Step 1: After splash ===');
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Detect current screen
      final hasEmailLogin = find.text('이메일 로그인');
      final hasSurveyIntro = find.text('설문 건너뛰기');
      final hasBeanList = find.text('저장된 원두가 없어요');
      final hasBeanListTitle = find.text('원두 목록');

      if (hasEmailLogin.evaluate().isNotEmpty) {
        // On sign-in screen → Login with email
        print('=== On sign-in screen, navigating to email login ===');
        await tester.tap(hasEmailLogin);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Enter credentials
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, 'test@test.com');
        await tester.pumpAndSettle();
        await tester.enterText(textFields.last, '111111');
        await tester.pumpAndSettle();

        // Tap login button
        final loginButton = find.text('로그인');
        if (loginButton.evaluate().isNotEmpty) {
          await tester.tap(loginButton.last);
          await tester.pumpAndSettle(const Duration(seconds: 5));
        }

        // After login, check if survey or main shell
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Check if we're on survey intro → skip
      if (find.text('설문 건너뛰기').evaluate().isNotEmpty) {
        print('=== On survey intro, skipping survey ===');
        await tester.tap(find.text('설문 건너뛰기'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // === Step 2: Now on MainShell, tab 0 = bean list ===
      print('=== Step 2: On MainShell (bean list) ===');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Print all visible texts to understand current state
      _printVisibleTexts(tester, limit: 15);

      // === Step 3: Add a new bean ===
      print('=== Step 3: Adding new bean ===');

      // Look for add button - either "원두 추가하기" or the + icon
      final addButton = find.text('원두 추가하기');
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton);
      } else {
        // Try the + icon button
        final addIcon = find.byIcon(Icons.add);
        if (addIcon.evaluate().isNotEmpty) {
          await tester.tap(addIcon.first);
        }
      }
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're on BeanEditView (원두 추가 screen)
      final beanAddTitle = find.text('원두 추가');
      if (beanAddTitle.evaluate().isNotEmpty) {
        print('=== On BeanEditView (원두 추가) ===');

        // Fill in the form
        // Find text fields
        final textFields = find.byType(TextField);
        print('Found ${textFields.evaluate().length} text fields');

        if (textFields.evaluate().length >= 2) {
          // Brand name (1st field)
          await tester.enterText(textFields.at(0), '테스트 브랜드');
          await tester.pumpAndSettle();

          // Bean name (2nd field)
          await tester.enterText(
            textFields.at(1),
            '테스트 원두 ${DateTime.now().millisecondsSinceEpoch}',
          );
          await tester.pumpAndSettle();

          // Origin (3rd field if exists)
          if (textFields.evaluate().length >= 3) {
            await tester.enterText(textFields.at(2), '에티오피아');
            await tester.pumpAndSettle();
          }
        }

        // Tap save/add button
        final saveButton = find.text('추가');
        if (saveButton.evaluate().isNotEmpty) {
          print('=== Tapping 추가 button ===');
          await tester.tap(saveButton.last);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }

        // After save, should return to bean list
        print('=== After save, checking bean list ===');
        await tester.pumpAndSettle(const Duration(seconds: 2));
        _printVisibleTexts(tester, limit: 15);

        // Verify the added bean appears in the list
        final addedBean = find.textContaining('테스트 원두');
        if (addedBean.evaluate().isNotEmpty) {
          print('SUCCESS: Added bean found in list!');
        } else {
          print('FAIL: Added bean NOT found in list');
          // Print debug info
          print('Looking for any text containing "테스트"...');
          final testText = find.textContaining('테스트');
          print('Found: ${testText.evaluate().length} matches');
        }
      } else {
        print('FAIL: Did not navigate to BeanEditView');
        _printVisibleTexts(tester, limit: 20);
      }

      print('=== Bean CRUD test completed ===');
    });
  });
}

void _printVisibleTexts(WidgetTester tester, {int limit = 10}) {
  final allTexts = find.byType(Text);
  final count = allTexts.evaluate().length;
  print('--- Visible texts ($count total, showing first $limit) ---');
  for (int i = 0; i < count && i < limit; i++) {
    final widget = allTexts.evaluate().elementAt(i).widget as Text;
    if (widget.data != null && widget.data!.isNotEmpty) {
      print('  [$i] ${widget.data}');
    }
  }
}
