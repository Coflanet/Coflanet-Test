import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_step_indicator.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Survey Index Screen — Figma POC `Survey_index01` (1114:59459 / 1401:19621)
/// 설문 시작 안내 + 진행 단계 스테퍼. 캔버스 흰색 유지(온보딩 흐름 일관).
/// 텍스트 블록은 중앙 정렬, 스테퍼는 좌측 정렬(24px 불릿 + 연결선).
class SurveyIndexView extends GetView<SurveyController> {
  const SurveyIndexView({super.key});

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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space24,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.space16),

                    // Figma 1401:19624 — 중앙 정렬 타이틀 + 보조 문구
                    Text(
                      '$userName님께\n커피 경험 질문을 드릴게요!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1Bold.copyWith(
                        color: colors.labelNormal,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space8),
                    Text(
                      '취향 분석은 이런 단계로 진행돼요.\n예상 소요 시간은 3분 입니다.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.label2Regular.copyWith(
                        color: colors.labelAlternative,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.space40),

                    // Figma 1401:20044 — 진행 단계 스테퍼 (좌측 정렬)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space20,
                      ),
                      child: SurveyStepIndicator(
                        colors: colors,
                        labels: const ['커피 경험 질문', '기본 맛 취향', '특성 향미 취향'],
                        currentStep: 1,
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Figma 프레임엔 버튼이 없으나(프로토타입 자동 진행), 라우트 진입 시
            // 다음 단계로 넘어갈 수단이 필요해 표준 pill 버튼을 유지한다.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space24,
                AppSpacing.space16,
                AppSpacing.space24,
                AppSpacing.space24,
              ),
              child: PrimaryButton(
                text: '다음',
                onPressed: () => controller.startSurvey(),
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
    );
  }
}
