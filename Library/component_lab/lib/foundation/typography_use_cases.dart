import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'app_color.dart';
import 'app_text_style.dart';

/// 텍스트 스타일 카탈로그 항목.
class _T {
  final String name;
  final TextStyle style;
  final String preview;

  const _T(this.name, this.style, [this.preview = '한글 Aa 1234']);
}

/// 텍스트 스타일 use_cases — 66 + emoji 5.
final List<WidgetbookComponent> typographyUseCases = [
  WidgetbookComponent(
    name: 'Display',
    useCases: [
      WidgetbookUseCase(
        name: 'Display 1 (56px)',
        builder: (context) => _list(context, const [
          _T('display1Bold', AppTextStyles.display1Bold),
          _T('display1Medium', AppTextStyles.display1Medium),
          _T('display1Regular', AppTextStyles.display1Regular),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Display 2 (40px)',
        builder: (context) => _list(context, const [
          _T('display2Bold', AppTextStyles.display2Bold),
          _T('display2Medium', AppTextStyles.display2Medium),
          _T('display2Regular', AppTextStyles.display2Regular),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Title',
    useCases: [
      WidgetbookUseCase(
        name: 'Title 1 (36px)',
        builder: (context) => _list(context, const [
          _T('title1Bold', AppTextStyles.title1Bold),
          _T('title1Medium', AppTextStyles.title1Medium),
          _T('title1Regular', AppTextStyles.title1Regular),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Title 2 (28px) — Tabular 포함',
        builder: (context) => _list(context, const [
          _T('title2Bold', AppTextStyles.title2Bold),
          _T('title2Medium', AppTextStyles.title2Medium),
          _T('title2Regular', AppTextStyles.title2Regular),
          _T('title2MediumTabular', AppTextStyles.title2MediumTabular,
              '00:23:45  ₩12,340'),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Title 3 (24px) — Tabular 포함',
        builder: (context) => _list(context, const [
          _T('title3Bold', AppTextStyles.title3Bold),
          _T('title3Medium', AppTextStyles.title3Medium),
          _T('title3Regular', AppTextStyles.title3Regular),
          _T('title3MediumTabular', AppTextStyles.title3MediumTabular,
              '00:23:45  ₩12,340'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Heading',
    useCases: [
      WidgetbookUseCase(
        name: 'Heading 1 (22px) — Bold는 SemiBold(w600)',
        builder: (context) => _list(context, const [
          _T('heading1Bold', AppTextStyles.heading1Bold),
          _T('heading1Medium', AppTextStyles.heading1Medium),
          _T('heading1Regular', AppTextStyles.heading1Regular),
          _T('heading1BoldTabular', AppTextStyles.heading1BoldTabular,
              '12,340 잔'),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Heading 2 (20px) — Bold는 SemiBold(w600)',
        builder: (context) => _list(context, const [
          _T('heading2Bold', AppTextStyles.heading2Bold),
          _T('heading2Medium', AppTextStyles.heading2Medium),
          _T('heading2Regular', AppTextStyles.heading2Regular),
          _T('heading2BoldTabular', AppTextStyles.heading2BoldTabular,
              '12,340 잔'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Headline',
    useCases: [
      WidgetbookUseCase(
        name: 'Headline 1 (18px)',
        builder: (context) => _list(context, const [
          _T('headline1Bold', AppTextStyles.headline1Bold),
          _T('headline1Medium', AppTextStyles.headline1Medium),
          _T('headline1Regular', AppTextStyles.headline1Regular),
          _T('headline1BoldTabular', AppTextStyles.headline1BoldTabular),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Headline 2 (17px)',
        builder: (context) => _list(context, const [
          _T('headline2Bold', AppTextStyles.headline2Bold),
          _T('headline2Medium', AppTextStyles.headline2Medium),
          _T('headline2Regular', AppTextStyles.headline2Regular),
          _T('headline2BoldTabular', AppTextStyles.headline2BoldTabular),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Body',
    useCases: [
      WidgetbookUseCase(
        name: 'Body 1 / Normal (16px)',
        builder: (context) => _list(context, const [
          _T('body1NormalBold', AppTextStyles.body1NormalBold),
          _T('body1NormalMedium', AppTextStyles.body1NormalMedium),
          _T('body1NormalRegular', AppTextStyles.body1NormalRegular),
          _T('body1NormalRegularTabular',
              AppTextStyles.body1NormalRegularTabular),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Body 1 / Reading (16px) — 긴 글 (line-height 큼)',
        builder: (context) => _list(context, const [
          _T('body1ReadingBold', AppTextStyles.body1ReadingBold),
          _T('body1ReadingMedium', AppTextStyles.body1ReadingMedium),
          _T('body1ReadingRegular', AppTextStyles.body1ReadingRegular),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Body 2 / Normal (15px)',
        builder: (context) => _list(context, const [
          _T('body2NormalBold', AppTextStyles.body2NormalBold),
          _T('body2NormalMedium', AppTextStyles.body2NormalMedium),
          _T('body2NormalRegular', AppTextStyles.body2NormalRegular),
          _T('body2NormalRegularTabular',
              AppTextStyles.body2NormalRegularTabular),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Body 2 / Reading (15px)',
        builder: (context) => _list(context, const [
          _T('body2ReadingBold', AppTextStyles.body2ReadingBold),
          _T('body2ReadingMedium', AppTextStyles.body2ReadingMedium),
          _T('body2ReadingRegular', AppTextStyles.body2ReadingRegular),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Label',
    useCases: [
      WidgetbookUseCase(
        name: 'Label 1 / Normal (14px)',
        builder: (context) => _list(context, const [
          _T('label1NormalBold', AppTextStyles.label1NormalBold),
          _T('label1NormalMedium', AppTextStyles.label1NormalMedium),
          _T('label1NormalRegular', AppTextStyles.label1NormalRegular),
          _T('label1NormalRegularTabular',
              AppTextStyles.label1NormalRegularTabular),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Label 1 / Reading (14px)',
        builder: (context) => _list(context, const [
          _T('label1ReadingBold', AppTextStyles.label1ReadingBold),
          _T('label1ReadingMedium', AppTextStyles.label1ReadingMedium),
          _T('label1ReadingRegular', AppTextStyles.label1ReadingRegular),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Label 2 (13px)',
        builder: (context) => _list(context, const [
          _T('label2Bold', AppTextStyles.label2Bold),
          _T('label2Medium', AppTextStyles.label2Medium),
          _T('label2Regular', AppTextStyles.label2Regular),
          _T('label2RegularTabular', AppTextStyles.label2RegularTabular),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Caption',
    useCases: [
      WidgetbookUseCase(
        name: 'Caption 1 (12px)',
        builder: (context) => _list(context, const [
          _T('caption1Bold', AppTextStyles.caption1Bold),
          _T('caption1Medium', AppTextStyles.caption1Medium),
          _T('caption1Regular', AppTextStyles.caption1Regular),
          _T('caption1RegularTabular', AppTextStyles.caption1RegularTabular),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Caption 2 (11px)',
        builder: (context) => _list(context, const [
          _T('caption2Bold', AppTextStyles.caption2Bold),
          _T('caption2Medium', AppTextStyles.caption2Medium),
          _T('caption2Regular', AppTextStyles.caption2Regular),
          _T('caption2RegularTabular', AppTextStyles.caption2RegularTabular),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Emoji',
    useCases: [
      WidgetbookUseCase(
        name: '5단계 (Figma 외부, 시스템 폰트 폴백)',
        builder: (context) => _list(context, const [
          _T('emojiSmall (16px)', AppTextStyles.emojiSmall, '☕️ 🌱'),
          _T('emojiMedium (20px)', AppTextStyles.emojiMedium, '☕️ 🌱'),
          _T('emojiNormal (24px)', AppTextStyles.emojiNormal, '☕️ 🌱'),
          _T('emojiLarge (48px)', AppTextStyles.emojiLarge, '☕️'),
          _T('emojiXLarge (80px)', AppTextStyles.emojiXLarge, '☕️'),
        ]),
      ),
    ],
  ),
];

/// 텍스트 스타일 카드 리스트.
Widget _list(BuildContext context, List<_T> items) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final labelColor = isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
  final altColor =
      isDark ? AppColor.darkLabelAlternative : AppColor.labelAlternative;
  final bgColor = isDark
      ? AppColor.darkBackgroundElevatedNormal
      : AppColor.backgroundElevatedNormal;
  final borderColor =
      isDark ? AppColor.darkLineSolidNormal : AppColor.lineSolidNormal;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: items.map((it) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                it.name,
                style: TextStyle(
                  color: altColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                it.preview,
                style: it.style.copyWith(color: labelColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${it.style.fontSize?.toStringAsFixed(0)}px • '
                'h ${it.style.height?.toStringAsFixed(3)} • '
                'ls ${it.style.letterSpacing?.toStringAsFixed(2)} • '
                'w${it.style.fontWeight?.value}'
                '${(it.style.fontFeatures?.any((f) => f.feature == 'tnum') ?? false) ? ' • tnum' : ''}',
                style: TextStyle(color: altColor, fontSize: 11),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
