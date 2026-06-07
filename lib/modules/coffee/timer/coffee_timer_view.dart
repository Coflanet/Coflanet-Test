import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/coffee/timer/coffee_timer_controller.dart';
import 'package:coflanet/modules/coffee/timer/widgets/timer_action_text.dart';
import 'package:coflanet/modules/coffee/timer/widgets/timer_step_illustration.dart';
import 'package:coflanet/modules/coffee/timer/widgets/timer_water_amount_chip.dart';
import 'package:coflanet/widgets/timer/circular_timer.dart';
import 'package:coflanet/widgets/modals/confirm_modal.dart';

/// 타이머 진행 화면 — 스텝 dot / 정보 바 / 준비·타이머 콘텐츠 / 하단 네비게이션.
///
/// 순수 표시 위젯(TimerActionText/TimerStepIllustration/TimerWaterAmountChip)은
/// widgets/ 로 분리. 1초 틱 Obx 경계(CircularTimer/preCountdown 오버레이)와
/// 타이머 상태 5분기 네비게이션은 controller 강결합이라 View 에 잔류한다 —
/// 400줄 임계값 초과의 정당한 예외.
class CoffeeTimerView extends GetView<CoffeeTimerController> {
  const CoffeeTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showStopConfirmation();
      },
      child: Scaffold(
        backgroundColor: colors.backgroundNormalNormal,
        appBar: _buildAppBar(colors),
        body: SafeArea(
          top: false,
          child: Obx(() {
            final step = controller.currentStep;
            if (step == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Main content
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            _buildStepDotIndicator(colors),
                            const SizedBox(height: 12),
                            _buildInfoBar(colors),
                            const SizedBox(height: 28),
                            if (step.isPreparation)
                              _buildPreparationContent(colors, step)
                            else
                              _buildTimedContent(colors, step),
                          ],
                        ),
                      ),
                      // Pre-countdown overlay
                      if (controller.state == TimerState.preCountdown)
                        _buildPreCountdownOverlay(colors),
                    ],
                  ),
                ),
                _buildBottomNavigation(colors),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ─── App Bar ───

  PreferredSizeWidget _buildAppBar(AppColorScheme colors) {
    return AppBar(
      backgroundColor: colors.backgroundNormalNormal,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            colors.labelNormal,
            BlendMode.srcIn,
          ),
        ),
        onPressed: () => _showStopConfirmation(),
      ),
      title: Obx(() {
        final step = controller.currentStep;
        return Text(
          step != null
              ? 'Step ${step.stepNumber}. ${step.title}'
              : controller.recipe?.name ?? '타이머',
          style: AppTextStyles.headline2Bold.copyWith(
            color: colors.labelNormal,
          ),
        );
      }),
      centerTitle: true,
    );
  }

  // ─── Step Dot Indicator ───

  Widget _buildStepDotIndicator(AppColorScheme colors) {
    return Obx(() {
      final total = controller.totalSteps;
      final current = controller.currentStepIndex;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (index) {
          final isActive = index == current;
          final isPast = index < current;
          final dotSize = isActive ? 10.0 : 8.0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // 비활성 dot 트랙 — 라이트 회색을 시맨틱 비활성 토큰으로
                color: (isActive || isPast)
                    ? colors.primaryNormal
                    : colors.interactionInactive,
              ),
            ),
          );
        }),
      );
    });
  }

  // ─── Info Bar (Total water | time pill) ───

  Widget _buildInfoBar(AppColorScheme colors) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: colors.backgroundNormalAlternative,
          borderRadius: AppRadius.xxlBorder,
        ),
        child: Text(
          '${controller.totalWaterLabel} | ${controller.totalTimeLabel}',
          style: AppTextStyles.caption1Medium.copyWith(
            color: colors.labelAlternative,
          ),
        ),
      );
    });
  }

  // ─── Preparation Step Content ───

  Widget _buildPreparationContent(AppColorScheme colors, dynamic step) {
    return Column(
      children: [
        // Title
        Text(
          step.title,
          style: AppTextStyles.title2Bold.copyWith(
            color: colors.labelNormal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Description
        Text(
          step.description,
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: colors.labelAlternative,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),
        // 스텝 일러스트
        TimerStepIllustration(
          title: step.title,
          illustrationEmoji: step.illustrationEmoji,
        ),
        const SizedBox(height: 36),
        // 수치 강조 액션 안내
        if (step.actionText != null) TimerActionText(text: step.actionText!),
      ],
    );
  }

  // ─── Timed Step Content (Brewing / Waiting) ───

  Widget _buildTimedContent(AppColorScheme colors, dynamic step) {
    return Column(
      children: [
        // Title
        Text(
          step.title,
          style: AppTextStyles.title2Bold.copyWith(
            color: colors.labelNormal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Description
        Text(
          step.description,
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: colors.labelAlternative,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        // Step duration label
        Obx(
          () => Text(
            controller.stepDurationString,
            style: AppTextStyles.caption1Medium.copyWith(
              color: colors.labelAssistive,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Circular timer — 1초 틱 사이를 선형 보간해 연속 스윕으로 표시.
        // key 를 스텝 단위로 바꿔 스텝 전환 시 되감기 애니메이션 방지.
        Obx(
          () => CircularTimer(
            key: ValueKey(controller.currentStepIndex),
            progress: controller.stepProgress,
            animationDuration: const Duration(seconds: 1),
            progressColor: colors.primaryNormal,
            // 타이머 트랙 — 라이트 회색을 시맨틱 비활성 토큰으로
            backgroundColor: colors.componentFillStrong,
            size: 240,
            strokeWidth: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.remainingTimeString,
                  style: AppTextStyles.display2Bold.copyWith(
                    color: colors.labelNormal,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '남은 시간',
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: colors.labelAssistive,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // 수치 강조 액션 안내 / 물의 양 칩
        if (step.actionText != null) TimerActionText(text: step.actionText!),
        if (step.waterAmount != null && step.actionText == null)
          TimerWaterAmountChip(waterAmount: step.waterAmount!),
      ],
    );
  }

  // ─── Pre-Countdown Overlay ───

  Widget _buildPreCountdownOverlay(AppColorScheme colors) {
    return Positioned(
      top: 16,
      left: 24,
      right: 24,
      child: Obx(() {
        final nextName =
            controller.nextTimedStepName ?? controller.currentStep?.title ?? '';
        // 대비 토스트 — 배경/텍스트를 inverse 토큰으로 묶어 테마와 함께 반전
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.inverseBackground,
            borderRadius: AppRadius.lgBorder,
            boxShadow: AppShadows.shadowBlackEmphasize,
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: colors.inverseLabelStrong,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${controller.preCountdownSeconds}초 뒤에 $nextName이 시작됩니다',
                  style: AppTextStyles.label1NormalMedium.copyWith(
                    color: colors.inverseLabelStrong,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ─── Bottom Navigation ───

  Widget _buildBottomNavigation(AppColorScheme colors) {
    return Obx(() {
      final step = controller.currentStep;
      if (step == null) return const SizedBox();

      return Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        decoration: BoxDecoration(
          color: colors.backgroundNormalNormal,
        ),
        child: step.isPreparation
            ? _buildPrepNavigationButtons(colors)
            : _buildTimedNavigationButtons(colors),
      );
    });
  }

  Widget _buildPrepNavigationButtons(AppColorScheme colors) {
    return Obx(() {
      return Row(
        children: [
          // Previous button
          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: controller.isFirstStep
                    ? null
                    : () => controller.previousStep(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: controller.isFirstStep
                        ? colors.lineNormalNormal
                        : colors.lineNormalAlternative,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgBorder,
                  ),
                  foregroundColor: colors.labelNormal,
                  disabledForegroundColor: colors.labelDisable,
                ),
                child: Text(
                  '이전',
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: controller.isFirstStep
                        ? colors.labelDisable
                        : colors.labelNormal,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Next button
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () => controller.nextStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primaryNormal,
                  foregroundColor: AppColor.staticLabelWhiteStrong,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgBorder,
                  ),
                ),
                child: Text(
                  controller.isLastStep ? '완료' : '다음',
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: AppColor.staticLabelWhiteStrong,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTimedNavigationButtons(AppColorScheme colors) {
    return Obx(() {
      final state = controller.state;
      final isRunning = state == TimerState.running;
      final isPreCountdown = state == TimerState.preCountdown;
      final isTimerActive = isRunning || isPreCountdown;

      return Row(
        children: [
          // Previous button
          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: controller.isFirstStep
                    ? null
                    : () => controller.previousStep(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: controller.isFirstStep
                        ? colors.lineNormalNormal
                        : colors.lineNormalAlternative,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgBorder,
                  ),
                  foregroundColor: colors.labelNormal,
                  disabledForegroundColor: colors.labelDisable,
                ),
                child: Text(
                  '이전',
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: controller.isFirstStep
                        ? colors.labelDisable
                        : colors.labelNormal,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Play/Pause / Next button
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 52,
              child: isTimerActive
                  ? ElevatedButton.icon(
                      onPressed: () => controller.toggleTimer(),
                      icon: Icon(
                        isRunning
                            ? Icons.pause_rounded
                            : Icons.hourglass_top_rounded,
                        size: 20,
                      ),
                      label: Text(
                        isRunning ? '일시정지' : '준비 중...',
                        style: AppTextStyles.body1NormalMedium.copyWith(
                          color: AppColor.staticLabelWhiteStrong,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRunning
                            ? colors.primaryNormal
                            : colors.labelAssistive,
                        foregroundColor: AppColor.staticLabelWhiteStrong,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.lgBorder,
                        ),
                      ),
                    )
                  : state == TimerState.paused
                  ? ElevatedButton.icon(
                      onPressed: () => controller.toggleTimer(),
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      label: Text(
                        '계속',
                        style: AppTextStyles.body1NormalMedium.copyWith(
                          color: AppColor.staticLabelWhiteStrong,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primaryNormal,
                        foregroundColor: AppColor.staticLabelWhiteStrong,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.lgBorder,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: isTimerActive
                          ? null
                          : () => controller.nextStep(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primaryNormal,
                        foregroundColor: AppColor.staticLabelWhiteStrong,
                        disabledBackgroundColor: colors.interactionDisable,
                        disabledForegroundColor: colors.labelDisable,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.lgBorder,
                        ),
                      ),
                      child: Text(
                        controller.isLastStep ? '완료' : '다음',
                        style: AppTextStyles.body1NormalMedium.copyWith(
                          color: isTimerActive
                              ? AppColor.labelDisable
                              : AppColor.staticLabelWhiteStrong,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }

  // ─── Stop Confirmation Dialog (RT-08: Recipe Close Alert) ───

  void _showStopConfirmation() async {
    final confirmed = await ConfirmModal.show(
      title: '타이머를 중단할까요?',
      message: '진행 상황이 저장되지 않습니다.',
      confirmText: '중단',
      cancelText: '취소',
      isDestructive: true,
    );

    if (confirmed == true) {
      controller.stopTimer();
    }
  }
}
