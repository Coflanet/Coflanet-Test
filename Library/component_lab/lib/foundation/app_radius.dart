import 'package:flutter/material.dart';

/// Border radius 토큰 — Figma 디자인 시스템 기준.
///
/// 2계층 구조:
/// - **Palette** (`radius{N}`): Figma `Round/*` 7단계 + Pill + 미세값 (게이지·프로그레스용).
/// - **Semantic** (`radius{Component}`): 컴포넌트별 의미 토큰.
class AppRadius {
  AppRadius._();

  // ═══════════════════════════════════════════════════════════════
  // PALETTE
  // ═══════════════════════════════════════════════════════════════

  // ── Figma 외 미세값 (게이지·프로그레스·세부 디테일용) ──────────
  /// 2px — 얇은 게이지·프로그레스바 모서리
  static const double radius2 = 2.0;

  /// 4px — 작은 게이지·체크 디테일
  static const double radius4 = 4.0;

  /// 6px — 작은 컴포넌트 미세 모서리
  static const double radius6 = 6.0;

  // ── Figma `Round/*` 7단계 ──────────────────────────────────────
  /// 8px — Figma `Round/8`
  static const double radius8 = 8.0;

  /// 10px — Avatar Large, Chip Medium/Large cornerRadius
  static const double radius10 = 10.0;

  /// 12px — Figma `Round/12`
  static const double radius12 = 12.0;

  /// 14px — Figma 외, Card 변형 등 미세 디테일
  static const double radius14 = 14.0;

  /// 16px — Figma `Round/16(Box in Box)`
  static const double radius16 = 16.0;

  /// 20px — Figma `Round/20(Box)`
  static const double radius20 = 20.0;

  /// 24px — Figma `Round/24(Box)`
  static const double radius24 = 24.0;

  /// 32px — Figma `Round/32(Box)`
  static const double radius32 = 32.0;

  /// 40px — Figma `Round/40(1st Box)`
  static const double radius40 = 40.0;

  /// 100px — Pill / fully rounded (avatar, chip 둥근 끝 등)
  static const double radiusPill = 100.0;

  // ── BorderRadius getters ───────────────────────────────────────
  static BorderRadius get radius2Border => BorderRadius.circular(radius2);
  static BorderRadius get radius4Border => BorderRadius.circular(radius4);
  static BorderRadius get radius6Border => BorderRadius.circular(radius6);
  static BorderRadius get radius8Border => BorderRadius.circular(radius8);
  static BorderRadius get radius10Border => BorderRadius.circular(radius10);
  static BorderRadius get radius12Border => BorderRadius.circular(radius12);
  static BorderRadius get radius14Border => BorderRadius.circular(radius14);
  static BorderRadius get radius16Border => BorderRadius.circular(radius16);
  static BorderRadius get radius20Border => BorderRadius.circular(radius20);
  static BorderRadius get radius24Border => BorderRadius.circular(radius24);
  static BorderRadius get radius32Border => BorderRadius.circular(radius32);
  static BorderRadius get radius40Border => BorderRadius.circular(radius40);
  static BorderRadius get radiusPillBorder => BorderRadius.circular(radiusPill);

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC
  // ═══════════════════════════════════════════════════════════════

  /// Button radius — Figma 99px (Pill, 완전 둥글림)
  static const double radiusButton = 99.0;
  static BorderRadius get radiusButtonBorder => BorderRadius.circular(radiusButton);

  /// Input field radius — 12px
  static const double radiusInput = radius12;
  static BorderRadius get radiusInputBorder => radius12Border;

  /// Card radius — 16px (Figma `Round/16`)
  static const double radiusCard = radius16;
  static BorderRadius get radiusCardBorder => radius16Border;

  /// Modal radius — 20px (Figma `Round/20`)
  static const double radiusModal = radius20;
  static BorderRadius get radiusModalBorder => radius20Border;

  /// Chip radius — 8px
  static const double radiusChip = radius8;
  static BorderRadius get radiusChipBorder => radius8Border;

  /// Checkbox radius — 6px
  static const double radiusCheckbox = radius6;
  static BorderRadius get radiusCheckboxBorder => radius6Border;

  /// Avatar radius — Pill (완전 둥글게)
  static const double radiusAvatar = radiusPill;
  static BorderRadius get radiusAvatarBorder => radiusPillBorder;

  // ═══════════════════════════════════════════════════════════════
  // DIRECTIONAL HELPERS
  // ═══════════════════════════════════════════════════════════════

  static BorderRadius top(double radius) => BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );

  static BorderRadius bottom(double radius) => BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );

  static BorderRadius left(double radius) => BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      );

  static BorderRadius right(double radius) => BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
}
