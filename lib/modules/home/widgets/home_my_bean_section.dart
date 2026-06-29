import 'package:flutter/material.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/widgets/typography/section_title.dart';

/// 홈 보유 원두 섹션 (보라 둥근 카드) — "레시피를 시작해볼까요?" 헤더 + 원두 카드 리스트.
///
/// 다른 섹션 카드들과 동일하게 풀폭 + radius 20 독립 카드다.
/// [beans] 가 비어 있으면 빈 안내 카드를 노출한다.
/// 카드가 브랜드 보라 고정색이므로 내부 색은 테마 무관 static 토큰을 쓴다
/// (흰 내부 카드 + 검정 계열 텍스트 — 라이트/다크 동일).
class HomeMyBeanSection extends StatelessWidget {
  const HomeMyBeanSection({
    super.key,
    required this.beans,
    required this.onEditTap,
    required this.onViewAllTap,
    this.onBeanTap,
  });

  /// 보유 원두 목록 (최대 3개만 표시)
  final List<CoffeeItem> beans;

  /// '편집하기' 탭 콜백
  final VoidCallback onEditTap;

  /// '전체보기' 탭 콜백
  final VoidCallback onViewAllTap;

  /// 개별 원두 카드 탭 콜백 — 원두 상세로 이동 (null 이면 비탭)
  final void Function(CoffeeItem item)? onBeanTap;

  @override
  Widget build(BuildContext context) {
    // Figma subscribe_item_list(83:13151): 보라 카드 radius40, pt32/pb16,
    // 헤더 px24·리스트 px16, 헤더↔리스트 gap16.
    return Container(
      padding: const EdgeInsets.only(
        top: AppSpacing.space32,
        bottom: AppSpacing.space16,
      ),
      decoration: BoxDecoration(
        // 브랜드 보라 고정 카드 (테마 무관) — raw 팔레트 직접 사용
        color: AppColor.colorGlobalViolet50,
        borderRadius: AppRadius.sectionRadiusBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SectionTitle(
                  title: '레시피를 시작해볼까요?',
                  // Figma 헤더(83:13153): SemiBold 20 = heading2Bold
                  titleStyle: AppTextStyles.heading2Bold.copyWith(
                    color: AppColor.colorGlobalCommon100,
                  ),
                ),
                GestureDetector(
                  onTap: onEditTap,
                  child: Text(
                    '편집하기',
                    // Figma Button/Text/Assistive(83:13154): SemiBold 16, label/neutral(불투명도 0.88)
                    style: AppTextStyles.body1NormalBold.copyWith(
                      color: AppColor.colorGlobalCommon100.withValues(
                        alpha: 0.88,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
            ),
            child: beans.isNotEmpty ? _buildBeanList() : _buildEmpty(),
          ),
        ],
      ),
    );
  }

  /// 원두 카드 리스트 (최대 3개) + 전체보기 버튼
  Widget _buildBeanList() {
    final items = beans.take(3).toList();
    return Column(
      children: [
        for (final item in items) _buildBeanCard(item),
        const SizedBox(height: AppSpacing.xxs),
        GestureDetector(
          onTap: onViewAllTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              // Figma Button/Solid/Gray(83:13165): inverse/label/assistive
              // (어두운 반투명) — 보라 카드 위에서 한 단계 가라앉은 pill.
              color: AppColor.staticBlack.withValues(alpha: 0.2),
              borderRadius: AppRadius.fullBorder,
            ),
            child: Center(
              child: Text(
                '전체보기',
                // Figma Button/Solid/Gray(83:13165): SemiBold 16 = body1NormalBold
                style: AppTextStyles.body1NormalBold.copyWith(
                  color: AppColor.colorGlobalCommon100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 단일 원두 카드 — 썸네일 + 브랜드/구독중 뱃지 + 이름. 탭 시 상세로 이동.
  Widget _buildBeanCard(CoffeeItem item) {
    final Widget card = Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100,
        // Figma Coffee Card(83:13158): radius 24 = itemRadius
        borderRadius: AppRadius.itemRadiusBorder,
      ),
      child: Row(
        children: [
          // Figma Thumbnail(115:16639): 세로형 84×104, inner radius 20
          Container(
            width: 56,
            height: 72,
            decoration: BoxDecoration(
              color: AppColor.colorGlobalCoolNeutral95,
              borderRadius: AppRadius.xxlBorder,
              image: item.displayImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(item.displayImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            // 원두 이미지 없을 때 기본 일러스트 (흰 배경 임시 — 누끼 추후).
            child: item.displayImageUrl == null
                ? Image.asset(
                    AssetPath.beanDefault,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.coffee, color: item.color, size: 28),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // 가변 브랜드명 — 길면 '구독중' 뱃지와 충돌하지 않도록
                    // Flexible + ellipsis 로 폭을 제한한다.
                    Flexible(
                      child: Text(
                        item.brand ?? '브랜드명',
                        // Figma 제조사(52:16183): Regular 13 = label2Regular
                        style: AppTextStyles.label2Regular.copyWith(
                          color: AppColor.staticLabelBlackAlternative,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space6,
                        vertical: AppSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        // Figma Content Badge(52:16184): primary @8%, radius 6
                        color: AppColor.colorGlobalViolet50.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: AppRadius.smBorder,
                      ),
                      child: Text(
                        '구독중',
                        style: AppTextStyles.caption2Medium.copyWith(
                          color: AppColor.colorGlobalViolet50,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  item.name,
                  // Figma 원두명(52:16185): Medium 14 = label1NormalMedium
                  style: AppTextStyles.label1NormalMedium.copyWith(
                    color: AppColor.staticLabelBlackNormal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onBeanTap == null) return card;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onBeanTap!(item),
      child: card,
    );
  }

  /// 보유 원두가 없을 때의 안내.
  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100.withValues(alpha: 0.16),
        borderRadius: AppRadius.xlBorder,
        border: Border.all(
          color: AppColor.colorGlobalCommon100.withValues(alpha: 0.32),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.coffee_outlined,
            color: AppColor.colorGlobalCommon100.withValues(alpha: 0.7),
            size: 28,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '보유 중인 원두가 아직 없어요',
            style: AppTextStyles.body2NormalBold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '구독하거나 레시피를 등록해보세요',
            style: AppTextStyles.caption1Regular.copyWith(
              color: AppColor.colorGlobalCommon100.withValues(alpha: 0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
