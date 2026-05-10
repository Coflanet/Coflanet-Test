import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

// Components (atoms)
import 'components/avatars/avatar_use_cases.dart';
import 'components/buttons/button_use_cases.dart';
import 'components/chips/chip_use_cases.dart';
import 'components/dividers/divider_use_cases.dart';
import 'components/indicators/indicator_use_cases.dart';
import 'components/ratio/ratio_use_cases.dart';
import 'components/scrolls/scroll_use_cases.dart';
import 'components/thumbnails/thumbnail_use_cases.dart';

// Tabs & Navigation
import 'components/tabs/app_tab_bar_use_cases.dart';
import 'components/tabs/app_category_use_cases.dart';
import 'components/tabs/app_segmented_control_use_cases.dart';
import 'components/pagination/app_pagination_use_cases.dart';
import 'components/navigation/app_top_navigation_use_cases.dart';
import 'components/navigation/app_bottom_navigation_use_cases.dart';
import 'components/navigation/app_gnb_use_cases.dart';
import 'components/navigation/app_footer_use_cases.dart';

// Selection & Input
import 'components/selection/app_slider_use_cases.dart';
import 'components/selection/app_select_use_cases.dart';

// Control Box
import 'components/control_box/app_control_box_use_cases.dart';

// Gauge
import 'components/gauge/app_gauge_use_cases.dart';

// Feedback
import 'components/feedback/app_toast_use_cases.dart';
import 'components/feedback/app_snackbar_use_cases.dart';
import 'components/feedback/app_tooltip_use_cases.dart';

// Presentation
import 'components/presentation/app_bottom_sheet_use_cases.dart';
import 'components/presentation/app_menu_use_cases.dart';

// Contents
import 'components/contents/app_cell_use_cases.dart';
import 'components/contents/app_accordion_use_cases.dart';
import 'components/contents/app_table_use_cases.dart';

// Molecular (molecules)
import 'components/cards/card_use_cases.dart';
import 'components/controls/control_use_cases.dart';
import 'components/forms/text_field_use_cases.dart';
import 'components/indicators/progress_use_cases.dart';
import 'components/modals/modal_use_cases.dart';

// Foundation (tokens)
import 'foundation/app_theme.dart';
import 'foundation/opacity_use_cases.dart';
import 'foundation/palette_use_cases.dart';
import 'foundation/radius_use_cases.dart';
import 'foundation/semantic_use_cases.dart';
import 'foundation/shadow_use_cases.dart';
import 'foundation/spacing_use_cases.dart';
import 'foundation/typography_use_cases.dart';

/// Coflanet Design System Widgetbook entry point.
///
/// Figma `📚 Library` 페이지 구조에 맞춘 3계층:
/// - **Foundation**: 디자인 토큰 (Color, Typography, Space, Round, Shadow ...).
/// - **Components**: Atoms — 가장 작은 단위 (Button, Chip, Avatar, Divider ...).
/// - **Molecular**: Molecules — atoms 조합 (Selection & Input, Modal ...).
///
/// 실행:
/// ```bash
/// cd Library/component_lab
/// flutter pub get
/// flutter run -d chrome
/// ```
void main() {
  runApp(const ComponentLabApp());
}

class ComponentLabApp extends StatelessWidget {
  const ComponentLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        // ═════════════════════════════════════════════════════════
        // FOUNDATION — 디자인 토큰
        // ═════════════════════════════════════════════════════════
        WidgetbookCategory(
          name: 'Foundation',
          children: [
            WidgetbookFolder(
              name: 'Colors',
              children: [
                ...paletteUseCases,
                ...semanticUseCases,
              ],
            ),
            WidgetbookFolder(
              name: 'Typography',
              children: typographyUseCases,
            ),
            WidgetbookFolder(
              name: 'Space',
              children: spacingUseCases,
            ),
            WidgetbookFolder(
              name: 'Round',
              children: radiusUseCases,
            ),
            WidgetbookFolder(
              name: 'Shadow',
              children: shadowUseCases,
            ),
            WidgetbookFolder(
              name: 'Opacity',
              children: opacityUseCases,
            ),
            // 추후 추가: Gradient / Decorate / Icon / Image / 3D Illustration / Logo
          ],
        ),

        // ═════════════════════════════════════════════════════════
        // COMPONENTS — Atoms (가장 작은 단위)
        // ═════════════════════════════════════════════════════════
        WidgetbookCategory(
          name: 'Components',
          children: [
            WidgetbookFolder(
              name: 'Button',
              children: [
                ...solidButtonUseCases,
                ...outlinedButtonUseCases,
                ...textButtonUseCases,
                ...iconButtonUseCases,
                ...fabUseCases,
                ...sectionBottomUseCases,
              ],
            ),
            WidgetbookFolder(
              name: 'Chip',
              children: [
                ...chipActionUseCases,
                ...chipFilterUseCases,
              ],
            ),
            WidgetbookFolder(
              name: 'Avatar',
              children: avatarUseCases,
            ),
            WidgetbookFolder(
              name: 'Divider',
              children: dividerUseCases,
            ),
            WidgetbookFolder(
              name: 'Ratio',
              children: ratioUseCases,
            ),
            WidgetbookFolder(
              name: 'Thumbnail',
              children: thumbnailUseCases,
            ),
            WidgetbookFolder(
              name: 'Indicators',
              children: [
                ...indicatorUseCases,
                ...homeIndicatorUseCases,
              ],
            ),
            WidgetbookFolder(
              name: 'Scroll',
              children: scrollUseCases,
            ),
          ],
        ),

        // ═════════════════════════════════════════════════════════
        // NAVIGATION & TABS — Navigation components
        // ═════════════════════════════════════════════════════════
        WidgetbookCategory(
          name: 'Navigation',
          children: [
            WidgetbookFolder(
              name: 'Tab Bar',
              children: tabBarUseCases,
            ),
            WidgetbookFolder(
              name: 'Category',
              children: categoryUseCases,
            ),
            WidgetbookFolder(
              name: 'Segmented Control',
              children: segmentedControlUseCases,
            ),
            WidgetbookFolder(
              name: 'Pagination',
              children: paginationUseCases,
            ),
            WidgetbookFolder(
              name: 'Top Navigation',
              children: topNavigationUseCases,
            ),
            WidgetbookFolder(
              name: 'Bottom Navigation',
              children: bottomNavigationUseCases,
            ),
            WidgetbookFolder(
              name: 'GNB',
              children: gnbUseCases,
            ),
            WidgetbookFolder(
              name: 'Footer',
              children: footerUseCases,
            ),
          ],
        ),

        // ═════════════════════════════════════════════════════════
        // MOLECULAR — Molecules (atoms 조합)
        // ═════════════════════════════════════════════════════════
        WidgetbookCategory(
          name: 'Molecular',
          children: [
            WidgetbookFolder(
              name: 'Selection and Input',
              children: [
                ...textFieldUseCases,
                ...switchUseCases,
                ...checkboxUseCases,
                ...radioUseCases,
                ...sliderUseCases,
                ...selectUseCases,
              ],
            ),
            WidgetbookFolder(
              name: 'Control Box',
              children: controlBoxUseCases,
            ),
            WidgetbookFolder(
              name: 'Gauge',
              children: gaugeUseCases,
            ),
            WidgetbookFolder(
              name: 'Feedback',
              children: [
                ...toastUseCases,
                ...snackbarUseCases,
                ...tooltipUseCases,
              ],
            ),
            WidgetbookFolder(
              name: 'Presentation',
              children: [
                ...modalUseCases,
                ...bottomSheetUseCases,
                ...menuUseCases,
              ],
            ),
            WidgetbookFolder(
              name: 'Contents',
              children: [
                ...cardUseCases,
                ...cellUseCases,
                ...accordionUseCases,
                ...tableUseCases,
              ],
            ),
            WidgetbookFolder(
              name: 'Progress Indicators',
              children: progressUseCases,
            ),
          ],
        ),
      ],
      addons: [
        ThemeAddon<ThemeData>(
          themes: [
            WidgetbookTheme(name: 'Light', data: AppTheme.light),
            WidgetbookTheme(name: 'Dark', data: AppTheme.dark),
          ],
          themeBuilder: (context, theme, child) {
            return Theme(data: theme, child: child);
          },
        ),
        TextScaleAddon(scales: const [1.0, 1.15, 1.3]),
        InspectorAddon(),
        AlignmentAddon(),
      ],
    );
  }
}
