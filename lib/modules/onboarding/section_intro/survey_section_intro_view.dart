import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_step_indicator.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Survey Section Intro View — Figma POC `Survey_index02/03` (1751:16928 / 1751:17437)
/// 각 섹션 시작 전 진행 단계 안내. 좌측 타이틀 + 스테퍼(완료/활성/비활성).
/// 캔버스 흰색 유지(온보딩 흐름 일관).
/// Standard: 3 sections (커피 경험, 기본 맛 취향, 특성 향미 취향)
/// Lifestyle: 4 sections (커피 경험, 라이프스타일, 맛 취향, 감각/성향)
class SurveySectionIntroView extends GetView<SurveyController> {
  const SurveySectionIntroView({super.key});

  // Figma 사양: Pretendard SemiBold 22 / lineHeight 1.36 / letterSpacing -0.4268
  TextStyle _screenHeaderStyle(AppColorScheme colors) =>
      AppTextStyles.heading1Bold.copyWith(color: colors.labelNormal);

  /// Check if current survey is lifestyle type
  bool get _isLifestyle => controller.surveyType == SurveyType.lifestyle;

  /// Get section labels based on survey type
  List<String> get _sectionLabels => _isLifestyle
      ? ['커피 경험 질문', '라이프스타일', '맛 취향', '감각/성향']
      : ['커피 경험 질문', '기본 맛 취향', '특성 향미 취향'];

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    // Get section number from route parameter
    final sectionParam = Get.parameters['section'] ?? '1';
    final sectionNumber = int.tryParse(sectionParam) ?? 1;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: _buildAppBar(colors),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.space16),

                    // Main title (좌측 정렬)
                    _buildTitle(colors, sectionNumber),

                    const SizedBox(height: AppSpacing.space40),

                    // Figma 1401:20044 — 진행 단계 스테퍼
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space20,
                      ),
                      child: SurveyStepIndicator(
                        colors: colors,
                        labels: _sectionLabels,
                        currentStep: sectionNumber,
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Figma 프레임엔 버튼이 없으나 라우트 진입 시 다음 단계로 넘어갈
            // 수단이 필요해 표준 pill 버튼을 유지한다.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space24,
                AppSpacing.space16,
                AppSpacing.space24,
                AppSpacing.space24,
              ),
              child: PrimaryButton(
                text: '다음',
                onPressed: () => _onNextPressed(sectionNumber),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColorScheme colors) {
    return AppBar(
      backgroundColor: AppColor.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(colors.labelNormal, BlendMode.srcIn),
        ),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Text(
        '취향 분석',
        style: AppTextStyles.headline2Bold.copyWith(color: colors.labelStrong),
      ),
      actions: [
        // X 닫기 버튼 (건너뛰기)
        IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconClose,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(colors.labelNormal, BlendMode.srcIn),
          ),
          onPressed: () => controller.skipSurvey(),
        ),
      ],
    );
  }

  Widget _buildTitle(AppColorScheme colors, int sectionNumber) {
    final userName = controller.userName;

    String line1;
    String line2;

    if (_isLifestyle) {
      switch (sectionNumber) {
        case 1:
          line1 = '$userName님께';
          line2 = '커피 경험 질문을 드릴게요!';
          break;
        case 2:
          line1 = '$userName님께';
          line2 = '라이프스타일 질문을 드릴게요!';
          break;
        case 3:
          line1 = '$userName님께';
          line2 = '맛 취향 질문을 드릴게요!';
          break;
        case 4:
          line1 = '$userName님께';
          line2 = '감각/성향 질문을 드릴게요!';
          break;
        default:
          line1 = '$userName님의';
          line2 = '취향을 분석할게요';
      }
    } else {
      switch (sectionNumber) {
        case 1:
          line1 = '$userName님께';
          line2 = '커피 경험 질문을 드릴게요!';
          break;
        case 2:
          line1 = '$userName님의';
          line2 = '기본 맛 취향을 알려주세요';
          break;
        case 3:
          line1 = '$userName님의';
          line2 = '특성 향미 취향을 알려주세요';
          break;
        default:
          line1 = '$userName님의';
          line2 = '취향을 분석할게요';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(line1, style: _screenHeaderStyle(colors)),
        Text(line2, style: _screenHeaderStyle(colors)),
      ],
    );
  }

  /// Handle next button press - navigate to first question of the section
  void _onNextPressed(int sectionNumber) {
    if (_isLifestyle) {
      switch (sectionNumber) {
        case 1:
          controller.goToStep(0);
          break;
        case 2:
          controller.goToStep(2); // Lifestyle starts at step 2
          break;
        case 3:
          controller.goToStep(6); // 맛 취향 starts at step 6
          break;
        case 4:
          controller.goToStep(10); // 감각/성향 starts at step 10
          break;
      }
    } else {
      switch (sectionNumber) {
        case 1:
          controller.goToStep(0);
          break;
        case 2:
          controller.goToStep(2);
          break;
        case 3:
          controller.goToStep(6);
          break;
      }
    }
  }
}
