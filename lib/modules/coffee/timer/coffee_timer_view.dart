import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/modules/coffee/timer/coffee_timer_controller.dart';
import 'package:coflanet/modules/coffee/timer/widgets/timer_action_text.dart';
import 'package:coflanet/modules/coffee/timer/widgets/timer_step_illustration.dart';
import 'package:coflanet/modules/coffee/timer/widgets/timer_water_amount_chip.dart';
import 'package:coflanet/widgets/timer/circular_timer.dart';
import 'package:coflanet/widgets/modals/confirm_modal.dart';

/// 타이머 진행 화면 — Figma(레시피 타이머) 정합.
///
/// 상단바: 뒤로(글라스 칩) + 가운데 스텝 트래커(점/번호 배지). 본문 상단:
/// 제목/설명. 가운데: 준비 스텝=일러스트, 타이머 스텝=Total 정보 + 원형
/// 타이머(연보라 원판, 상단 소요시간·중앙 남은시간·하단 재생/일시정지) + 액션
/// 안내. 사전 카운트다운은 하단 토스트(블러 알약). 하단 CTA: 이전/다음(알약).
///
/// 1초 틱 Obx 경계(CircularTimer)와 타이머 상태 분기 네비게이션은 controller
/// 강결합이라 View 에 잔류한다 — 400줄 임계값 초과의 정당한 예외.
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
        appBar: _buildAppBar(context, colors),
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
                      // 본문: 제목/설명(상단 고정) + 가운데 콘텐츠 그룹
                      Padding(
                        padding: AppSpacing.horizontal(AppSpacing.space24),
                        child: Column(
                          children: [
                            SizedBox(height: AppSpacing.space8),
                            _buildTitleBlock(colors, step),
                            Expanded(
                              child: Center(
                                child: step.isPreparation
                                    ? _buildPreparationContent(colors, step)
                                    : _buildTimedContent(colors, step),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 하단 페이드 — 콘텐츠가 CTA 로 매끄럽게 이어지도록
                      _buildBottomFade(colors),
                      // 사전 카운트다운 토스트 (하단, CTA 위)
                      if (controller.state == TimerState.preCountdown)
                        _buildPreCountdownToast(colors),
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

  // ─── App Bar (뒤로 + 스텝 트래커) ───

  PreferredSizeWidget _buildAppBar(BuildContext context, AppColorScheme colors) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: colors.backgroundNormalNormal,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      leadingWidth: AppSpacing.space56,
      leading: Center(
        child: GestureDetector(
          onTap: _showStopConfirmation,
          child: Container(
            width: AppSpacing.space40,
            height: AppSpacing.space40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.componentFillAlternative,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AssetPath.iconArrowBack,
              width: AppSpacing.space20,
              height: AppSpacing.space20,
              colorFilter: ColorFilter.mode(colors.labelNormal, BlendMode.srcIn),
            ),
          ),
        ),
      ),
      title: _buildStepProgress(colors),
      centerTitle: true,
    );
  }

  // ─── Step Progress Tracker (점 + 현재 번호 배지) ───

  Widget _buildStepProgress(AppColorScheme colors) {
    return Obx(() {
      final total = controller.totalSteps;
      final current = controller.currentStepIndex;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(total, (index) {
          final isCurrent = index == current;
          final isPast = index < current;

          return Padding(
            padding: AppSpacing.horizontal(AppSpacing.space4),
            child: isCurrent
                ? Container(
                    width: AppSpacing.space20,
                    height: AppSpacing.space20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primarySecondary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.caption1Bold.copyWith(
                        color: AppColor.staticWhite,
                      ),
                    ),
                  )
                : Container(
                    width: AppSpacing.space8,
                    height: AppSpacing.space8,
                    decoration: BoxDecoration(
                      color: isPast
                          ? colors.primarySecondary
                          : colors.lineSolidNormal,
                      shape: BoxShape.circle,
                    ),
                  ),
          );
        }),
      );
    });
  }

  // ─── Title + Description ───

  Widget _buildTitleBlock(AppColorScheme colors, dynamic step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          step.title,
          style: AppTextStyles.title2Bold.copyWith(color: colors.labelStrong),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.space4),
        Text(
          step.description,
          style: AppTextStyles.label1NormalRegular.copyWith(
            color: colors.labelAlternative,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ─── Total Info Pill (Total · 물의 양 | 총 시간) ───

  Widget _buildTotalInfo(AppColorScheme colors) {
    return Obx(() {
      return Container(
        padding: AppSpacing.symmetric(
          h: AppSpacing.space12,
          v: AppSpacing.space8,
        ),
        decoration: BoxDecoration(
          color: colors.backgroundNormalAlternative,
          borderRadius: AppRadius.fullBorder,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total',
              style: AppTextStyles.label1NormalBold.copyWith(
                color: colors.labelAssistive,
              ),
            ),
            SizedBox(width: AppSpacing.space8),
            Text(
              controller.totalWaterValue,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelNeutral,
              ),
            ),
            Padding(
              padding: AppSpacing.horizontal(AppSpacing.space4),
              child: Container(
                width: 1,
                height: AppSpacing.space12,
                color: colors.lineNormalNormal,
              ),
            ),
            Text(
              controller.totalTimeLabel,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelNeutral,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── Preparation Step Content (일러스트 + 액션) ───

  Widget _buildPreparationContent(AppColorScheme colors, dynamic step) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimerStepIllustration(
          title: step.title,
          illustrationEmoji: step.illustrationEmoji,
        ),
        SizedBox(height: AppSpacing.space20),
        if (step.actionText != null) TimerActionText(text: step.actionText!),
      ],
    );
  }

  // ─── Timed Step Content (Total + 원형 타이머 + 액션) ───

  Widget _buildTimedContent(AppColorScheme colors, dynamic step) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTotalInfo(colors),
        SizedBox(height: AppSpacing.space20),
        // 원형 타이머 — 1초 틱 사이를 선형 보간해 연속 스윕으로 표시.
        // key 를 스텝 단위로 바꿔 스텝 전환 시 되감기 애니메이션 방지.
        Obx(() {
          final isRunning = controller.state == TimerState.running;
          return GestureDetector(
            onTap: controller.toggleTimer,
            child: CircularTimer(
              key: ValueKey(controller.currentStepIndex),
              progress: controller.stepProgress,
              animationDuration: const Duration(seconds: 1),
              size: 220,
              strokeWidth: 12,
              progressColor: colors.primaryNormal,
              backgroundColor: colors.lineSolidNormal,
              fillColor: colors.primaryLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 스텝 총 소요 시간
                  Text(
                    controller.stepDurationString,
                    style: AppTextStyles.heading2Regular.copyWith(
                      color: colors.labelAlternative,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                  SizedBox(height: AppSpacing.space2),
                  // 남은 시간 (강조)
                  Text(
                    controller.remainingTimeString,
                    style: AppTextStyles.display1Medium.copyWith(
                      color: colors.labelStrong,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                  SizedBox(height: AppSpacing.space2),
                  // 재생/일시정지 표시 (탭하면 토글)
                  Icon(
                    isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: colors.labelNeutral,
                    size: AppSpacing.space28,
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: AppSpacing.space24),
        if (step.actionText != null)
          TimerActionText(text: step.actionText!)
        else if (step.waterAmount != null)
          TimerWaterAmountChip(waterAmount: step.waterAmount!),
      ],
    );
  }

  // ─── Bottom Fade ───

  Widget _buildBottomFade(AppColorScheme colors) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: AppSpacing.space40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.backgroundNormalNormal.withValues(alpha: 0.0),
                colors.backgroundNormalNormal,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Pre-Countdown Toast (블러 알약, 하단) ───

  Widget _buildPreCountdownToast(AppColorScheme colors) {
    return Positioned(
      left: AppSpacing.space20,
      right: AppSpacing.space20,
      bottom: AppSpacing.space12,
      child: Obx(() {
        final nextName =
            controller.nextTimedStepName ?? controller.currentStep?.title ?? '';
        return ClipRRect(
          borderRadius: AppRadius.fullBorder,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: AppSpacing.symmetric(
                h: AppSpacing.space16,
                v: AppSpacing.space12,
              ),
              decoration: BoxDecoration(
                color: colors.inverseBackground.withValues(alpha: 0.88),
                borderRadius: AppRadius.fullBorder,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: colors.inverseLabelNormal,
                    size: AppSpacing.space20,
                  ),
                  SizedBox(width: AppSpacing.space8),
                  Expanded(
                    child: Text(
                      '${controller.preCountdownSeconds}초 뒤에 $nextName이 시작됩니다.',
                      style: AppTextStyles.body2NormalMedium.copyWith(
                        color: colors.inverseLabelNormal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─── Bottom Navigation (이전 / 다음 — 알약) ───

  Widget _buildBottomNavigation(AppColorScheme colors) {
    return Obx(() {
      final step = controller.currentStep;
      if (step == null) return const SizedBox();

      return Container(
        color: colors.backgroundNormalNormal,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.space16,
          AppSpacing.space12,
          AppSpacing.space16,
          AppSpacing.space16,
        ),
        child: controller.isFirstStep
            ? _ctaButton(
                colors,
                label: controller.isLastStep ? '완료' : '다음',
                primary: true,
                onTap: controller.nextStep,
              )
            : Row(
                children: [
                  Expanded(
                    child: _ctaButton(
                      colors,
                      label: '이전',
                      primary: false,
                      onTap: controller.previousStep,
                    ),
                  ),
                  SizedBox(width: AppSpacing.space4),
                  Expanded(
                    child: _ctaButton(
                      colors,
                      label: controller.isLastStep ? '완료' : '다음',
                      primary: true,
                      onTap: controller.nextStep,
                    ),
                  ),
                ],
              ),
      );
    });
  }

  Widget _ctaButton(
    AppColorScheme colors, {
    required String label,
    required bool primary,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      // Large 버튼 높이 — PrimaryButton(ButtonSize.lg) 과 동일한 컴포넌트 치수
      height: 52,
      child: Material(
        color: primary ? colors.primaryNormal : colors.componentFillAlternative,
        borderRadius: AppRadius.fullBorder,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.body1NormalBold.copyWith(
                color: primary
                    ? AppColor.staticLabelWhiteStrong
                    : colors.labelNormal,
              ),
            ),
          ),
        ),
      ),
    );
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
