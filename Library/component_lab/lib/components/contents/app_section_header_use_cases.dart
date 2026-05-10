import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_text_style.dart';
import 'app_section_header.dart';

// ═══════════════════════════════════════════════════════════════
// SECTION HEADER — Figma `Contents/Section Header`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> sectionHeaderUseCases = [
  WidgetbookComponent(
    name: 'Section Header — Size',
    useCases: [
      WidgetbookUseCase(
        name: 'xsmall / small / medium / large',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              AppSectionHeader(
                title: '제목',
                size: AppSectionHeaderSize.xsmall,
              ),
              AppSectionHeader(
                title: '제목',
                size: AppSectionHeaderSize.small,
              ),
              AppSectionHeader(
                title: '제목',
                size: AppSectionHeaderSize.medium,
              ),
              AppSectionHeader(
                title: '제목',
                size: AppSectionHeaderSize.large,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Section Header — Trailing',
    useCases: [
      WidgetbookUseCase(
        name: 'Trailing text + chevron',
        builder: (context) => _bg(
          context,
          AppSectionHeader(
            title: '제목',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '텍스트',
                  style: AppTextStyles.label2Regular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColor.labelAlternative,
                ),
              ],
            ),
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Trailing checkbox / switch',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSectionHeader(
                title: '제목',
                trailing: Icon(
                  Icons.check_box_outlined,
                  size: 18,
                  color: AppColor.labelAlternative,
                ),
              ),
              AppSectionHeader(
                title: '제목',
                trailing: Switch(value: true, onChanged: (_) {}),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Section Header — Align',
    useCases: [
      WidgetbookUseCase(
        name: 'Inline (한 줄)',
        builder: (context) => _bg(
          context,
          AppSectionHeader(
            title: '제목이 한 줄 일 때',
            align: AppSectionHeaderAlign.inline,
            trailing: Text(
              '텍스트',
              style: AppTextStyles.label2Regular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Multiline (제목이 한 줄 이상일 때)',
        builder: (context) => _bg(
          context,
          AppSectionHeader(
            title: '제목이 한 줄 이상일 때\n이렇게 표현 됩니다',
            align: AppSectionHeaderAlign.multiline,
            trailing: Text(
              '텍스트',
              style: AppTextStyles.label2Regular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Section Header — With Subtitle',
    useCases: [
      WidgetbookUseCase(
        name: 'Title + subtitle + trailing',
        builder: (context) => _bg(
          context,
          AppSectionHeader(
            title: '추천 컬렉션',
            subtitle: '오늘의 큐레이션',
            trailing: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColor.labelAlternative,
            ),
            onTap: () {},
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: Theme.of(context).canvasColor,
    child: child,
  );
}
