import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_section_message.dart';

// ═══════════════════════════════════════════════════════════════
// SECTION MESSAGE — Figma `Section Message/Section Message`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> sectionMessageUseCases = [
  WidgetbookComponent(
    name: 'Section Message',
    useCases: [
      WidgetbookUseCase(
        name: 'Neutral — title only',
        builder: (context) => _bg(
          context,
          const AppSectionMessage(
            title: '안내 메시지입니다.',
            type: AppSectionMessageType.neutral,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Info — with description',
        builder: (context) => _bg(
          context,
          const AppSectionMessage(
            title: '새로운 기능이 추가되었어요.',
            description: '설정 화면에서 다크 모드를 켤 수 있습니다.',
            type: AppSectionMessageType.info,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Success — with close',
        builder: (context) => _bg(
          context,
          AppSectionMessage(
            title: '저장되었어요.',
            description: '변경한 내용이 정상적으로 반영되었습니다.',
            type: AppSectionMessageType.success,
            onClose: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Warning — trailing action',
        builder: (context) => _bg(
          context,
          AppSectionMessage(
            title: '용량이 거의 다 찼어요.',
            description: '5.8GB / 6GB 사용 중',
            type: AppSectionMessageType.warning,
            actionLabel: '정리',
            onAction: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Error — bottom actions',
        builder: (context) => _bg(
          context,
          AppSectionMessage(
            title: '연결에 실패했어요.',
            description: '네트워크 상태를 확인해 주세요.',
            type: AppSectionMessageType.error,
            bottomActions: [
              AppSectionMessageBottomAction(
                label: '다시 시도',
                onPressed: () {},
              ),
              AppSectionMessageBottomAction(
                label: '나중에',
                emphasized: false,
                onPressed: () {},
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
    padding: const EdgeInsets.all(AppSpacing.space16),
    color: Theme.of(context).canvasColor,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: child,
    ),
  );
}
