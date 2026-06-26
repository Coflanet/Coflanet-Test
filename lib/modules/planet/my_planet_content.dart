import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/core/theme/theme_controller.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';
import 'package:coflanet/modules/planet/widgets/planet_account_section.dart';
import 'package:coflanet/modules/planet/widgets/planet_empty_card.dart';
import 'package:coflanet/modules/planet/widgets/planet_flavor_notes_card.dart';
import 'package:coflanet/modules/planet/widgets/planet_pill_button.dart';
import 'package:coflanet/modules/planet/widgets/planet_taste_tag_row.dart';
import 'package:coflanet/modules/planet/widgets/planet_text_cell.dart';
import 'package:coflanet/widgets/cards/card_section.dart';

/// 마이(My Planet) 탭 본문 — Static/Black 캔버스 위 iyumi 카드 구성.
///
/// 셸([MainShellView])이 캔버스(검정)·상단 네비(타이틀)·탭바를 소유하므로 이
/// 위젯은 **카드 본문만** 그린다. 색 규칙(task 4 방향 B):
/// - 카드 안(CardSection/CardItem 내부) = `AppColorScheme.of(context)` — 위젯
///   각자 자체 해석.
/// - 카드 밖(캔버스 위 법적 링크 등) = `AppColorScheme.canvas`(다크 스킴) — 검정
///   위에서 사라지지 않게.
///
/// 섹션 구성: ① 취향 프로필(큰 카드) ② 설정/계정(큰 카드) ③ 내 활동(큰 카드)
/// ④ 법적 링크(캔버스 위). 사이는 [CardGap](4). 카드 수치는 전부 cds 토큰.
///
/// 반응형 getter(isLoading/hasTasteProfile/surveyResult)는 build 의 Obx
/// 클로저 안에서 평가해 값으로 주입한다. flavorDescriptions(const 리스트)와
/// isAnonymous(SDK 동기 읽기)는 비반응 — 원본과 동일 동작.
class MyPlanetContent extends GetView<MyPlanetController> {
  const MyPlanetContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 카드 안 색 (섹션 타이틀 옆/내 활동 셀 등 카드 내부 요소)
    final colors = AppColorScheme.of(context);
    // 카드 밖(검정 캔버스) 색 — 항상 다크 스킴
    final canvas = AppColorScheme.canvas;

    return Obx(() {
      if (controller.isLoading) {
        // 검정 캔버스 위 로딩 — 캔버스 스킴 사용
        return Center(
          child: CircularProgressIndicator(color: canvas.primaryNormal),
        );
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        // 마지막 콘텐츠가 하단 탭바/독바에 가리지 않게
        padding: EdgeInsets.only(bottom: AppSpacing.bottomScrollInset(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 1) 취향 프로필 — 큰 카드 =====
            // 설문 데이터 유무에 따라 빈/채움 상태 자동 전환.
            // Figma(1331:17593): Contents inset 16 — 박스인박스 패딩.
            // Figma 톤: 바깥 카드 = background/normal/alternative(#F4F4F5),
            // 안쪽 태그/향미노트 = white. 가이드의 color 오버라이드 패턴으로 표현.
            CardSection(
              color: colors.surfaceCardStrong,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: controller.hasTasteProfile
                  ? _buildFilledContent()
                  : PlanetEmptyCard(onSurveyTap: () => controller.goToSurvey()),
            ),
            const CardGap(),

            // ===== 2) 설정/계정 — 큰 카드 =====
            PlanetAccountSection(
              themeController: Get.find<ThemeController>(),
              isAnonymous: controller.isAnonymous,
              onAccountLink: () => controller.goToAccountLink(),
              onLogout: () => controller.logout(),
              onWithdraw: () => controller.withdrawAccount(),
            ),
            const CardGap(),

            // ===== 3) 내 활동 — 큰 카드 =====
            // Figma 미존재(추출 기록 진입점, 기능 유지) — 톤은 설정 카드와 통일.
            CardSection(
              color: colors.surfaceCardStrong,
              title: '내 활동',
              child: PlanetTextCell(
                text: '추출 기록',
                color: colors.labelNormal, // 카드 안 → of(context)
                onTap: () => controller.goToExtractionList(),
              ),
            ),

            // ===== 4) 법적 링크 — 캔버스 위(카드 밖) =====
            const SizedBox(height: AppSpacing.md),
            _buildLegalLinks(canvas),
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
        // Figma(1341:15101): Contents gap 4 — 태그행과 향미노트 사이
        const SizedBox(height: AppSpacing.xxs),
        // 향미 노트 리스트 카드 (인셋 CardItem 톤)
        PlanetFlavorNotesCard(flavors: controller.flavorDescriptions),
        const SizedBox(height: AppSpacing.md),
        // 재설문 버튼
        PlanetPillButton(
          text: '취향 설문 다시 하기',
          onTap: () => controller.retakeSurvey(),
        ),
      ],
    );
  }

  /// 법적 링크 — 검정 캔버스 위(카드 밖)라 canvas 스킴(다크)으로 그려 사라지지 않게.
  Widget _buildLegalLinks(AppColorScheme canvas) {
    final linkColor = canvas.labelNeutral;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.headerHorizontalPadding,
      ),
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
