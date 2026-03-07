import 'package:flutter/material.dart';

class AppColor {
  // ===== PALETTE COLORS (Reference) =====

  // Common Colors
  static const Color colorGlobalCommon100 = Color(0xFFFFFFFF);
  static const Color colorGlobalCommon0 = Color(0xFF000000);

  /// Transparent color - use instead of Colors.transparent
  static const Color transparent = Color(0x00000000);

  // Neutral Colors
  static const Color colorGlobalNeutral99 = Color(0xFFF7F7F7);
  static const Color colorGlobalNeutral95 = Color(0xFFDCDCDC);
  static const Color colorGlobalNeutral90 = Color(0xFFC4C4C4);
  static const Color colorGlobalNeutral80 = Color(
    0xFF9B9B9B,
  ); // Fixed from JSON
  static const Color colorGlobalNeutral70 = Color(0xFF9B9B9B);
  static const Color colorGlobalNeutral60 = Color(0xFF8A8A8A);
  static const Color colorGlobalNeutral50 = Color(0xFF737373);
  static const Color colorGlobalNeutral40 = Color(0xFF5C5C5C);
  static const Color colorGlobalNeutral30 = Color(0xFF474747);
  static const Color colorGlobalNeutral22 = Color(0xFF303030);
  static const Color colorGlobalNeutral20 = Color(0xFF2A2A2A);
  static const Color colorGlobalNeutral15 = Color(0xFF1C1C1C);
  static const Color colorGlobalNeutral10 = Color(0xFF171717);
  static const Color colorGlobalNeutral5 = Color(0xFF0F0F0F);

  // Cool Neutral Colors
  static const Color colorGlobalCoolNeutral99 = Color(0xFFF7F7F8);
  static const Color colorGlobalCoolNeutral98 = Color(0xFFF4F4F5);
  static const Color colorGlobalCoolNeutral97 = Color(0xFFEAEBEC);
  static const Color colorGlobalCoolNeutral96 = Color(0xFFE1E2E4);
  static const Color colorGlobalCoolNeutral95 = Color(0xFFDBDCDF);
  static const Color colorGlobalCoolNeutral90 = Color(0xFFC2C4C8);
  static const Color colorGlobalCoolNeutral80 = Color(0xFFAEB0B6);
  static const Color colorGlobalCoolNeutral70 = Color(0xFF989BA2);
  static const Color colorGlobalCoolNeutral60 = Color(0xFF878A93);
  static const Color colorGlobalCoolNeutral50 = Color(0xFF70737C);
  static const Color colorGlobalCoolNeutral40 = Color(0xFF5A5C63);
  static const Color colorGlobalCoolNeutral30 = Color(0xFF46474C);
  static const Color colorGlobalCoolNeutral25 = Color(0xFF37383C);
  static const Color colorGlobalCoolNeutral23 = Color(0xFF333438);
  static const Color colorGlobalCoolNeutral22 = Color(0xFF2E2F33);
  static const Color colorGlobalCoolNeutral20 = Color(0xFF292A2D);
  static const Color colorGlobalCoolNeutral17 = Color(0xFF212225);
  static const Color colorGlobalCoolNeutral15 = Color(0xFF1B1C1E);
  static const Color colorGlobalCoolNeutral10 = Color(0xFF171719);
  static const Color colorGlobalCoolNeutral7 = Color(0xFF141415);
  static const Color colorGlobalCoolNeutral5 = Color(0xFF0F0F10);

  // Blue Colors
  static const Color colorGlobalBlue99 = Color(0xFFF7FBFF);
  static const Color colorGlobalBlue95 = Color(0xFFEAF2FE);
  static const Color colorGlobalBlue90 = Color(0xFFC9DEFE);
  static const Color colorGlobalBlue80 = Color(0xFF9EC5FF);
  static const Color colorGlobalBlue70 = Color(0xFF69A5FF);
  static const Color colorGlobalBlue60 = Color(0xFF3385FF);
  static const Color colorGlobalBlue55 = Color(0xFF1A75FF);
  static const Color colorGlobalBlue50 = Color(0xFF0066FF);
  static const Color colorGlobalBlue45 = Color(0xFF005EEB);
  static const Color colorGlobalBlue40 = Color(0xFF0054D1);
  static const Color colorGlobalBlue30 = Color(0xFF003E9C);
  static const Color colorGlobalBlue20 = Color(0xFF002966);
  static const Color colorGlobalBlue10 = Color(0xFF001536);

  // Red Colors
  static const Color colorGlobalRed99 = Color(0xFFFFFAFA);
  static const Color colorGlobalRed95 = Color(0xFFFEECEC);
  static const Color colorGlobalRed90 = Color(0xFFFED5D5);
  static const Color colorGlobalRed80 = Color(0xFFFFB5B5);
  static const Color colorGlobalRed70 = Color(0xFFFF8C8C);
  static const Color colorGlobalRed60 = Color(0xFFFF6363);
  static const Color colorGlobalRed50 = Color(0xFFFF4242);
  static const Color colorGlobalRed40 = Color(0xFFE52222);
  static const Color colorGlobalRed30 = Color(0xFFB20C0C);
  static const Color colorGlobalRed20 = Color(0xFF750404);
  static const Color colorGlobalRed10 = Color(0xFF3B0101);

  // Green Colors
  static const Color colorGlobalGreen99 = Color(0xFFF2FFF6);
  static const Color colorGlobalGreen95 = Color(0xFFD9FFE6);
  static const Color colorGlobalGreen90 = Color(0xFFACFCC7);
  static const Color colorGlobalGreen80 = Color(0xFF7DF5A5);
  static const Color colorGlobalGreen70 = Color(0xFF49E57D);
  static const Color colorGlobalGreen60 = Color(0xFF1ED45A);
  static const Color colorGlobalGreen50 = Color(0xFF00BF40);
  static const Color colorGlobalGreen40 = Color(0xFF009632);
  static const Color colorGlobalGreen30 = Color(0xFF006E25);
  static const Color colorGlobalGreen20 = Color(0xFF004517);
  static const Color colorGlobalGreen10 = Color(0xFF00240C);

  // Orange Colors
  static const Color colorGlobalOrange99 = Color(0xFFFFFCF7);
  static const Color colorGlobalOrange95 = Color(0xFFFEF4E6);
  static const Color colorGlobalOrange90 = Color(0xFFFEE6C6);
  static const Color colorGlobalOrange80 = Color(0xFFFFD49C);
  static const Color colorGlobalOrange70 = Color(0xFFFFC06E);
  static const Color colorGlobalOrange60 = Color(0xFFFFA938);
  static const Color colorGlobalOrange50 = Color(0xFFFF9200);
  static const Color colorGlobalOrange40 = Color(0xFFD47800);
  static const Color colorGlobalOrange39 = Color(0xFFD17600); // Hidden token
  static const Color colorGlobalOrange30 = Color(0xFF9C5800);
  static const Color colorGlobalOrange20 = Color(0xFF663A00);
  static const Color colorGlobalOrange10 = Color(0xFF361E00);

  // Yellow Colors (Added from JSON)
  static const Color colorGlobalYellow99 = Color(0xFFFFFDF7);
  static const Color colorGlobalYellow95 = Color(0xFFFEF9E5);
  static const Color colorGlobalYellow90 = Color(0xFFFEF3C6);
  static const Color colorGlobalYellow80 = Color(0xFFFFEB9C);
  static const Color colorGlobalYellow70 = Color(0xFFFFE063);
  static const Color colorGlobalYellow60 = Color(0xFFFFD52E);
  static const Color colorGlobalYellow50 = Color(0xFFFFCC00);
  static const Color colorGlobalYellow40 = Color(0xFFCCA300);
  static const Color colorGlobalYellow30 = Color(0xFF947600);
  static const Color colorGlobalYellow20 = Color(0xFF5C4900);
  static const Color colorGlobalYellow10 = Color(0xFF2E2500);

  // Lime Colors
  static const Color colorGlobalLime99 = Color(0xFFF8FFF2);
  static const Color colorGlobalLime95 = Color(0xFFE6FFD4);
  static const Color colorGlobalLime90 = Color(0xFFCCFCA9);
  static const Color colorGlobalLime80 = Color(0xFFAEF779);
  static const Color colorGlobalLime70 = Color(0xFF88F03E);
  static const Color colorGlobalLime60 = Color(0xFF6BE016);
  static const Color colorGlobalLime50 = Color(0xFF58CF04);
  static const Color colorGlobalLime40 = Color(0xFF48AD00);
  static const Color colorGlobalLime37 = Color(0xFF429E00); // Hidden token
  static const Color colorGlobalLime30 = Color(0xFF347D00);
  static const Color colorGlobalLime20 = Color(0xFF225200);
  static const Color colorGlobalLime10 = Color(0xFF112900);

  // Cyan Colors
  static const Color colorGlobalCyan99 = Color(0xFFF7FEFF);
  static const Color colorGlobalCyan95 = Color(0xFFDEFAFF);
  static const Color colorGlobalCyan90 = Color(0xFFB5F4FF);
  static const Color colorGlobalCyan80 = Color(0xFF8AEDFF);
  static const Color colorGlobalCyan70 = Color(0xFF57DFF7);
  static const Color colorGlobalCyan60 = Color(0xFF28D0ED);
  static const Color colorGlobalCyan50 = Color(0xFF00BDDE);
  static const Color colorGlobalCyan40 = Color(0xFF0098B2);
  static const Color colorGlobalCyan30 = Color(0xFF006F82);
  static const Color colorGlobalCyan20 = Color(0xFF004854);
  static const Color colorGlobalCyan10 = Color(0xFF00252B);

  // Light Blue Colors
  static const Color colorGlobalLightBlue99 = Color(0xFFF7FDFF);
  static const Color colorGlobalLightBlue95 = Color(0xFFE5F6FE);
  static const Color colorGlobalLightBlue90 = Color(0xFFC4ECFE);
  static const Color colorGlobalLightBlue80 = Color(0xFFA1E1FF);
  static const Color colorGlobalLightBlue70 = Color(0xFF70D2FF);
  static const Color colorGlobalLightBlue60 = Color(0xFF3DC2FF);
  static const Color colorGlobalLightBlue50 = Color(0xFF00AEFF);
  static const Color colorGlobalLightBlue40 = Color(0xFF008DCF);
  static const Color colorGlobalLightBlue30 = Color(0xFF006796);
  static const Color colorGlobalLightBlue20 = Color(0xFF004261);
  static const Color colorGlobalLightBlue10 = Color(0xFF002130);

  // Violet Colors
  static const Color colorGlobalViolet99 = Color(0xFFFBFAFF);
  static const Color colorGlobalViolet95 = Color(0xFFF0ECFE);
  static const Color colorGlobalViolet90 = Color(0xFFDBD3FE);
  static const Color colorGlobalViolet80 = Color(0xFFC0B0FF);
  static const Color colorGlobalViolet70 = Color(0xFF9E86FC);
  static const Color colorGlobalViolet60 = Color(0xFF7D5EF7);
  static const Color colorGlobalViolet55 = Color(0xFF7352F7);
  static const Color colorGlobalViolet50 = Color(0xFF6541F2);
  static const Color colorGlobalViolet45 = Color(0xFF5B35F2);
  static const Color colorGlobalViolet40 = Color(0xFF4F29E5);
  static const Color colorGlobalViolet30 = Color(0xFF3A16C9);
  static const Color colorGlobalViolet20 = Color(0xFF23098F);
  static const Color colorGlobalViolet10 = Color(0xFF11024D);

  // Pink Colors
  static const Color colorGlobalPink99 = Color(0xFFFFFAFE);
  static const Color colorGlobalPink95 = Color(0xFFFEECFB);
  static const Color colorGlobalPink90 = Color(0xFFFED3F7);
  static const Color colorGlobalPink80 = Color(0xFFFFB8F3);
  static const Color colorGlobalPink70 = Color(0xFFFF94ED);
  static const Color colorGlobalPink60 = Color(0xFFFA73E3);
  static const Color colorGlobalPink50 = Color(0xFFF553DA);
  static const Color colorGlobalPink46 = Color(0xFFE846CD); // Hidden token
  static const Color colorGlobalPink40 = Color(0xFFD331B8);
  static const Color colorGlobalPink30 = Color(0xFFA81690);
  static const Color colorGlobalPink20 = Color(0xFF730560);
  static const Color colorGlobalPink10 = Color(0xFF3D0133);

  // Opacity Values
  static const double colorGlobalOpacity0 = 0.0;
  static const double colorGlobalOpacity5 = 0.05;
  static const double colorGlobalOpacity8 = 0.08;
  static const double colorGlobalOpacity12 = 0.12;
  static const double colorGlobalOpacity16 = 0.16;
  static const double colorGlobalOpacity22 = 0.22;
  static const double colorGlobalOpacity28 = 0.28;
  static const double colorGlobalOpacity35 = 0.35;
  static const double colorGlobalOpacity43 = 0.43;
  static const double colorGlobalOpacity52 = 0.52;
  static const double colorGlobalOpacity61 = 0.61;
  static const double colorGlobalOpacity74 = 0.74;
  static const double colorGlobalOpacity88 = 0.88;
  static const double colorGlobalOpacity97 = 0.97;
  static const double colorGlobalOpacity100 = 1.0;

  // ===== SEMANTIC TOKENS (Light Mode) =====

  // Primary Colors
  static Color get primaryNormal => colorGlobalViolet50;
  static Color get primarySecondary => colorGlobalViolet70;
  static Color get primaryStrong => colorGlobalViolet45;
  static Color get primaryHeavy => colorGlobalViolet40;
  static Color get primaryLight => colorGlobalViolet95;

  // Label Colors
  static Color get labelNormal => colorGlobalCoolNeutral10;
  static Color get labelStrong => colorGlobalCommon0;
  static Color get labelNeutral => const Color(0xFF2E2F33).withOpacity(0.88);
  static Color get labelAlternative =>
      const Color(0xFF37383C).withOpacity(0.61);
  static Color get labelAssistive => const Color(0xFF37383C).withOpacity(0.35);
  static Color get labelDisable => const Color(0xFF37383C).withOpacity(0.16);

  // Background Colors
  static Color get backgroundNormalNormal => colorGlobalCommon100;
  static Color get backgroundNormalAlternative => colorGlobalCoolNeutral99;
  static Color get backgroundElevatedNormal => colorGlobalCommon100;
  static Color get backgroundElevatedAlternative => colorGlobalCoolNeutral99;
  static Color get backgroundOpacity75 =>
      const Color(0xFFFFFFFF).withOpacity(0.75);

  /// Timer background - #333333 per Figma CSS for 레시피 타이머 screen
  static const Color backgroundTimer = Color(0xFF333333);

  // Interaction Colors
  static Color get interactionInactive => colorGlobalCoolNeutral70;
  static Color get interactionDisable =>
      const Color(0xFFF4F4F5).withOpacity(0.5);

  // Line Colors
  static Color get lineNormalNormal =>
      const Color(0xFF70737C).withOpacity(0.22);
  static Color get lineNormalNeutral =>
      const Color(0xFF70737C).withOpacity(0.16);
  static Color get lineNormalAlternative =>
      const Color(0xFF70737C).withOpacity(0.08);
  static Color get lineSolidNormal => colorGlobalCoolNeutral96;
  static Color get lineSolidNeutral => colorGlobalCoolNeutral97;
  static Color get lineSolidAlternative => colorGlobalCoolNeutral98;

  // Status Colors
  static Color get statusPositive => colorGlobalGreen50;
  static Color get statusPositiveBlue => colorGlobalBlue50;
  static Color get statusCautionary => colorGlobalOrange50;
  static Color get statusNegative => colorGlobalRed50;

  // Accent Background Colors
  static Color get accentBackgroundRed => colorGlobalRed50;
  static Color get accentBackgroundOrange => colorGlobalOrange50;
  static Color get accentBackgroundYellow => colorGlobalYellow50;
  static Color get accentBackgroundLime => colorGlobalLime50;
  static Color get accentBackgroundCyan => colorGlobalCyan50;
  static Color get accentBackgroundBlue => colorGlobalBlue50;
  static Color get accentBackgroundPink => colorGlobalPink50;
  static Color get accentBackgroundBrown => const Color(0xFFAD683D);
  static Color get accentBackgroundViolet => colorGlobalViolet50;

  // Accent Foreground Colors
  static Color get accentForegroundRed => colorGlobalRed40;
  static Color get accentForegroundOrange => colorGlobalOrange39;
  static Color get accentForegroundYellow => colorGlobalYellow40;
  static Color get accentForegroundLime => colorGlobalLime37;
  static Color get accentForegroundGreen => colorGlobalGreen40;
  static Color get accentForegroundCyan => colorGlobalCyan40;
  static Color get accentForegroundLightBlue => colorGlobalLightBlue40;
  static Color get accentForegroundBlue => colorGlobalBlue45;
  static Color get accentForegroundViolet => colorGlobalViolet45;
  static Color get accentForegroundPink => colorGlobalPink46;

  // Inverse Colors
  static Color get inversePrimary => colorGlobalViolet50;
  static Color get inverseBackground => colorGlobalCoolNeutral15;
  static Color get inverseLabelNormal => colorGlobalCoolNeutral99;
  static Color get inverseLabelStrong => colorGlobalCommon100;
  static Color get inverseLabelNeutral =>
      const Color(0xFFC2C4C8).withOpacity(0.88);
  static Color get inverseLabelAlternative =>
      const Color(0xFFAEB0B6).withOpacity(0.61);
  static Color get inverseLabelAssistive =>
      const Color(0xFFAEB0B6).withOpacity(0.35);
  static Color get inverseLabelDisable =>
      const Color(0xFF989BA2).withOpacity(0.16);

  // Static Label Colors (Black)
  static Color get staticLabelBlackNormal => colorGlobalCoolNeutral10;
  static Color get staticLabelBlackStrong => colorGlobalCommon0;
  static Color get staticLabelBlackNeutral =>
      const Color(0xFF2E2F33).withOpacity(0.88);
  static Color get staticLabelBlackAlternative =>
      const Color(0xFF37383C).withOpacity(0.61);
  static Color get staticLabelBlackAssistive =>
      const Color(0xFF37383C).withOpacity(0.35);
  static Color get staticLabelBlackDisable =>
      const Color(0xFF37383C).withOpacity(0.16);

  // Static Label Colors (White)
  static Color get staticLabelWhiteNormal => colorGlobalCoolNeutral99;
  static Color get staticLabelWhiteStrong => colorGlobalCommon100;
  static Color get staticLabelWhiteNeutral =>
      const Color(0xFFC2C4C8).withOpacity(0.88);
  static Color get staticLabelWhiteAlternative =>
      const Color(0xFFAEB0B6).withOpacity(0.61);
  static Color get staticLabelWhiteAssistive =>
      const Color(0xFFAEB0B6).withOpacity(0.35);
  static Color get staticLabelWhiteDisable =>
      const Color(0xFF989BA2).withOpacity(0.16);

  // Component Colors
  static Color get componentFillNormal =>
      const Color(0xFF70737C).withOpacity(0.08);
  static Color get componentFillStrong =>
      const Color(0xFF70737C).withOpacity(0.16);
  static Color get componentFillAlternative =>
      const Color(0xFF70737C).withOpacity(0.05);
  static Color get componentFillScroll =>
      const Color(0xFF4D4D4D).withOpacity(0.6);
  static Color get componentMaterialDimmer =>
      const Color(0xFF171719).withOpacity(0.52);

  // ===== SOCIAL LOGIN COLORS =====

  /// Kakao yellow - official brand color
  static const Color socialKakao = Color(0xFFFEE500);

  /// Naver green - official brand color
  static const Color socialNaver = Color(0xFF03C75A);

  /// Apple black - official brand color
  static const Color socialApple = Color(0xFF000000);

  /// Apple white - for dark mode
  static const Color socialAppleWhite = Color(0xFFFFFFFF);

  // ===== DARK MODE SUPPORT =====

  // Dark Mode Primary Colors
  static Color get darkPrimaryNormal => colorGlobalViolet60;
  static Color get darkPrimarySecondary => colorGlobalViolet70;
  static Color get darkPrimaryStrong => colorGlobalViolet55;
  static Color get darkPrimaryHeavy => colorGlobalViolet50;
  static Color get darkPrimaryLight => colorGlobalViolet20;

  // Dark Mode Background Colors
  static Color get darkBackgroundNormalNormal => colorGlobalCoolNeutral15;
  static Color get darkBackgroundNormalAlternative => colorGlobalCoolNeutral5;
  static Color get darkBackgroundElevatedNormal => colorGlobalCoolNeutral17;
  static Color get darkBackgroundElevatedAlternative => colorGlobalCoolNeutral7;
  static Color get darkBackgroundOpacity75 =>
      const Color(0xFF000000).withOpacity(0.75);

  // Dark Mode Label Colors
  static Color get darkLabelNormal => colorGlobalCoolNeutral99;
  static Color get darkLabelStrong => colorGlobalCommon100;
  static Color get darkLabelNeutral =>
      const Color(0xFFC2C4C8).withOpacity(0.88);
  static Color get darkLabelAlternative =>
      const Color(0xFFAEB0B6).withOpacity(0.61);
  static Color get darkLabelAssistive =>
      const Color(0xFFAEB0B6).withOpacity(0.28);
  static Color get darkLabelDisable =>
      const Color(0xFF989BA2).withOpacity(0.16);

  // Dark Mode Interaction Colors
  static Color get darkInteractionInactive => colorGlobalCoolNeutral40;
  static Color get darkInteractionDisable =>
      const Color(0xFF2E2F33).withOpacity(0.5);

  // Dark Mode Line Colors
  static Color get darkLineNormalNormal =>
      const Color(0xFF70737C).withOpacity(0.32);
  static Color get darkLineNormalNeutral =>
      const Color(0xFF70737C).withOpacity(0.28);
  static Color get darkLineNormalAlternative =>
      const Color(0xFF70737C).withOpacity(0.22);
  static Color get darkLineSolidNormal => colorGlobalCoolNeutral25;
  static Color get darkLineSolidNeutral => colorGlobalCoolNeutral23;
  static Color get darkLineSolidAlternative => colorGlobalCoolNeutral22;

  // Dark Mode Status Colors
  static Color get darkStatusPositive => colorGlobalGreen60;
  static Color get darkStatusPositiveBlue => colorGlobalGreen60;
  static Color get darkStatusCautionary => colorGlobalOrange60;
  static Color get darkStatusNegative => colorGlobalRed60;

  // Dark Mode Component Colors
  static Color get darkComponentFillNormal =>
      const Color(0xFF70737C).withOpacity(0.22);
  static Color get darkComponentFillStrong =>
      const Color(0xFF70737C).withOpacity(0.28);
  static Color get darkComponentFillAlternative =>
      const Color(0xFF70737C).withOpacity(0.12);
  static Color get darkComponentFillScroll =>
      const Color(0xFF3E3E3E).withOpacity(0.6);
  static Color get darkComponentMaterialDimmer =>
      const Color(0xFF171719).withOpacity(0.74);

  // Helper method to apply opacity to any color
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // Convenience method to get theme-appropriate colors
  static Color getThemeColor({
    required Color lightColor,
    required Color darkColor,
    bool isDarkMode = false,
  }) {
    return isDarkMode ? darkColor : lightColor;
  }
}
