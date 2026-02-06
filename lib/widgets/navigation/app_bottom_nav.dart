import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// 하단 네비게이션 아이템 데이터
class BottomNavItem {
  /// 아이콘
  final IconData icon;

  /// 선택된 상태 아이콘 (null이면 icon 사용)
  final IconData? activeIcon;

  /// 라벨
  final String label;

  /// 뱃지 카운트 (0이면 표시 안함)
  final int badgeCount;

  /// 뱃지 표시 여부 (카운트 없이 점만 표시)
  final bool showBadge;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeCount = 0,
    this.showBadge = false,
  });
}

/// 하단 네비게이션 바
///
/// Figma: 🧭 Navigation 페이지
///
/// Usage:
/// ```dart
/// AppBottomNav(
///   currentIndex: _selectedIndex,
///   onTap: (index) => setState(() => _selectedIndex = index),
///   items: [
///     BottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: '홈'),
///     BottomNavItem(icon: Icons.coffee_outlined, activeIcon: Icons.coffee, label: '커피'),
///     BottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: '마이'),
///   ],
/// )
/// ```
class AppBottomNav extends StatelessWidget {
  /// 현재 선택된 인덱스
  final int currentIndex;

  /// 탭 선택 콜백
  final ValueChanged<int> onTap;

  /// 네비게이션 아이템 목록
  final List<BottomNavItem> items;

  /// 배경색
  final Color? backgroundColor;

  /// 선택된 아이템 색상
  final Color? activeColor;

  /// 비선택 아이템 색상
  final Color? inactiveColor;

  /// 라벨 표시 여부
  final bool showLabels;

  /// 그림자 표시 여부
  final bool showShadow;

  /// 높이
  final double height;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.showLabels = true,
    this.showShadow = true,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: height + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.backgroundElevatedNormal,
        boxShadow: showShadow ? AppShadows.shadowBlackHeavyBottom : null,
        border: Border(
          top: BorderSide(color: AppColor.lineNormalAlternative, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          return _buildNavItem(index, items[index]);
        }),
      ),
    );
  }

  Widget _buildNavItem(int index, BottomNavItem item) {
    final isActive = currentIndex == index;
    final effectiveActiveColor = activeColor ?? AppColor.primaryNormal;
    final effectiveInactiveColor = inactiveColor ?? AppColor.labelAssistive;
    final color = isActive ? effectiveActiveColor : effectiveInactiveColor;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(item, isActive, color),
                if (showLabels) ...[
                  SizedBox(height: AppSpacing.space4),
                  Text(
                    item.label,
                    style: AppTextStyles.caption2Medium.copyWith(color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BottomNavItem item, bool isActive, Color color) {
    final icon = isActive ? (item.activeIcon ?? item.icon) : item.icon;

    Widget iconWidget = Icon(icon, color: color, size: 24);

    // 뱃지 표시
    if (item.badgeCount > 0 || item.showBadge) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -6,
            top: -4,
            child: item.badgeCount > 0
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space4,
                      vertical: AppSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.statusNegative,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16),
                    child: Text(
                      item.badgeCount > 99 ? '99+' : '${item.badgeCount}',
                      style: AppTextStyles.caption2Bold.copyWith(
                        color: AppColor.staticLabelWhiteStrong,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColor.statusNegative,
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        ],
      );
    }

    return iconWidget;
  }
}

/// 플로팅 하단 네비게이션 바
///
/// Usage:
/// ```dart
/// AppFloatingBottomNav(
///   currentIndex: _selectedIndex,
///   onTap: (index) => setState(() => _selectedIndex = index),
///   items: [...],
/// )
/// ```
class AppFloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double height;
  final double margin;
  final double borderRadius;

  const AppFloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.height = 64,
    this.margin = 16,
    this.borderRadius = 32,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: margin,
        right: margin,
        bottom: margin + bottomPadding,
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColor.backgroundElevatedNormal,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: AppShadows.shadowBlackFloating,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            return _buildNavItem(index, items[index]);
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, BottomNavItem item) {
    final isActive = currentIndex == index;
    final effectiveActiveColor = activeColor ?? AppColor.primaryNormal;
    final effectiveInactiveColor = inactiveColor ?? AppColor.labelAssistive;
    final color = isActive ? effectiveActiveColor : effectiveInactiveColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space16,
            vertical: AppSpacing.space12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? (item.activeIcon ?? item.icon) : item.icon,
                color: color,
                size: 24,
              ),
              SizedBox(height: AppSpacing.space4),
              Text(
                item.label,
                style: AppTextStyles.caption2Medium.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
