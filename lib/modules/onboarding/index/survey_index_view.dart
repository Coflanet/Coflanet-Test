import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';

/// Survey Index Screen (Figma: Survey_01.png)
/// Shows vertical stepper with 3 sections before starting survey
/// "[이름]님께 커피 경험 질문을 드릴게요!"
class SurveyIndexView extends GetView<SurveyController> {
  const SurveyIndexView({super.key});

  // Figma 사양: Pretendard SemiBold 22 / lineHeight 1.36 / letterSpacing -0.4268
  // 색상은 Label/strong (#000000) 토큰 매핑
  // Auth 카테고리에서 통일한 페이지 헤더 스타일과 동일
  TextStyle _screenHeaderStyle(AppColorScheme colors) =>
      AppTextStyles.heading1Bold.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.36,
        letterSpacing: -0.4268,
        color: colors.labelStrong,
      );

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    final storage = Get.find<LocalStorage>();
    final userName = storage.getUserName() ?? '사용자';

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: _buildAppBar(colors),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Badge text
              Text(
                '첫번째 취향 조사를 시작할게요!',
                style: AppTextStyles.caption1Regular.copyWith(
                  color: colors.primaryNormal,
                ),
              ),
              const SizedBox(height: 8),

              // Main title
              Text('$userName님께', style: _screenHeaderStyle(colors)),
              Text('커피 경험 질문을 드릴게요!', style: _screenHeaderStyle(colors)),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                '취향 분석은 이런 단계로 진행돼요.',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
              Text(
                '예상 소요 시간은 3분 입니다.',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
              const SizedBox(height: 32),

              // 3-step vertical stepper (Figma: Survey_01.png)
              _buildStepIndicator(colors, 1, '커피 경험 질문', isActive: true),
              _buildVerticalLine(colors),
              _buildStepIndicator(colors, 2, '기본 맛 취향', isActive: false),
              _buildVerticalLine(colors),
              _buildStepIndicator(colors, 3, '특성 향미 취향', isActive: false),

              const Spacer(),

              // No bottom button - navigate via AppBar or auto-continue
              // Start button at bottom
              _buildStartButton(colors),

              const SizedBox(height: 34),
            ],
          ),
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
        style: AppTextStyles.headline2Bold.copyWith(
          color: colors.labelNormal,
        ),
      ),
    );
  }

  /// Build a step indicator row with circle and text (Figma: Survey_01.png)
  Widget _buildStepIndicator(
    AppColorScheme colors,
    int step,
    String label, {
    required bool isActive,
  }) {
    return Row(
      children: [
        // Circle with number
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? colors.primaryNormal : AppColor.transparent,
            border: isActive
                ? null
                : Border.all(color: colors.lineNormalNormal, width: 1.5),
          ),
          child: Center(
            child: Text(
              '$step',
              style: AppTextStyles.label1NormalBold.copyWith(
                color: isActive
                    ? AppColor.staticLabelWhiteNormal
                    : colors.labelAlternative,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Label
        Text(
          label,
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: isActive ? colors.primaryNormal : colors.labelNormal,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Build vertical connecting line between steps
  Widget _buildVerticalLine(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 15), // Center under 32px circle
      child: Container(
        width: 2,
        height: 24,
        color: colors.lineNormalNormal.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildStartButton(AppColorScheme colors) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => controller.startSurvey(),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryNormal,
          foregroundColor: AppColor.staticLabelWhiteNormal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          '다음',
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: AppColor.staticLabelWhiteNormal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
