import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/coffee/timer/coffee_timer_controller.dart';
import 'package:coflanet/widgets/timer/circular_timer.dart';
import 'package:coflanet/widgets/modals/confirm_modal.dart';

class CoffeeTimerView extends GetView<CoffeeTimerController> {
  const CoffeeTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showStopConfirmation();
      },
      child: Scaffold(
        backgroundColor: AppColor.backgroundNormalNormal, // White per Figma
        appBar: _buildAppBar(),
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
                            _buildStepDotIndicator(),
                            const SizedBox(height: 12),
                            _buildInfoBar(),
                            const SizedBox(height: 28),
                            if (step.isPreparation)
                              _buildPreparationContent(step)
                            else
                              _buildTimedContent(step),
                          ],
                        ),
                      ),
                      // Pre-countdown overlay
                      if (controller.state == TimerState.preCountdown)
                        _buildPreCountdownOverlay(),
                    ],
                  ),
                ),
                _buildBottomNavigation(),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ─── App Bar ───

  PreferredSizeWidget _buildAppBar() {
    // White background, dark text/icons
    return AppBar(
      backgroundColor: AppColor.backgroundNormalNormal,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            AppColor.labelNormal, // Dark icon on white bg
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
            color: AppColor.labelNormal, // Dark text on white bg
          ),
        );
      }),
      centerTitle: true,
    );
  }

  // ─── Step Dot Indicator ───

  Widget _buildStepDotIndicator() {
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
                color: (isActive || isPast)
                    ? AppColor.primaryNormal
                    : AppColor
                          .colorGlobalCoolNeutral80, // Light gray for inactive
              ),
            ),
          );
        }),
      );
    });
  }

  // ─── Info Bar (Total water | time pill) ───

  Widget _buildInfoBar() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalAlternative, // Light gray pill
          borderRadius: AppRadius.xxlBorder,
        ),
        child: Text(
          '${controller.totalWaterLabel} | ${controller.totalTimeLabel}',
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColor.labelAlternative, // Dark gray text
          ),
        ),
      );
    });
  }

  // ─── Preparation Step Content ───

  Widget _buildPreparationContent(dynamic step) {
    return Column(
      children: [
        // Title
        Text(
          step.title,
          style: AppTextStyles.title2Bold.copyWith(
            color: AppColor.labelNormal, // Dark on white bg
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Description
        Text(
          step.description,
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: AppColor.labelAlternative, // Gray on white bg
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),
        // Step illustration
        _buildStepIllustration(step),
        const SizedBox(height: 36),
        // Action text with highlighted keywords
        if (step.actionText != null) _buildActionText(step.actionText!),
      ],
    );
  }

  // ─── Timed Step Content (Brewing / Waiting) ───

  Widget _buildTimedContent(dynamic step) {
    return Column(
      children: [
        // Title
        Text(
          step.title,
          style: AppTextStyles.title2Bold.copyWith(
            color: AppColor.labelNormal, // Dark on white bg
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Description
        Text(
          step.description,
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: AppColor.labelAlternative, // Gray on white bg
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        // Step duration label
        Obx(
          () => Text(
            controller.stepDurationString,
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColor.labelAssistive, // Light gray
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Circular timer
        Obx(
          () => CircularTimer(
            progress: controller.stepProgress,
            progressColor: AppColor.primaryNormal,
            backgroundColor:
                AppColor.colorGlobalCoolNeutral90, // Light gray track
            size: 240,
            strokeWidth: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.remainingTimeString,
                  style: AppTextStyles.display2Bold.copyWith(
                    color: AppColor.labelNormal, // Dark on white bg
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '남은 시간',
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAssistive, // Light gray
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Action text with water amount highlighted
        if (step.actionText != null) _buildActionText(step.actionText!),
        if (step.waterAmount != null && step.actionText == null)
          _buildWaterAmountChip(step.waterAmount!),
      ],
    );
  }

  // ─── Action Text with highlighted numbers/measurements ───

  Widget _buildActionText(String text) {
    // Highlight patterns: numbers followed by g, ml, 초, 번, etc.
    final regex = RegExp(r'(\d+\s*(?:g|ml|초|번|회|분|μm))');
    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: AppColor.labelNormal, // Dark text
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: AppTextStyles.body1NormalBold.copyWith(
            color: AppColor.primaryNormal, // Violet highlight
          ),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastEnd),
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: AppColor.labelNormal, // Dark text
          ),
        ),
      );
    }

    // Fallback: no matches → plain text
    if (spans.isEmpty) {
      spans.add(
        TextSpan(
          text: text,
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: AppColor.labelNormal, // Dark text
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalAlternative, // Light gray card
        borderRadius: AppRadius.lgBorder,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: spans),
      ),
    );
  }

  // ─── Step Illustration (real images for preparation steps) ───

  Widget _buildStepIllustration(dynamic step) {
    final assetPath = _getIllustrationAsset(step.title);

    if (assetPath != null) {
      // Use real illustration image
      return Image.asset(
        assetPath,
        width: 280,
        height: 280,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to emoji if image fails to load
          return _buildEmojiPlaceholder(step.illustrationEmoji ?? '☕');
        },
      );
    }

    // Fallback to emoji placeholder
    return _buildEmojiPlaceholder(step.illustrationEmoji ?? '☕');
  }

  String? _getIllustrationAsset(String stepTitle) {
    // Map step titles to illustration assets
    switch (stepTitle) {
      case '원두 분쇄':
        return AssetPath.timerStepGrinder;
      case '예열하기':
        return AssetPath.timerStepPourover;
      default:
        return null;
    }
  }

  Widget _buildEmojiPlaceholder(String emoji) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: AppTextStyles.emojiLarge),
    );
  }

  Widget _buildWaterAmountChip(int waterAmount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalAlternative, // Light gray card
        borderRadius: AppRadius.lgBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.water_drop_outlined,
            color: AppColor.primaryNormal,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${waterAmount}ml',
            style: AppTextStyles.body1NormalBold.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Pre-Countdown Overlay ───

  Widget _buildPreCountdownOverlay() {
    return Positioned(
      top: 16,
      left: 24,
      right: 24,
      child: Obx(() {
        final nextName =
            controller.nextTimedStepName ?? controller.currentStep?.title ?? '';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.labelNormal,
            borderRadius: AppRadius.lgBorder,
            boxShadow: AppShadows.shadowBlackEmphasize,
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: AppColor.staticLabelWhiteStrong,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${controller.preCountdownSeconds}초 뒤에 $nextName이 시작됩니다',
                  style: AppTextStyles.label1NormalMedium.copyWith(
                    color: AppColor.staticLabelWhiteStrong,
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

  Widget _buildBottomNavigation() {
    return Obx(() {
      final step = controller.currentStep;
      if (step == null) return const SizedBox();

      return Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal, // White
        ),
        child: step.isPreparation
            ? _buildPrepNavigationButtons()
            : _buildTimedNavigationButtons(),
      );
    });
  }

  Widget _buildPrepNavigationButtons() {
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
                        ? AppColor.lineNormalNormal
                        : AppColor.lineNormalAlternative,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgBorder,
                  ),
                  foregroundColor: AppColor.labelNormal,
                  disabledForegroundColor: AppColor.labelDisable,
                ),
                child: Text(
                  '이전',
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: controller.isFirstStep
                        ? AppColor.labelDisable
                        : AppColor.labelNormal,
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
                  backgroundColor: AppColor.primaryNormal,
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

  Widget _buildTimedNavigationButtons() {
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
                        ? AppColor.lineNormalNormal
                        : AppColor.lineNormalAlternative,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgBorder,
                  ),
                  foregroundColor: AppColor.labelNormal,
                  disabledForegroundColor: AppColor.labelDisable,
                ),
                child: Text(
                  '이전',
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: controller.isFirstStep
                        ? AppColor.labelDisable
                        : AppColor.labelNormal,
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
                            ? AppColor.primaryNormal
                            : AppColor.labelAssistive,
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
                        backgroundColor: AppColor.primaryNormal,
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
                        backgroundColor: AppColor.primaryNormal,
                        foregroundColor: AppColor.staticLabelWhiteStrong,
                        disabledBackgroundColor: AppColor.interactionDisable,
                        disabledForegroundColor: AppColor.labelDisable,
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
