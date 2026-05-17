import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_snackbar.dart';

// ═══════════════════════════════════════════════════════════════
// SNACKBAR — Figma `Feedback / Snackbar`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> snackbarUseCases = [
  WidgetbookComponent(
    name: 'Snackbar',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic Snackbar',
        builder: (context) => _bg(
          context,
          AppSnackbar(
            message: 'This is a snackbar message',
            icon: Icons.notifications_rounded,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Snackbar with Description',
        builder: (context) => _bg(
          context,
          AppSnackbar(
            message: 'File saved',
            description: 'Your changes have been saved successfully',
            icon: Icons.check_circle_rounded,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Snackbar with Action',
        builder: (context) => _bg(
          context,
          AppSnackbar(
            message: 'Item deleted',
            description: 'You can undo this action',
            icon: Icons.delete_rounded,
            actionLabel: 'Undo',
            onAction: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Error Snackbar',
        builder: (context) => _bg(
          context,
          AppSnackbar(
            message: 'Connection error',
            description: 'Please check your internet connection',
            icon: Icons.cloud_off_rounded,
            actionLabel: 'Retry',
            onAction: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Success Snackbar',
        builder: (context) => _bg(
          context,
          AppSnackbar(
            message: 'Profile updated',
            description: 'Your profile has been updated successfully',
            icon: Icons.verified_user_rounded,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Warning Snackbar',
        builder: (context) => _bg(
          context,
          AppSnackbar(
            message: 'Storage almost full',
            description: '5.8 GB of 6 GB used',
            icon: Icons.warning_rounded,
            actionLabel: 'Clean up',
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
