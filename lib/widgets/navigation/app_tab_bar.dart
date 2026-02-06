import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 탭 바 스타일
enum TabBarStyle {
  /// 언더라인 인디케이터
  underline,

  /// 배경 필 인디케이터
  filled,

  /// 필 스타일 (둥근 모서리)
  pill,

  /// 세그먼트 컨트롤 스타일
  segmented,
}

/// 탭 바
///
/// Figma: 📑 Tab 페이지
///
/// Usage:
/// ```dart
/// // 기본 언더라인 스타일
/// AppTabBar(
///   tabs: ['전체', '핸드드립', '에스프레소'],
///   currentIndex: _tabIndex,
///   onTap: (index) => setState(() => _tabIndex = index),
/// )
///
/// // 필 스타일
/// AppTabBar(
///   tabs: ['일간', '주간', '월간'],
///   currentIndex: _tabIndex,
///   onTap: (index) => setState(() => _tabIndex = index),
///   style: TabBarStyle.filled,
/// )
///
/// // 세그먼트 스타일
/// AppTabBar(
///   tabs: ['Light', 'Dark'],
///   currentIndex: _themeIndex,
///   onTap: (index) => _changeTheme(index),
///   style: TabBarStyle.segmented,
/// )
/// ```
class AppTabBar extends StatelessWidget {
  /// 탭 라벨 목록
  final List<String> tabs;

  /// 현재 선택된 인덱스
  final int currentIndex;

  /// 탭 선택 콜백
  final ValueChanged<int> onTap;

  /// 스타일
  final TabBarStyle style;

  /// 활성 색상
  final Color? activeColor;

  /// 비활성 색상
  final Color? inactiveColor;

  /// 배경색
  final Color? backgroundColor;

  /// 인디케이터 색상
  final Color? indicatorColor;

  /// 탭 간 패딩
  final EdgeInsets? padding;

  /// 스크롤 가능 여부
  final bool isScrollable;

  const AppTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.style = TabBarStyle.underline,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.indicatorColor,
    this.padding,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case TabBarStyle.underline:
        return _buildUnderlineStyle();
      case TabBarStyle.filled:
        return _buildFilledStyle();
      case TabBarStyle.pill:
        return _buildPillStyle();
      case TabBarStyle.segmented:
        return _buildSegmentedStyle();
    }
  }

  Widget _buildUnderlineStyle() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.lineNormalAlternative, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = index == currentIndex;
          return Expanded(
            child: _UnderlineTab(
              label: tabs[index],
              isActive: isActive,
              onTap: () => onTap(index),
              activeColor: activeColor ?? AppColor.primaryNormal,
              inactiveColor: inactiveColor ?? AppColor.labelAssistive,
              indicatorColor: indicatorColor ?? AppColor.primaryNormal,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFilledStyle() {
    return Container(
      padding: padding ?? EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.componentFillNormal,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = index == currentIndex;
          return Expanded(
            child: _FilledTab(
              label: tabs[index],
              isActive: isActive,
              onTap: () => onTap(index),
              activeColor: activeColor ?? AppColor.labelNormal,
              inactiveColor: inactiveColor ?? AppColor.labelAssistive,
              activeBackgroundColor:
                  indicatorColor ?? AppColor.backgroundElevatedNormal,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPillStyle() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: isScrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = index == currentIndex;
          return Padding(
            padding: EdgeInsets.only(
              right: index < tabs.length - 1 ? AppSpacing.space8 : 0,
            ),
            child: _PillTab(
              label: tabs[index],
              isActive: isActive,
              onTap: () => onTap(index),
              activeColor: activeColor ?? AppColor.staticLabelWhiteStrong,
              inactiveColor: inactiveColor ?? AppColor.labelNormal,
              activeBackgroundColor: indicatorColor ?? AppColor.primaryNormal,
              inactiveBackgroundColor:
                  backgroundColor ?? AppColor.componentFillNormal,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSegmentedStyle() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.componentFillNormal,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = index == currentIndex;
          return Expanded(
            child: _SegmentedTab(
              label: tabs[index],
              isActive: isActive,
              onTap: () => onTap(index),
              activeColor: activeColor ?? AppColor.labelNormal,
              inactiveColor: inactiveColor ?? AppColor.labelAssistive,
              activeBackgroundColor:
                  indicatorColor ?? AppColor.backgroundElevatedNormal,
            ),
          );
        }),
      ),
    );
  }
}

class _UnderlineTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color indicatorColor;

  const _UnderlineTab({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.space12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? indicatorColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.label1NormalBold.copyWith(
              color: isActive ? activeColor : inactiveColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _FilledTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBackgroundColor;

  const _FilledTab({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdBorder,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.space10,
            horizontal: AppSpacing.space12,
          ),
          decoration: BoxDecoration(
            color: isActive ? activeBackgroundColor : Colors.transparent,
            borderRadius: AppRadius.mdBorder,
            boxShadow: isActive ? AppShadows.shadowBlackNormal : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: isActive ? activeColor : inactiveColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _PillTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBackgroundColor;
  final Color inactiveBackgroundColor;

  const _PillTab({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeBackgroundColor,
    required this.inactiveBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.fullBorder,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.space8,
            horizontal: AppSpacing.space16,
          ),
          decoration: BoxDecoration(
            color: isActive ? activeBackgroundColor : inactiveBackgroundColor,
            borderRadius: AppRadius.fullBorder,
          ),
          child: Text(
            label,
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentedTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBackgroundColor;

  const _SegmentedTab({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdBorder,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.space8,
            horizontal: AppSpacing.space12,
          ),
          decoration: BoxDecoration(
            color: isActive ? activeBackgroundColor : Colors.transparent,
            borderRadius: AppRadius.mdBorder,
            boxShadow: isActive ? AppShadows.shadowBlackNormal : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: isActive ? activeColor : inactiveColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
