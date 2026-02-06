import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 상태 타입
enum StatusType {
  /// 성공/완료
  success,

  /// 경고
  warning,

  /// 에러/실패
  error,

  /// 정보
  info,

  /// 비활성/대기
  inactive,

  /// 진행 중
  pending,
}

/// 상태 인디케이터 사이즈
enum StatusIndicatorSize {
  /// 6px
  xs,

  /// 8px (default)
  sm,

  /// 10px
  md,

  /// 12px
  lg,
}

/// 상태 인디케이터 (점)
///
/// Figma: 💡 Indicators 페이지
///
/// 상태를 나타내는 색상 점
///
/// Usage:
/// ```dart
/// // 기본 사용
/// AppStatusIndicator(status: StatusType.success)
///
/// // 사이즈 지정
/// AppStatusIndicator(
///   status: StatusType.error,
///   size: StatusIndicatorSize.lg,
/// )
///
/// // 펄스 애니메이션 (진행 중)
/// AppStatusIndicator(
///   status: StatusType.pending,
///   pulse: true,
/// )
/// ```
class AppStatusIndicator extends StatefulWidget {
  /// 상태 타입
  final StatusType status;

  /// 사이즈
  final StatusIndicatorSize size;

  /// 펄스 애니메이션 여부
  final bool pulse;

  /// 커스텀 색상 (null이면 status에 따라 자동)
  final Color? color;

  const AppStatusIndicator({
    super.key,
    required this.status,
    this.size = StatusIndicatorSize.sm,
    this.pulse = false,
    this.color,
  });

  @override
  State<AppStatusIndicator> createState() => _AppStatusIndicatorState();
}

class _AppStatusIndicatorState extends State<AppStatusIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.pulse) {
      _setupAnimation();
    }
  }

  @override
  void didUpdateWidget(AppStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse != oldWidget.pulse) {
      if (widget.pulse) {
        _setupAnimation();
      } else {
        _disposeAnimation();
      }
    }
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 0.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );
  }

  void _disposeAnimation() {
    _animationController?.dispose();
    _animationController = null;
    _scaleAnimation = null;
    _opacityAnimation = null;
  }

  @override
  void dispose() {
    _disposeAnimation();
    super.dispose();
  }

  Color get _color {
    if (widget.color != null) return widget.color!;

    switch (widget.status) {
      case StatusType.success:
        return AppColor.statusPositive;
      case StatusType.warning:
        return AppColor.statusCautionary;
      case StatusType.error:
        return AppColor.statusNegative;
      case StatusType.info:
        return AppColor.statusPositiveBlue;
      case StatusType.inactive:
        return AppColor.interactionInactive;
      case StatusType.pending:
        return AppColor.primaryNormal;
    }
  }

  double get _size {
    switch (widget.size) {
      case StatusIndicatorSize.xs:
        return 6;
      case StatusIndicatorSize.sm:
        return 8;
      case StatusIndicatorSize.md:
        return 10;
      case StatusIndicatorSize.lg:
        return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget dot = Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
    );

    if (widget.pulse && _animationController != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          // 펄스 효과
          AnimatedBuilder(
            animation: _animationController!,
            builder: (context, child) {
              return Container(
                width: _size * _scaleAnimation!.value,
                height: _size * _scaleAnimation!.value,
                decoration: BoxDecoration(
                  color: _color.withOpacity(_opacityAnimation!.value),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
          // 메인 점
          dot,
        ],
      );
    }

    return dot;
  }
}

/// 라벨이 있는 상태 인디케이터
///
/// Usage:
/// ```dart
/// AppStatusBadge(
///   status: StatusType.success,
///   label: '완료',
/// )
/// ```
class AppStatusBadge extends StatelessWidget {
  /// 상태 타입
  final StatusType status;

  /// 라벨 텍스트
  final String label;

  /// 커스텀 색상
  final Color? color;

  /// 아이콘 표시 여부
  final bool showIcon;

  const AppStatusBadge({
    super.key,
    required this.status,
    required this.label,
    this.color,
    this.showIcon = true,
  });

  Color get _color {
    if (color != null) return color!;

    switch (status) {
      case StatusType.success:
        return AppColor.statusPositive;
      case StatusType.warning:
        return AppColor.statusCautionary;
      case StatusType.error:
        return AppColor.statusNegative;
      case StatusType.info:
        return AppColor.statusPositiveBlue;
      case StatusType.inactive:
        return AppColor.interactionInactive;
      case StatusType.pending:
        return AppColor.primaryNormal;
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case StatusType.success:
        return AppColor.colorGlobalGreen95;
      case StatusType.warning:
        return AppColor.colorGlobalOrange95;
      case StatusType.error:
        return AppColor.colorGlobalRed95;
      case StatusType.info:
        return AppColor.colorGlobalBlue95;
      case StatusType.inactive:
        return AppColor.componentFillNormal;
      case StatusType.pending:
        return AppColor.primaryLight;
    }
  }

  IconData get _icon {
    switch (status) {
      case StatusType.success:
        return Icons.check_circle_rounded;
      case StatusType.warning:
        return Icons.warning_rounded;
      case StatusType.error:
        return Icons.error_rounded;
      case StatusType.info:
        return Icons.info_rounded;
      case StatusType.inactive:
        return Icons.remove_circle_rounded;
      case StatusType.pending:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space10,
        vertical: AppSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppRadius.fullBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(_icon, size: 14, color: _color),
            SizedBox(width: AppSpacing.space4),
          ],
          Text(
            label,
            style: AppTextStyles.caption1Medium.copyWith(color: _color),
          ),
        ],
      ),
    );
  }
}

/// 온라인/오프라인 상태 인디케이터
///
/// Usage:
/// ```dart
/// AppOnlineIndicator(isOnline: true)
/// ```
class AppOnlineIndicator extends StatelessWidget {
  /// 온라인 여부
  final bool isOnline;

  /// 사이즈
  final StatusIndicatorSize size;

  /// 펄스 애니메이션 (온라인일 때)
  final bool pulseWhenOnline;

  const AppOnlineIndicator({
    super.key,
    required this.isOnline,
    this.size = StatusIndicatorSize.sm,
    this.pulseWhenOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppStatusIndicator(
      status: isOnline ? StatusType.success : StatusType.inactive,
      size: size,
      pulse: isOnline && pulseWhenOnline,
    );
  }
}

/// 상태 텍스트 (점 + 라벨)
///
/// Usage:
/// ```dart
/// AppStatusText(
///   status: StatusType.warning,
///   text: '검토 중',
/// )
/// ```
class AppStatusText extends StatelessWidget {
  /// 상태 타입
  final StatusType status;

  /// 텍스트
  final String text;

  /// 텍스트 스타일
  final TextStyle? textStyle;

  /// 점과 텍스트 간격
  final double spacing;

  const AppStatusText({
    super.key,
    required this.status,
    required this.text,
    this.textStyle,
    this.spacing = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppStatusIndicator(status: status, size: StatusIndicatorSize.xs),
        SizedBox(width: spacing),
        Text(
          text,
          style:
              textStyle ??
              AppTextStyles.label2Regular.copyWith(color: AppColor.labelNormal),
        ),
      ],
    );
  }
}
