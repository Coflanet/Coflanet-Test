import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 선호도 게이지
///
/// Figma: 🌡️ Gauge 페이지
///
/// 맛 선호도 등을 표시하는 그라데이션 게이지
///
/// Usage:
/// ```dart
/// // 기본 사용 (1-5 스케일)
/// AppPreferenceGauge(
///   value: 3,
///   onChanged: (value) => print('Selected: $value'),
/// )
///
/// // 커스텀 라벨
/// AppPreferenceGauge(
///   value: 4,
///   minLabel: '약함',
///   maxLabel: '강함',
///   onChanged: (value) {},
/// )
///
/// // 읽기 전용
/// AppPreferenceGauge(
///   value: 2,
///   readOnly: true,
/// )
/// ```
class AppPreferenceGauge extends StatefulWidget {
  /// 현재 값 (1-5, 또는 커스텀 범위)
  final int value;

  /// 최소값 (기본: 1)
  final int minValue;

  /// 최대값 (기본: 5)
  final int maxValue;

  /// 값 변경 콜백
  final ValueChanged<int>? onChanged;

  /// 최소값 라벨
  final String minLabel;

  /// 최대값 라벨
  final String maxLabel;

  /// 중간값 라벨 (null이면 표시 안함)
  final String? midLabel;

  /// 읽기 전용 여부
  final bool readOnly;

  /// 게이지 높이
  final double height;

  /// 라벨 표시 여부
  final bool showLabels;

  /// 이모지 표시 여부
  final bool showEmoji;

  const AppPreferenceGauge({
    super.key,
    required this.value,
    this.minValue = 1,
    this.maxValue = 5,
    this.onChanged,
    this.minLabel = '싫어해요',
    this.maxLabel = '좋아해요',
    this.midLabel = '그냥 그래요',
    this.readOnly = false,
    this.height = 12,
    this.showLabels = true,
    this.showEmoji = true,
  });

  @override
  State<AppPreferenceGauge> createState() => _AppPreferenceGaugeState();
}

class _AppPreferenceGaugeState extends State<AppPreferenceGauge> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(AppPreferenceGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _currentValue = widget.value;
    }
  }

  String get _emoji {
    final range = widget.maxValue - widget.minValue;
    final normalizedValue =
        (_currentValue - widget.minValue) / range; // 0.0 ~ 1.0

    if (normalizedValue <= 0.2) return '😣';
    if (normalizedValue <= 0.4) return '😕';
    if (normalizedValue <= 0.6) return '😐';
    if (normalizedValue <= 0.8) return '🙂';
    return '😍';
  }

  double get _progress {
    return (_currentValue - widget.minValue) /
        (widget.maxValue - widget.minValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showEmoji) ...[
          Text(_emoji, style: TextStyle(fontSize: 32)),
          SizedBox(height: AppSpacing.space8),
        ],
        GestureDetector(
          onHorizontalDragUpdate: widget.readOnly ? null : _handleDrag,
          onTapDown: widget.readOnly ? null : _handleTap,
          child: _buildGauge(),
        ),
        if (widget.showLabels) ...[
          SizedBox(height: AppSpacing.space8),
          _buildLabels(),
        ],
      ],
    );
  }

  void _handleDrag(DragUpdateDetails details) {
    _updateValueFromPosition(details.localPosition.dx);
  }

  void _handleTap(TapDownDetails details) {
    _updateValueFromPosition(details.localPosition.dx);
  }

  void _updateValueFromPosition(double x) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final width = box.size.width;
    final percent = (x / width).clamp(0.0, 1.0);
    final range = widget.maxValue - widget.minValue;
    final newValue = (percent * range + widget.minValue).round();

    if (newValue != _currentValue) {
      setState(() => _currentValue = newValue);
      widget.onChanged?.call(newValue);
    }
  }

  Widget _buildGauge() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: AppRadius.fullBorder,
        gradient: LinearGradient(
          colors: [
            AppColor.statusNegative,
            AppColor.colorGlobalOrange50,
            AppColor.colorGlobalYellow50,
            AppColor.colorGlobalLime50,
            AppColor.statusPositive,
          ],
        ),
      ),
      child: Stack(
        children: [
          // 핸들 위치
          AnimatedPositioned(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            left: _calculateHandlePosition(),
            top: 0,
            bottom: 0,
            child: _buildHandle(),
          ),
        ],
      ),
    );
  }

  double _calculateHandlePosition() {
    // 핸들 위치 계산 (핸들 크기의 절반만큼 빼줌)
    final handleSize = widget.height + 8;
    return (_progress * (MediaQuery.of(context).size.width - 32 - handleSize))
        .clamp(0.0, double.infinity);
  }

  Widget _buildHandle() {
    final handleSize = widget.height + 8;
    return Container(
      width: handleSize,
      height: handleSize,
      decoration: BoxDecoration(
        color: AppColor.staticLabelWhiteStrong,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryNormal, width: 3),
        boxShadow: AppShadows.shadowBlackEmphasize,
      ),
    );
  }

  Widget _buildLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.minLabel,
          style: AppTextStyles.caption1Regular.copyWith(
            color: AppColor.labelAssistive,
          ),
        ),
        if (widget.midLabel != null)
          Text(
            widget.midLabel!,
            style: AppTextStyles.caption1Regular.copyWith(
              color: AppColor.labelAssistive,
            ),
          ),
        Text(
          widget.maxLabel,
          style: AppTextStyles.caption1Regular.copyWith(
            color: AppColor.labelAssistive,
          ),
        ),
      ],
    );
  }
}

/// 세그먼트형 선호도 게이지
///
/// 터치 가능한 세그먼트로 구성된 게이지
///
/// Usage:
/// ```dart
/// AppSegmentedGauge(
///   value: 3,
///   segments: 5,
///   onChanged: (value) => print('Selected: $value'),
/// )
/// ```
class AppSegmentedGauge extends StatelessWidget {
  /// 현재 선택된 값 (1부터 시작)
  final int value;

  /// 세그먼트 수
  final int segments;

  /// 값 변경 콜백
  final ValueChanged<int>? onChanged;

  /// 활성 색상
  final Color? activeColor;

  /// 비활성 색상
  final Color? inactiveColor;

  /// 세그먼트 높이
  final double height;

  /// 세그먼트 간격
  final double gap;

  /// 읽기 전용 여부
  final bool readOnly;

  const AppSegmentedGauge({
    super.key,
    required this.value,
    this.segments = 5,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.height = 8,
    this.gap = 4,
    this.readOnly = false,
  });

  Color _getSegmentColor(int index) {
    final segmentValue = index + 1;
    if (segmentValue > value) {
      return inactiveColor ?? AppColor.componentFillNormal;
    }

    // 그라데이션 효과
    final progress = segmentValue / segments;
    if (progress <= 0.2) {
      return AppColor.statusNegative;
    } else if (progress <= 0.4) {
      return AppColor.colorGlobalOrange50;
    } else if (progress <= 0.6) {
      return AppColor.colorGlobalYellow50;
    } else if (progress <= 0.8) {
      return AppColor.colorGlobalLime50;
    } else {
      return AppColor.statusPositive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(segments, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: readOnly ? null : () => onChanged?.call(index + 1),
            child: Container(
              margin: EdgeInsets.only(right: index < segments - 1 ? gap : 0),
              height: height,
              decoration: BoxDecoration(
                color: _getSegmentColor(index),
                borderRadius: AppRadius.fullBorder,
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// 레이팅 게이지 (별점 스타일)
///
/// Usage:
/// ```dart
/// AppRatingGauge(
///   value: 4,
///   maxValue: 5,
///   onChanged: (value) => print('Rating: $value'),
/// )
/// ```
class AppRatingGauge extends StatelessWidget {
  /// 현재 값
  final int value;

  /// 최대값 (기본: 5)
  final int maxValue;

  /// 값 변경 콜백
  final ValueChanged<int>? onChanged;

  /// 아이콘 크기
  final double iconSize;

  /// 활성 색상
  final Color? activeColor;

  /// 비활성 색상
  final Color? inactiveColor;

  /// 읽기 전용
  final bool readOnly;

  /// 아이콘
  final IconData activeIcon;
  final IconData inactiveIcon;

  const AppRatingGauge({
    super.key,
    required this.value,
    this.maxValue = 5,
    this.onChanged,
    this.iconSize = 32,
    this.activeColor,
    this.inactiveColor,
    this.readOnly = false,
    this.activeIcon = Icons.star_rounded,
    this.inactiveIcon = Icons.star_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxValue, (index) {
        final isActive = index < value;
        return GestureDetector(
          onTap: readOnly ? null : () => onChanged?.call(index + 1),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.space2),
            child: Icon(
              isActive ? activeIcon : inactiveIcon,
              size: iconSize,
              color: isActive
                  ? (activeColor ?? AppColor.colorGlobalYellow50)
                  : (inactiveColor ?? AppColor.componentFillNormal),
            ),
          ),
        );
      }),
    );
  }
}
