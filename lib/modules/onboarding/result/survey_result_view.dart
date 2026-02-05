import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundNormalNormal,
        surfaceTintColor: AppColor.backgroundNormalNormal,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.labelNormal,
            size: 20,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emoji
        Text(item.emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 10),

        // Circular indicator
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  value: item.value / 100,
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColor.lineNormalAlternative,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.primaryNormal,
                  ),
                ),
              ),
              Text(
                '${item.value}',
                style: AppTextStyles.label1NormalBold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Label
        Text(
          item.label,
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColor.labelAlternative,
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
          // Emoji icon inside purple circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColor.primaryLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(desc.emoji, style: const TextStyle(fontSize: 20)),
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
            borderRadius: AppRadius.lgBorder,
            border: Border.all(
              color: isSelected
                  ? AppColor.primaryNormal
                  : AppColor.lineNormalNeutral,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected ? AppShadows.shadowPrimaryNormalList : null,
          ),
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
    final bars = [
      ('산미', profile.acidity),
      ('바디', profile.body),
      ('단맛', profile.sweetness),
      ('쓴맛', profile.bitterness),
    ];

    return Column(
      children: bars.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  item.$1,
                  style: AppTextStyles.caption2Medium.copyWith(
                    color: AppColor.labelAssistive,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: SizedBox(
                  height: 4,
                  child: ClipRRect(
                    borderRadius: AppRadius.xxsBorder,
                    child: LinearProgressIndicator(
                      value: item.$2 / 100,
                      backgroundColor: AppColor.lineNormalAlternative,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.primaryNormal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRoundCheckbox(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? AppColor.primaryNormal : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? AppColor.primaryNormal
              : AppColor.lineNormalNormal,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 14, color: AppColor.staticLabelWhiteStrong)
          : null,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 5. Bottom CTA bar
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
            text: '총 ${count}개 원두 신청 추가',
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
