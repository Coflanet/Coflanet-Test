import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';

/// Segmented Control 사이즈 — Figma `Segmented Control` Size variant.
enum AppSegmentedControlSize {
  /// Large
  large(40),

  /// Medium
  medium(36),

  /// Small
  small(32);

  const AppSegmentedControlSize(this.height);
  final double height;
}

/// 세그먼트 항목 데이터.
class AppSegmentItem {
  const AppSegmentItem({
    required this.label,
    this.icon,
  });

  final String label;
  final IconData? icon;
}

/// Segmented Control — Figma `Segmented Control/Segmented Control`.
///
/// 여러 옵션 중 하나를 선택할 수 있으며, 선택된 항목을 비주얼로 표시합니다.
///
/// Size: Large / Medium / Small
/// Icon: True / False
class AppSegmentedControl extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.size = AppSegmentedControlSize.medium,
  });

  final List<AppSegmentItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final AppSegmentedControlSize size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      padding: const EdgeInsets.all(AppSpacing.s2),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral97,
        borderRadius: BorderRadius.circular(AppRadius.radius10),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final isActive = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColor.colorGlobalCommon100
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.radius8),
                  boxShadow: isActive
                      ? [
                          const BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.06),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (items[i].icon != null) ...[
                      Icon(
                        items[i].icon,
                        size: 16,
                        color: isActive
                            ? AppColor.colorGlobalCoolNeutral10
                            : AppColor.colorGlobalCoolNeutral50,
                      ),
                      const SizedBox(width: AppSpacing.s4),
                    ],
                    Text(
                      items[i].label,
                      style: AppTextStyles.label1NormalBold.copyWith(
                        color: isActive
                            ? AppColor.colorGlobalCoolNeutral10
                            : AppColor.colorGlobalCoolNeutral50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
