import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';

/// Figma `Scroll Bar` 사이즈.
///
/// - Normal: 전체 폭 13px, 바 폭 7px
/// - Small : 전체 폭 9px, 바 폭 3px
enum AppScrollBarSize { normal, small }

/// 정적 Scroll Bar — 스크롤 정도를 시각적으로 나타내는 인디케이터.
///
/// Figma `Scroll Bar` 컴포넌트 매핑:
///
/// Props (피그마 variant):
/// - `Size`    : Normal / Small
/// - `Percent` : 100% / 75% / 50% / 25% → [percent] (0~1)
/// - `Position`: Top / Center / Bottom   → [position] (0~1)
///
/// 피그마 boundVariables:
/// - Bar fill: `Component/fill/strong` (0x70737C) @ opacity 0.20
/// - Bar cornerRadius: 1000 (pill)
/// - Container height: 100 (within 106 total)
///
/// ```dart
/// AppScrollBar(
///   percent: 0.5,    // 절반 길이 thumb
///   position: 0.0,   // 상단 위치
///   size: AppScrollBarSize.normal,
/// )
/// ```
///
/// 동적 ScrollController 연동은 [AppScrollableScrollBar] 사용.
class AppScrollBar extends StatelessWidget {
  /// thumb 길이 비율 (0~1). 1.0이면 전체 트랙 길이.
  final double percent;

  /// thumb 위치 비율 (0=top, 1=bottom).
  final double position;

  final AppScrollBarSize size;

  /// 전체 높이 (피그마 기본값 106).
  final double height;

  const AppScrollBar({
    super.key,
    required this.percent,
    this.position = 0,
    this.size = AppScrollBarSize.normal,
    this.height = 106,
  });

  /// 전체 위젯 폭 — 피그마 Normal=13, Small=9.
  double get _outerWidth => size == AppScrollBarSize.small ? 9.0 : 13.0;

  /// 실제 바 폭 — 피그마 Normal=7, Small=3.
  double get _barWidth => size == AppScrollBarSize.small ? 3.0 : 7.0;

  /// 트랙 영역 높이 — 피그마에서 container height 100 (total 106, 패딩 3씩).
  double get _trackHeight => height - 6;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    // 피그마: Component/fill/strong @ 0.20 opacity
    final barColor = c.componentFillStrong;

    final p = percent.clamp(0.0, 1.0);
    final pos = position.clamp(0.0, 1.0);
    final track = _trackHeight;
    final thumbHeight = (track * p).clamp(_barWidth * 2, track);
    final maxOffset = track - thumbHeight;
    final topOffset = maxOffset * pos;

    return SizedBox(
      width: _outerWidth,
      height: height,
      child: Center(
        child: SizedBox(
          width: _barWidth,
          height: track,
          child: Stack(
            children: [
              Positioned(
                top: topOffset,
                left: 0,
                right: 0,
                child: Container(
                  height: thumbHeight,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 동적 Scroll Bar — ScrollController에 연동되는 인디케이터.
///
/// [child]에 스크롤 가능한 위젯을 두고, 우측에 자동으로 인디케이터 표시.
class AppScrollableScrollBar extends StatefulWidget {
  final ScrollController controller;
  final Widget child;
  final AppScrollBarSize size;

  /// 우측 패딩 — 컨텐츠와 인디케이터 간격
  final double indicatorRightPadding;

  const AppScrollableScrollBar({
    super.key,
    required this.controller,
    required this.child,
    this.size = AppScrollBarSize.normal,
    this.indicatorRightPadding = 4,
  });

  @override
  State<AppScrollableScrollBar> createState() =>
      _AppScrollableScrollBarState();
}

class _AppScrollableScrollBarState extends State<AppScrollableScrollBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = constraints.maxHeight;
        final hasMetrics = widget.controller.hasClients &&
            widget.controller.position.hasContentDimensions;
        final maxExtent =
            hasMetrics ? widget.controller.position.maxScrollExtent : 0.0;
        final totalContent = maxExtent + viewport;
        final percent =
            (totalContent <= 0) ? 1.0 : (viewport / totalContent);
        final position = (maxExtent <= 0)
            ? 0.0
            : (widget.controller.offset / maxExtent).clamp(0.0, 1.0);

        return Stack(
          children: [
            Positioned.fill(child: widget.child),
            Positioned(
              top: 0,
              bottom: 0,
              right: widget.indicatorRightPadding,
              child: Center(
                child: AppScrollBar(
                  percent: percent,
                  position: position,
                  size: widget.size,
                  height: viewport - 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
