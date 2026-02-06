import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 점 인디케이터 스타일
enum DotIndicatorStyle {
  /// 기본 점
  dot,

  /// 확장되는 점 (활성 상태에서 길어짐)
  expanding,

  /// 스케일 점 (활성 상태에서 커짐)
  scaling,

  /// 연결된 점 (활성 상태까지 연결)
  connected,
}

/// 점 인디케이터
///
/// Figma: 💡 Indicators 페이지
///
/// 페이지 인디케이터, 온보딩 스텝 등에 사용
///
/// Usage:
/// ```dart
/// // 기본 사용
/// AppDotIndicator(
///   count: 5,
///   activeIndex: 2,
/// )
///
/// // 확장 스타일
/// AppDotIndicator(
///   count: 4,
///   activeIndex: 1,
///   style: DotIndicatorStyle.expanding,
/// )
///
/// // 탭 가능
/// AppDotIndicator(
///   count: 3,
///   activeIndex: _currentPage,
///   onTap: (index) => _pageController.animateToPage(index),
/// )
/// ```
class AppDotIndicator extends StatelessWidget {
  /// 총 점 개수
  final int count;

  /// 현재 활성 인덱스
  final int activeIndex;

  /// 스타일
  final DotIndicatorStyle style;

  /// 활성 색상
  final Color? activeColor;

  /// 비활성 색상
  final Color? inactiveColor;

  /// 점 크기
  final double dotSize;

  /// 점 간격
  final double spacing;

  /// 탭 콜백
  final ValueChanged<int>? onTap;

  /// 확장 시 너비 (expanding 스타일)
  final double expandedWidth;

  /// 스케일 배율 (scaling 스타일)
  final double scaleFactor;

  const AppDotIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    this.style = DotIndicatorStyle.dot,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 8,
    this.spacing = 8,
    this.onTap,
    this.expandedWidth = 24,
    this.scaleFactor = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case DotIndicatorStyle.dot:
        return _buildDotStyle();
      case DotIndicatorStyle.expanding:
        return _buildExpandingStyle();
      case DotIndicatorStyle.scaling:
        return _buildScalingStyle();
      case DotIndicatorStyle.connected:
        return _buildConnectedStyle();
    }
  }

  Widget _buildDotStyle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return GestureDetector(
          onTap: onTap != null ? () => onTap!(index) : null,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isActive
                  ? (activeColor ?? AppColor.primaryNormal)
                  : (inactiveColor ?? AppColor.componentFillNormal),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildExpandingStyle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return GestureDetector(
          onTap: onTap != null ? () => onTap!(index) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            width: isActive ? expandedWidth : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isActive
                  ? (activeColor ?? AppColor.primaryNormal)
                  : (inactiveColor ?? AppColor.componentFillNormal),
              borderRadius: AppRadius.fullBorder,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScalingStyle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        final size = isActive ? dotSize * scaleFactor : dotSize;
        return GestureDetector(
          onTap: onTap != null ? () => onTap!(index) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isActive
                  ? (activeColor ?? AppColor.primaryNormal)
                  : (inactiveColor ?? AppColor.componentFillNormal),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildConnectedStyle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count * 2 - 1, (index) {
        // 짝수 인덱스: 점
        if (index.isEven) {
          final dotIndex = index ~/ 2;
          final isActive = dotIndex <= activeIndex;
          return GestureDetector(
            onTap: onTap != null ? () => onTap!(dotIndex) : null,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: isActive
                    ? (activeColor ?? AppColor.primaryNormal)
                    : (inactiveColor ?? AppColor.componentFillNormal),
                shape: BoxShape.circle,
              ),
            ),
          );
        }
        // 홀수 인덱스: 연결선
        else {
          final prevDotIndex = index ~/ 2;
          final isActive = prevDotIndex < activeIndex;
          return Container(
            width: spacing,
            height: 2,
            color: isActive
                ? (activeColor ?? AppColor.primaryNormal)
                : (inactiveColor ?? AppColor.componentFillNormal),
          );
        }
      }),
    );
  }
}

/// 슬라이딩 점 인디케이터 (PageView와 함께 사용)
///
/// Usage:
/// ```dart
/// AppSlidingDotIndicator(
///   controller: _pageController,
///   count: 5,
/// )
/// ```
class AppSlidingDotIndicator extends StatefulWidget {
  /// PageController
  final PageController controller;

  /// 총 페이지 수
  final int count;

  /// 활성 색상
  final Color? activeColor;

  /// 비활성 색상
  final Color? inactiveColor;

  /// 점 크기
  final double dotSize;

  /// 점 간격
  final double spacing;

  const AppSlidingDotIndicator({
    super.key,
    required this.controller,
    required this.count,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 8,
    this.spacing = 8,
  });

  @override
  State<AppSlidingDotIndicator> createState() => _AppSlidingDotIndicatorState();
}

class _AppSlidingDotIndicatorState extends State<AppSlidingDotIndicator> {
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPageChanged);
    _currentPage = widget.controller.initialPage.toDouble();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      _currentPage = widget.controller.page ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = widget.activeColor ?? AppColor.primaryNormal;
    final effectiveInactiveColor =
        widget.inactiveColor ?? AppColor.componentFillNormal;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.count, (index) {
        // 현재 페이지와의 거리 계산
        final distance = (_currentPage - index).abs();
        final scale = (1 - distance * 0.3).clamp(0.5, 1.0);
        final opacity = (1 - distance * 0.5).clamp(0.3, 1.0);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          width: widget.dotSize * scale,
          height: widget.dotSize * scale,
          decoration: BoxDecoration(
            color: distance < 0.5
                ? effectiveActiveColor.withOpacity(opacity)
                : effectiveInactiveColor,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
