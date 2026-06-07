import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/reason/survey_reason_controller.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_checkbox_item.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_progress_bar.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Survey Reason Screen (Figma: 937:45569 - Onboarding_Survey_Reason)
/// "커플래닛을 찾게 된 이유를 알려주세요." - 중복 선택 가능
class SurveyReasonView extends GetView<SurveyReasonController> {
  const SurveyReasonView({super.key});

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

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: _buildAppBar(colors),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SurveyProgressIndicator(progress: 1.0),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Title
                    Text('커플래닛을 찾게 된', style: _screenHeaderStyle(colors)),
                    Text('이유를 알려주세요.', style: _screenHeaderStyle(colors)),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      '중복 선택 가능해요.',
                      style: AppTextStyles.body1NormalRegular.copyWith(
                        color: colors.labelAlternative,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Checkbox options
                    _buildOptions(),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            _buildBottomCTA(colors),
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
        tooltip: '뒤로 가기',
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildOptions() {
    return Obx(
      () => Column(
        children: controller.options.map((option) {
          final isSelected = controller.isSelected(option.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SurveyCheckboxItem(
              label: option.label,
              isSelected: isSelected,
              onTap: () => controller.toggleOption(option.id),
              showIcon: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomCTA(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
      decoration: BoxDecoration(color: colors.backgroundNormalNormal),
      child: Obx(
        () => PrimaryButton(
          text: '원두 취향 찾으러 가기',
          onPressed: controller.complete,
          isEnabled: controller.hasSelection,
        ),
      ),
    );
  }
}
