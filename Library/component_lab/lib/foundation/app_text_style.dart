import 'package:flutter/material.dart';

/// Figma Library 등록 텍스트 스타일 (66개) + Emoji (5개).
///
/// 명명 규칙:
/// - 카테고리: display / title / heading / headline / body / label / caption
/// - body / label 은 추가 변형: Normal / Reading
/// - weight: Bold / Medium / Regular
/// - "숫자 고정폭" 변형: 접미사 `Tabular` (OpenType `tnum` feature)
///
/// "Bold" weight 매핑:
/// - Display 1, 2 / Title 1, 2, 3 → weight **700** (실제 Bold)
/// - Heading / Headline / Body / Label / Caption → weight **600** (SemiBold)
class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Pretendard';
  static const List<FontFeature> _features = [FontFeature('ss10')];
  static const List<FontFeature> _featuresTnum = [
    FontFeature('ss10'),
    FontFeature('tnum'),
  ];

  // ===== DISPLAY =====
  static const TextStyle display1Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w700,
    fontSize: 56.0, height: 1.286, letterSpacing: -1.7864,
    fontFeatures: _features,
  );
  static const TextStyle display1Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 56.0, height: 1.286, letterSpacing: -1.7864,
    fontFeatures: _features,
  );
  static const TextStyle display1Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 56.0, height: 1.286, letterSpacing: -1.7864,
    fontFeatures: _features,
  );
  static const TextStyle display2Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w700,
    fontSize: 40.0, height: 1.300, letterSpacing: -1.128,
    fontFeatures: _features,
  );
  static const TextStyle display2Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 40.0, height: 1.300, letterSpacing: -1.128,
    fontFeatures: _features,
  );
  static const TextStyle display2Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 40.0, height: 1.300, letterSpacing: -1.128,
    fontFeatures: _features,
  );

  // ===== TITLE =====
  static const TextStyle title1Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w700,
    fontSize: 36.0, height: 1.334, letterSpacing: -0.972,
    fontFeatures: _features,
  );
  static const TextStyle title1Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 36.0, height: 1.334, letterSpacing: -0.972,
    fontFeatures: _features,
  );
  static const TextStyle title1Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 36.0, height: 1.334, letterSpacing: -0.972,
    fontFeatures: _features,
  );
  static const TextStyle title2Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w700,
    fontSize: 28.0, height: 1.358, letterSpacing: -0.6608,
    fontFeatures: _features,
  );
  static const TextStyle title2Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 28.0, height: 1.358, letterSpacing: -0.6608,
    fontFeatures: _features,
  );
  static const TextStyle title2Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 28.0, height: 1.358, letterSpacing: -0.6608,
    fontFeatures: _features,
  );
  static const TextStyle title2MediumTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 28.0, height: 1.358, letterSpacing: -0.6608,
    fontFeatures: _featuresTnum,
  );
  static const TextStyle title3Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w700,
    fontSize: 24.0, height: 1.334, letterSpacing: -0.552,
    fontFeatures: _features,
  );
  static const TextStyle title3Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 24.0, height: 1.334, letterSpacing: -0.552,
    fontFeatures: _features,
  );
  static const TextStyle title3Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 24.0, height: 1.334, letterSpacing: -0.552,
    fontFeatures: _features,
  );
  static const TextStyle title3MediumTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 24.0, height: 1.334, letterSpacing: -0.552,
    fontFeatures: _featuresTnum,
  );

  // ===== HEADING =====
  static const TextStyle heading1Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 22.0, height: 1.364, letterSpacing: -0.4268,
    fontFeatures: _features,
  );
  static const TextStyle heading1Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 22.0, height: 1.364, letterSpacing: -0.4268,
    fontFeatures: _features,
  );
  static const TextStyle heading1Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 22.0, height: 1.364, letterSpacing: -0.4268,
    fontFeatures: _features,
  );
  static const TextStyle heading1BoldTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 22.0, height: 1.364, letterSpacing: -0.4268,
    fontFeatures: _featuresTnum,
  );
  static const TextStyle heading2Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 20.0, height: 1.400, letterSpacing: -0.24,
    fontFeatures: _features,
  );
  static const TextStyle heading2Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 20.0, height: 1.400, letterSpacing: -0.24,
    fontFeatures: _features,
  );
  static const TextStyle heading2Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 20.0, height: 1.400, letterSpacing: -0.24,
    fontFeatures: _features,
  );
  static const TextStyle heading2BoldTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 20.0, height: 1.400, letterSpacing: -0.24,
    fontFeatures: _featuresTnum,
  );

  // ===== HEADLINE =====
  static const TextStyle headline1Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 18.0, height: 1.445, letterSpacing: -0.036,
    fontFeatures: _features,
  );
  static const TextStyle headline1Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 18.0, height: 1.445, letterSpacing: -0.036,
    fontFeatures: _features,
  );
  static const TextStyle headline1Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 18.0, height: 1.445, letterSpacing: -0.036,
    fontFeatures: _features,
  );
  static const TextStyle headline1BoldTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 18.0, height: 1.445, letterSpacing: -0.036,
    fontFeatures: _featuresTnum,
  );
  static const TextStyle headline2Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 17.0, height: 1.412, letterSpacing: 0,
    fontFeatures: _features,
  );
  static const TextStyle headline2Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 17.0, height: 1.412, letterSpacing: 0,
    fontFeatures: _features,
  );
  static const TextStyle headline2Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 17.0, height: 1.412, letterSpacing: 0,
    fontFeatures: _features,
  );
  static const TextStyle headline2BoldTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 17.0, height: 1.412, letterSpacing: 0,
    fontFeatures: _featuresTnum,
  );

  // ===== BODY =====
  static const TextStyle body1NormalBold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 16.0, height: 1.500, letterSpacing: 0.0912,
    fontFeatures: _features,
  );
  static const TextStyle body1NormalMedium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 16.0, height: 1.500, letterSpacing: 0.0912,
    fontFeatures: _features,
  );
  static const TextStyle body1NormalRegular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 16.0, height: 1.500, letterSpacing: 0.0912,
    fontFeatures: _features,
  );
  static const TextStyle body1NormalRegularTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 16.0, height: 1.500, letterSpacing: 0.0912,
    fontFeatures: _featuresTnum,
  );
  static const TextStyle body1ReadingBold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 16.0, height: 1.625, letterSpacing: 0.0912,
    fontFeatures: _features,
  );
  static const TextStyle body1ReadingMedium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 16.0, height: 1.625, letterSpacing: 0.0912,
    fontFeatures: _features,
  );
  static const TextStyle body1ReadingRegular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 16.0, height: 1.625, letterSpacing: 0.0912,
    fontFeatures: _features,
  );
  static const TextStyle body2NormalBold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 15.0, height: 1.467, letterSpacing: 0.144,
    fontFeatures: _features,
  );
  static const TextStyle body2NormalMedium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 15.0, height: 1.467, letterSpacing: 0.144,
    fontFeatures: _features,
  );
  static const TextStyle body2NormalRegular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 15.0, height: 1.467, letterSpacing: 0.144,
    fontFeatures: _features,
  );
  static const TextStyle body2NormalRegularTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 15.0, height: 1.467, letterSpacing: 0.144,
    fontFeatures: _featuresTnum,
  );
  static const TextStyle body2ReadingBold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 15.0, height: 1.600, letterSpacing: 0.144,
    fontFeatures: _features,
  );
  static const TextStyle body2ReadingMedium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 15.0, height: 1.600, letterSpacing: 0.144,
    fontFeatures: _features,
  );
  static const TextStyle body2ReadingRegular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 15.0, height: 1.600, letterSpacing: 0.144,
    fontFeatures: _features,
  );

  // ===== LABEL =====
  static const TextStyle label1NormalBold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 14.0, height: 1.429, letterSpacing: 0.203,
    fontFeatures: _features,
  );
  static const TextStyle label1NormalMedium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 14.0, height: 1.429, letterSpacing: 0.203,
    fontFeatures: _features,
  );
  static const TextStyle label1NormalRegular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 14.0, height: 1.429, letterSpacing: 0.203,
    fontFeatures: _features,
  );
  static const TextStyle label1NormalRegularTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 14.0, height: 1.429, letterSpacing: 0.203,
    fontFeatures: _featuresTnum,
  );
  static const TextStyle label1ReadingBold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 14.0, height: 1.5714, letterSpacing: 0.203,
    fontFeatures: _features,
  );
  static const TextStyle label1ReadingMedium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 14.0, height: 1.571, letterSpacing: 0.203,
    fontFeatures: _features,
  );
  static const TextStyle label1ReadingRegular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 14.0, height: 1.5714, letterSpacing: 0.203,
    fontFeatures: _features,
  );
  static const TextStyle label2Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 13.0, height: 1.385, letterSpacing: 0.2522,
    fontFeatures: _features,
  );
  static const TextStyle label2Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 13.0, height: 1.385, letterSpacing: 0.2522,
    fontFeatures: _features,
  );
  static const TextStyle label2Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 13.0, height: 1.385, letterSpacing: 0.2522,
    fontFeatures: _features,
  );
  static const TextStyle label2RegularTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 13.0, height: 1.385, letterSpacing: 0.2522,
    fontFeatures: _featuresTnum,
  );

  // ===== CAPTION =====
  static const TextStyle caption1Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 12.0, height: 1.334, letterSpacing: 0.3024,
    fontFeatures: _features,
  );
  static const TextStyle caption1Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 12.0, height: 1.334, letterSpacing: 0.3024,
    fontFeatures: _features,
  );
  static const TextStyle caption1Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 12.0, height: 1.334, letterSpacing: 0.3024,
    fontFeatures: _features,
  );
  static const TextStyle caption1RegularTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 12.0, height: 1.334, letterSpacing: 0.3024,
    fontFeatures: _featuresTnum,
  );
  static const TextStyle caption2Bold = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w600,
    fontSize: 11.0, height: 1.273, letterSpacing: 0.3421,
    fontFeatures: _features,
  );
  static const TextStyle caption2Medium = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w500,
    fontSize: 11.0, height: 1.273, letterSpacing: 0.3421,
    fontFeatures: _features,
  );
  static const TextStyle caption2Regular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 11.0, height: 1.273, letterSpacing: 0.3421,
    fontFeatures: _features,
  );
  static const TextStyle caption2RegularTabular = TextStyle(
    fontFamily: _fontFamily, fontWeight: FontWeight.w400,
    fontSize: 11.0, height: 1.273, letterSpacing: 0.3421,
    fontFeatures: _featuresTnum,
  );

  // ===== EMOJI (Figma 외) =====
  static const TextStyle emojiSmall = TextStyle(fontSize: 16.0);
  static const TextStyle emojiMedium = TextStyle(fontSize: 20.0);
  static const TextStyle emojiNormal = TextStyle(fontSize: 24.0);
  static const TextStyle emojiLarge = TextStyle(fontSize: 48.0);
  static const TextStyle emojiXLarge = TextStyle(fontSize: 80.0);
}
