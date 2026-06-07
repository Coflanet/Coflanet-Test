import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/core/theme/theme_controller.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';
import 'package:coflanet/modules/planet/widgets/planet_account_section.dart';
import 'package:coflanet/modules/planet/widgets/planet_empty_card.dart';
import 'package:coflanet/modules/planet/widgets/planet_flavor_notes_card.dart';
import 'package:coflanet/modules/planet/widgets/planet_pill_button.dart';
import 'package:coflanet/modules/planet/widgets/planet_taste_tag_row.dart';
import 'package:coflanet/modules/planet/widgets/planet_text_cell.dart';

/// Content widget for My Planet screen (without Scaffold/bottom nav)
/// Used inside MainShellView's IndexedStack
///
/// Figma Layout Structure (테마 스킴 기반, 섹션 위젯은 widgets/ 에 분리):
/// - 페이지 배경: MainShellView 담당 (backgroundNormalAlternative)
/// - Main container (surfaceCardStrong, border-radius 40px)
///   - 빈 상태: PlanetEmptyCard / 채움 상태: 취향 태그 + 향미 노트 + 재설문
/// - 테마/Logout/Withdraw container: PlanetAccountSection (별도 컨테이너)
/// - Legal links: PlanetTextCell (페이지 배경 위 직접)
///
/// 반응형 getter(isLoading/hasTasteProfile/surveyResult)는 build 의 Obx
/// 클로저 안에서 평가해 값으로 주입한다. flavorDescriptions(const 리스트)와
/// isAnonymous(SDK 동기 읽기)는 비반응 — 원본과 동일 동작.
class MyPlanetContent extends GetView<MyPlanetController> {
  const MyPlanetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Obx(() {
      if (controller.isLoading) {
        return Center(
          child: CircularProgressIndicator(color: colors.primaryNormal),
        );
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== MAIN CONTAINER (옅은 회색 컨테이너) =====
            // Figma: border-radius 40px, padding 12px 24px, width: stretch
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ), // Figma: 12px 24px
              decoration: BoxDecoration(
                color: colors.surfaceCardStrong,
                borderRadius: BorderRadius.circular(
                  40,
                ), // Figma: 40px all corners
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // 설문 데이터 유무에 따라 빈/채움 상태 자동 전환
                  if (controller.hasTasteProfile)
                    _buildFilledContent()
                  else
                    PlanetEmptyCard(onSurveyTap: () => controller.goToSurvey()),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // ===== 테마/LOGOUT/WITHDRAW CONTAINER (Separate container) =====
            const SizedBox(height: 8),
            PlanetAccountSection(
              themeController: Get.find<ThemeController>(),
              isAnonymous: controller.isAnonymous,
              onAccountLink: () => controller.goToAccountLink(),
              onLogout: () => controller.logout(),
              onWithdraw: () => controller.withdrawAccount(),
            ),

            // ===== LEGAL LINKS (페이지 배경 위 직접) =====
            const SizedBox(height: 16),
            _buildLegalLinks(colors),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  /// 채움 상태 — 취향 태그 행 + 향미 노트 카드 + 재설문 버튼
  Widget _buildFilledContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 취향 태그 4종 (모델 통째 주입 — null 가드는 위젯 내부)
        PlanetTasteTagRow(profile: controller.surveyResult?.tasteProfile),
        const SizedBox(height: 20),
        // 향미 노트 리스트 카드
        PlanetFlavorNotesCard(flavors: controller.flavorDescriptions),
        const SizedBox(height: 16),
        // 재설문 버튼
        PlanetPillButton(
          text: '취향 설문 다시 하기',
          onTap: () => controller.retakeSurvey(),
        ),
      ],
    );
  }

  // 법적 링크 — 테마 라벨 토큰 사용, 다크에서는 기존 회색 톤과 동일하게 보인다
  Widget _buildLegalLinks(AppColorScheme colors) {
    final linkColor = colors.labelNeutral;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24), // Same as containers
      child: Column(
        children: [
          PlanetTextCell(
            text: '개인정보처리방침',
            color: linkColor,
            onTap: () => controller.openPrivacyPolicy(),
          ),
          PlanetTextCell(
            text: '서비스 이용약관',
            color: linkColor,
            onTap: () => controller.openTermsOfService(),
          ),
        ],
      ),
    );
  }
}
