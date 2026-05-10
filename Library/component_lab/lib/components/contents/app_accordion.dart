import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Accordion 세로 패딩 — Figma `Accordion/Accordion` Vertical Padding.
enum AppAccordionPadding {
  large(16),
  medium(12);

  const AppAccordionPadding(this.value);
  final double value;
}

/// Accordion 컴포넌트 — Figma `Accordion/Accordion`.
///
/// Variant:
/// - Vertical Padding: Large / Medium
/// - Fill Width: True / False
/// - Complete: True / False
/// - Expand: True / False
class AppAccordion extends StatefulWidget {
  const AppAccordion({
    super.key,
    required this.title,
    required this.content,
    this.subtitle,
    this.leading,
    this.initiallyExpanded = false,
    this.isComplete = false,
    this.fillWidth = false,
    this.padding = AppAccordionPadding.large,
    this.onExpansionChanged,
  });

  final String title;
  final Widget content;
  final String? subtitle;
  final Widget? leading;
  final bool initiallyExpanded;
  final bool isComplete;
  final bool fillWidth;
  final AppAccordionPadding padding;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<AppAccordion> createState() => _AppAccordionState();
}

class _AppAccordionState extends State<AppAccordion>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconRotation = Tween<double>(begin: 0, end: 0.5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call(_isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.padding.value,
              horizontal: AppSpacing.space16,
            ),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  SizedBox(width: AppSpacing.space12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: AppTextStyles.body1NormalMedium.copyWith(
                          color: AppColor.colorGlobalCoolNeutral10,
                        ),
                      ),
                      if (widget.subtitle != null)
                        Text(
                          widget.subtitle!,
                          style: AppTextStyles.caption1Regular.copyWith(
                            color: AppColor.colorGlobalCoolNeutral50,
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.isComplete)
                  Padding(
                    padding: EdgeInsets.only(right: AppSpacing.space8),
                    child: Icon(
                      Icons.check_circle,
                      size: 20,
                      color: AppColor.colorGlobalCoolNeutral10,
                    ),
                  ),
                RotationTransition(
                  turns: _iconRotation,
                  child: Icon(
                    Icons.expand_more,
                    size: 24,
                    color: AppColor.colorGlobalCoolNeutral50,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expandable content
        SizeTransition(
          sizeFactor: _heightFactor,
          axisAlignment: -1.0,
          child: widget.content,
        ),

        // Divider
        Container(
          height: 1,
          color: AppColor.colorGlobalCoolNeutral97,
        ),
      ],
    );
  }
}
