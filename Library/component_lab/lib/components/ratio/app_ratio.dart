import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';

/// Figma Ratio/Horizontal 17 개 + Ratio/Vertical 2 개 비율 프리셋.
///
/// 가로 크기 기준(Horizontal)과 세로 크기 기준(Vertical) 모두 포함합니다.
enum AppRatio {
  // ── Landscape / Square ──────────────────────────

  /// 1:1 — 정사각형
  square(1, 1),

  /// 5:4 — 클래식 사진
  ratio5x4(5, 4),

  /// 4:3 — 가로 사진
  ratio4x3(4, 3),

  /// 3:2 — 일반 카메라 사진
  ratio3x2(3, 2),

  /// 16:10 — 와이드스크린 모니터
  ratio16x10(16, 10),

  /// 1.618:1 — 황금비 가로
  goldenLandscape(1.618, 1),

  /// 16:9 — 와이드 (영상, 배너)
  ratio16x9(16, 9),

  /// 2:1 — 파노라마
  ratio2x1(2, 1),

  /// 21:9 — 시네마틱 와이드
  ratio21x9(21, 9),

  // ── Portrait ────────────────────────────────────

  /// 4:5 — 인스타그램 세로
  ratio4x5(4, 5),

  /// 3:4 — 세로 사진
  ratio3x4(3, 4),

  /// 2:3 — 책 표지·포스터
  ratio2x3(2, 3),

  /// 10:16 — 세로 와이드스크린
  ratio10x16(10, 16),

  /// 1:1.618 — 황금비 세로
  goldenPortrait(1, 1.618),

  /// 9:16 — 세로 영상 (Shorts, Story)
  ratio9x16(9, 16),

  /// 1:2 — 세로 파노라마
  ratio1x2(1, 2),

  /// 9:21 — 세로 시네마틱
  ratio9x21(9, 21);

  const AppRatio(this.width, this.height);

  /// 비율의 가로 비
  final double width;

  /// 비율의 세로 비
  final double height;

  /// 가로/세로 비율 값 (Flutter [AspectRatio] 위젯에 사용)
  double get value => width / height;
}

// ─────────────────────────────────────────────────────
// AppRatioBox — 가로 크기 기준 비율 컨테이너 (Figma Ratio/Horizontal)
// ─────────────────────────────────────────────────────

/// 가로 크기 기준으로 같은 비율을 유지하는 컨테이너.
///
/// 부모가 가로 폭을 제약하면, 해당 폭 기준으로 높이를 결정합니다.
///
/// ```dart
/// AppRatioBox(
///   ratio: AppRatio.ratio16x9,
///   child: Image.network(url, fit: BoxFit.cover),
/// )
/// ```
class AppRatioBox extends StatelessWidget {
  /// 적용할 비율 프리셋.
  final AppRatio ratio;

  /// 비율 컨테이너 안에 표시할 자식 위젯.
  final Widget child;

  /// 모서리 둥글림. null 이면 카드 기본값(16).
  final BorderRadius? borderRadius;

  /// 배경색 (이미지 로딩 전 플레이스홀더).
  final Color? backgroundColor;

  const AppRatioBox({
    super.key,
    required this.child,
    this.ratio = AppRatio.square,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? AppRadius.radiusCardBorder;
    final bg = backgroundColor ??
        (isDark
            ? AppColor.darkComponentFillNormal
            : AppColor.componentFillNormal);

    return AspectRatio(
      aspectRatio: ratio.value,
      child: ClipRRect(
        borderRadius: radius,
        child: Container(color: bg, child: child),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// AppRatioBoxVertical — 세로 크기 기준 비율 컨테이너 (Figma Ratio/Vertical)
// ─────────────────────────────────────────────────────

/// 세로 크기 기준으로 같은 비율을 유지하는 컨테이너.
///
/// 부모가 세로 높이를 제약하면, 해당 높이 기준으로 가로 폭을 결정합니다.
/// Row 등 가로 레이아웃 안에서 높이를 Fill 하고 가로 Hug 할 때 유용합니다.
///
/// ```dart
/// SizedBox(
///   height: 200,
///   child: Row(
///     children: [
///       AppRatioBoxVertical(
///         ratio: AppRatio.square, // 200×200
///         child: Image.network(url, fit: BoxFit.cover),
///       ),
///     ],
///   ),
/// )
/// ```
class AppRatioBoxVertical extends StatelessWidget {
  /// 적용할 비율 프리셋.
  final AppRatio ratio;

  /// 비율 컨테이너 안에 표시할 자식 위젯.
  final Widget child;

  /// 모서리 둥글림. null 이면 카드 기본값(16).
  final BorderRadius? borderRadius;

  /// 배경색 (이미지 로딩 전 플레이스홀더).
  final Color? backgroundColor;

  const AppRatioBoxVertical({
    super.key,
    required this.child,
    this.ratio = AppRatio.square,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? AppRadius.radiusCardBorder;
    final bg = backgroundColor ??
        (isDark
            ? AppColor.darkComponentFillNormal
            : AppColor.componentFillNormal);

    return LayoutBuilder(
      builder: (context, constraints) {
        // 사용 가능한 높이 기준으로 가로 폭 계산
        final height = constraints.maxHeight;
        final width = height * ratio.value;

        return SizedBox(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: radius,
            child: Container(color: bg, child: child),
          ),
        );
      },
    );
  }
}
