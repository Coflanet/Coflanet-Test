import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';

/// Survey Intro View — Figma POC `Survey_intro` (1114:59435)
/// 설문 방식 선택 화면: "일반 설문"(맛/향 직접 선택) vs "라이프스타일 분석".
/// 카드 탭으로 표준/라이프스타일 설문을 시작하고, 하단 "설문 건너뛰기"로 스킵.
/// 캔버스는 Figma·코드 공통 흰색 유지(온보딩 흐름 일관).
class SurveyIntroView extends GetView<SurveyController> {
  const SurveyIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconArrowBack,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(colors.labelNormal, BlendMode.srcIn),
          ),
          tooltip: '뒤로 가기',
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.space16),

              // Figma 1114:59439 — 중앙 정렬 타이틀 + 보조 문구
              Text(
                '${controller.userName}님의 취향을\n찾으러 가볼까요?',
                textAlign: TextAlign.center,
                style: AppTextStyles.title3Bold.copyWith(
                  color: colors.labelNormal,
                ),
              ),
              const SizedBox(height: AppSpacing.space8),
              Text(
                '원하는 분석 방식을 선택해주세요',
                textAlign: TextAlign.center,
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: colors.labelNeutral,
                ),
              ),

              const Spacer(flex: 2),

              // Figma 1752:44740 — 설문 방식 선택 카드 2개 (gap 4)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _SurveyTypeCard(
                        colors: colors,
                        label: '일반 설문',
                        title: '커피 맛과 향을\n직접 선택해요',
                        emoji: '☕️',
                        onTap: () => controller.startSurvey(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space4),
                    Expanded(
                      child: _SurveyTypeCard(
                        colors: colors,
                        label: '라이프스타일 분석',
                        title: '일상 습관으로\n취향을 파악해요',
                        emoji: '🏖️',
                        onTap: () => controller.startLifestyleSurvey(),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Figma 1852:17270 — 보조 텍스트 버튼 "설문 건너뛰기"
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.skipSurvey(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.space4,
                  ),
                  child: Text(
                    '설문 건너뛰기',
                    style: AppTextStyles.body1NormalBold.copyWith(
                      color: colors.labelAlternative,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space16),
            ],
          ),
        ),
      ),
    );
  }
}

/// 설문 방식 선택 카드 — Figma "Check Box with img01"(1752:44741)
/// bg component/fill/alternative, radius 32(round/box), padding (24,32), gap 20.
class _SurveyTypeCard extends StatelessWidget {
  const _SurveyTypeCard({
    required this.colors,
    required this.label,
    required this.title,
    required this.emoji,
    required this.onTap,
  });

  final AppColorScheme colors;
  final String label;
  final String title;
  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.componentFillAlternative,
          borderRadius: AppRadius.roundBorder,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space24,
          vertical: AppSpacing.space32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.label1NormalRegular.copyWith(
                color: colors.labelAlternative,
              ),
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              title,
              style: AppTextStyles.headline2Bold.copyWith(
                color: colors.labelNormal,
              ),
            ),
            const SizedBox(height: AppSpacing.space20),
            Text(emoji, style: AppTextStyles.title1Bold),
          ],
        ),
      ),
    );
  }
}
