import 'package:flutter/material.dart';

/// Color 토큰 — Figma 디자인 시스템 기준.
///
/// 2계층 구조:
/// - **Palette** (`colorGlobal*`): 원시 컬러. Figma `tokens/Palette/Mode 1.json`.
/// - **Semantic** Light/Dark: 의미 토큰. `dark*` prefix로 다크 모드 구분.
class AppColor {
  AppColor._();

  // ═══════════════════════════════════════════════════════════════
  // PALETTE — 원시 컬러
  // ═══════════════════════════════════════════════════════════════

  // Common
  static const Color colorGlobalCommon100 = Color(0xFFFFFFFF);
  static const Color colorGlobalCommon0 = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Neutral (14단계)
  static const Color colorGlobalNeutral99 = Color(0xFFF7F7F7);
  static const Color colorGlobalNeutral95 = Color(0xFFDCDCDC);
  static const Color colorGlobalNeutral90 = Color(0xFFC4C4C4);
  static const Color colorGlobalNeutral80 = Color(0xFFB0B0B0);
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

  // Cool Neutral (21단계)
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

  // Blue (13단계)
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

  // Red (11단계)
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

  // Green (11단계)
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

  // Orange (12단계, 39 hidden 포함)
  static const Color colorGlobalOrange99 = Color(0xFFFFFCF7);
  static const Color colorGlobalOrange95 = Color(0xFFFEF4E6);
  static const Color colorGlobalOrange90 = Color(0xFFFEE6C6);
  static const Color colorGlobalOrange80 = Color(0xFFFFD49C);
  static const Color colorGlobalOrange70 = Color(0xFFFFC06E);
  static const Color colorGlobalOrange60 = Color(0xFFFFA938);
  static const Color colorGlobalOrange50 = Color(0xFFFF9200);
  static const Color colorGlobalOrange40 = Color(0xFFD47800);
  static const Color colorGlobalOrange39 = Color(0xFFD17600);
  static const Color colorGlobalOrange30 = Color(0xFF9C5800);
  static const Color colorGlobalOrange20 = Color(0xFF663A00);
  static const Color colorGlobalOrange10 = Color(0xFF361E00);

  // Yellow (11단계)
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

  // Lime (12단계, 37 hidden 포함)
  static const Color colorGlobalLime99 = Color(0xFFF8FFF2);
  static const Color colorGlobalLime95 = Color(0xFFE6FFD4);
  static const Color colorGlobalLime90 = Color(0xFFCCFCA9);
  static const Color colorGlobalLime80 = Color(0xFFAEF779);
  static const Color colorGlobalLime70 = Color(0xFF88F03E);
  static const Color colorGlobalLime60 = Color(0xFF6BE016);
  static const Color colorGlobalLime50 = Color(0xFF58CF04);
  static const Color colorGlobalLime40 = Color(0xFF48AD00);
  static const Color colorGlobalLime37 = Color(0xFF429E00);
  static const Color colorGlobalLime30 = Color(0xFF347D00);
  static const Color colorGlobalLime20 = Color(0xFF225200);
  static const Color colorGlobalLime10 = Color(0xFF112900);

  // Cyan (11단계)
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

  // Light Blue (11단계)
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

  // Violet (13단계, 브랜드 Primary)
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

  // Pink (12단계, 46 hidden 포함)
  static const Color colorGlobalPink99 = Color(0xFFFFFAFE);
  static const Color colorGlobalPink95 = Color(0xFFFEECFB);
  static const Color colorGlobalPink90 = Color(0xFFFED3F7);
  static const Color colorGlobalPink80 = Color(0xFFFFB8F3);
  static const Color colorGlobalPink70 = Color(0xFFFF94ED);
  static const Color colorGlobalPink60 = Color(0xFFFA73E3);
  static const Color colorGlobalPink50 = Color(0xFFF553DA);
  static const Color colorGlobalPink46 = Color(0xFFE846CD);
  static const Color colorGlobalPink40 = Color(0xFFD331B8);
  static const Color colorGlobalPink30 = Color(0xFFA81690);
  static const Color colorGlobalPink20 = Color(0xFF730560);
  static const Color colorGlobalPink10 = Color(0xFF3D0133);

  // Opacity
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

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC — Light Mode
  // ═══════════════════════════════════════════════════════════════

  // Primary
  static final Color primaryNormal = colorGlobalViolet50;
  static final Color primarySecondary = colorGlobalViolet70;
  static final Color primaryStrong = colorGlobalViolet45;
  static final Color primaryHeavy = colorGlobalViolet40;
  static final Color primaryLight = colorGlobalViolet95;

  // Label
  static final Color labelNormal = colorGlobalCoolNeutral10;
  static final Color labelStrong = colorGlobalCommon0;
  static final Color labelNeutral = const Color(0xFF2E2F33).withValues(alpha: 0.88);
  static final Color labelAlternative = const Color(0xFF37383C).withValues(alpha: 0.61);
  static final Color labelAssistive = const Color(0xFF37383C).withValues(alpha: 0.35);
  static final Color labelDisable = const Color(0xFF37383C).withValues(alpha: 0.16);

  // Background
  static final Color backgroundNormalNormal = colorGlobalCommon100;
  static final Color backgroundNormalAlternative = colorGlobalCoolNeutral99;
  static final Color backgroundElevatedNormal = colorGlobalCommon100;
  static final Color backgroundElevatedAlternative = colorGlobalCoolNeutral99;
  static final Color backgroundOpacity75 = const Color(0xFFFFFFFF).withValues(alpha: 0.75);
  static const Color backgroundTimer = Color(0xFF333333);

  // Interaction
  static final Color interactionInactive = colorGlobalCoolNeutral70;
  static final Color interactionDisable = const Color(0xFFF4F4F5).withValues(alpha: 0.5);

  // Line
  static final Color lineNormalNormal = const Color(0xFF70737C).withValues(alpha: 0.22);
  static final Color lineNormalNeutral = const Color(0xFF70737C).withValues(alpha: 0.16);
  static final Color lineNormalAlternative = const Color(0xFF70737C).withValues(alpha: 0.08);
  static final Color lineSolidNormal = colorGlobalCoolNeutral96;
  static final Color lineSolidNeutral = colorGlobalCoolNeutral97;
  static final Color lineSolidAlternative = colorGlobalCoolNeutral98;

  // Status
  static final Color statusPositive = colorGlobalGreen50;
  static final Color statusPositiveBlue = colorGlobalBlue50;
  static final Color statusCautionary = colorGlobalOrange50;
  static final Color statusNegative = colorGlobalRed50;

  // Accent Background
  static final Color accentBackgroundRed = colorGlobalRed50;
  static final Color accentBackgroundOrange = colorGlobalOrange50;
  static final Color accentBackgroundYellow = colorGlobalYellow50;
  static final Color accentBackgroundLime = colorGlobalLime50;
  static final Color accentBackgroundCyan = colorGlobalCyan50;
  static final Color accentBackgroundBlue = colorGlobalBlue50;
  static final Color accentBackgroundPink = colorGlobalPink50;
  static final Color accentBackgroundBrown = const Color(0xFFAD683D);
  static final Color accentBackgroundBrownLight = const Color(0xFFF5E6D9);
  static final Color accentBackgroundViolet = colorGlobalViolet50;

  // Accent Foreground
  static final Color accentForegroundRed = colorGlobalRed40;
  static final Color accentForegroundOrange = colorGlobalOrange39;
  static final Color accentForegroundYellow = colorGlobalYellow40;
  static final Color accentForegroundLime = colorGlobalLime37;
  static final Color accentForegroundGreen = colorGlobalGreen40;
  static final Color accentForegroundCyan = colorGlobalCyan40;
  static final Color accentForegroundLightBlue = colorGlobalLightBlue40;
  static final Color accentForegroundBlue = colorGlobalBlue45;
  static final Color accentForegroundViolet = colorGlobalViolet45;
  static final Color accentForegroundPink = colorGlobalPink46;

  // Inverse
  static final Color inversePrimary = colorGlobalViolet50;
  static final Color inverseBackground = colorGlobalCoolNeutral15;
  static final Color inverseLabelNormal = colorGlobalCoolNeutral99;
  static final Color inverseLabelStrong = colorGlobalCommon100;
  static final Color inverseLabelNeutral = const Color(0xFFC2C4C8).withValues(alpha: 0.88);
  static final Color inverseLabelAlternative = const Color(0xFFAEB0B6).withValues(alpha: 0.61);
  static final Color inverseLabelAssistive = const Color(0xFFAEB0B6).withValues(alpha: 0.35);
  static final Color inverseLabelDisable = const Color(0xFF989BA2).withValues(alpha: 0.16);

  // Static Label (Black)
  static final Color staticLabelBlackNormal = colorGlobalCoolNeutral10;
  static final Color staticLabelBlackStrong = colorGlobalCommon0;
  static final Color staticLabelBlackNeutral = const Color(0xFF2E2F33).withValues(alpha: 0.88);
  static final Color staticLabelBlackAlternative = const Color(0xFF37383C).withValues(alpha: 0.61);
  static final Color staticLabelBlackAssistive = const Color(0xFF37383C).withValues(alpha: 0.35);
  static final Color staticLabelBlackDisable = const Color(0xFF37383C).withValues(alpha: 0.16);

  // Static Label (White)
  static final Color staticLabelWhiteNormal = colorGlobalCoolNeutral99;
  static final Color staticLabelWhiteStrong = colorGlobalCommon100;
  static final Color staticLabelWhiteNeutral = const Color(0xFFC2C4C8).withValues(alpha: 0.88);
  static final Color staticLabelWhiteAlternative = const Color(0xFFAEB0B6).withValues(alpha: 0.61);
  static final Color staticLabelWhiteAssistive = const Color(0xFFAEB0B6).withValues(alpha: 0.35);
  static final Color staticLabelWhiteDisable = const Color(0xFF989BA2).withValues(alpha: 0.16);

  // Component
  static final Color componentFillNormal = const Color(0xFF70737C).withValues(alpha: 0.08);
  static final Color componentFillStrong = const Color(0xFF70737C).withValues(alpha: 0.16);
  static final Color componentFillAlternative = const Color(0xFF70737C).withValues(alpha: 0.05);
  static final Color componentFillScroll = const Color(0xFF4D4D4D).withValues(alpha: 0.6);
  static final Color componentMaterialDimmer = const Color(0xFF171719).withValues(alpha: 0.52);

  // Social
  static const Color socialKakao = Color(0xFFFEE500);
  static const Color socialNaver = Color(0xFF03C75A);
  static const Color socialApple = Color(0xFF000000);
  static const Color socialAppleWhite = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC — Dark Mode
  // ═══════════════════════════════════════════════════════════════

  // Dark Primary
  static final Color darkPrimaryNormal = colorGlobalViolet60;
  static final Color darkPrimarySecondary = colorGlobalViolet70;
  static final Color darkPrimaryStrong = colorGlobalViolet55;
  static final Color darkPrimaryHeavy = colorGlobalViolet50;
  static final Color darkPrimaryLight = colorGlobalViolet20;

  // Dark Background
  static final Color darkBackgroundNormalNormal = colorGlobalCoolNeutral15;
  static final Color darkBackgroundNormalAlternative = colorGlobalCoolNeutral5;
  static final Color darkBackgroundElevatedNormal = colorGlobalCoolNeutral17;
  static final Color darkBackgroundElevatedAlternative = colorGlobalCoolNeutral7;
  static final Color darkBackgroundOpacity75 = const Color(0xFF000000).withValues(alpha: 0.75);

  // Dark Label
  static final Color darkLabelNormal = colorGlobalCoolNeutral99;
  static final Color darkLabelStrong = colorGlobalCommon100;
  static final Color darkLabelNeutral = const Color(0xFFC2C4C8).withValues(alpha: 0.88);
  static final Color darkLabelAlternative = const Color(0xFFAEB0B6).withValues(alpha: 0.61);
  static final Color darkLabelAssistive = const Color(0xFFAEB0B6).withValues(alpha: 0.28);
  static final Color darkLabelDisable = const Color(0xFF989BA2).withValues(alpha: 0.16);

  // Dark Interaction
  static final Color darkInteractionInactive = colorGlobalCoolNeutral40;
  static final Color darkInteractionDisable = const Color(0xFF2E2F33).withValues(alpha: 0.5);

  // Dark Line
  static final Color darkLineNormalNormal = const Color(0xFF70737C).withValues(alpha: 0.32);
  static final Color darkLineNormalNeutral = const Color(0xFF70737C).withValues(alpha: 0.28);
  static final Color darkLineNormalAlternative = const Color(0xFF70737C).withValues(alpha: 0.22);
  static final Color darkLineSolidNormal = colorGlobalCoolNeutral25;
  static final Color darkLineSolidNeutral = colorGlobalCoolNeutral23;
  static final Color darkLineSolidAlternative = colorGlobalCoolNeutral22;

  // Dark Status
  static final Color darkStatusPositive = colorGlobalGreen60;
  static final Color darkStatusPositiveBlue = colorGlobalBlue60;
  static final Color darkStatusCautionary = colorGlobalOrange60;
  static final Color darkStatusNegative = colorGlobalRed60;

  // Dark Component
  static final Color darkComponentFillNormal = const Color(0xFF70737C).withValues(alpha: 0.22);
  static final Color darkComponentFillStrong = const Color(0xFF70737C).withValues(alpha: 0.28);
  static final Color darkComponentFillAlternative = const Color(0xFF70737C).withValues(alpha: 0.12);
  static final Color darkComponentFillScroll = const Color(0xFF3E3E3E).withValues(alpha: 0.6);
  static final Color darkComponentMaterialDimmer = const Color(0xFF171719).withValues(alpha: 0.74);

  // Dark Static Label (Black)
  static final Color darkStaticLabelBlackNormal = colorGlobalNeutral10;
  static final Color darkStaticLabelBlackStrong = colorGlobalCommon0;
  static final Color darkStaticLabelBlackNeutral = const Color(0xFF2E2F33).withValues(alpha: 0.88);
  static final Color darkStaticLabelBlackAlternative = const Color(0xFF37383C).withValues(alpha: 0.61);
  static final Color darkStaticLabelBlackAssistive = const Color(0xFF37383C).withValues(alpha: 0.28);
  static final Color darkStaticLabelBlackDisable = const Color(0xFF37383C).withValues(alpha: 0.16);

  // Dark Static Label (White)
  static final Color darkStaticLabelWhiteNormal = colorGlobalCoolNeutral99;
  static final Color darkStaticLabelWhiteStrong = colorGlobalCommon100;
  static final Color darkStaticLabelWhiteNeutral = const Color(0xFFC2C4C8).withValues(alpha: 0.88);
  static final Color darkStaticLabelWhiteAlternative = const Color(0xFFAEB0B6).withValues(alpha: 0.61);
  static final Color darkStaticLabelWhiteAssistive = const Color(0xFFAEB0B6).withValues(alpha: 0.35);
  static final Color darkStaticLabelWhiteDisable = const Color(0xFF989BA2).withValues(alpha: 0.16);

  // Dark Accent Background
  static final Color darkAccentBackgroundRed = colorGlobalRed60;
  static final Color darkAccentBackgroundOrange = colorGlobalOrange60;
  static final Color darkAccentBackgroundYellow = colorGlobalYellow60;
  static final Color darkAccentBackgroundLime = colorGlobalLime60;
  static final Color darkAccentBackgroundCyan = colorGlobalCyan60;
  static final Color darkAccentBackgroundBlue = colorGlobalBlue60;
  static final Color darkAccentBackgroundPink = colorGlobalPink60;
  static final Color darkAccentBackgroundBrown = const Color(0xFFC27545);
  static final Color darkAccentBackgroundViolet = colorGlobalViolet50;

  // Dark Accent Foreground
  static final Color darkAccentForegroundRed = colorGlobalRed60;
  static final Color darkAccentForegroundOrange = colorGlobalOrange50;
  static final Color darkAccentForegroundYellow = colorGlobalYellow60;
  static final Color darkAccentForegroundLime = colorGlobalLime50;
  static final Color darkAccentForegroundGreen = colorGlobalGreen60;
  static final Color darkAccentForegroundCyan = colorGlobalCyan50;
  static final Color darkAccentForegroundLightBlue = colorGlobalLightBlue50;
  static final Color darkAccentForegroundBlue = colorGlobalBlue60;
  static final Color darkAccentForegroundViolet = colorGlobalViolet70;
  static final Color darkAccentForegroundPink = colorGlobalPink60;

  // Dark Inverse
  static final Color darkInversePrimary = colorGlobalViolet50;
  static final Color darkInverseBackground = colorGlobalCommon100;
  static final Color darkInverseLabelNormal = colorGlobalCoolNeutral10;
  static final Color darkInverseLabelStrong = colorGlobalCommon0;
  static final Color darkInverseLabelNeutral = const Color(0xFF2E2F33).withValues(alpha: 0.88);
  static final Color darkInverseLabelAlternative = const Color(0xFF37383C).withValues(alpha: 0.61);
  static final Color darkInverseLabelAssistive = const Color(0xFF37383C).withValues(alpha: 0.35);
  static final Color darkInverseLabelDisable = const Color(0xFF37383C).withValues(alpha: 0.16);
}
