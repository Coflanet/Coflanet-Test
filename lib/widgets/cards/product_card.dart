import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';

/// 상품/추천 카드 — Figma `List/Item/Vertical`(83:13268) 1:1 구현.
///
/// 구조(위→아래, gap 8): 썸네일(1:1, radius 20, 우하단 하트) → 텍스트 블록
/// (px8, gap4): 취향 일치율 태그 → 브랜드·원산지 → 이름(2줄) → 가격(할인%+가격)
/// + '구독 할인가'. Figma 카드는 외곽 보더/배경 없이 썸네일과 텍스트만으로
/// 구성되며(섹션 표면 위에 직접 얹힘), 높이는 호출부 GridView(childAspectRatio)가
/// 부여하고 내부 Expanded/Flexible 가 오버플로우를 구조적으로 차단한다.
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
    final colors = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      // Figma 카드: 외곽 보더/배경 없음 — 썸네일 + 텍스트(섹션 표면 위 직접).
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImage(colors),
          // Figma List/Item/Vertical gap = 8 (썸네일↔텍스트)
          const SizedBox(height: AppSpacing.xs),
          // 텍스트 블록 — Figma txt: px8, 행 간격 4
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 취향 일치율 (Figma label_best 슬롯 위치)
                  if (matchPercent != null && matchPercent! > 0) ...[
                    _buildSmallTag('취향 $matchPercent%', colors),
                    const SizedBox(height: AppSpacing.xxs),
                  ],
                  Text(
                    subtitle,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: colors.labelAlternative,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  // 이름 — 잔여 높이를 흡수하고 초과 시 말줄임 (가변 데이터 안전)
                  Flexible(
                    child: Text(
                      name,
                      style: AppTextStyles.caption1Medium.copyWith(
                        color: colors.labelNormal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  _buildPriceBlock(colors),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 썸네일(1:1, radius 20) + 우하단 하트 오버레이
  Widget _buildImage(AppColorScheme colors) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceCardStrong,
                // Figma thumbnail radius 20
                borderRadius: AppRadius.xxlBorder,
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null
                  ? Icon(Icons.coffee, size: 48, color: colors.primaryNormal)
                  : null,
            ),
          ),
          // Figma Item/Resource/Heart: 우하단 인셋 8, 24px primary 하트 (배경 없음)
          Positioned(
            right: AppSpacing.xs,
            bottom: AppSpacing.xs,
            child: Semantics(
              label: isLiked ? '좋아요 취소' : '좋아요',
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onLikeTap,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: AppSpacing.space24,
                  color: colors.primaryNormal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 가격 블록 — 할인%+가격 행 + '구독 할인가' 보조 라벨. 가격 없으면 미표시.
  Widget _buildPriceBlock(AppColorScheme colors) {
    if (price == null && discountPercent == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (discountPercent != null) ...[
              Text(
                '$discountPercent%',
                style: AppTextStyles.body2NormalBold.copyWith(
                  color: colors.primaryNormal,
                ),
              ),
              const SizedBox(width: AppSpacing.space2),
            ],
            if (price != null)
              Text(
                AppUtil.changeNumberToWon(price),
                style: AppTextStyles.body2NormalBold.copyWith(
                  color: colors.labelNormal,
                ),
              ),
          ],
        ),
        // Figma: 가격 아래 '구독 할인가' 보조 라벨 (할인 상품일 때)
        if (discountPercent != null)
          Text(
            '구독 할인가',
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelAlternative,
            ),
          ),
      ],
    );
  }

  Widget _buildSmallTag(String label, AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: colors.primaryNormal.withValues(alpha: 0.1),
        borderRadius: AppRadius.xsBorder,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption2Medium.copyWith(
          color: colors.primaryNormal,
        ),
      ),
    );
  }
}
