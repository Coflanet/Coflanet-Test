import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';
import '../../foundation/app_shadow.dart';

/// Floating Action Button — Figma `Button/Floating Action`.
///
/// 정확한 Figma 측정:
/// - 56×56, padding 16, radius 1000 (완전 원형)
/// - Disable=False: fill `Component/fill/alternative` 8% (componentFillNormal)
/// - Disable=True: fill `interaction/disable` 50%
class AppFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const AppFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
  });

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = _enabled ? c.componentFillNormal : c.interactionDisable;
    final fg = _enabled ? c.labelNormal : c.labelAssistive;

    final body = Container(
      width: 56,
      height: 56,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        boxShadow: _enabled
            ? (isDark
                ? AppShadows.shadowBlackEmphasize
                : AppShadows.shadowPrimaryEmphasize)
            : null,
      ),
      child: Center(child: Icon(icon, size: 24, color: fg)),
    );

    final tappable = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: body,
      ),
    );

    return tooltip != null
        ? Tooltip(message: tooltip!, child: tappable)
        : tappable;
  }
}
