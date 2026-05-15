import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_color_theme.dart';
import '../../foundation/app_text_style.dart';

// ═══════════════════════════════════════════════════════════════
// Badge
// ═══════════════════════════════════════════════════════════════

/// Badge 스타일.
enum AppBadgeStyle {
  /// 점만 표시 (count 무관)
  dot,

  /// 숫자 표시 (count > 99면 "99+")
  count,
}

/// Notification Badge — 작은 알림 점·숫자.
class AppBadge extends StatelessWidget {
  /// 표시할 숫자. style이 dot이면 무시됨.
  final int? count;
  final AppBadgeStyle style;
  final Color? color;

  const AppBadge({
    super.key,
    this.count,
    this.style = AppBadgeStyle.count,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final fill = color ??
        (c.statusNegative);

    if (style == AppBadgeStyle.dot || count == null) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
      );
    }

    final display = count! > 99 ? '99+' : count!.toString();
    final isWide = display.length >= 2;

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: EdgeInsets.symmetric(horizontal: isWide ? 6 : 4),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: Text(
        display,
        style: AppTextStyles.caption2Bold.copyWith(
          color: AppColor.staticLabelWhiteStrong,
          height: 1.0,
        ),
      ),
    );
  }
}

/// 컨텐츠 위에 Badge를 배치하는 헬퍼.
///
/// ```dart
/// AppBadgedItem(
///   badge: AppBadge(count: 3),
///   child: Icon(Icons.notifications),
/// )
/// ```
class AppBadgedItem extends StatelessWidget {
  final Widget child;
  final Widget badge;

  /// Badge 위치 — 기본은 우상단.
  final Alignment alignment;
  final Offset offset;

  const AppBadgedItem({
    super.key,
    required this.child,
    required this.badge,
    this.alignment = Alignment.topRight,
    this.offset = const Offset(2, -2),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: alignment,
      children: [
        child,
        Positioned(
          right: alignment.x > 0 ? offset.dx : null,
          left: alignment.x < 0 ? offset.dx : null,
          top: alignment.y < 0 ? offset.dy : null,
          bottom: alignment.y > 0 ? offset.dy : null,
          child: badge,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Pagination Dots
// ═══════════════════════════════════════════════════════════════

/// Pagination Dot — 페이지 인디케이터의 개별 점.
class AppPaginationDot extends StatelessWidget {
  final bool isActive;
  final double size;

  const AppPaginationDot({
    super.key,
    this.isActive = false,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final activeColor =
        c.primaryNormal;
    final inactiveColor = c.componentFillStrong;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? size * 2 : size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}

/// Pagination Dots — 여러 페이지 인디케이터.
class AppPaginationDots extends StatelessWidget {
  final int count;
  final int activeIndex;
  final double dotSize;
  final double gap;

  const AppPaginationDots({
    super.key,
    required this.count,
    required this.activeIndex,
    this.dotSize = 8,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isLast = i == count - 1;
        return Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : gap),
          child: AppPaginationDot(
            isActive: i == activeIndex,
            size: dotSize,
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Home Indicator — Figma `Home Indicator`
// ═══════════════════════════════════════════════════════════════

/// Figma `Home Indicator` 디바이스 유형.
enum AppHomeIndicatorDevice { iPhone, iPad }

/// Figma `Home Indicator` 방향.
enum AppHomeIndicatorOrientation { portrait, landscape }

/// iOS 홈 인디케이터 바 — Figma `Home Indicator` 컴포넌트.
///
/// 피그마 variant:
/// - `Device`     : iPhone / iPad
/// - `Orientation`: Portrait / Landscape
///
/// 피그마 boundVariables:
/// - Bar fill: `Label/strong` (black/white)
/// - Bar size: 144×5, cornerRadius=100
/// - Height: iPhone Portrait=34, iPhone Landscape=21, iPad=20
class AppHomeIndicator extends StatelessWidget {
  final AppHomeIndicatorDevice device;
  final AppHomeIndicatorOrientation orientation;

  const AppHomeIndicator({
    super.key,
    this.device = AppHomeIndicatorDevice.iPhone,
    this.orientation = AppHomeIndicatorOrientation.portrait,
  });

  double get _height {
    if (device == AppHomeIndicatorDevice.iPad) return 20;
    return orientation == AppHomeIndicatorOrientation.portrait ? 34 : 21;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final barColor =
        c.labelStrong;

    return SizedBox(
      width: double.infinity,
      height: _height,
      child: Center(
        child: Container(
          width: 144,
          height: 5,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Grabber — Figma `Grabber`
// ═══════════════════════════════════════════════════════════════

/// 바텀시트/드로어 상단 그랩 핸들 — Figma `Grabber` 컴포넌트.
///
/// 피그마 boundVariables:
/// - Bar fill: `Component/fill/strong` (0x70737C @ 20%)
/// - Bar size: 40×5, cornerRadius=1000
/// - Total height: 12
class AppGrabber extends StatelessWidget {
  const AppGrabber({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final barColor = c.componentFillStrong;

    return SizedBox(
      width: double.infinity,
      height: 12,
      child: Center(
        child: Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(1000),
          ),
        ),
      ),
    );
  }
}
