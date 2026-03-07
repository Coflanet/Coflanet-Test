import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';

/// Survey Index Screen (Figma: 1114:59459 - Survey_index01)
/// Shows vertical stepper with 4 sections before starting survey
/// "[이름]님께 커피 경험 질문을 드릴게요!"
class SurveyIndexView extends GetView<SurveyController> {
  const SurveyIndexView({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<LocalStorage>();
    final userName = storage.getUserName() ?? '사용자';

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: _buildAppBar(),
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
                  color: AppColor.primaryNormal,
                ),
              ),
              const SizedBox(height: 8),

              // Main title
              Text(
                '$userName님께',
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              Text(
                '커피 경험 질문을 드릴게요!',
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                '취향 분석은 이런 단계로 진행돼요.',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                ),
              ),
              Text(
                '예상 소요 시간은 3분 입니다.',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                ),
              ),
              const SizedBox(height: 32),

              // 4-step vertical stepper (per Figma 1114:59459)
              _buildStepIndicator(1, '커피 경험 질문', isActive: true),
              _buildVerticalLine(),
              _buildStepIndicator(2, '기본 맛 취향', isActive: false),
              _buildVerticalLine(),
              _buildStepIndicator(3, '특성 향미 취향', isActive: false),
              _buildVerticalLine(),
              _buildStepIndicator(4, '커피 마시는 스타일', isActive: false),

              const Spacer(),

              // No bottom button - navigate via AppBar or auto-continue
              // Start button at bottom
              _buildStartButton(),

              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(AppColor.labelNormal, BlendMode.srcIn),
        ),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Text(
        '취향 분석',
        style: AppTextStyles.headline2Bold.copyWith(
          color: AppColor.labelNormal,
        ),
      ),
    );
  }

  /// Build a step indicator row with circle and text
  Widget _buildStepIndicator(int step, String label, {required bool isActive}) {
    return Row(
      children: [
        // Circle with number
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColor.primaryNormal : AppColor.transparent,
            border: isActive
                ? null
                : Border.all(color: AppColor.lineNormalNormal, width: 1.5),
          ),
          child: Center(
            child: Text(
              '$step',
              style: AppTextStyles.label1NormalBold.copyWith(
                color: isActive
                    ? AppColor.staticLabelWhiteNormal
                    : AppColor.labelAlternative,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Label text
        Text(
          label,
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: isActive ? AppColor.primaryNormal : AppColor.labelNormal,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Build vertical connecting line between steps
  Widget _buildVerticalLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 15), // Center under 32px circle
      child: Container(
        width: 2,
        height: 24,
        color: AppColor.lineNormalNormal.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => controller.startSurvey(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryNormal,
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
