import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import 'app_push_badge_dot.dart';

// ─────────────────────────────────────────────────────────────
// Top Navigation — Figma "Top Navigation/Resource/Contents"
//
// Variants: Normal · Extended · Floating
// Properties: title, leadingIcon, trailingActions, toolBar,
//             avatar, showNavBar, showTitle
// Tokens:  Label/strong  →  AppColor.labelStrong
//          Label/normal  →  AppColor.labelNormal
//          Headline 2/Bold (17 SemiBold)  →  AppTextStyles.headline2Bold
//          Title 3/Bold   (24 Bold)       →  AppTextStyles.title3Bold
// ─────────────────────────────────────────────────────────────

/// Top Navigation 레이아웃 변형.
enum TopNavigationVariant {
  /// 기본 — 중앙 제목 + 좌우 아이콘.  높이 56px.
  normal,

  /// 확장 — 큰 제목 왼쪽 정렬 + 뒤로가기 별도 행.
  extended,

  /// 플로팅 — 콘텐츠 위에 떠있는 투명 바.
  floating,
}

/// 트레일링 액션 버튼 모델.
class TopNavAction {
  /// 아이콘
  final IconData icon;

  /// 탭 콜백
  final VoidCallback? onPressed;

  /// 푸시 뱃지 표시 여부
  final bool showBadge;

  const TopNavAction({
    required this.icon,
    this.onPressed,
    this.showBadge = false,
  });
}

/// 커플래닛 Top Navigation.
///
/// ```dart
/// AppTopNavigation(
///   title: '제목',
///   variant: TopNavigationVariant.normal,
///   leadingIcon: Icons.arrow_back_ios_new,
///   onLeadingPressed: () => Navigator.pop(context),
///   trailingActions: [
///     TopNavAction(icon: Icons.search),
///     TopNavAction(icon: Icons.notifications_none, showBadge: true),
///   ],
/// )
/// ```
class AppTopNavigation extends StatelessWidget {
  /// 타이틀 텍스트.
  final String? title;

  /// 레이아웃 변형.
  final TopNavigationVariant variant;

  /// 좌측 아이콘 (null이면 숨김).
  final IconData? leadingIcon;

  /// 좌측 아이콘 탭 콜백.
  final VoidCallback? onLeadingPressed;

  /// 우측 액션 버튼 목록 (최대 3개).
  final List<TopNavAction> trailingActions;

  /// 제목 표시 여부 (Floating에서 스크롤 시 제목 노출 제어).
  final bool showTitle;

  /// 하단 Tool Bar 위젯 (Tab, Category, Segmented Control 등).
  final Widget? toolBar;

  /// 두 번째 Tool Bar 위젯.
  final Widget? toolBar2;

  /// 아바타 위젯 (Extended에서 우측 상단).
  final Widget? avatar;

  /// 배경색 (null이면 투명).
  final Color? backgroundColor;

  const AppTopNavigation({
    super.key,
    this.title,
    this.variant = TopNavigationVariant.normal,
    this.leadingIcon,
    this.onLeadingPressed,
    this.trailingActions = const [],
    this.showTitle = true,
    this.toolBar,
    this.toolBar2,
    this.avatar,
    this.backgroundColor,
  });

  // ─── 상수 ───
  static const double _navHeight = 56.0;
  static const double _iconButtonSize = 40.0;
  static const double _iconSize = 20.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;
  static const double _contentSpacing = 16.0;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case TopNavigationVariant.normal:
        return _buildNormal(context);
      case TopNavigationVariant.extended:
        return _buildExtended(context);
      case TopNavigationVariant.floating:
        return _buildFloating(context);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // NORMAL — 중앙 정렬 제목 + Leading/Trailing
  // ═══════════════════════════════════════════════════════════
  Widget _buildNormal(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Navigation Bar
        Container(
          height: _navHeight,
          color: backgroundColor ?? Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 중앙 제목
                    if (showTitle && title != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              leadingIcon != null ? _iconButtonSize + 4 : 4,
                        ),
                        child: Text(
                          title!,
                          style: AppTextStyles.headline2Bold.copyWith(
                            color: AppColor.labelStrong,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Leading 아이콘 (좌측 절대 배치)
                    if (leadingIcon != null)
                      Positioned(
                        left: 0,
                        child: _buildIconButton(
                          leadingIcon!,
                          onLeadingPressed,
                        ),
                      ),

                    // Trailing 아이콘 (우측 절대 배치)
                    if (trailingActions.isNotEmpty)
                      Positioned(
                        right: 0,
                        child: _buildTrailingRow(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tool Bar
        if (toolBar != null) toolBar!,

        // Tool Bar 2
        if (toolBar2 != null) toolBar2!,
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // EXTENDED — 큰 제목 + Leading 별도 행
  // ═══════════════════════════════════════════════════════════
  Widget _buildExtended(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: backgroundColor ?? Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leading row
                  if (leadingIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: _contentSpacing),
                      child: _buildIconButton(
                        leadingIcon!,
                        onLeadingPressed,
                      ),
                    ),

                  // 큰 제목
                  if (showTitle && title != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                      child: SizedBox(
                        height: _iconButtonSize,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title!,
                            style: AppTextStyles.title3Bold.copyWith(
                              color: AppColor.labelStrong,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Trailing (우측 상단 절대 배치)
              Positioned(
                right: 0,
                top: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: _contentSpacing,
                  children: [
                    if (trailingActions.isNotEmpty) _buildTrailingRow(),
                    if (avatar != null) avatar!,
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tool Bar
        if (toolBar != null) toolBar!,

        // Tool Bar 2
        if (toolBar2 != null) toolBar2!,
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FLOATING — 레이아웃 높이 0, 콘텐츠는 위로 떠서 렌더 (clipBehavior로 자르지 않음)
  //
  // SizedBox(height: 0) + OverflowBox 조합은 "이 위젯은 레이아웃 흐름상 0px이지만
  // 시각적으로는 nav 높이만큼 렌더되며 부모 영역 밖으로 오버플로해도 자르지 않는다"
  // 는 의도를 표현하는 Flutter 표준 패턴. 호출자가 Stack 등을 강제하지 않고도
  // 그대로 Column 안에 둘 수 있도록 만든 트릭이다.
  // ═══════════════════════════════════════════════════════════
  Widget _buildFloating(BuildContext context) {
    return SizedBox(
      height: 0,
      child: OverflowBox(
        alignment: Alignment.topCenter,
        maxHeight: _navHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          child: Stack(
            children: [
              // 중앙 제목 (선택적)
              if (showTitle && title != null)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          leadingIcon != null ? _iconButtonSize + 4 : 4,
                    ),
                    child: Text(
                      title!,
                      style: AppTextStyles.headline2Bold.copyWith(
                        color: AppColor.labelStrong,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

              // Leading
              if (leadingIcon != null)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _buildIconButton(
                      leadingIcon!,
                      onLeadingPressed,
                    ),
                  ),
                ),

              // Trailing
              if (trailingActions.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(child: _buildTrailingRow()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 공통 헬퍼 ───

  /// 아이콘 버튼 (40×40, 아이콘 20px).
  Widget _buildIconButton(IconData icon, VoidCallback? onPressed) {
    return SizedBox(
      width: _iconButtonSize,
      height: _iconButtonSize,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: _iconSize, color: AppColor.labelNormal),
        splashRadius: _iconButtonSize / 2,
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  /// 트레일링 액션 행.
  Widget _buildTrailingRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s10,
      children: trailingActions.map((action) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _buildIconButton(action.icon, action.onPressed),
            if (action.showBadge)
              const Positioned(
                right: 0,
                top: 0,
                child: AppPushBadgeDot(),
              ),
          ],
        );
      }).toList(),
    );
  }
}
