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

class SurveyResultView extends GetView<SurveyController> {
  const SurveyResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.surveyResult;

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal, // White background
      appBar: AppBar(
        backgroundColor: AppColor.backgroundNormalNormal,
        surfaceTintColor: AppColor.backgroundNormalNormal,
        elevation: 0,
        scrolledUnderElevation: 0,
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
        centerTitle: true,
        title: Text(
          '나의 커피 취향',
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal, // Dark text on light bg
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
              child: Divider(height: 1, color: AppColor.lineNormalNeutral),
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
  // 1. Purple banner - Gradient profile result card (Left-aligned per Figma)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildBannerSection(SurveyResultModel? result) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.colorGlobalViolet60, // Violet 60
            AppColor.colorGlobalViolet50, // Violet 50 (primary)
          ],
        ),
        borderRadius: AppRadius.xlBorder,
        boxShadow: AppShadows.shadowPrimaryStrong,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned per Figma
        children: [
          // User name line — small text with transparency (per Figma 12-14px)
          Text(
            '${controller.userName}님은',
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColor.staticLabelWhiteStrong.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),

          // Main headline — bold 20-24px with emoji (per Figma)
          // Figma shows 2 lines: "진하고 깊은 풍미를" + "즐기시네요! ☕"
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${result?.coffeeTypeDescription ?? ''}\n즐기시네요!',
                  style: AppTextStyles.heading1Bold.copyWith(
                    color: AppColor.staticLabelWhiteStrong,
                    height: 1.4,
                  ),
                ),
                const TextSpan(text: ' ☕', style: TextStyle(fontSize: 22)),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 2. Taste profile grid (4 individual tiles) - Per Figma design
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildTasteProfileGrid(SurveyResultModel? result) {
    final profile = result?.tasteProfile;
    if (profile == null) return const SizedBox.shrink();

    final items = [
      _TasteItem(emoji: '', label: '산미', value: profile.acidity),
      _TasteItem(emoji: '', label: '바디감', value: profile.body),
      _TasteItem(emoji: '', label: '단맛', value: profile.sweetness),
      _TasteItem(emoji: '', label: '쓴맛', value: profile.bitterness),
    ];

    // Per Figma: 4 white pill tiles with subtle shadows, vertical dividers between
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(
              child: _buildTasteProfileTile(
                items[i],
                showDivider: i < items.length - 1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Individual taste profile tile with emoji per Figma design
  /// 👍 = 좋음, 😐 = 보통, 👎 = 싫음
  /// Figma: White pill with subtle shadow, no border
  Widget _buildTasteProfileTile(_TasteItem item, {bool showDivider = false}) {
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

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColor.backgroundNormalNormal,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.colorGlobalCommon0.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label (top)
                Text(
                  item.label,
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
                const SizedBox(height: 8),
                // Emoji (per Figma)
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                // Level text (bottom)
                Text(
                  levelText,
                  style: AppTextStyles.caption2Medium.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Vertical divider (Figma: thin gray line between tiles)
        if (showDivider)
          Container(
            width: 1,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: AppColor.lineNormalNeutral,
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 3. Flavor description list - Light theme
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildFlavorDescriptions(SurveyResultModel? result) {
    final descriptions = result?.flavorDescriptions ?? [];
    if (descriptions.isEmpty) return const SizedBox.shrink();

    // No section title per Figma - flavor items appear directly
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: descriptions.map((desc) => _buildFlavorRow(desc)).toList(),
      ),
    );
  }

  Widget _buildFlavorRow(FlavorDescriptionModel desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: AppColor.lineNormalNeutral),
        boxShadow: AppShadows.shadowBlackNormal,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Aroma icon inside purple gradient circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.primaryLight,
                  AppColor.primaryNormal.withValues(alpha: 0.3),
                ],
              ),
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
          const SizedBox(width: 14),

          // Title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc.name,
                  style: AppTextStyles.label1NormalBold.copyWith(
                    color: AppColor.labelNormal, // Dark text on light bg
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc.description,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative, // Gray text on light bg
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
  // 4. Recommended coffee bean cards - Light theme with shadows
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
          const SizedBox(height: 6),
          Text(
            '${controller.userName}님의 취향과 가까운 원두예요 🤗',
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
          const SizedBox(height: 20),
          ...recommendations.map((rec) => _buildRecommendationCard(rec)),
        ],
      ),
    );
  }

  /// Figma CSS-exact recommendation card layout:
  /// Card: border-radius 40px, padding 24px, gap 16px, purple border
  /// Top: Checkbox (24x24) + Label badge
  /// Item: Thumbnail (88x88) + Text (name, price)
  /// Coffee Profile: Gray bg container with taste bars + flavor tags
  /// Bottom: Gray button with purple text
  Widget _buildRecommendationCard(CoffeeRecommendationModel rec) {
    final matchPercent = rec.matchPercent > 0
        ? rec.matchPercent
        : 20 + (rec.id.hashCode.abs() % 76);

    return Obx(() {
      final isSelected = controller.isBeanSelected(rec.id);

      return GestureDetector(
        onTap: () => controller.toggleBeanSelection(rec.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24), // Figma: padding 24px
          decoration: BoxDecoration(
            color: AppColor.backgroundNormalNormal,
            borderRadius: BorderRadius.circular(
              40,
            ), // Figma: border-radius 40px
            border: Border.all(
              color: AppColor.primaryNormal, // Figma: always purple border
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top: Checkbox + Label badge ──
              Row(
                children: [
                  // Checkbox (Figma: 24x24, inner 18x18, radius 3px)
                  _buildFigmaCheckbox(isSelected),
                  const Spacer(),
                  // Match badge (Figma: blue bg, radius 99px)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.colorGlobalBlue50.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      '일치율 $matchPercent%',
                      style: AppTextStyles.caption2Regular.copyWith(
                        color: AppColor.colorGlobalBlue50,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Figma: gap 16px
              // ── Item: Thumbnail + Text ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail (Figma: 88x88, radius 12px)
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColor.backgroundNormalAlternative,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.coffee_rounded,
                      color: AppColor.labelAssistive,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Text column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bean name (Figma: 16px Medium, #171719)
                        Text(
                          rec.name,
                          style: AppTextStyles.body1NormalMedium.copyWith(
                            color: AppColor.labelNormal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Price (Figma: 16px Bold + 15px Regular)
                        _buildFigmaPriceRow(rec),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Coffee Profile section (Figma: gray bg, radius 24px) ──
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: BoxDecoration(
                  color: AppColor.componentFillNormal,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // Taste bars
                    _buildFigmaTasteBars(rec.tasteProfile),
                    // Divider
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      color: AppColor.componentFillNormal,
                    ),
                    // Flavor tags
                    _buildFigmaFlavorTags(rec.flavorTags),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Bottom: Purchase link button (Figma: gray bg, purple text) ──
              _buildFigmaPurchaseButton(),
            ],
          ),
        ),
      );
    });
  }

  /// Figma checkbox: 24x24 outer, 18x18 inner, radius 3px
  Widget _buildFigmaCheckbox(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(2),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
          border: Border.all(color: AppColor.primaryNormal, width: 1.5),
          borderRadius: BorderRadius.circular(3),
        ),
        child: isSelected
            ? Icon(Icons.check, size: 12, color: AppColor.colorGlobalCommon100)
            : null,
      ),
    );
  }

  /// Figma price: "12,000" (16px Bold) + "원" (15px Regular)
  Widget _buildFigmaPriceRow(CoffeeRecommendationModel rec) {
    final price = rec.discountPrice ?? rec.originalPrice;
    if (price == null) return const SizedBox.shrink();

    final priceStr = _formatPriceNumber(price);
    return Row(
      children: [
        Text(
          priceStr,
          style: AppTextStyles.body1NormalBold.copyWith(
            color: AppColor.labelNormal,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '원',
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: AppColor.labelNeutral,
          ),
        ),
      ],
    );
  }

  /// Figma taste bars: Label (40px) + Gauge (140px) + Score (28px)
  /// Bar color: #9E86FC (light purple), track: rgba(112,115,124,0.12)
  Widget _buildFigmaTasteBars(TasteProfileModel profile) {
    double toFiveScale(int value) => (value / 20).clamp(0.0, 5.0);

    final items = [
      ('산미', profile.acidity),
      ('바디감', profile.body),
      ('단맛', profile.sweetness),
      ('쓴맛', profile.bitterness),
      ('밸런스', profile.balance),
    ];

    return Column(
      children: items.asMap().entries.map((entry) {
        final item = entry.value;
        final fiveScaleValue = toFiveScale(item.$2);
        return Padding(
          padding: EdgeInsets.only(
            bottom: entry.key < items.length - 1 ? 0 : 0,
          ),
          child: SizedBox(
            height: 20,
            child: Row(
              children: [
                // Title (Figma: 40px width, 14px Medium, #171719)
                SizedBox(
                  width: 40,
                  child: Text(
                    item.$1,
                    style: AppTextStyles.label1NormalMedium.copyWith(
                      color: AppColor.labelNormal,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Indicator (Figma: flex-grow, 8px height, #9E86FC fill)
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColor.componentFillNormal,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: item.$2 / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.colorGlobalViolet70, // Light purple
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Score (Figma: 28px width, 14px Regular, rgba(55,56,60,0.61))
                SizedBox(
                  width: 28,
                  child: Text(
                    fiveScaleValue.toStringAsFixed(1),
                    style: AppTextStyles.label1NormalRegular.copyWith(
                      color: AppColor.labelAlternative,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Figma flavor tags: Chip with gray bg (#70737C 8%), radius 99px
  Widget _buildFigmaFlavorTags(List<String> tags) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.componentFillNormal,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            tag,
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: AppColor.labelNormal,
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Figma purchase button: Gray bg, radius 99px, purple text
  Widget _buildFigmaPurchaseButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Center(
        child: Text(
          '판매링크 바로가기',
          style: AppTextStyles.body2NormalBold.copyWith(
            color: AppColor.primaryNormal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 5. Bottom action links - Light theme
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildBottomLinks() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          // "추천 원두 더 보기" - Figma: full width, gray border, dark text
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // 추천 원두 전체 목록 (추후 구현)
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: AppColor.lineNormalNeutral),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                '추천 원두 더 보기',
                style: AppTextStyles.body2NormalMedium.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // "취향 설문 다시하기" link (muted, underlined)
          TextButton(
            onPressed: () {
              controller.startSurvey();
            },
            child: Text(
              '취향 설문 다시하기',
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.labelAssistive,
                decoration: TextDecoration.underline,
                decorationColor: AppColor.labelAssistive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 6. Bottom CTA bar - Light theme
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
            text: '총 $count개 원두 리스트 추가',
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

  /// Format price with comma separators (no currency suffix)
  String _formatPriceNumber(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
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
