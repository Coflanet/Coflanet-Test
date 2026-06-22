import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        // 브랜드 보라 고정 카드 (테마 무관) — raw 팔레트 직접 사용
        color: AppColor.colorGlobalViolet50,
        borderRadius: AppRadius.xxlBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SectionTitle(
                title: '레시피를 시작해볼까요?',
                titleStyle: AppTextStyles.body1NormalBold.copyWith(
                  color: AppColor.colorGlobalCommon100,
                ),
              ),
              GestureDetector(
                onTap: onEditTap,
                child: Text(
                  '편집하기',
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.colorGlobalCommon100.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (beans.isNotEmpty) _buildBeanList() else _buildEmpty(),
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
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onViewAllTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColor.colorGlobalCommon100.withValues(alpha: 0.2),
              borderRadius: AppRadius.fullBorder,
            ),
            child: Center(
              child: Text(
                '전체보기',
                style: AppTextStyles.body2NormalBold.copyWith(
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100,
        borderRadius: AppRadius.xlBorder,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColor.colorGlobalCoolNeutral95,
              borderRadius: AppRadius.mdBorder,
              image: item.displayImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(item.displayImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.displayImageUrl == null
                ? Icon(Icons.coffee, color: item.color, size: 24)
                : null,
          ),
          const SizedBox(width: 12),
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
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.staticLabelBlackAlternative,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.colorGlobalViolet50.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: AppRadius.xsBorder,
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
                const SizedBox(height: 4),
                Text(
                  item.name,
                  style: AppTextStyles.body2NormalBold.copyWith(
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
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
          const SizedBox(height: 8),
          Text(
            '보유 중인 원두가 아직 없어요',
            style: AppTextStyles.body2NormalBold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: 4),
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
