import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/routes/app_pages.dart';

/// 개발용 직접 네비게이션 메뉴
/// 원하는 화면을 바로 골라서 이동할 수 있습니다.
class DevMenuView extends StatelessWidget {
  const DevMenuView({super.key});

  static const _sections = <_RouteSection>[
    _RouteSection('메인 쉘 (탭 화면)', [
      _RouteItem('메인 쉘 (하단 탭)', Routes.mainShell, Icons.home_rounded),
    ]),
    _RouteSection('인증 (Auth)', [
      _RouteItem('로그인', Routes.signIn, Icons.login_rounded),
      _RouteItem('이메일 로그인', Routes.emailLogin, Icons.email_rounded),
      _RouteItem('이메일 회원가입', Routes.emailSignUp, Icons.person_add_rounded),
      _RouteItem('회원가입 완료', Routes.signUpComplete, Icons.check_circle_rounded),
      _RouteItem('프로필 설정', Routes.profileSetup, Icons.badge_rounded),
      _RouteItem('계정 연동', Routes.accountLink, Icons.link_rounded),
    ]),
    _RouteSection('온보딩 (Survey)', [
      _RouteItem('설문 이유', Routes.surveyReason, Icons.help_outline_rounded),
      _RouteItem('설문 인덱스', Routes.surveyIndex, Icons.list_rounded),
      _RouteItem('설문 소개', Routes.surveyIntro, Icons.info_outline_rounded),
      _RouteItem('설문 분석중', Routes.surveyAnalyzing, Icons.hourglass_top_rounded),
      _RouteItem('설문 완료', Routes.surveyComplete, Icons.done_all_rounded),
      _RouteItem('설문 결과', Routes.surveyResult, Icons.analytics_rounded),
    ]),
    _RouteSection('커피', [
      _RouteItem('커피 메인', Routes.coffeeMain, Icons.coffee_rounded),
      _RouteItem('핸드드립', Routes.handDrip, Icons.coffee_maker_rounded),
      _RouteItem('에스프레소', Routes.espresso, Icons.local_cafe_rounded),
      _RouteItem('에스프레소 설정', Routes.espressoSettings, Icons.tune_rounded),
      _RouteItem('커피 설정', Routes.coffeeSettings, Icons.settings_rounded),
      _RouteItem('커피 설정 상세', Routes.coffeeSettingDetail, Icons.settings_applications_rounded),
      _RouteItem('커피 선택', Routes.selectCoffee, Icons.add_circle_outline_rounded),
      _RouteItem('타이머', Routes.timerActive, Icons.timer_rounded),
      _RouteItem('타이머 완료', Routes.timerComplete, Icons.timer_off_rounded),
    ]),
    _RouteSection('원두 / 레시피', [
      _RouteItem('원두 상세', Routes.beanDetail, Icons.info_rounded),
      _RouteItem('원두 편집', Routes.beanEdit, Icons.edit_rounded),
      _RouteItem('레시피 편집', Routes.recipeEdit, Icons.edit_note_rounded),
      _RouteItem('레시피 추가', Routes.recipeAdd, Icons.add_rounded),
    ]),
    _RouteSection('매칭 / 프로필', [
      _RouteItem('매칭 결과', Routes.matchingResult, Icons.compare_arrows_rounded),
      _RouteItem('나의 취향', Routes.myTaste, Icons.favorite_rounded),
      _RouteItem('My 행성', Routes.myPlanet, Icons.public_rounded),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text(
          'Dev Menu — 직접 이동',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 40),
        itemCount: _sections.length,
        itemBuilder: (context, sectionIndex) {
          final section = _sections[sectionIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Text(
                  section.title,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7D5EF7),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Route items
              ...section.items.map((item) => _buildRouteItem(context, item)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRouteItem(BuildContext context, _RouteItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(item.route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF2C2C2E), width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, size: 18, color: const Color(0xFFC2C4C8)),
              ),
              const SizedBox(width: 14),
              // Label + Route
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF7F7F8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.route,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF8E8E93),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteSection {
  final String title;
  final List<_RouteItem> items;
  const _RouteSection(this.title, this.items);
}

class _RouteItem {
  final String label;
  final String route;
  final IconData icon;
  const _RouteItem(this.label, this.route, this.icon);
}
