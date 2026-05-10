import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Select/Dropdown 컴포넌트 — Figma Selection and Input 페이지.
///
/// Textfield 베이스의 드롭다운 셀렉트.
/// Status: Normal / Positive / Negative
/// Disable 지원
class AppSelect<T> extends StatefulWidget {
  const AppSelect({
    super.key,
    required this.items,
    required this.itemLabel,
    this.selectedItem,
    this.onChanged,
    this.label,
    this.hintText = '선택하세요',
    this.isDisabled = false,
    this.isError = false,
    this.errorText,
    this.helperText,
  });

  final List<T> items;
  final String Function(T) itemLabel;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String hintText;
  final bool isDisabled;
  final bool isError;
  final String? errorText;
  final String? helperText;

  @override
  State<AppSelect<T>> createState() => _AppSelectState<T>();
}

class _AppSelectState<T> extends State<AppSelect<T>> {
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggle() {
    if (widget.isDisabled) return;
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Backdrop
          GestureDetector(
            onTap: _close,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
          // Dropdown
          CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 4),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: size.width,
                constraints: const BoxConstraints(maxHeight: 240),
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCommon100,
                  borderRadius: BorderRadius.circular(AppRadius.radius12),
                  boxShadow: AppShadows.shadowBlackStrong,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radius12),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (_, i) {
                      final item = widget.items[i];
                      final isSelected = item == widget.selectedItem;
                      return GestureDetector(
                        onTap: () {
                          widget.onChanged?.call(item);
                          _close();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.space16,
                            vertical: AppSpacing.space12,
                          ),
                          color: isSelected
                              ? AppColor.colorGlobalCoolNeutral99
                              : null,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.itemLabel(item),
                                  style:
                                      AppTextStyles.body2NormalRegular.copyWith(
                                    color: isSelected
                                        ? AppColor.colorGlobalCoolNeutral10
                                        : AppColor.colorGlobalCoolNeutral30,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  size: 18,
                                  color: AppColor.colorGlobalCoolNeutral10,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Border color: error → red, open → CoolNeutral10, default → CoolNeutral95
    Color borderColor;
    if (widget.isError) {
      borderColor = const Color(0xFFFF5252);
    } else if (_isOpen) {
      borderColor = AppColor.colorGlobalCoolNeutral10;
    } else {
      borderColor = AppColor.colorGlobalCoolNeutral95;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: AppColor.colorGlobalCoolNeutral10,
            ),
          ),
          SizedBox(height: AppSpacing.space8),
        ],

        // Select field
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggle,
            child: Opacity(
              opacity: widget.isDisabled ? 0.4 : 1.0,
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.space16),
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCommon100,
                  border: Border.all(color: borderColor, width: 1),
                  borderRadius: BorderRadius.circular(AppRadius.radius12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.selectedItem != null
                            ? widget.itemLabel(widget.selectedItem as T)
                            : widget.hintText,
                        style: AppTextStyles.body1NormalRegular.copyWith(
                          color: widget.selectedItem != null
                              ? AppColor.colorGlobalCoolNeutral10
                              : AppColor.colorGlobalCoolNeutral60,
                        ),
                      ),
                    ),
                    Icon(
                      _isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: AppColor.colorGlobalCoolNeutral50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Helper / Error text
        if (widget.errorText != null && widget.isError) ...[
          SizedBox(height: AppSpacing.space4),
          Text(
            widget.errorText!,
            style: AppTextStyles.caption1Regular.copyWith(
              color: const Color(0xFFFF5252),
            ),
          ),
        ] else if (widget.helperText != null) ...[
          SizedBox(height: AppSpacing.space4),
          Text(
            widget.helperText!,
            style: AppTextStyles.caption1Regular.copyWith(
              color: AppColor.colorGlobalCoolNeutral50,
            ),
          ),
        ],
      ],
    );
  }
}
