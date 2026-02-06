import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 구분선 두께
enum DividerThickness {
  /// 0.5px - 매우 얇은
  hairline,

  /// 1px - 기본
  thin,

  /// 2px - 중간
  medium,

  /// 4px - 두꺼운
  thick,

  /// 8px - 섹션 구분
  section,
}

/// 구분선
///
/// Figma: ➗ Divider 페이지
///
/// Usage:
/// ```dart
/// // 기본 구분선
/// AppDivider()
///
/// // 두꺼운 섹션 구분선
/// AppDivider(thickness: DividerThickness.section)
///
/// // 인덴트가 있는 구분선
/// AppDivider(indent: 16, endIndent: 16)
///
/// // 색상 지정
/// AppDivider(color: AppColor.lineSolidNormal)
///
/// // 세로 구분선
/// AppDivider.vertical(height: 24)
/// ```
class AppDivider extends StatelessWidget {
  /// 두께
  final DividerThickness thickness;

  /// 색상 (기본: lineNormalNormal)
  final Color? color;

  /// 시작 인덴트
  final double indent;

  /// 끝 인덴트
  final double endIndent;

  /// 수직 구분선 여부
  final bool isVertical;

  /// 수직 구분선의 높이
  final double? height;

  const AppDivider({
    super.key,
    this.thickness = DividerThickness.thin,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  }) : isVertical = false,
       height = null;

  /// 수직 구분선
  const AppDivider.vertical({
    super.key,
    this.thickness = DividerThickness.thin,
    this.color,
    this.height = 24,
  }) : isVertical = true,
       indent = 0,
       endIndent = 0;

  double get _thickness {
    switch (thickness) {
      case DividerThickness.hairline:
        return 0.5;
      case DividerThickness.thin:
        return 1;
      case DividerThickness.medium:
        return 2;
      case DividerThickness.thick:
        return 4;
      case DividerThickness.section:
        return 8;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColor.lineNormalNormal;

    if (isVertical) {
      return Container(
        width: _thickness,
        height: height,
        color: effectiveColor,
      );
    }

    return Divider(
      height: _thickness,
      thickness: _thickness,
      color: effectiveColor,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

/// 라벨이 있는 구분선
///
/// Usage:
/// ```dart
/// AppDividerWithLabel(label: '또는')
/// AppDividerWithLabel(
///   label: '소셜 로그인',
///   labelWidget: Icon(Icons.login),
/// )
/// ```
class AppDividerWithLabel extends StatelessWidget {
  /// 라벨 텍스트
  final String? label;

  /// 커스텀 라벨 위젯
  final Widget? labelWidget;

  /// 구분선 색상
  final Color? color;

  /// 라벨 텍스트 스타일
  final TextStyle? labelStyle;

  /// 라벨과 구분선 간격
  final double spacing;

  const AppDividerWithLabel({
    super.key,
    this.label,
    this.labelWidget,
    this.color,
    this.labelStyle,
    this.spacing = 16,
  }) : assert(label != null || labelWidget != null);

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColor.lineNormalNormal;
    final effectiveLabelStyle =
        labelStyle ??
        AppTextStyles.label2Regular.copyWith(color: AppColor.labelAssistive);

    return Row(
      children: [
        Expanded(child: Container(height: 1, color: effectiveColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: labelWidget ?? Text(label!, style: effectiveLabelStyle),
        ),
        Expanded(child: Container(height: 1, color: effectiveColor)),
      ],
    );
  }
}

/// 점선 구분선
///
/// Usage:
/// ```dart
/// AppDashedDivider()
/// AppDashedDivider(
///   dashWidth: 8,
///   dashSpace: 4,
///   color: AppColor.lineSolidNormal,
/// )
/// ```
class AppDashedDivider extends StatelessWidget {
  /// 점선 너비
  final double dashWidth;

  /// 점선 간격
  final double dashSpace;

  /// 두께
  final double thickness;

  /// 색상
  final Color? color;

  const AppDashedDivider({
    super.key,
    this.dashWidth = 6,
    this.dashSpace = 3,
    this.thickness = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColor.lineNormalNormal;

    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: thickness,
              color: effectiveColor,
            );
          }),
        );
      },
    );
  }
}

/// 섹션 구분 영역 (배경색이 다른 넓은 구분선)
///
/// Usage:
/// ```dart
/// AppSectionDivider()
/// AppSectionDivider(height: 16)
/// ```
class AppSectionDivider extends StatelessWidget {
  /// 높이 (기본: 8)
  final double height;

  /// 배경색
  final Color? color;

  const AppSectionDivider({super.key, this.height = 8, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color ?? AppColor.backgroundNormalAlternative,
    );
  }
}
