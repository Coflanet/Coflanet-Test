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
            Color(0xFF7D5EF7), // Violet 60
            Color(0xFF6541F2), // Violet 50 (primary)
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
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: result?.coffeeTypeDescription ?? '',
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

    // Per Figma: 4 individual tiles in horizontal row with 8-12px gap
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(child: _buildTasteProfileTile(items[i])),
            if (i < items.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  /// Individual taste profile tile with gradient background (per Figma)
  Widget _buildTasteProfileTile(_TasteItem item) {
    // Determine level text based on value
    // Value >= 70 → 좋음
    // Value >= 40 → 보통
    // Value < 40 → 싫음
    final String levelText;
    final Color levelColor;

    if (item.value >= 70) {
      levelText = '좋음';
      levelColor = AppColor.statusPositive;
    } else if (item.value >= 40) {
      levelText = '보통';
      levelColor = AppColor.labelNormal;
    } else {
      levelText = '싫음';
      levelColor = AppColor.statusNegative;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.backgroundNormalNormal,
            AppColor.primaryLight.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: AppColor.lineNormalNeutral),
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
          // Level text (bottom) with color
          Text(
            levelText,
            style: AppTextStyles.body1NormalBold.copyWith(color: levelColor),
          ),
        ],
      ),
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
            '${controller.userName}님의 취향과 가까운 원두에요 👍',
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

  /// Figma-exact recommendation card layout:
  /// Top: Checkbox (left) + Badge (right)
  /// Below: Bean Name
  /// Below: Price
  /// Below: Image (left) + Taste Bars (right)
  /// Below: Flavor Tags
  /// Bottom: Purchase Link
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.backgroundNormalNormal,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColor.primaryNormal
                  : AppColor.lineNormalNeutral,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: AppShadows.shadowBlackEmphasize,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Row 1: Checkbox (left) + Match Badge (right) ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rounded square checkbox (Figma: 24x24, 6px radius)
                  _buildSquareCheckbox(isSelected),
                  // Match percentage badge - Solid purple (Figma)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primaryNormal, // Solid purple
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '일치율 $matchPercent%',
                      style: AppTextStyles.caption2Bold.copyWith(
                        color: AppColor.staticLabelWhiteStrong,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Row 2: Bean Name ──
              Text(
                rec.name,
                style: AppTextStyles.label1NormalBold.copyWith(
                  color: AppColor.labelNormal,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // ── Row 3: Price ──
              _buildPriceRow(rec),
              const SizedBox(height: 12),

              // ── Row 4: Image (left) + Taste Bars (right) ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coffee bag image (Figma: 48x64 portrait)
                  Container(
                    width: 48,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColor.backgroundNormalAlternative,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.coffee_rounded,
                      color: AppColor.labelAssistive,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Taste bars (Figma: 5 rows, purple fill)
                  Expanded(
                    child: _buildMiniTasteBarsWithValues(rec.tasteProfile),
                  ),
                ],
              ),

              // ── Row 5: Flavor Tags ──
              if (rec.flavorTags.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildFlavorTags(rec.flavorTags),
              ],

              // ── Row 6: Purchase Link (centered, underlined) ──
              const SizedBox(height: 12),
              Center(child: _buildPurchaseLink()),
            ],
          ),
        ),
      );
    });
  }

  /// Rounded square checkbox (Figma: 24x24, 6px radius)
  Widget _buildSquareCheckbox(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColor.primaryNormal
            : AppColor.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(6),
        border: isSelected
            ? null
            : Border.all(color: AppColor.lineNormalNeutral, width: 1.5),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 16, color: AppColor.staticLabelWhiteStrong)
          : null,
    );
  }

  Widget _buildPriceRow(CoffeeRecommendationModel rec) {
    // Simplified price display per Figma (just show price, no discount info)
    final price = rec.discountPrice ?? rec.originalPrice;
    if (price == null) return const SizedBox.shrink();

    return Text(
      _formatPrice(price),
      style: AppTextStyles.body1NormalBold.copyWith(
        color: AppColor.labelNormal,
      ),
    );
  }

  /// Mini taste bars with numeric values (0-5 scale) per Figma design
  /// Uses purple bars (Primary Violet) per Figma
  Widget _buildMiniTasteBarsWithValues(TasteProfileModel profile) {
    // Convert 0-100 scale to 0-5 scale
    double toFiveScale(int value) => (value / 20).clamp(0.0, 5.0);

    final items = [
      ('산미', profile.acidity),
      ('바디감', profile.body),
      ('단맛', profile.sweetness),
      ('쓴맛', profile.bitterness),
      ('밸런스', profile.balance),
    ];

    return Column(
      children: items.map((item) {
        final fiveScaleValue = toFiveScale(item.$2);
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              // Label (Figma: 36px width, 11px, gray)
              SizedBox(
                width: 36,
                child: Text(
                  item.$1,
                  style: AppTextStyles.caption2Medium.copyWith(
                    color: AppColor.labelAssistive,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Progress bar (Figma: 6px height, rounded, purple fill)
              Expanded(
                child: SizedBox(
                  height: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: item.$2 / 100,
                      backgroundColor: AppColor.lineNormalAlternative,
                      // Purple bars per Figma
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.primaryNormal,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Numeric value (Figma: 11px, gray)
              SizedBox(
                width: 24,
                child: Text(
                  fiveScaleValue.toStringAsFixed(1),
                  style: AppTextStyles.caption2Medium.copyWith(
                    color: AppColor.labelAssistive,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Flavor tags per Figma: Light gray (#F5F5F5) background, dark text
  Widget _buildFlavorTags(List<String> tags) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), // Light gray per Figma
                borderRadius: BorderRadius.circular(13), // Pill shape
              ),
              child: Text(
                tag,
                style: AppTextStyles.caption2Medium.copyWith(
                  color: AppColor.labelNormal, // Dark text per Figma
                  fontSize: 11,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  /// Purchase link per Figma: Underlined, violet, 13px SemiBold
  Widget _buildPurchaseLink() {
    return Text(
      '판매링크 바로가기',
      style: AppTextStyles.label2Medium.copyWith(
        color: AppColor.primaryNormal,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: AppColor.primaryNormal,
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
          // "추천 원두 더 보기" link
          TextButton(
            onPressed: () {
              // TODO: Navigate to full recommendation list
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.lgBorder,
                side: BorderSide(color: AppColor.primaryNormal),
              ),
            ),
            child: Text(
              '추천 원두 더 보기',
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: AppColor.primaryNormal,
              ),
            ),
          ),
          const SizedBox(height: 12),

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
        color: AppColor.backgroundNormalNormal, // White bg
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
