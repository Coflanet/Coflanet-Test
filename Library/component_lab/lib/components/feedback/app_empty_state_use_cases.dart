import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import 'app_empty_state.dart';

// ═══════════════════════════════════════════════════════════════
// EMPTY STATE — Figma `Empty State/Empty State`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> emptyStateUseCases = [
  WidgetbookComponent(
    name: 'Empty State',
    useCases: [
      WidgetbookUseCase(
        name: 'No Data',
        builder: (context) => _bg(
          context,
          AppEmptyState(
            icon: Icons.coffee_rounded,
            title: '아직 기록이 없어요',
            description: '첫 시음 기록을 남겨보세요.',
            actionLabel: '기록하기',
            onAction: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'No Search Result',
        builder: (context) => _bg(
          context,
          const AppEmptyState(
            icon: Icons.search_rounded,
            title: '검색 결과가 없어요',
            description: '다른 키워드로 다시 검색해 보세요.',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'No Permission',
        builder: (context) => _bg(
          context,
          AppEmptyState(
            icon: Icons.lock_outline_rounded,
            title: '접근 권한이 없어요',
            description: '해당 콘텐츠를 보려면 권한이 필요합니다.',
            actionLabel: '권한 요청',
            onAction: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Error',
        builder: (context) => _bg(
          context,
          AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: '문제가 발생했어요',
            description: '잠시 후 다시 시도해 주세요.',
            actionLabel: '다시 시도',
            onAction: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Compact + Custom Illustration',
        builder: (context) => _bg(
          context,
          AppEmptyState(
            compact: true,
            illustration: const Icon(
              Icons.inbox_rounded,
              size: 72,
              color: Colors.grey,
            ),
            title: '받은 알림이 없어요',
            description: '새로운 알림이 도착하면 여기에 표시됩니다.',
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: AppColor.backgroundNormalNormal,
    child: child,
  );
}
