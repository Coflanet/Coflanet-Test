import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Item Heart 토글 — Figma `Contents/Item List/Item/Resource/Heart`.
///
/// 작은 하트 아이콘 토글. 단독 컴포넌트이자 [AppItemCard] 의 우상단 영역에서도 재사용된다.
class AppItemHeart extends StatelessWidget {
  const AppItemHeart({
    super.key,
    required this.isLiked,
    this.onTap,
    this.size = 24,
  });

  final bool isLiked;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: size + 8,
        height: size + 8,
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          size: size,
          color: isLiked
              ? AppColor.primaryNormal
              : AppColor.labelAlternative,
        ),
      ),
    );
  }
}

/// Item Card 레이아웃 — Figma `Contents/Item List`.
enum AppItemCardLayout { vertical, horizontal }

/// Item Card — Figma `Contents/Item List`.
///
/// 가로 / 세로 레이아웃을 지원하며, 이미지 위에 상단 우측 하트 토글이 얹어진다.
/// 내용: 브랜드 칩(옵션) + 이름(최대 2줄) + 할인율/가격 + 평점.
class AppItemCard extends StatelessWidget {
  const AppItemCard({
    super.key,
    required this.name,
    required this.price,
    this.layout = AppItemCardLayout.vertical,
    this.image,
    this.brandTags = const [],
    this.discountPercent,
    this.rating,
    this.reviewCount,
    this.isLiked = false,
    this.onLikeTap,
    this.onTap,
  });

  final String name;
  final int price;
  final AppItemCardLayout layout;

  /// 썸네일 위젯. null 이면 placeholder 표시.
  final Widget? image;

  /// 이름 위쪽에 표시할 작은 태그(예: NEW, BEST).
  final List<String> brandTags;

  /// 할인율(%). null 이면 미표시.
  final int? discountPercent;

  /// 평점 (예: 4.8).
  final double? rating;

  /// 리뷰 수.
  final int? reviewCount;

  final bool isLiked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: layout == AppItemCardLayout.vertical
          ? _buildVertical(context)
          : _buildHorizontal(context),
    );
  }

  Widget _buildVertical(BuildContext context) {
    return SizedBox(
      width: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Thumbnail(
            image: image,
            isLiked: isLiked,
            onLikeTap: onLikeTap,
            size: 112,
          ),
          const SizedBox(height: AppSpacing.space8),
          _BrandTags(tags: brandTags),
          if (brandTags.isNotEmpty) const SizedBox(height: 4),
          Text(
            name,
            style: AppTextStyles.label1NormalRegular.copyWith(
              color: AppColor.labelNormal,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _PriceRow(price: price, discountPercent: discountPercent),
          if (rating != null) ...[
            const SizedBox(height: 2),
            _RatingRow(rating: rating!, reviewCount: reviewCount),
          ],
        ],
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Thumbnail(image: image, size: 88),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: AppTextStyles.body2NormalMedium.copyWith(
                        color: AppColor.labelNormal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppItemHeart(isLiked: isLiked, onTap: onLikeTap, size: 20),
                ],
              ),
              const SizedBox(height: 4),
              _BrandTags(tags: brandTags),
              if (brandTags.isNotEmpty) const SizedBox(height: 4),
              _PriceRow(price: price, discountPercent: discountPercent),
              if (rating != null) ...[
                const SizedBox(height: 2),
                _RatingRow(rating: rating!, reviewCount: reviewCount),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    this.image,
    this.isLiked = false,
    this.onLikeTap,
    this.size = 112,
  });

  final Widget? image;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radius8),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (image != null)
              image!
            else
              ColoredBox(color: AppColor.lineSolidNormal),
            if (onLikeTap != null)
              Positioned(
                top: 4,
                right: 4,
                child: AppItemHeart(
                  isLiked: isLiked,
                  onTap: onLikeTap,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BrandTags extends StatelessWidget {
  const _BrandTags({required this.tags});
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags
          .map(
            (t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.radius4),
              ),
              child: Text(
                t,
                style: AppTextStyles.caption1Bold.copyWith(
                  color: AppColor.primaryNormal,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.price, this.discountPercent});
  final int price;
  final int? discountPercent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (discountPercent != null) ...[
          Text(
            '$discountPercent%',
            style: AppTextStyles.label1NormalBold.copyWith(
              color: AppColor.statusNegative,
            ),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          _formatPrice(price),
          style: AppTextStyles.label1NormalBold.copyWith(
            color: AppColor.labelNormal,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  static String _formatPrice(int p) {
    final s = p.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, this.reviewCount});
  final double rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 12, color: AppColor.colorGlobalYellow50),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.caption1Regular.copyWith(
            color: AppColor.labelNormal,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '· 구매 $reviewCount건',
            style: AppTextStyles.caption1Regular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ],
      ],
    );
  }
}
