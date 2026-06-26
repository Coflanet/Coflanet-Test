import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 추천 원두 카드 — Figma Survey_Result `Preference_Card`(1264:49163) 1:1.
///
/// 구조(gap 16): ① Top[체크박스 / 썸네일88+텍스트(일치율 배지·이름·가격)] ②
/// Coffee Profile 박스(맛바 5축 + 향미칩) ③ 판매링크 버튼.
/// 카드: 흰 배경 + 1px primary 보더 + radius 40 + padding 24. 그림자 없음.
///
/// 반응성 설계:
/// - [isSelected] 는 평범한 bool — 호출부에서 카드 단위 Obx 로 주입.
/// - 좋아요 버튼은 [likeButton] 슬롯으로 주입(Figma 미존재, 기능 유지를 위해
///   썸네일 오버레이로 잔류) — 호출부에서 별도 Obx 로 감싼다.
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

  /// 리스트 추가 선택 여부 (체크박스 강조)
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
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space24),
        decoration: BoxDecoration(
          color: colors.backgroundNormalNormal,
          borderRadius: AppRadius.sectionRadiusBorder, // Figma: Round/40
          border: Border.all(color: colors.primaryNormal),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top: 체크박스 + (썸네일 + 텍스트) ──
            _buildCheckbox(colors),
            const SizedBox(height: AppSpacing.space8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 썸네일 (88x88, radius 12) + 좋아요 오버레이
                Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: colors.backgroundNormalAlternative,
                        borderRadius: AppRadius.lgBorder,
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
                // 텍스트 컬럼: 일치율 배지 / 이름 / 가격
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMatchBadge(matchPercent),
                      const SizedBox(height: AppSpacing.space2),
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

            // ── Coffee Profile (회색 박스, radius 24) ──
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space24,
                AppSpacing.space16,
                AppSpacing.space24,
                AppSpacing.space24,
              ),
              decoration: BoxDecoration(
                color: colors.componentFillNormal,
                borderRadius: AppRadius.xxxlBorder,
              ),
              child: Column(
                children: [
                  _buildTasteBars(colors, rec.tasteProfile),
                  const SizedBox(height: AppSpacing.space20),
                  Container(height: 1, color: colors.lineNormalAlternative),
                  const SizedBox(height: AppSpacing.space20),
                  _buildFlavorTags(colors, rec.flavorTags),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space16),

            // ── 판매링크 버튼 ──
            // [백엔드 API 연동 대기] 판매 링크 이동 동작
            _buildPurchaseButton(colors),
          ],
        ),
      ),
    );
  }

  /// Figma Control/Checkbox: 24 컨테이너 / 18 내부 박스 / radius 3
  Widget _buildCheckbox(AppColorScheme colors) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: isSelected ? colors.primaryNormal : AppColor.transparent,
            border: Border.all(color: colors.primaryNormal, width: 1.5),
            borderRadius: AppRadius.checkboxInnerBorder,
          ),
          child: isSelected
              ? Icon(Icons.check, size: 12, color: colors.backgroundNormalNormal)
              : null,
        ),
      ),
    );
  }

  /// 일치율 배지 — accent/blue 8% 배경 + accent/blue 텍스트, radius 99, 11 Regular
  Widget _buildMatchBadge(int matchPercent) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space8,
        vertical: AppSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: AppColor.accentBackgroundBlue.withValues(alpha: 0.08),
        borderRadius: AppRadius.fullBorder,
      ),
      child: Text(
        '일치율 $matchPercent%',
        style: AppTextStyles.caption2Regular.copyWith(
          color: AppColor.accentBackgroundBlue,
        ),
      ),
    );
  }

  /// Figma 가격: "12,000" (16 SemiBold) + "원" (15 Regular, label/neutral)
  Widget _buildPriceRow(AppColorScheme colors, CoffeeRecommendationModel rec) {
    final price = rec.discountPrice ?? rec.originalPrice;
    if (price == null) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          AppUtil.formatNumberWithComma(price),
          style: AppTextStyles.body1NormalBold.copyWith(
            color: colors.labelNormal,
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

  /// Figma 맛바: 라벨(40px, 14 Medium) + 게이지(8px, 5세그먼트 틱) + 점수(28px, 14 Regular).
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
      children: [
        for (final item in items)
          SizedBox(
            height: 28,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    item.$1,
                    style: AppTextStyles.label1NormalMedium.copyWith(
                      color: colors.labelNormal,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space12),
                Expanded(child: _buildGauge(colors, item.$2 / 100)),
                const SizedBox(width: AppSpacing.space12),
                SizedBox(
                  width: 28,
                  child: Text(
                    toFiveScale(item.$2).toStringAsFixed(1),
                    style: AppTextStyles.label1NormalRegular.copyWith(
                      color: colors.labelAlternative,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// 게이지 — 트랙 + 채움(primary/secondary) + 5세그먼트 구분 틱(4개) 오버레이.
  Widget _buildGauge(AppColorScheme colors, double fraction) {
    final pct = (fraction.clamp(0.0, 1.0) * 100).round();
    return SizedBox(
      height: 8,
      child: ClipRRect(
        borderRadius: AppRadius.fullBorder,
        child: Stack(
          children: [
            // 트랙
            Positioned.fill(
              child: ColoredBox(color: colors.componentFillNormal),
            ),
            // 채움 (flex 비율, 라운드 트랙으로 클립) — tight fit 으로 채움 폭 확보
            Positioned.fill(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (pct > 0)
                    Expanded(
                      flex: pct,
                      child: ColoredBox(color: colors.primarySecondary),
                    ),
                  if (pct < 100)
                    Expanded(flex: 100 - pct, child: const SizedBox.shrink()),
                ],
              ),
            ),
            // 5세그먼트 틱 (4개 1px 디바이더)
            Positioned.fill(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int s = 0; s < 5; s++) ...[
                    if (s > 0)
                      Container(width: 1, color: colors.lineNormalNeutral),
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Figma 향미칩: component/fill/alternative 배경, radius 8, label/normal 14 Medium.
  Widget _buildFlavorTags(AppColorScheme colors, List<String> tags) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: AppSpacing.space4,
        runSpacing: AppSpacing.space4,
        children: tags.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space8,
              vertical: AppSpacing.space6,
            ),
            decoration: BoxDecoration(
              color: colors.componentFillAlternative,
              borderRadius: AppRadius.mdBorder,
            ),
            child: Text(
              tag,
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: colors.labelNormal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Figma 판매링크 버튼: component/fill 배경, radius 99(pill), primary 텍스트 15 SemiBold.
  Widget _buildPurchaseButton(AppColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.space8,
        horizontal: AppSpacing.space20,
      ),
      decoration: BoxDecoration(
        color: colors.componentFillNormal,
        borderRadius: AppRadius.fullBorder,
      ),
      child: Center(
        child: Text(
          '판매링크 바로가기',
          style: AppTextStyles.body2NormalBold.copyWith(
            color: colors.primaryNormal,
          ),
        ),
      ),
    );
  }
}
