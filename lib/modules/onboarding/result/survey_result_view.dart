import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
// AppCircularTasteIndicator replaced with simple emoji-based indicator
import 'package:coflanet/widgets/gauge/app_animated_taste_bar.dart';
import 'package:coflanet/widgets/forms/app_round_checkbox.dart';

class SurveyResultView extends GetView<SurveyController> {
  const SurveyResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.surveyResult;

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundNormalNormal,
        surfaceTintColor: AppColor.backgroundNormalNormal,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconClose, // Close icon - navigates to Home
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              AppColor.labelNormal,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => controller.completeOnboarding(),
        ),
        centerTitle: true,
        title: Text(
          '나의 커피 취향',
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Purple banner ──
          SliverToBoxAdapter(child: _buildBannerSection(result)),

          // ── Taste profile 4-column grid ──
          SliverToBoxAdapter(child: _buildTasteProfileGrid(result)),

          // ── Flavor descriptions ──
          SliverToBoxAdapter(child: _buildFlavorDescriptions(result)),

          // ── Divider ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1, color: AppColor.lineNormalAlternative),
            ),
          ),

          // ── Recommended coffee beans ──
          SliverToBoxAdapter(child: _buildRecommendationsSection(result)),

          // ── Bottom action links ──
          SliverToBoxAdapter(child: _buildBottomLinks()),

          // Bottom spacing so content clears the CTA bar
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomNavigationBar: _buildBottomCTA(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 1. Purple banner
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildBannerSection(SurveyResultModel? result) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.primaryNormal, AppColor.primaryStrong],
        ),
        borderRadius: AppRadius.xlBorder,
      ),
      child: Column(
        children: [
          // Pill badge — "{userName}님은"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.staticLabelWhiteStrong.withValues(alpha: 0.18),
              borderRadius: AppRadius.fullBorder,
            ),
            child: Text(
              '${controller.userName}님은',
              style: AppTextStyles.label2Medium.copyWith(
                color: AppColor.staticLabelWhiteStrong,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Coffee type — large title
          Text(
            result?.coffeeType ?? '',
            style: AppTextStyles.title2Bold.copyWith(
              color: AppColor.staticLabelWhiteStrong,
            ),
          ),
          const SizedBox(height: 10),

          // Description text
          Text(
            result?.coffeeTypeDescription ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.staticLabelWhiteStrong.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 2. Taste profile grid (4 columns)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildTasteProfileGrid(SurveyResultModel? result) {
    final profile = result?.tasteProfile;
    if (profile == null) return const SizedBox.shrink();

    final items = [
      _TasteItem(emoji: '🍋', label: '산미', value: profile.acidity),
      _TasteItem(emoji: '💪', label: '바디감', value: profile.body),
      _TasteItem(emoji: '🍬', label: '단맛', value: profile.sweetness),
      _TasteItem(emoji: '☕', label: '쓴맛', value: profile.bitterness),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 맛 프로필',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: items
                .map((item) => Expanded(child: _buildCircularTasteItem(item)))
                .toList(),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildCircularTasteItem(_TasteItem item) {
    // Determine emoji and level text based on value
    // Value >= 70 → 👍 좋음
    // Value >= 40 → 😐 보통
    // Value < 40 → 👎 싫음
    final String emoji;
    final String levelText;

    if (item.value >= 70) {
      emoji = '👍';
      levelText = '좋음';
    } else if (item.value >= 40) {
      emoji = '😐';
      levelText = '보통';
    } else {
      emoji = '👎';
      levelText = '싫음';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          item.label,
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
        const SizedBox(height: 8),

        // Emoji indicator
        Text(emoji, style: AppTextStyles.emojiLarge.copyWith(fontSize: 28)),
        const SizedBox(height: 6),

        // Level text
        Text(
          levelText,
          style: AppTextStyles.label2Medium.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 3. Flavor description list
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildFlavorDescriptions(SurveyResultModel? result) {
    final descriptions = result?.flavorDescriptions ?? [];
    if (descriptions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이런 맛을 좋아해요',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 20),
          ...descriptions.map((desc) => _buildFlavorRow(desc)),
        ],
      ),
    );
  }

  Widget _buildFlavorRow(FlavorDescriptionModel desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aroma icon inside purple circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColor.primaryLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(
              child: _getAromaImage(desc.name) != null
                  ? Image.asset(
                      _getAromaImage(desc.name)!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Text(desc.emoji, style: AppTextStyles.emojiMedium),
                    )
                  : Text(desc.emoji, style: AppTextStyles.emojiMedium),
            ),
          ),
          const SizedBox(width: 12),

          // Title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc.name,
                  style: AppTextStyles.label1NormalBold.copyWith(
                    color: AppColor.labelNormal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc.description,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 4. Recommended coffee bean cards
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildRecommendationsSection(SurveyResultModel? result) {
    final recommendations = result?.recommendations ?? [];
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '추천 원두',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 16),
          ...recommendations.map((rec) => _buildRecommendationCard(rec)),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(CoffeeRecommendationModel rec) {
    // Generate deterministic match percentage based on rec id (20-95%)
    final matchPercent = 20 + (rec.id.hashCode.abs() % 76);

    return Obx(() {
      final isSelected = controller.isBeanSelected(rec.id);

      return GestureDetector(
        onTap: () => controller.toggleBeanSelection(rec.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColor.backgroundNormalNormal,
            borderRadius: AppRadius.lgBorder,
            border: Border.all(
              color: isSelected
                  ? AppColor.primaryNormal
                  : AppColor.lineNormalNeutral,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected ? AppShadows.shadowPrimaryNormalList : null,
          ),
          child: Stack(
            children: [
              // Main content with padding
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Coffee bag placeholder image ──
                    Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColor.backgroundNormalAlternative,
                        borderRadius: AppRadius.mdBorder,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.coffee_rounded,
                        color: AppColor.labelAssistive,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // ── Info column ──
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bean name
                          Text(
                            rec.name,
                            style: AppTextStyles.headline2Bold.copyWith(
                              color: AppColor.labelNormal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Origin + Roast badges
                          Row(
                            children: [
                              _buildBadge(rec.origin),
                              const SizedBox(width: 6),
                              _buildBadge(rec.roastLevel),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Price row
                          _buildPriceRow(rec),
                          const SizedBox(height: 12),

                          // Mini taste bars
                          _buildMiniTasteBars(rec.tasteProfile),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ── Round checkbox ──
                    _buildRoundCheckbox(isSelected),
                  ],
                ),
              ),

              // ── Match percentage badge (top-left) ──
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.colorGlobalPink60,
                        AppColor.primaryNormal,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.lg - 1),
                      bottomRight: Radius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    '일치율 $matchPercent%',
                    style: AppTextStyles.caption1Bold.copyWith(
                      color: AppColor.staticLabelWhiteStrong,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: AppRadius.xsBorder,
      ),
      child: Text(
        text,
        style: AppTextStyles.caption1Medium.copyWith(
          color: AppColor.labelAlternative,
        ),
      ),
    );
  }

  Widget _buildPriceRow(CoffeeRecommendationModel rec) {
    if (rec.discountPrice == null) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Discount percent red badge
        if (rec.discountPercent != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: AppColor.statusNegative,
              borderRadius: AppRadius.xsBorder,
            ),
            child: Text(
              '${rec.discountPercent}%',
              style: AppTextStyles.caption1Bold.copyWith(
                color: AppColor.staticLabelWhiteStrong,
              ),
            ),
          ),

        // Discount price (bold)
        Text(
          _formatPrice(rec.discountPrice!),
          style: AppTextStyles.headline2Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        const SizedBox(width: 6),

        // Original price (strikethrough)
        if (rec.originalPrice != null)
          Text(
            _formatPrice(rec.originalPrice!),
            style: AppTextStyles.caption1Regular.copyWith(
              color: AppColor.labelAssistive,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  Widget _buildMiniTasteBars(TasteProfileModel profile) {
    return Column(
      children: [
        AppMiniTasteBar(label: '산미', value: profile.acidity),
        AppMiniTasteBar(label: '바디', value: profile.body),
        AppMiniTasteBar(label: '단맛', value: profile.sweetness),
        AppMiniTasteBar(label: '쓴맛', value: profile.bitterness),
      ],
    );
  }

  Widget _buildRoundCheckbox(bool isSelected) {
    return AppRoundCheckbox(isSelected: isSelected);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 5. Bottom action links
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildBottomLinks() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          // "추천 원두 더 보기" link
          TextButton(
            onPressed: () {
              // TODO: Navigate to full recommendation list
            },
            child: Text(
              '추천 원두 더 보기',
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: AppColor.primaryNormal,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // "취향 설문 다시하기" link (muted)
          TextButton(
            onPressed: () {
              // Navigate back to survey start
              controller.startSurvey();
            },
            child: Text(
              '취향 설문 다시하기',
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.labelAssistive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 6. Bottom CTA bar
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        boxShadow: AppShadows.shadowBlackHeavyBottom,
      ),
      child: SafeArea(
        child: Obx(() {
          final count = controller.selectedBeanCount;
          return PrimaryButton(
            text: '총 $count개 원두 신청 추가',
            isEnabled: count > 0,
            onPressed: count > 0 ? () => controller.completeOnboarding() : null,
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Maps flavor names to aroma asset paths
  String? _getAromaImage(String flavorName) {
    if (flavorName.contains('과일')) {
      return AssetPath.aromaFruit;
    } else if (flavorName.contains('꽃')) {
      return AssetPath.aromaFlower;
    } else if (flavorName.contains('견과류') || flavorName.contains('초콜릿')) {
      return AssetPath.aromaNutChoco;
    } else if (flavorName.contains('로스팅')) {
      return AssetPath.aromaRoasting;
    }
    return null;
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    buffer.write('원');
    return buffer.toString();
  }
}

/// Internal model for the 4-column taste grid items.
class _TasteItem {
  final String emoji;
  final String label;
  final int value;

  const _TasteItem({
    required this.emoji,
    required this.label,
    required this.value,
  });
}
