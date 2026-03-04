import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';

/// Survey Intro View - Figma: 1114-59435
/// 2개의 옵션 카드로 설문 유형 선택 (일반 설문 / 라이프스타일 분석)
class SurveyIntroView extends GetView<SurveyController> {
  const SurveyIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconArrowBack,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColor.labelNormal,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header text
              Text(
                '${controller.userName}님의 취향을',
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              Text(
                '찾으러 가볼까요?',
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                '원하는 분석 방식을 선택해주세요',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                ),
              ),
              const SizedBox(height: 32),

              // Option cards - Figma: 두 카드 동일 크기
              // Expanded로 남은 공간에 맞게 조정 (오버플로우 방지)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left card - 일반 설문
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 280),
                        child: _buildOptionCard(
                          label: '일반 설문',
                          description: '커피 맛과 향을\n직접 선택해요',
                          iconWidget: Image.asset(
                            AssetPath.emojiCoffee,
                            width: 72,
                            height: 72,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Text('☕', style: TextStyle(fontSize: 56)),
                          ),
                          onTap: () => controller.startSurvey(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Right card - 라이프스타일 분석
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 280),
                        child: _buildOptionCard(
                          label: '라이프스타일 분석',
                          description: '일상 습관으로\n취향을 파악해요',
                          iconWidget: Image.asset(
                            AssetPath.emojiBeach,
                            width: 72,
                            height: 72,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Text(
                              '🏖️',
                              style: TextStyle(fontSize: 56),
                            ),
                          ),
                          onTap: () => controller.startLifestyleSurvey(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 설문 건너뛰기 링크 - 하단
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => controller.skipSurvey(),
                  child: Text(
                    '설문 건너뛰기',
                    style: AppTextStyles.body2NormalMedium.copyWith(
                      color: AppColor.labelAssistive,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColor.labelAssistive,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Build an option card - Figma 디자인
  /// - 미선택 상태 (선택 인디케이터 없음)
  /// - 중앙 정렬
  /// - 탭 시 바로 해당 설문으로 이동
  Widget _buildOptionCard({
    required String label,
    required String description,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.lineNormalNormal, width: 1),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Label - 상단 중앙
            Text(
              label,
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: AppColor.labelAlternative,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Description - 중앙
            Text(
              description,
              style: AppTextStyles.body1NormalMedium.copyWith(
                color: AppColor.labelNormal,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Icon - 하단 중앙
            iconWidget,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
