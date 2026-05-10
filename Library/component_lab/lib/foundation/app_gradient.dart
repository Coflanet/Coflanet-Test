import 'package:flutter/material.dart';

/// Gradient 토큰 — Figma 🌈 Gradient 페이지 기준.
///
/// 3가지 카테고리:
/// - **Solid**: 단일 방향 검정→투명 그라데이션 (배경 경계를 자연스럽게 표현)
/// - **Multiple**: Solid 그라데이션 2개를 조합해 사용 (두 가지 방향을 동시에 적용)
/// - **Mask**: 요소에 마스크를 씌워 경계를 매끄럽게 표현
///
/// 모든 그라데이션은 16-stop easing curve를 사용합니다.
class AppGradient {
  AppGradient._();

  // ═══════════════════════════════════════════════════════════════
  // EASING STOPS — 16단계 자연스러운 페이드
  // ═══════════════════════════════════════════════════════════════
  // Figma에서 정의된 opacity easing curve:
  // position: [0, 0.047, 0.089, 0.128, 0.166, 0.204, 0.244, 0.288,
  //            0.338, 0.396, 0.463, 0.541, 0.632, 0.738, 0.860, 1.0]
  // opacity:  [1.0, 0.98, 0.96, 0.93, 0.90, 0.86, 0.82, 0.77,
  //            0.71, 0.65, 0.57, 0.48, 0.38, 0.27, 0.14, 0.0]

  static const List<double> _stops = [
    0.000, 0.047, 0.089, 0.128, 0.166, 0.204, 0.244, 0.288,
    0.338, 0.396, 0.463, 0.541, 0.632, 0.738, 0.860, 1.000,
  ];

  static const List<double> _opacities = [
    1.00, 0.98, 0.96, 0.93, 0.90, 0.86, 0.82, 0.77,
    0.71, 0.65, 0.57, 0.48, 0.38, 0.27, 0.14, 0.00,
  ];

  /// 기본 색상(검정)의 easing 컬러 리스트를 생성합니다.
  static List<Color> _blackEasingColors() =>
      _opacities.map((o) => Color.fromRGBO(0, 0, 0, o)).toList();

  /// 커스텀 색상의 easing 컬러 리스트를 생성합니다.
  static List<Color> _easingColors(Color baseColor) =>
      _opacities
          .map((o) => baseColor.withValues(alpha: o))
          .toList();

  // ═══════════════════════════════════════════════════════════════
  // SOLID — 단일 방향 그라데이션
  // 배경 경계를 자연스럽게 표현합니다.
  // ═══════════════════════════════════════════════════════════════

  /// Solid Bottom — 위에서 아래로 (검정→투명)
  static LinearGradient solidBottom({Color? color}) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: color != null ? _easingColors(color) : _blackEasingColors(),
        stops: _stops,
      );

  /// Solid Top — 아래에서 위로 (검정→투명)
  static LinearGradient solidTop({Color? color}) => LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: color != null ? _easingColors(color) : _blackEasingColors(),
        stops: _stops,
      );

  /// Solid Left — 오른쪽에서 왼쪽으로 (검정→투명)
  static LinearGradient solidLeft({Color? color}) => LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: color != null ? _easingColors(color) : _blackEasingColors(),
        stops: _stops,
      );

  /// Solid Right — 왼쪽에서 오른쪽으로 (검정→투명)
  static LinearGradient solidRight({Color? color}) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: color != null ? _easingColors(color) : _blackEasingColors(),
        stops: _stops,
      );

  // ═══════════════════════════════════════════════════════════════
  // MULTIPLE — 두 방향 조합용 그라데이션
  // 두 가지 색을 그라디언트로 표현합니다.
  // 사용 시 Stack에 두 개의 Solid를 겹쳐 적용합니다.
  // ═══════════════════════════════════════════════════════════════

  /// Multiple Top+Bottom 조합을 위한 위젯 데코레이션 리스트.
  /// Stack으로 두 레이어를 겹쳐 사용합니다.
  static List<LinearGradient> multipleTopBottom({Color? color}) => [
        solidTop(color: color),
        solidBottom(color: color),
      ];

  /// Multiple Left+Right 조합
  static List<LinearGradient> multipleLeftRight({Color? color}) => [
        solidLeft(color: color),
        solidRight(color: color),
      ];

  // ═══════════════════════════════════════════════════════════════
  // MASK — 요소 경계 마스크
  // 요소에 마스크를 씌워 경계를 매끄럽게 표현합니다.
  // ShaderMask 위젯과 함께 사용합니다.
  // ═══════════════════════════════════════════════════════════════

  /// Mask용 흰색→투명 그라데이션 (ShaderMask에 사용)
  /// [direction]으로 마스크 방향을 지정합니다.
  static LinearGradient mask({
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
  }) =>
      LinearGradient(
        begin: begin,
        end: end,
        colors: _opacities
            .map((o) => Color.fromRGBO(255, 255, 255, o))
            .toList(),
        stops: _stops,
      );

  /// Mask Bottom — 아래쪽 경계를 페이드아웃
  static LinearGradient maskBottom() => mask(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  /// Mask Top — 위쪽 경계를 페이드아웃
  static LinearGradient maskTop() => mask(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  /// Mask Left — 왼쪽 경계를 페이드아웃
  static LinearGradient maskLeft() => mask(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      );

  /// Mask Right — 오른쪽 경계를 페이드아웃
  static LinearGradient maskRight() => mask(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  // ═══════════════════════════════════════════════════════════════
  // HELPER — 편의 위젯 빌더
  // ═══════════════════════════════════════════════════════════════

  /// [gradient]를 적용한 BoxDecoration을 반환합니다.
  static BoxDecoration decoration(LinearGradient gradient) =>
      BoxDecoration(gradient: gradient);

  /// ShaderMask에 사용할 수 있는 래퍼.
  /// ```dart
  /// AppGradient.shaderMask(
  ///   gradient: AppGradient.maskBottom(),
  ///   child: ListView(...),
  /// )
  /// ```
  static ShaderMask shaderMask({
    required LinearGradient gradient,
    required Widget child,
    BlendMode blendMode = BlendMode.dstIn,
  }) =>
      ShaderMask(
        shaderCallback: (bounds) => gradient.createShader(bounds),
        blendMode: blendMode,
        child: child,
      );
}
