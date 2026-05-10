import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_gradient.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Tab 사이즈 — Figma `Tab/Tab` Size variant.
enum AppTabBarSize {
  /// 56px height
  large(56),

  /// 48px height
  medium(48),

  /// 40px height
  small(40);

  const AppTabBarSize(this.height);
  final double height;
}

/// Tab 리사이즈 모드 — Figma Resize variant.
enum AppTabBarResize {
  /// 콘텐츠에 맞춤 (스크롤 가능)
  hug,

  /// 전체 너비를 균등 분할
  fill,
}

/// 디자인 시스템 Tab Bar — Figma `Tab/Tab` 컴포넌트.
///
/// 속성:
/// - Size: Large(56) / Medium(48) / Small(40)
/// - Resize: Hug (스크롤) / Fill (균등)
/// - Horizontal Padding: True / False
/// - Tab item gap: 24px
/// - Divider: `line/normal/alternative` token
/// - Active text: `Label/strong` token
/// - Inactive text: `Label/assistive` token
/// - Font: headline2Bold (fontSize 17, fontWeight 600)
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.size = AppTabBarSize.large,
    this.resize = AppTabBarResize.hug,
    this.horizontalPadding = false,
    this.trailingIcon,
    this.onTrailingPressed,
    this.showGradientMask = true,
  });

  /// 탭 라벨 목록
  final List<String> tabs;

  /// 현재 선택된 탭 인덱스
  final int selectedIndex;

  /// 탭 변경 콜백
  final ValueChanged<int> onTabChanged;

  /// 탭 크기
  final AppTabBarSize size;

  /// 리사이즈 모드
  final AppTabBarResize resize;

  /// 좌우 패딩 적용 여부
  final bool horizontalPadding;

  /// 우측 trailing 아이콘 (Figma: Icon Button)
  final IconData? trailingIcon;

  /// trailing 아이콘 콜백
  final VoidCallback? onTrailingPressed;

  /// Hug 모드에서 좌우 그라데이션 마스크 표시 여부
  final bool showGradientMask;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: resize == AppTabBarResize.hug
                      ? _buildScrollableTabs()
                      : _buildFixedTabs(),
                ),
                if (trailingIcon != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: IconButton(
                      icon: Icon(trailingIcon, size: 24),
                      onPressed: onTrailingPressed,
                      color: AppColor.colorGlobalCoolNeutral30,
                    ),
                  ),
              ],
            ),
          ),
          // Divider — Figma: stroke line/normal/alternative
          Container(
            height: 1,
            color: AppColor.colorGlobalCoolNeutral96,
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableTabs() {
    final tabsWidget = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: horizontalPadding
          ? EdgeInsets.symmetric(horizontal: AppSpacing.space16)
          : EdgeInsets.zero,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isLast = i == tabs.length - 1;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 24),
            child: _TabItem(
              label: tabs[i],
              isActive: i == selectedIndex,
              height: size.height - 1,
              onTap: () => onTabChanged(i),
            ),
          );
        }),
      ),
    );

    if (!showGradientMask) return tabsWidget;

    // Figma: Gradient/Mask on leading & trailing
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppGradient.mask(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ).createShader(Rect.fromLTWH(
              bounds.width - 48, 0, 48, bounds.height)),
      blendMode: BlendMode.dstIn,
      child: tabsWidget,
    );
  }

  Widget _buildFixedTabs() {
    return Row(
      children: List.generate(tabs.length, (i) {
        return Expanded(
          child: _TabItem(
            label: tabs[i],
            isActive: i == selectedIndex,
            height: size.height - 1,
            onTap: () => onTabChanged(i),
          ),
        );
      }),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isActive,
    required this.height,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              label,
              style: AppTextStyles.headline2Bold.copyWith(
                // Figma: Active → Label/strong, Inactive → Label/assistive
                color: isActive
                    ? AppColor.colorGlobalCoolNeutral10
                    : AppColor.colorGlobalCoolNeutral25,
              ),
            ),
            const Spacer(),
            // Indicator — 활성 탭 하단 바
            Container(
              height: 2,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColor.colorGlobalCoolNeutral10
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
