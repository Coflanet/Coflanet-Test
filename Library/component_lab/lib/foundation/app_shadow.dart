import 'package:flutter/material.dart';

/// Shadow 토큰 — 5단계 강도 × 2 컬러군 (Primary Violet / Black).
///
/// 강도 구분:
/// - **Normal**: 가벼운 그림자 (카드, 작은 elevation)
/// - **Emphasize**: 강조 그림자 (눈에 띄는 카드)
/// - **Strong**: 강한 그림자 (모달, 팝오버)
/// - **Heavy**: 깊은 그림자 (큰 모달, FAB)
/// - **Floating**: 떠 있는 느낌 (다이얼로그, 핵심 액션 버튼)
/// - **HeavyBottom**: Heavy의 위쪽 그림자 버전 (BottomSheet 등)
class AppShadows {
  AppShadows._();

  // ═══════════════════════════════════════════════════════════════
  // PRIMARY (Violet rgb(101,65,242)) SHADOWS — 브랜드 강조용
  // ═══════════════════════════════════════════════════════════════

  /// Primary Normal — 가벼운 보라 그림자 (단일)
  static const BoxShadow shadowPrimaryNormal = BoxShadow(
    color: Color.fromRGBO(101, 65, 242, 0.04),
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  );

  static const List<BoxShadow> shadowPrimaryNormalList = [
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 0),
      blurRadius: 1,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 0),
      blurRadius: 1,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.06),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowPrimaryEmphasize = [
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 0),
      blurRadius: 1,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.06),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowPrimaryStrong = [
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.06),
      offset: Offset(0, 6),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowPrimaryHeavy = [
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.06),
      offset: Offset(0, 16),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowPrimaryHeavyBottom = [
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, -8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.06),
      offset: Offset(0, -16),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowPrimaryFloating = [
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.04),
      offset: Offset(0, 16),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(101, 65, 242, 0.06),
      offset: Offset(0, 24),
      blurRadius: 40,
      spreadRadius: 0,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════
  // BLACK SHADOWS — 일반 elevation
  // ═══════════════════════════════════════════════════════════════

  static const List<BoxShadow> shadowBlackNormal = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 0),
      blurRadius: 1,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 0),
      blurRadius: 1,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowBlackEmphasize = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 0),
      blurRadius: 1,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowBlackStrong = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, 6),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowBlackHeavy = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, 16),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowBlackHeavyBottom = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, -8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, -16),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowBlackFloating = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 16),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, 24),
      blurRadius: 40,
      spreadRadius: 0,
    ),
  ];

  /// Background blur amount (Flutter ImageFilter.blur용)
  static const double backgroundBlur30 = 30.0;
}
