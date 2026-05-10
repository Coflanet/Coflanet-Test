import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';

// ─────────────────────────────────────────────────────────────
// GNB (Global Navigation Bar) — Figma "GNB"
//
// 구조: Logo(좌측) + Trailing Actions(우측)
// 크기: 360 × 44,  padding: 0 16 0 16
// 아이콘 행: spacing 10, 아이콘 40×40
// ─────────────────────────────────────────────────────────────

/// GNB 트레일링 액션.
class GnbAction {
  /// 아이콘
  final IconData icon;

  /// 탭 콜백
  final VoidCallback? onPressed;

  /// 푸시 뱃지 표시 여부
  final bool showBadge;

  const GnbAction({
    required this.icon,
    this.onPressed,
    this.showBadge = false,
  });
}

/// 커플래닛 GNB (Global Navigation Bar).
///
/// 주로 메인 화면 최상단에 배치되며, 좌측에 브랜드 로고,
/// 우측에 검색·알림·설정 등 액션 아이콘을 표시합니다.
///
/// ```dart
/// AppGnb(
///   logo: Image.asset('assets/logo.png', height: 28),
///   actions: [
///     GnbAction(icon: Icons.search, onPressed: () {}),
///     GnbAction(icon: Icons.notifications_none, showBadge: true),
///     GnbAction(icon: Icons.settings),
///   ],
/// )
/// ```
class AppGnb extends StatelessWidget {
  /// 로고 위젯 (65×38 기본).
  final Widget logo;

  /// 우측 액션 아이콘 목록 (최대 3개).
  final List<GnbAction> actions;

  /// 배경색.
  final Color? backgroundColor;

  const AppGnb({
    super.key,
    required this.logo,
    this.actions = const [],
    this.backgroundColor,
  });

  static const double _height = 44.0;
  static const double _horizontalPadding = 16.0;
  static const double _iconButtonSize = 40.0;
  static const double _iconSize = 20.0;
  static const double _actionSpacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      color: backgroundColor ?? Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Row(
        children: [
          // 로고 (좌측)
          logo,

          const Spacer(),

          // 트레일링 액션 (우측)
          if (actions.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: _actionSpacing,
              children: actions.map((action) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      width: _iconButtonSize,
                      height: _iconButtonSize,
                      child: IconButton(
                        onPressed: action.onPressed,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          action.icon,
                          size: _iconSize,
                          color: AppColor.labelNormal,
                        ),
                        style: IconButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                    if (action.showBadge)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColor.statusNegative,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.backgroundNormalNormal,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
