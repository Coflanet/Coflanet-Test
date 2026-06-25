import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 추천 원두 카드 — Figma CSS 사양 1:1 구현.
///
/// 구성: 체크박스 + 일치율 뱃지 / 썸네일(88x88) + 이름·가격 /
/// 커피 프로필(맛바 5축 + 향미 태그) / 판매링크 버튼.
///
/// 반응성 설계:
/// - [isSelected] 는 평범한 bool — 호출부에서 카드 단위 Obx 로 주입.
/// - 좋아요 버튼은 [likeButton] 위젯 슬롯으로 주입 — 호출부에서 별도 Obx 로
///   감싸 좋아요 토글이 카드 전체를 리빌드하지 않게 한다 (원본 중첩 Obx 보존).
///
/// 맛바/향미 태그는 공통 위젯(AppAnimatedTasteBar/FlavorTag)과 디자인이 달라
/// (정적 바 + 5점 환산 점수 / 무보더 칩) 카드 내부 private 으로 유지한다.
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.recommendation,
    required this.isSelected,
    required this.onTap,
    required this.likeButton,
  });

  /// 추천 원두 데이터
  final CoffeeRecommendationModel recommendation;

  /// 리스트 추가 선택 여부 (체크박스/보더 강조)
  final bool isSelected;

  /// 카드 탭 — 선택 토글
  final VoidCallback onTap;

  /// 좋아요 버튼 슬롯 — 호출부에서 Obx 로 감싸 주입
  final Widget likeButton;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    final rec = recommendation;
    // [임시] 일치율 0 이하일 때 placeholder 값 (서버가 0 을 보내는 경우 대비)
    final matchPercent = rec.matchPercent > 0
        ? rec.matchPercent
        : 20 + (rec.id.hashCode.abs() % 76);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: AppSpacing.space16),
        padding: const EdgeInsets.all(AppSpacing.space24), // Figma: padding 24px
        decoration: BoxDecoration(
          color: colors.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(
            AppRadius.sectionRadius,
          ), // Figma: border-radius 40px
          border: Border.all(
            color: colors.primaryNormal, // Figma: 항상 보라 보더
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 상단: 체크박스 + 일치율 뱃지 ──
            Row(
              children: [
                _buildCheckbox(colors),
                const Spacer(),
                _buildMatchBadge(context, matchPercent),
              ],
            ),
            const SizedBox(height: AppSpacing.space16), // Figma: gap 16px
            // ── 아이템: 썸네일 + 텍스트 ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 썸네일 (88x88, radius 12) + 좋아요 토글 오버레이
                Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: colors.backgroundNormalAlternative,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: rec.imageUrl != null && rec.imageUrl!.isNotEmpty
                          ? Image.network(
                              rec.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.coffee_rounded,
                                color: colors.labelAssistive,
                                size: 40,
                              ),
                            )
                          : Icon(
                              Icons.coffee_rounded,
                              color: colors.labelAssistive,
                              size: 40,
                            ),
                    ),
                    Positioned(right: 4, bottom: 4, child: likeButton),
                  ],
                ),
                const SizedBox(width: AppSpacing.space12),
                // 텍스트 컬럼
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 원두 이름 (Figma: 16px Medium)
                      Text(
                        rec.name,
                        style: AppTextStyles.body1NormalMedium.copyWith(
                          color: colors.labelNormal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      _buildPriceRow(colors, rec),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space16),

            // ── 커피 프로필 (Figma: 회색 배경, radius 24) ──
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space24,
                AppSpacing.space16,
                AppSpacing.space24,
                AppSpacing.space24,
              ),
              decoration: BoxDecoration(
                color: colors.componentFillNormal,
                borderRadius: BorderRadius.circular(AppRadius.xxxl),
              ),
              child: Column(
                children: [
                  _buildTasteBars(colors, rec.tasteProfile),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(
                      vertical: AppSpacing.space16,
                    ),
                    color: colors.componentFillNormal,
                  ),
                  _buildFlavorTags(colors, rec.flavorTags),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space16),

            // ── 하단: 판매링크 버튼 (Figma: 회색 배경, 보라 텍스트) ──
            // [백엔드 API 연동 대기] 판매 링크 이동 동작
            _buildPurchaseButton(colors),
          ],
        ),
      ),
    );
  }

  /// Figma 체크박스: 24x24 외곽, 18x18 내부, radius 3px
  Widget _buildCheckbox(AppColorScheme colors) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(AppSpacing.space2),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryNormal : AppColor.transparent,
          border: Border.all(color: colors.primaryNormal, width: 1.5),
          borderRadius: BorderRadius.circular(3),
        ),
        child: isSelected
            ? Icon(Icons.check, size: 12, color: AppColor.colorGlobalCommon100)
            : null,
      ),
    );
  }

  /// 일치율 뱃지 — 다크/라이트 분기.
  /// 다크: 검정 배경 위 윤곽 확보를 위해 배경 Blue50@0.2 + 텍스트 Blue60.
  /// 라이트: Figma 확정본 그대로 Blue50@0.08 + 텍스트 Blue50.
  Widget _buildMatchBadge(BuildContext context, int matchPercent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeBackground = isDark
        ? AppColor.colorGlobalBlue50.withValues(alpha: 0.2)
        : AppColor.colorGlobalBlue50.withValues(alpha: 0.08);
    final badgeText = isDark
        ? AppColor.colorGlobalBlue60
        : AppColor.colorGlobalBlue50;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space8,
        vertical: AppSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: badgeBackground,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        '일치율 $matchPercent%',
        style: AppTextStyles.caption2Regular.copyWith(
          color: badgeText,
          fontSize: 11,
        ),
      ),
    );
  }

  /// Figma 가격: "12,000" (16px Bold) + "원" (15px Regular)
  Widget _buildPriceRow(AppColorScheme colors, CoffeeRecommendationModel rec) {
    final price = rec.discountPrice ?? rec.originalPrice;
    if (price == null) return const SizedBox.shrink();

    return Row(
      children: [
        Text(
          AppUtil.formatNumberWithComma(price),
          style: AppTextStyles.body1NormalBold.copyWith(
            color: colors.labelNormal,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '원',
          style: AppTextStyles.body2NormalRegular.copyWith(
            color: colors.labelNeutral,
          ),
        ),
      ],
    );
  }

  /// Figma 맛바: 라벨(40px) + 게이지 + 5점 환산 점수(28px).
  /// 정적 바(violet70) — AppAnimatedTasteBar 와 트랙색/점수 표기/애니메이션이
  /// 달라 공통화하지 않는다 (시각 변화 0 원칙).
  Widget _buildTasteBars(AppColorScheme colors, TasteProfileModel profile) {
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
        return SizedBox(
          height: 20,
          child: Row(
            children: [
              // 라벨 (Figma: 40px, 14px Medium)
              SizedBox(
                width: 40,
                child: Text(
                  item.$1,
                  style: AppTextStyles.label1NormalMedium.copyWith(
                    color: colors.labelNormal,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              // 게이지 (Figma: flex-grow, 8px, violet 채움)
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.componentFillNormal,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: item.$2 / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.primarySecondary,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              // 점수 (Figma: 28px, 14px Regular, 5점 환산)
              SizedBox(
                width: 28,
                child: Text(
                  fiveScaleValue.toStringAsFixed(1),
                  style: AppTextStyles.label1NormalRegular.copyWith(
                    color: colors.labelAlternative,
                    fontSize: 14,
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

  /// Figma 향미 태그: 회색 칩 (radius 99, 무보더, h8/v6) —
  /// FlavorTag.secondary 와 패딩/보더/radius 가 달라 공통화하지 않는다.
  Widget _buildFlavorTags(AppColorScheme colors, List<String> tags) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space8,
            vertical: AppSpacing.space6,
          ),
          decoration: BoxDecoration(
            color: colors.componentFillNormal,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            tag,
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: colors.labelNormal,
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Figma 판매링크 버튼: 회색 배경, radius 99, 보라 텍스트
  Widget _buildPurchaseButton(AppColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: AppSpacing.space20,
      ),
      decoration: BoxDecoration(
        color: colors.componentFillNormal,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Center(
        child: Text(
          '판매링크 바로가기',
          style: AppTextStyles.body2NormalBold.copyWith(
            color: colors.primaryNormal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
