import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';

/// 상품/추천 카드 — 이미지(1:1) + 좋아요 토글 + 취향 일치율 태그 + 브랜드/이름/가격.
///
/// 높이 비종속 설계: 셀 높이는 호출부 GridView(childAspectRatio)가 부여하고,
/// 내부 Expanded/Flexible 구조가 텍스트 영역 오버플로우를 구조적으로 차단한다.
///
/// 좋아요 반응성: [isLiked] 는 평범한 bool — Rx 구독이 필요하면 호출부에서
/// 카드 단위 Obx 로 감싸 전달한다 (전체 그리드 단일 Obx 금지).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.isLiked,
    required this.onLikeTap,
    this.imageUrl,
    this.matchPercent,
    this.discountPercent,
    this.price,
    this.onTap,
  });

  /// 상품명 (최대 2줄, 말줄임)
  final String name;

  /// 부제 — 예: '브랜드명 | 에티오피아'
  final String subtitle;

  /// 좋아요(찜) 여부
  final bool isLiked;

  /// 좋아요 토글 콜백
  final VoidCallback onLikeTap;

  /// 상품 이미지 URL — null 이면 커피 아이콘 placeholder
  final String? imageUrl;

  /// 취향 일치율 (%) — null 또는 0 이하이면 태그 미표시
  final int? matchPercent;

  /// 할인율 (%) — null 이면 미표시
  final int? discountPercent;

  /// 표시 가격 (원) — null 이면 가격 행 미표시
  final int? price;

  /// 카드 탭 콜백 (상세 이동 등)
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.colorGlobalCoolNeutral95),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            // Expanded 로 텍스트 영역을 셀 잔여 높이에 가둬 오버플로우를 구조적으로 차단.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 취향 일치율
                    if (matchPercent != null && matchPercent! > 0)
                      _buildSmallTag('취향 $matchPercent%'),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // 이름 — 잔여 높이를 흡수하고 초과 시 말줄임 (가변 데이터 안전)
                    Flexible(
                      child: Text(
                        name,
                        style: AppTextStyles.caption1Medium.copyWith(
                          color: AppColor.labelNormal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildPriceRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 이미지(1:1) + 좋아요 오버레이
  Widget _buildImage() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.colorGlobalCoolNeutral98,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Icon(Icons.coffee, size: 48, color: AppColor.primaryNormal)
                : null,
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: Semantics(
            label: isLiked ? '좋아요 취소' : '좋아요',
            button: true,
            child: GestureDetector(
              onTap: onLikeTap,
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCommon100.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: AppColor.primaryNormal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 가격 행 — 할인율 + 가격. 가격 정보 없으면 표시 안 함.
  Widget _buildPriceRow() {
    if (price == null && discountPercent == null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        if (discountPercent != null) ...[
          Text(
            '$discountPercent%',
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
          const SizedBox(width: 4),
        ],
        if (price != null)
          Text(
            AppUtil.changeNumberToWon(price),
            style: AppTextStyles.body2NormalBold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
      ],
    );
  }

  Widget _buildSmallTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: AppColor.primaryNormal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption2Medium.copyWith(
          color: AppColor.primaryNormal,
        ),
      ),
    );
  }
}
