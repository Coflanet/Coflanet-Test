import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'app_color.dart';

import '_swatch.dart';

/// Semantic 컬러 use_cases — 위젯북의 ThemeAddon에 따라 자동 전환됨.
///
/// `Theme.of(context).brightness`로 현재 모드를 감지해서 light/dark 토큰을
/// 분기. 위젯북 상단의 Theme 셀렉터로 라이트/다크 전환 가능.
final List<WidgetbookComponent> semanticUseCases = [
  WidgetbookComponent(
    name: 'Primary',
    useCases: [
      WidgetbookUseCase(
        name: '브랜드 Primary 5단계',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('primaryNormal', AppColor.darkPrimaryNormal),
                      ('primaryStrong', AppColor.darkPrimaryStrong),
                      ('primaryHeavy', AppColor.darkPrimaryHeavy),
                      ('primaryLight', AppColor.darkPrimaryLight),
                      ('primarySecondary', AppColor.darkPrimarySecondary),
                    ]
                  : [
                      ('primaryNormal', AppColor.primaryNormal),
                      ('primaryStrong', AppColor.primaryStrong),
                      ('primaryHeavy', AppColor.primaryHeavy),
                      ('primaryLight', AppColor.primaryLight),
                      ('primarySecondary', AppColor.primarySecondary),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Label',
    useCases: [
      WidgetbookUseCase(
        name: '6단계 — normal/strong/neutral/alternative/assistive/disable',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('labelNormal', AppColor.darkLabelNormal),
                      ('labelStrong', AppColor.darkLabelStrong),
                      ('labelNeutral', AppColor.darkLabelNeutral),
                      ('labelAlternative', AppColor.darkLabelAlternative),
                      ('labelAssistive', AppColor.darkLabelAssistive),
                      ('labelDisable', AppColor.darkLabelDisable),
                    ]
                  : [
                      ('labelNormal', AppColor.labelNormal),
                      ('labelStrong', AppColor.labelStrong),
                      ('labelNeutral', AppColor.labelNeutral),
                      ('labelAlternative', AppColor.labelAlternative),
                      ('labelAssistive', AppColor.labelAssistive),
                      ('labelDisable', AppColor.labelDisable),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Background',
    useCases: [
      WidgetbookUseCase(
        name: 'normal / elevated / opacity',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('bgNormal', AppColor.darkBackgroundNormalNormal),
                      ('bgNormalAlt',
                          AppColor.darkBackgroundNormalAlternative),
                      ('bgElevated', AppColor.darkBackgroundElevatedNormal),
                      ('bgElevatedAlt',
                          AppColor.darkBackgroundElevatedAlternative),
                      ('bgOpacity75', AppColor.darkBackgroundOpacity75),
                    ]
                  : [
                      ('bgNormal', AppColor.backgroundNormalNormal),
                      ('bgNormalAlt', AppColor.backgroundNormalAlternative),
                      ('bgElevated', AppColor.backgroundElevatedNormal),
                      ('bgElevatedAlt',
                          AppColor.backgroundElevatedAlternative),
                      ('bgOpacity75', AppColor.backgroundOpacity75),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Status',
    useCases: [
      WidgetbookUseCase(
        name: '4단계 — positive/positiveBlue/cautionary/negative',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('statusPositive', AppColor.darkStatusPositive),
                      ('statusPositiveBlue', AppColor.darkStatusPositiveBlue),
                      ('statusCautionary', AppColor.darkStatusCautionary),
                      ('statusNegative', AppColor.darkStatusNegative),
                    ]
                  : [
                      ('statusPositive', AppColor.statusPositive),
                      ('statusPositiveBlue', AppColor.statusPositiveBlue),
                      ('statusCautionary', AppColor.statusCautionary),
                      ('statusNegative', AppColor.statusNegative),
                    ],
              crossAxisCount: 4,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Line',
    useCases: [
      WidgetbookUseCase(
        name: 'solid (실선) + normal (반투명)',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('solidNormal', AppColor.darkLineSolidNormal),
                      ('solidNeutral', AppColor.darkLineSolidNeutral),
                      ('solidAlternative', AppColor.darkLineSolidAlternative),
                      ('lineNormal', AppColor.darkLineNormalNormal),
                      ('lineNeutral', AppColor.darkLineNormalNeutral),
                      ('lineAlternative', AppColor.darkLineNormalAlternative),
                    ]
                  : [
                      ('solidNormal', AppColor.lineSolidNormal),
                      ('solidNeutral', AppColor.lineSolidNeutral),
                      ('solidAlternative', AppColor.lineSolidAlternative),
                      ('lineNormal', AppColor.lineNormalNormal),
                      ('lineNeutral', AppColor.lineNormalNeutral),
                      ('lineAlternative', AppColor.lineNormalAlternative),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Component',
    useCases: [
      WidgetbookUseCase(
        name: 'fill / scroll / dimmer',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('fillNormal', AppColor.darkComponentFillNormal),
                      ('fillStrong', AppColor.darkComponentFillStrong),
                      ('fillAlternative',
                          AppColor.darkComponentFillAlternative),
                      ('fillScroll', AppColor.darkComponentFillScroll),
                      ('dimmer', AppColor.darkComponentMaterialDimmer),
                    ]
                  : [
                      ('fillNormal', AppColor.componentFillNormal),
                      ('fillStrong', AppColor.componentFillStrong),
                      ('fillAlternative', AppColor.componentFillAlternative),
                      ('fillScroll', AppColor.componentFillScroll),
                      ('dimmer', AppColor.componentMaterialDimmer),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Interaction',
    useCases: [
      WidgetbookUseCase(
        name: 'disable / inactive',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('disable', AppColor.darkInteractionDisable),
                      ('inactive', AppColor.darkInteractionInactive),
                    ]
                  : [
                      ('disable', AppColor.interactionDisable),
                      ('inactive', AppColor.interactionInactive),
                    ],
              crossAxisCount: 2,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Accent',
    useCases: [
      WidgetbookUseCase(
        name: 'Background (9개)',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('Red', AppColor.darkAccentBackgroundRed),
                      ('Orange', AppColor.darkAccentBackgroundOrange),
                      ('Yellow', AppColor.darkAccentBackgroundYellow),
                      ('Lime', AppColor.darkAccentBackgroundLime),
                      ('Cyan', AppColor.darkAccentBackgroundCyan),
                      ('Blue', AppColor.darkAccentBackgroundBlue),
                      ('Pink', AppColor.darkAccentBackgroundPink),
                      ('Brown', AppColor.darkAccentBackgroundBrown),
                      ('Violet', AppColor.darkAccentBackgroundViolet),
                    ]
                  : [
                      ('Red', AppColor.accentBackgroundRed),
                      ('Orange', AppColor.accentBackgroundOrange),
                      ('Yellow', AppColor.accentBackgroundYellow),
                      ('Lime', AppColor.accentBackgroundLime),
                      ('Cyan', AppColor.accentBackgroundCyan),
                      ('Blue', AppColor.accentBackgroundBlue),
                      ('Pink', AppColor.accentBackgroundPink),
                      ('Brown', AppColor.accentBackgroundBrown),
                      ('Violet', AppColor.accentBackgroundViolet),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
      WidgetbookUseCase(
        name: 'Foreground (10개)',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('Red', AppColor.darkAccentForegroundRed),
                      ('Orange', AppColor.darkAccentForegroundOrange),
                      ('Yellow', AppColor.darkAccentForegroundYellow),
                      ('Lime', AppColor.darkAccentForegroundLime),
                      ('Green', AppColor.darkAccentForegroundGreen),
                      ('Cyan', AppColor.darkAccentForegroundCyan),
                      ('LightBlue', AppColor.darkAccentForegroundLightBlue),
                      ('Blue', AppColor.darkAccentForegroundBlue),
                      ('Violet', AppColor.darkAccentForegroundViolet),
                      ('Pink', AppColor.darkAccentForegroundPink),
                    ]
                  : [
                      ('Red', AppColor.accentForegroundRed),
                      ('Orange', AppColor.accentForegroundOrange),
                      ('Yellow', AppColor.accentForegroundYellow),
                      ('Lime', AppColor.accentForegroundLime),
                      ('Green', AppColor.accentForegroundGreen),
                      ('Cyan', AppColor.accentForegroundCyan),
                      ('LightBlue', AppColor.accentForegroundLightBlue),
                      ('Blue', AppColor.accentForegroundBlue),
                      ('Violet', AppColor.accentForegroundViolet),
                      ('Pink', AppColor.accentForegroundPink),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Static Label',
    useCases: [
      WidgetbookUseCase(
        name: 'Black (배경 무관 항상 검정 계열)',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('blackNormal', AppColor.darkStaticLabelBlackNormal),
                      ('blackStrong', AppColor.darkStaticLabelBlackStrong),
                      ('blackNeutral', AppColor.darkStaticLabelBlackNeutral),
                      ('blackAlternative',
                          AppColor.darkStaticLabelBlackAlternative),
                      ('blackAssistive',
                          AppColor.darkStaticLabelBlackAssistive),
                      ('blackDisable', AppColor.darkStaticLabelBlackDisable),
                    ]
                  : [
                      ('blackNormal', AppColor.staticLabelBlackNormal),
                      ('blackStrong', AppColor.staticLabelBlackStrong),
                      ('blackNeutral', AppColor.staticLabelBlackNeutral),
                      ('blackAlternative',
                          AppColor.staticLabelBlackAlternative),
                      ('blackAssistive', AppColor.staticLabelBlackAssistive),
                      ('blackDisable', AppColor.staticLabelBlackDisable),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
      WidgetbookUseCase(
        name: 'White (배경 무관 항상 흰색 계열)',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('whiteNormal', AppColor.darkStaticLabelWhiteNormal),
                      ('whiteStrong', AppColor.darkStaticLabelWhiteStrong),
                      ('whiteNeutral', AppColor.darkStaticLabelWhiteNeutral),
                      ('whiteAlternative',
                          AppColor.darkStaticLabelWhiteAlternative),
                      ('whiteAssistive',
                          AppColor.darkStaticLabelWhiteAssistive),
                      ('whiteDisable', AppColor.darkStaticLabelWhiteDisable),
                    ]
                  : [
                      ('whiteNormal', AppColor.staticLabelWhiteNormal),
                      ('whiteStrong', AppColor.staticLabelWhiteStrong),
                      ('whiteNeutral', AppColor.staticLabelWhiteNeutral),
                      ('whiteAlternative',
                          AppColor.staticLabelWhiteAlternative),
                      ('whiteAssistive', AppColor.staticLabelWhiteAssistive),
                      ('whiteDisable', AppColor.staticLabelWhiteDisable),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Inverse',
    useCases: [
      WidgetbookUseCase(
        name: '현재 모드의 반대 모드 컬러 (Light↔Dark 토글용)',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: swatchGrid(
              isDark
                  ? [
                      ('inversePrimary', AppColor.darkInversePrimary),
                      ('inverseBackground', AppColor.darkInverseBackground),
                      ('inverseLabelNormal', AppColor.darkInverseLabelNormal),
                      ('inverseLabelStrong', AppColor.darkInverseLabelStrong),
                      ('inverseLabelNeutral',
                          AppColor.darkInverseLabelNeutral),
                      ('inverseLabelAlternative',
                          AppColor.darkInverseLabelAlternative),
                      ('inverseLabelAssistive',
                          AppColor.darkInverseLabelAssistive),
                      ('inverseLabelDisable',
                          AppColor.darkInverseLabelDisable),
                    ]
                  : [
                      ('inversePrimary', AppColor.inversePrimary),
                      ('inverseBackground', AppColor.inverseBackground),
                      ('inverseLabelNormal', AppColor.inverseLabelNormal),
                      ('inverseLabelStrong', AppColor.inverseLabelStrong),
                      ('inverseLabelNeutral', AppColor.inverseLabelNeutral),
                      ('inverseLabelAlternative',
                          AppColor.inverseLabelAlternative),
                      ('inverseLabelAssistive',
                          AppColor.inverseLabelAssistive),
                      ('inverseLabelDisable', AppColor.inverseLabelDisable),
                    ],
              crossAxisCount: 3,
            ),
          );
        },
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Brand & Etc',
    useCases: [
      WidgetbookUseCase(
        name: '소셜 로그인 + 특수 (Figma 외부)',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('socialKakao', AppColor.socialKakao),
            ('socialNaver', AppColor.socialNaver),
            ('socialApple', AppColor.socialApple),
            ('backgroundTimer', AppColor.backgroundTimer),
          ], crossAxisCount: 4),
        ),
      ),
    ],
  ),
];
