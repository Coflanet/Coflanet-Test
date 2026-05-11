import 'package:flutter/material.dart';

import '../foundation/app_spacing.dart';

import 'app_text_style.dart';

/// 버튼 사이즈별 공통 메트릭 (Figma 측정).
///
/// AppSolidButton / AppOutlinedButton의 size enum이 동일한 4단계 룩업을
/// 공유한다. 두 곳에 동일 표를 두는 대신 이 클래스 하나만 두고 enum별
/// switch에서 같은 인스턴스를 반환한다.
class AppButtonMetrics {
  const AppButtonMetrics({
    required this.height,
    required this.padding,
    required this.gap,
    required this.iconSize,
    required this.textStyle,
  });

  /// 버튼 높이 (px).
  final double height;

  /// 내부 패딩 (horizontal/vertical).
  final EdgeInsets padding;

  /// 텍스트와 아이콘 사이 간격.
  final double gap;

  /// 좌/우 아이콘 사이즈.
  final double iconSize;

  /// 라벨 텍스트 스타일.
  final TextStyle textStyle;

  /// `Large` — 52h, Figma `Button/Solid/Large`.
  static const AppButtonMetrics large = AppButtonMetrics(
    height: 52,
    padding: EdgeInsets.symmetric(horizontal: 28, vertical: AppSpacing.space12),
    gap: 6,
    iconSize: 20,
    textStyle: AppTextStyles.body1NormalBold,
  );

  /// `Medium` — 40h.
  static const AppButtonMetrics medium = AppButtonMetrics(
    height: 40,
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20, vertical: 9),
    gap: 5,
    iconSize: 18,
    textStyle: AppTextStyles.body2NormalBold,
  );

  /// `Small` — 32h.
  static const AppButtonMetrics small = AppButtonMetrics(
    height: 32,
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.space14, vertical: 7),
    gap: 4,
    iconSize: 16,
    textStyle: AppTextStyles.label2Bold,
  );

  /// `XSmall` — 32h, padding만 더 좁다.
  static const AppButtonMetrics xsmall = AppButtonMetrics(
    height: 32,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    gap: 4,
    iconSize: 16,
    textStyle: AppTextStyles.label2Bold,
  );
}
