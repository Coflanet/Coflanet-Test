import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/coffee/timer/coffee_timer_controller.dart';
import 'package:coflanet/data/models/timer_step_model.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class TimerCompleteView extends GetView<CoffeeTimerController> {
  const TimerCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    final recipe = controller.recipe;

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconClose, // Close icon - navigates to Home
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColor.labelNormal,
              BlendMode.srcIn,
            ),
          ),
          onPressed: controller.goToHome,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // ─── Coffee mug illustration ───
            _buildMugIllustration(),

            const SizedBox(height: 32),

            // ─── Completion message ───
            _buildCompletionMessage(recipe),

            const SizedBox(height: 32),

            // ─── Aroma card ───
            if (recipe != null &&
                (recipe.aromaDescription != null ||
                    recipe.aromaTags.isNotEmpty))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildAromaCard(recipe),
              ),

            const Spacer(flex: 3),

            // ─── CTA button ───
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                text: '완료하기',
                onPressed: controller.goToHome,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMugIllustration() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.primaryLight,
        ),
        child: const Center(
          child: Text('\u2615', style: AppTextStyles.emojiLarge),
        ),
      ),
    );
  }

  Widget _buildCompletionMessage(TimerRecipeModel? recipe) {
    final message = recipe?.completionMessage ?? '맛있는 커피가 완성되었어요!';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          message,
          style: AppTextStyles.title2Bold.copyWith(color: AppColor.labelNormal),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAromaCard(TimerRecipeModel recipe) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.primaryLight,
          borderRadius: AppRadius.xlBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              '이런 향을 느껴보세요',
              style: AppTextStyles.headline2Bold.copyWith(
                color: AppColor.primaryNormal,
              ),
            ),

            // Description
            if (recipe.aromaDescription != null) ...[
              const SizedBox(height: 8),
              Text(
                recipe.aromaDescription!,
                style: AppTextStyles.body2NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                ),
              ),
            ],

            // Flavor tags
            if (recipe.aromaTags.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildFlavorTags(recipe.aromaTags),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFlavorTags(List<AromaTagModel> tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.backgroundNormalNormal,
            borderRadius: AppRadius.xxlBorder,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tag.emoji, style: AppTextStyles.emojiSmall),
              const SizedBox(width: 6),
              Text(
                tag.name,
                style: AppTextStyles.label1NormalMedium.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
