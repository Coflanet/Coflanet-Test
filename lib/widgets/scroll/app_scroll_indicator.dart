import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 커스텀 스크롤바 위젯
///
/// Figma: 🖱️ Scroll 페이지
///
/// 디자인 시스템 색상이 적용된 스크롤바
///
/// Usage:
/// ```dart
/// AppScrollbar(
///   child: ListView.builder(...),
/// )
///
/// // 항상 표시
/// AppScrollbar(
///   thumbVisibility: true,
///   child: ListView(...),
/// )
/// ```
class AppScrollbar extends StatelessWidget {
  /// 스크롤 가능한 자식 위젯
  final Widget child;

  /// 스크롤바 컨트롤러
  final ScrollController? controller;

  /// 스크롤바 항상 표시 여부
  final bool thumbVisibility;

  /// 트랙 표시 여부
  final bool trackVisibility;

  /// 스크롤바 두께
  final double? thickness;

  /// 스크롤바 반경
  final Radius? radius;

  /// 인터랙티브 여부 (드래그 가능)
  final bool interactive;

  /// 스크롤바 색상
  final Color? thumbColor;

  /// 트랙 색상
  final Color? trackColor;

  const AppScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility = false,
    this.trackVisibility = false,
    this.thickness,
    this.radius,
    this.interactive = true,
    this.thumbColor,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      thickness: thickness ?? 6,
      radius: radius ?? Radius.circular(AppRadius.full),
      interactive: interactive,
      thumbColor: thumbColor ?? AppColor.componentFillScroll,
      trackColor: trackColor ?? AppColor.componentFillNormal,
      child: child,
    );
  }
}

/// 스크롤 진행률 인디케이터
///
/// 스크롤 위치에 따른 진행률을 표시
///
/// Usage:
/// ```dart
/// Column(
///   children: [
///     AppScrollProgressIndicator(controller: _scrollController),
///     Expanded(
///       child: ListView.builder(
///         controller: _scrollController,
///         ...
///       ),
///     ),
///   ],
/// )
/// ```
class AppScrollProgressIndicator extends StatefulWidget {
  /// 스크롤 컨트롤러
  final ScrollController controller;

  /// 높이
  final double height;

  /// 색상
  final Color? color;

  /// 배경색
  final Color? backgroundColor;

  const AppScrollProgressIndicator({
    super.key,
    required this.controller,
    this.height = 3,
    this.color,
    this.backgroundColor,
  });

  @override
  State<AppScrollProgressIndicator> createState() =>
      _AppScrollProgressIndicatorState();
}

class _AppScrollProgressIndicatorState
    extends State<AppScrollProgressIndicator> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateProgress);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateProgress);
    super.dispose();
  }

  void _updateProgress() {
    if (!widget.controller.hasClients) return;

    final maxScroll = widget.controller.position.maxScrollExtent;
    final currentScroll = widget.controller.offset;

    if (maxScroll <= 0) {
      setState(() => _progress = 0);
      return;
    }

    setState(() {
      _progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColor.componentFillNormal,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _progress,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color ?? AppColor.primaryNormal,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(widget.height / 2),
              bottomRight: Radius.circular(widget.height / 2),
            ),
          ),
        ),
      ),
    );
  }
}

/// 스크롤 가능 영역 표시 인디케이터
///
/// 더 스크롤 가능함을 표시하는 그라데이션 오버레이
///
/// Usage:
/// ```dart
/// AppScrollFadeOverlay(
///   controller: _scrollController,
///   child: ListView.builder(...),
/// )
/// ```
class AppScrollFadeOverlay extends StatefulWidget {
  /// 스크롤 가능한 자식 위젯
  final Widget child;

  /// 스크롤 컨트롤러
  final ScrollController? controller;

  /// 페이드 높이
  final double fadeHeight;

  /// 상단 페이드 표시 여부
  final bool showTop;

  /// 하단 페이드 표시 여부
  final bool showBottom;

  /// 페이드 색상 (보통 배경색과 동일)
  final Color? fadeColor;

  const AppScrollFadeOverlay({
    super.key,
    required this.child,
    this.controller,
    this.fadeHeight = 24,
    this.showTop = true,
    this.showBottom = true,
    this.fadeColor,
  });

  @override
  State<AppScrollFadeOverlay> createState() => _AppScrollFadeOverlayState();
}

class _AppScrollFadeOverlayState extends State<AppScrollFadeOverlay> {
  bool _showTopFade = false;
  bool _showBottomFade = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_updateFadeVisibility);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateFadeVisibility);
    super.dispose();
  }

  void _updateFadeVisibility() {
    if (widget.controller == null || !widget.controller!.hasClients) return;

    final position = widget.controller!.position;
    final atTop = position.pixels <= position.minScrollExtent;
    final atBottom = position.pixels >= position.maxScrollExtent;

    setState(() {
      _showTopFade = !atTop && widget.showTop;
      _showBottomFade = !atBottom && widget.showBottom;
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveFadeColor =
        widget.fadeColor ?? AppColor.backgroundNormalNormal;

    return Stack(
      children: [
        widget.child,
        // 상단 페이드
        if (_showTopFade)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: widget.fadeHeight,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      effectiveFadeColor,
                      effectiveFadeColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        // 하단 페이드
        if (_showBottomFade)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: widget.fadeHeight,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      effectiveFadeColor,
                      effectiveFadeColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 맨 위로 스크롤 버튼
///
/// Usage:
/// ```dart
/// Scaffold(
///   body: ListView(...),
///   floatingActionButton: AppScrollToTopButton(
///     controller: _scrollController,
///   ),
/// )
/// ```
class AppScrollToTopButton extends StatefulWidget {
  /// 스크롤 컨트롤러
  final ScrollController controller;

  /// 버튼이 나타나는 스크롤 임계값
  final double showThreshold;

  /// 아이콘
  final IconData icon;

  /// 색상
  final Color? color;

  /// 배경색
  final Color? backgroundColor;

  const AppScrollToTopButton({
    super.key,
    required this.controller,
    this.showThreshold = 200,
    this.icon = Icons.keyboard_arrow_up_rounded,
    this.color,
    this.backgroundColor,
  });

  @override
  State<AppScrollToTopButton> createState() => _AppScrollToTopButtonState();
}

class _AppScrollToTopButtonState extends State<AppScrollToTopButton> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateVisibility);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateVisibility);
    super.dispose();
  }

  void _updateVisibility() {
    if (!widget.controller.hasClients) return;

    final shouldShow = widget.controller.offset > widget.showThreshold;
    if (shouldShow != _show) {
      setState(() => _show = shouldShow);
    }
  }

  void _scrollToTop() {
    widget.controller.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedScale(
        scale: _show ? 1.0 : 0.8,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton.small(
          onPressed: _show ? _scrollToTop : null,
          backgroundColor:
              widget.backgroundColor ?? AppColor.backgroundElevatedNormal,
          foregroundColor: widget.color ?? AppColor.labelNormal,
          elevation: 4,
          child: Icon(widget.icon),
        ),
      ),
    );
  }
}
