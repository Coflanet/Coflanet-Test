import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_toast.dart';

// ═══════════════════════════════════════════════════════════════
// TOAST — Figma `Feedback / Toast`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> toastUseCases = [
  WidgetbookComponent(
    name: 'Toast — Normal',
    useCases: [
      WidgetbookUseCase(
        name: 'Normal Toast',
        builder: (context) => _bg(
          context,
          AppToast(
            variant: AppToastVariant.normal,
            message: 'This is a normal toast message',
            showIcon: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Normal with Action',
        builder: (context) => _bg(
          context,
          AppToast(
            variant: AppToastVariant.normal,
            message: 'Item saved to favorites',
            showIcon: true,
            action: 'Undo',
            onAction: () {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Toast — Positive',
    useCases: [
      WidgetbookUseCase(
        name: 'Success Toast',
        builder: (context) => _bg(
          context,
          AppToast(
            variant: AppToastVariant.positive,
            message: 'Action completed successfully',
            showIcon: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Success with Action',
        builder: (context) => _bg(
          context,
          AppToast(
            variant: AppToastVariant.positive,
            message: 'File uploaded successfully',
            showIcon: true,
            action: 'View',
            onAction: () {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Toast — Cautionary',
    useCases: [
      WidgetbookUseCase(
        name: 'Warning Toast',
        builder: (context) => _bg(
          context,
          AppToast(
            variant: AppToastVariant.cautionary,
            message: 'This action cannot be undone',
            showIcon: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Warning with Action',
        builder: (context) => _bg(
          context,
          AppToast(
            variant: AppToastVariant.cautionary,
            message: 'Storage almost full',
            showIcon: true,
            action: 'Clean up',
            onAction: () {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Toast — Negative',
    useCases: [
      WidgetbookUseCase(
        name: 'Error Toast',
        builder: (context) => _bg(
          context,
          AppToast(
            variant: AppToastVariant.negative,
            message: 'Something went wrong',
            showIcon: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Error with Action',
        builder: (context) => _bg(
          context,
          AppToast(
            variant: AppToastVariant.negative,
            message: 'Failed to upload file',
            showIcon: true,
            action: 'Retry',
            onAction: () {},
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    padding: const EdgeInsets.all(AppSpacing.s16),
    color: Theme.of(context).canvasColor,
    child: child,
  );
}
