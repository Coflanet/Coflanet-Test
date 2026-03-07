import 'package:flutter/material.dart';

class AppTextStyles {
  // Font Family - Using system fonts as fallback until custom fonts are added
  static const String _fontFamily = 'Pretendard';
  static const String _monospaceFontFamily = 'PretendardMono'; // 숫자-고정폭용

  // Note: When fonts are not available, Flutter falls back to system fonts

  // ===== DISPLAY STYLES =====
  static const TextStyle display1Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 56.0,
    height: 1.2,
  );

  static const TextStyle display1Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 56.0,
    height: 1.2,
  );

  static const TextStyle display1Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 56.0,
    height: 1.2,
  );

  static const TextStyle display2Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 40.0,
    height: 1.2,
  );

  static const TextStyle display2Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 40.0,
    height: 1.2,
  );

  static const TextStyle display2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 40.0,
    height: 1.2,
  );

  // ===== TITLE STYLES =====
  static const TextStyle title1Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 36.0,
    height: 1.3,
  );

  static const TextStyle title1Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 36.0,
    height: 1.3,
  );

  static const TextStyle title1Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 36.0,
    height: 1.3,
  );

  static const TextStyle title2Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 28.0,
    height: 1.3,
  );

  static const TextStyle title2Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 28.0,
    height: 1.3,
  );

  static const TextStyle title2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 28.0,
    height: 1.3,
  );

  static const TextStyle title2MediumMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 28.0,
    height: 1.3,
  );

  static const TextStyle title3Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 24.0,
    height: 1.3,
  );

  static const TextStyle title3Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 24.0,
    height: 1.3,
  );

  static const TextStyle title3Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 24.0,
    height: 1.3,
  );

  static const TextStyle title3MediumMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 24.0,
    height: 1.3,
  );

  // ===== HEADING STYLES =====
  static const TextStyle heading1Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 22.0,
    height: 1.4,
  );

  static const TextStyle heading1BoldMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 22.0,
    height: 1.4,
  );

  static const TextStyle heading1Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 22.0,
    height: 1.4,
  );

  static const TextStyle heading1Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 22.0,
    height: 1.4,
  );

  static const TextStyle heading2Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 20.0,
    height: 1.4,
  );

  static const TextStyle heading2BoldMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 20.0,
    height: 1.4,
  );

  static const TextStyle heading2Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
    height: 1.4,
  );

  static const TextStyle heading2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 20.0,
    height: 1.4,
  );

  // ===== HEADLINE STYLES =====
  static const TextStyle headline1Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 1.4,
  );

  static const TextStyle headline1BoldMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 1.4,
  );

  static const TextStyle headline1Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
    height: 1.4,
  );

  static const TextStyle headline1Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 18.0,
    height: 1.4,
  );

  static const TextStyle headline2Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 17.0,
    height: 1.4,
  );

  static const TextStyle headline2BoldMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 17.0,
    height: 1.4,
  );

  static const TextStyle headline2Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 17.0,
    height: 1.4,
  );

  static const TextStyle headline2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 17.0,
    height: 1.4,
  );

  // ===== BODY STYLES =====
  static const TextStyle body1NormalRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    height: 1.5,
  );

  static const TextStyle body1NormalRegularMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    height: 1.5,
  );

  static const TextStyle body1NormalMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    height: 1.5,
  );

  static const TextStyle body1NormalBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 16.0,
    height: 1.5,
  );

  static const TextStyle body1ReadingRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    height: 1.6,
  );

  static const TextStyle body1ReadingMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    height: 1.6,
  );

  static const TextStyle body1ReadingBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 16.0,
    height: 1.6,
  );

  static const TextStyle body2NormalRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 15.0,
    height: 1.5,
  );

  static const TextStyle body2NormalRegularMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 15.0,
    height: 1.5,
  );

  static const TextStyle body2NormalMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    height: 1.5,
  );

  static const TextStyle body2NormalBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 15.0,
    height: 1.5,
  );

  static const TextStyle body2ReadingRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 15.0,
    height: 1.6,
  );

  static const TextStyle body2ReadingMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    height: 1.6,
  );

  static const TextStyle body2ReadingBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 15.0,
    height: 1.6,
  );

  // ===== LABEL STYLES =====
  static const TextStyle label1NormalRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    height: 1.4,
  );

  static const TextStyle label1NormalRegularMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    height: 1.4,
  );

  static const TextStyle label1NormalMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    height: 1.4,
  );

  static const TextStyle label1NormalBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 14.0,
    height: 1.4,
  );

  static const TextStyle label1ReadingRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    height: 1.5,
  );

  static const TextStyle label1ReadingMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    height: 1.5,
  );

  static const TextStyle label1ReadingBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 14.0,
    height: 1.5,
  );

  static const TextStyle label2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
    height: 1.4,
  );

  static const TextStyle label2RegularMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
    height: 1.4,
  );

  static const TextStyle label2Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    height: 1.4,
  );

  static const TextStyle label2Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 13.0,
    height: 1.4,
  );

  // ===== CAPTION STYLES =====
  static const TextStyle caption1Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    height: 1.3,
  );

  static const TextStyle caption1RegularMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    height: 1.3,
  );

  static const TextStyle caption1Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    height: 1.3,
  );

  static const TextStyle caption1Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 12.0,
    height: 1.3,
  );

  static const TextStyle caption2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 11.0,
    height: 1.3,
  );

  static const TextStyle caption2RegularMono = TextStyle(
    fontFamily: _monospaceFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 11.0,
    height: 1.3,
  );

  static const TextStyle caption2Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    height: 1.3,
  );

  static const TextStyle caption2Bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 11.0,
    height: 1.3,
  );

  // ===== EMOJI STYLES =====
  /// Emoji text style - 16px (small tags, labels)
  static const TextStyle emojiSmall = TextStyle(fontSize: 16.0);

  /// Emoji text style - 20px (inline emoji)
  static const TextStyle emojiMedium = TextStyle(fontSize: 20.0);

  /// Emoji text style - 24px (default emoji size)
  static const TextStyle emojiNormal = TextStyle(fontSize: 24.0);

  /// Emoji text style - 48px (large illustrations)
  static const TextStyle emojiLarge = TextStyle(fontSize: 48.0);

  /// Emoji text style - 80px (hero illustrations)
  static const TextStyle emojiXLarge = TextStyle(fontSize: 80.0);
}

class AppShadows {
  // ===== PRIMARY SHADOWS =====
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

  // ===== BLACK SHADOWS =====
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

  // Background blur effect (Flutter uses ImageFilter for blur)
  static const double backgroundBlur30 = 30.0;
}
