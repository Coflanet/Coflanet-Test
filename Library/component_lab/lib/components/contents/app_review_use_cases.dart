import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import 'app_review.dart';

// ═══════════════════════════════════════════════════════════════
// REVIEW — Figma `Contents/Review`
// ═══════════════════════════════════════════════════════════════

const _content = '처음 마셔봤는데 산미가 상큼하고 향이 너무 좋아요. 아침에 일어나서 마시니까 하루가 상쾌하게 시작되더라고요!';

Widget _placeholderThumb({IconData icon = Icons.image_outlined}) => Container(
      color: AppColor.lineSolidNeutral,
      alignment: Alignment.center,
      child: Icon(icon, color: AppColor.labelAlternative, size: 18),
    );

final List<WidgetbookComponent> reviewUseCases = [
  WidgetbookComponent(
    name: 'Review — Compact',
    useCases: [
      WidgetbookUseCase(
        name: 'No thumbnail',
        builder: (context) => _bg(
          context,
          AppReview(
            rating: 4.6,
            author: '하얀동람보르기니',
            date: '25.8.12',
            content: _content,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With single thumbnail',
        builder: (context) => _bg(
          context,
          AppReview(
            rating: 4.6,
            author: '하얀동람보르기니',
            date: '25.8.12',
            content: _content,
            thumbnails: [_placeholderThumb()],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Review — Multi Image',
    useCases: [
      WidgetbookUseCase(
        name: '4 thumbnails inline',
        builder: (context) => _bg(
          context,
          AppReview(
            layout: AppReviewLayout.multiImage,
            rating: 4.6,
            author: '하얀동람보르기니',
            date: '25.8.12',
            content: _content,
            thumbnails: List.generate(4, (_) => _placeholderThumb()),
            helpfulCount: 56,
            onHelpfulTap: () {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Review — Full',
    useCases: [
      WidgetbookUseCase(
        name: 'Avatar + 5-star + 2 image grid + helpful',
        builder: (context) => _bg(
          context,
          AppReview(
            layout: AppReviewLayout.full,
            rating: 4.6,
            author: '하얀동람보르기니',
            date: '25.8.12',
            content: '$_content $_content',
            thumbnails: List.generate(2, (_) => _placeholderThumb()),
            helpfulCount: 56,
            onHelpfulTap: () {},
            onReportTap: () {},
            onMoreTap: () {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Review — Stack',
    useCases: [
      WidgetbookUseCase(
        name: 'Mixed layouts',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppReview(
                rating: 4.6,
                author: '하얀동람보르기니',
                date: '25.8.12',
                content: _content,
                thumbnails: [_placeholderThumb()],
              ),
              Container(height: 1, color: AppColor.lineNormalAlternative),
              AppReview(
                layout: AppReviewLayout.multiImage,
                rating: 4.6,
                author: '하얀동람보르기니',
                date: '25.8.12',
                content: _content,
                thumbnails: List.generate(4, (_) => _placeholderThumb()),
                helpfulCount: 56,
                onHelpfulTap: () {},
              ),
              Container(height: 1, color: AppColor.lineNormalAlternative),
              AppReview(
                layout: AppReviewLayout.full,
                rating: 4.6,
                author: '하얀동람보르기니',
                date: '25.8.12',
                content: _content,
                thumbnails: List.generate(2, (_) => _placeholderThumb()),
                helpfulCount: 56,
                onHelpfulTap: () {},
                onReportTap: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: Theme.of(context).canvasColor,
    decoration: BoxDecoration(
      color: Theme.of(context).canvasColor,
      borderRadius: BorderRadius.circular(AppRadius.radius8),
    ),
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.space8),
    child: child,
  );
}
