import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:coflanet/main.dart' as app;

/// 게스트 로그인 → 전체 온보딩 플로우 → My Planet → "계정 연결" 버튼 확인
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Guest → Account Link button visible on My Planet', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // 1. SignIn 화면 — "게스트로 로그인" 탭
    final guestBtn = find.text('게스트로 로그인');
    expect(guestBtn, findsOneWidget, reason: 'SignIn 화면에 게스트 버튼 필요');
    await tester.tap(guestBtn);
    debugPrint('[Test] 1. 게스트로 로그인 탭');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 2. 프로필 설정 — 닉네임 입력 + "시작하기"
    final nameField = find.byType(TextField);
    expect(nameField, findsWidgets, reason: '프로필 설정에 TextField 필요');
    await tester.enterText(nameField.first, '테스트유저');
    await tester.pumpAndSettle();
    final startBtn1 = find.text('시작하기');
    expect(startBtn1, findsOneWidget, reason: '프로필 설정에 시작하기 버튼 필요');
    await tester.tap(startBtn1);
    debugPrint('[Test] 2. 프로필 설정 완료');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 3. 설문 이유 화면 — 아무 옵션 선택 + "완료"
    // SurveyCheckboxItem 찾기 — 첫 번째 옵션 탭
    final checkboxItems = find.text('커피 취향을 찾고 싶어요.');
    if (checkboxItems.evaluate().isNotEmpty) {
      await tester.tap(checkboxItems.first);
      await tester.pumpAndSettle();
      final completeBtn = find.text('완료');
      if (completeBtn.evaluate().isNotEmpty) {
        await tester.tap(completeBtn);
        debugPrint('[Test] 3. 설문 이유 완료');
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    } else {
      debugPrint('[Test] 3. 설문 이유 화면 스킵 (옵션 없음)');
    }

    // 4. 가입 완료 화면 — "시작하기"
    final startBtn2 = find.text('시작하기');
    if (startBtn2.evaluate().isNotEmpty) {
      await tester.tap(startBtn2);
      debugPrint('[Test] 4. 가입 완료 → 시작하기');
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    // 5. 설문 인트로 — "설문 건너뛰기"
    final skipBtn = find.text('설문 건너뛰기');
    if (skipBtn.evaluate().isNotEmpty) {
      await tester.tap(skipBtn);
      debugPrint('[Test] 5. 설문 건너뛰기');
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    // 6. MainShell 도착 — My 행성 탭 (index 3) 탭
    // 커스텀 탭바이므로 "My 행성" 텍스트나 person 아이콘으로 찾기
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final myPlanetIcon = find.byIcon(Icons.person_outline_rounded);
    final myPlanetIconFilled = find.byIcon(Icons.person_rounded);

    if (myPlanetIcon.evaluate().isNotEmpty) {
      await tester.tap(myPlanetIcon.first);
      debugPrint('[Test] 6. My 행성 탭 (outline)');
    } else if (myPlanetIconFilled.evaluate().isNotEmpty) {
      await tester.tap(myPlanetIconFilled.first);
      debugPrint('[Test] 6. My 행성 탭 (filled)');
    } else {
      debugPrint('[Test] 6. My 행성 아이콘 못 찾음');
    }
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 7. "계정 연결" 버튼 확인
    // 스크롤해서 하단 확인
    final scrollable = find.byType(SingleChildScrollView);
    if (scrollable.evaluate().isNotEmpty) {
      await tester.drag(scrollable.first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    final accountLinkBtn = find.text('계정 연결');
    final logoutBtn = find.text('로그아웃');
    final withdrawBtn = find.text('회원탈퇴');

    debugPrint('[Test] ========= RESULTS =========');
    debugPrint('[Test] 계정 연결: ${accountLinkBtn.evaluate().isNotEmpty}');
    debugPrint('[Test] 로그아웃: ${logoutBtn.evaluate().isNotEmpty}');
    debugPrint('[Test] 회원탈퇴: ${withdrawBtn.evaluate().isNotEmpty}');
    debugPrint('[Test] ============================');

    expect(
      accountLinkBtn,
      findsOneWidget,
      reason: '게스트일 때 "계정 연결" 버튼이 보여야 합니다',
    );
    expect(logoutBtn, findsOneWidget);
    expect(withdrawBtn, findsOneWidget);

    debugPrint('[Test] SUCCESS: 계정 연결 버튼 확인됨!');
  });
}
