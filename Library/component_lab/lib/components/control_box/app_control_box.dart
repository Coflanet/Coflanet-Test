import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Control Box 타입 — Figma `Check Box` / `Radio Box`.
enum AppControlBoxType {
  checkbox,
  radio,
}

/// Control Box — Figma 🕹️ Control Box 페이지.
///
/// 체크박스/라디오 + 라벨을 포함한 선택 컨트롤.
/// Variant: Select=on / Select=off
class AppControlBox extends StatelessWidget {
  const AppControlBox({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onChanged,
    this.type = AppControlBoxType.checkbox,
    this.subtitle,
    this.isDisabled = false,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  final AppControlBoxType type;
  final String? subtitle;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged(!isSelected),
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.s12,
            horizontal: AppSpacing.s16,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.colorGlobalCoolNeutral99
                : AppColor.colorGlobalCommon100,
            border: Border.all(
              color: isSelected
                  ? AppColor.colorGlobalCoolNeutral10
                  : AppColor.colorGlobalCoolNeutral95,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(AppRadius.radius12),
          ),
          child: Row(
            children: [
              // 선택 인디케이터
              _buildIndicator(),
              SizedBox(width: AppSpacing.s12),
              // 라벨
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.body1NormalMedium.copyWith(
                        color: AppColor.colorGlobalCoolNeutral10,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacingSemantic.inlineXs),
                      Text(
                        subtitle!,
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.colorGlobalCoolNeutral50,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    if (type == AppControlBoxType.radio) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? AppColor.colorGlobalCoolNeutral10
                : AppColor.colorGlobalCoolNeutral80,
            width: isSelected ? 6 : 1.5,
          ),
        ),
      );
    }

    // Checkbox
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColor.colorGlobalCoolNeutral10
            : Colors.transparent,
        border: isSelected
            ? null
            : Border.all(
                color: AppColor.colorGlobalCoolNeutral80,
                width: 1.5,
              ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}
