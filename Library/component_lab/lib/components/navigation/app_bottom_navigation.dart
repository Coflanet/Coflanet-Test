import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_text_style.dart';
import '../../foundation/app_spacing.dart';

// ─────────────────────────────────────────────────────────────
// Bottom Navigation (Tab Bar) — Figma "Tab Bar"
//
// 구조: Background(mask gradient) + Liquid Glass Container
//       + 5 Vertical Stack 아이템 + Home Indicator
//
// Tokens:
//   Selected label   →  Primary/normal  →  AppColor.primaryNormal
//   Unselected label →  Label/neutral   →  AppColor.labelNeutral
//   Container bg     →  Component/fill/normal → AppColor.componentFillNormal
//   Selected bg tint →  Static/Black opacity 5%
//   Caption 2/Medium (11 Medium) → AppTextStyles.caption2Medium
//   Icon size: 24px, Item size: 64×56, Container: rounded 99, padding 4
// ─────────────────────────────────────────────────────────────

/// 탭 바 아이템 모델.
class BottomNavItem {
  /// 비선택 아이콘
  final IconData icon;

  /// 선택 아이콘 (filled)
  final IconData activeIcon;

  /// 라벨
  final String label;

  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// 커플래닛 Bottom Navigation (Tab Bar).
///
/// ```dart
/// AppBottomNavigation(
///   currentIndex: 0,
///   onTap: (i) => setState(() => _index = i),
///   items: [
///     BottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: '홈'),
///     BottomNavItem(icon: Icons.coffee_outlined, activeIcon: Icons.coffee, label: '원두'),
///     BottomNavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: '커뮤니티'),
///     BottomNavItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: '쇼핑'),
///     BottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: '마이'),
///   ],
/// )
/// ```
class AppBottomNavigation extends StatelessWidget {
  /// 현재 선택 인덱스.
  final int currentIndex;

  /// 탭 콜백.
  final ValueChanged<int>? onTap;

  /// 탭 아이템 목록 (3~5개 권장).
  final List<BottomNavItem> items;

  /// Safe Area 하단 여백 자동 적용 여부.
  final bool useSafeArea;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    this.onTap,
    this.useSafeArea = true,
  });

  // ─── 상수 (Figma 기준) ───
  static const double _containerHeight = 64.0;
  static const double _containerPadding = 4.0;
  static const double _containerRadius = 99.0;
  static const double _itemWidth = 64.0;
  static const double _itemHeight = 56.0;
  static const double _iconSize = 24.0;
  static const double _iconLabelGap = 3.0;
  static const double _selectedBgOpacity = 0.05;
  static const double _horizontalPadding = 16.0;
  static const double _bottomPadding = 32.0; // Home Indicator 영역 포함

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        useSafeArea ? MediaQuery.of(context).padding.bottom : 0.0;

    return Container(
      padding: EdgeInsets.only(
        left: _horizontalPadding,
        right: _horizontalPadding,
        bottom: bottomPadding > 0 ? bottomPadding : _bottomPadding,
      ),
      child: Container(
        height: _containerHeight,
        decoration: BoxDecoration(
          color: AppColor.componentFillNormal,
          borderRadius: BorderRadius.circular(_containerRadius),
        ),
        padding: const EdgeInsets.all(_containerPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (index) {
            return _buildItem(index);
          }),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = items[index];
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap?.call(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _itemWidth,
        height: _itemHeight,
        child: Stack(
          children: [
            // 선택 배경 틴트
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: _selectedBgOpacity),
                    borderRadius: BorderRadius.circular(_containerRadius),
                  ),
                ),
              ),

            // 아이콘 + 라벨
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space8,
                  vertical: AppSpacing.space4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: _iconLabelGap,
                  children: [
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      size: _iconSize,
                      color: isSelected
                          ? AppColor.primaryNormal
                          : AppColor.labelNeutral,
                    ),
                    Text(
                      item.label,
                      style: AppTextStyles.caption2Medium.copyWith(
                        color: isSelected
                            ? AppColor.primaryNormal
                            : AppColor.labelNeutral,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
