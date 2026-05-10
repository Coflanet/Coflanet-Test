import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Review 레이아웃 — Figma `Contents/Review`.
enum AppReviewLayout {
  /// 컴팩트 — 한 줄 헤더(별점 + 작성자 + 날짜) + 본문 + 우측 1개 썸네일
  compact,

  /// 다중 썸네일 — 헤더 + 1열 4개 썸네일 + 본문 + helpful
  multiImage,

  /// 풀 — 아바타 + 5-스타 + 작성자 + 날짜 + 신고 + 2열 그리드 썸네일 + 본문 + 더보기 + helpful
  full,
}

/// Review 아이템 — Figma `Contents/Review`.
///
/// 평점 + 작성자 + 날짜 + 본문 + 썸네일 + 도움 카운트로 구성된 리뷰 행.
class AppReview extends StatelessWidget {
  const AppReview({
    super.key,
    required this.rating,
    required this.author,
    required this.date,
    required this.content,
    this.layout = AppReviewLayout.compact,
    this.thumbnails = const [],
    this.helpfulCount,
    this.onHelpfulTap,
    this.onReportTap,
    this.onMoreTap,
  });

  final double rating;
  final String author;
  final String date;
  final String content;
  final AppReviewLayout layout;

  /// 본문 옆/아래에 표시할 썸네일.
  /// - compact: 첫 1개
  /// - multiImage: 4개까지 한 줄
  /// - full: 2열 그리드
  final List<Widget> thumbnails;

  /// "이 리뷰가 도움이 되었어요" 카운트. null이면 미표시.
  final int? helpfulCount;
  final VoidCallback? onHelpfulTap;
  final VoidCallback? onReportTap;

  /// 본문이 길어 잘렸을 때 표시할 "더보기" 액션.
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case AppReviewLayout.compact:
        return _buildCompact(context);
      case AppReviewLayout.multiImage:
        return _buildMultiImage(context);
      case AppReviewLayout.full:
        return _buildFull(context);
    }
  }

  Widget _buildCompact(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _StarRow(rating: rating, author: author, date: date),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: AppColor.labelNormal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (thumbnails.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.space12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: thumbnails.first,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMultiImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _StarRow(rating: rating, author: author, date: date),
          const SizedBox(height: AppSpacing.space8),
          Row(
            children: thumbnails.take(4).map((t) {
              final i = thumbnails.indexOf(t);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 3 ? 6 : 0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.radius8),
                      child: t,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            content,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.labelNormal,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.space8),
          _HelpfulRow(
            count: helpfulCount,
            onTap: onHelpfulTap,
          ),
        ],
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _AvatarStarRow(
            rating: rating,
            author: author,
            date: date,
            onReportTap: onReportTap,
          ),
          if (thumbnails.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space8),
            _ImageGrid(thumbnails: thumbnails),
          ],
          const SizedBox(height: AppSpacing.space8),
          Text(
            content,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.labelNormal,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          if (onMoreTap != null) ...[
            const SizedBox(height: 4),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onMoreTap,
              child: Text(
                '더보기',
                style: AppTextStyles.label2Regular.copyWith(
                  color: AppColor.labelAlternative,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.space8),
          _HelpfulRow(
            count: helpfulCount,
            onTap: onHelpfulTap,
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({
    required this.rating,
    required this.author,
    required this.date,
  });

  final double rating;
  final String author;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_rounded, size: 14, color: AppColor.colorGlobalYellow50),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.label2Bold.copyWith(
            color: AppColor.labelNormal,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: AppSpacing.space8),
        Text(
          author,
          style: AppTextStyles.label2Regular.copyWith(
            color: AppColor.labelNeutral,
          ),
        ),
        const SizedBox(width: AppSpacing.space8),
        Text(
          date,
          style: AppTextStyles.caption1Regular.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
      ],
    );
  }
}

class _AvatarStarRow extends StatelessWidget {
  const _AvatarStarRow({
    required this.rating,
    required this.author,
    required this.date,
    this.onReportTap,
  });

  final double rating;
  final String author;
  final String date;
  final VoidCallback? onReportTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColor.lineSolidNormal,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.person_rounded,
            size: 18,
            color: AppColor.labelAlternative,
          ),
        ),
        const SizedBox(width: AppSpacing.space8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ...List.generate(
                    5,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 1),
                      child: Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: i < rating.round()
                            ? AppColor.colorGlobalYellow50
                            : AppColor.lineSolidNeutral,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: AppTextStyles.label2Bold.copyWith(
                      color: AppColor.labelNormal,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    author,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.labelNeutral,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space8),
                  Text(
                    date,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                  ),
                  if (onReportTap != null) ...[
                    const SizedBox(width: AppSpacing.space8),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onReportTap,
                      child: Text(
                        '신고하기',
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.labelAlternative,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.thumbnails});
  final List<Widget> thumbnails;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: thumbnails.take(2).map((t) {
        final i = thumbnails.indexOf(t);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == 0 ? 6 : 0),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.radius8),
                child: t,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HelpfulRow extends StatelessWidget {
  const _HelpfulRow({this.count, this.onTap});
  final int? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '이 리뷰가 도움이 되었어요',
          style: AppTextStyles.caption1Regular.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
        const Spacer(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.lineSolidNeutral,
              borderRadius: BorderRadius.circular(AppRadius.radius6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.thumb_up_off_alt_rounded,
                  size: 12,
                  color: AppColor.labelAlternative,
                ),
                const SizedBox(width: 4),
                Text(
                  '${count ?? 0}',
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
