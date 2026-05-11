# Code Library Inventory (Phase 2/5)

- **Target**: `Library/component_lab/lib/` (Flutter / Dart 디자인 시스템)
- **Total files**: 121 `.dart`
- **TS/JSX 파일**: 0 (프롬프트 가정과 달리 코드베이스는 Flutter)
- **매핑 정책**: `StatelessWidget`/`StatefulWidget` 클래스 = Component / 생성자 named params = Props / `enum` (+ factory 생성자) = Variants / `foundation/app_*.dart` 클래스 참조 = Design tokens / `*_use_cases.dart` = Widgetbook stories

---

## 📁 디렉토리 트리 (sorted)

```
lib/
├── main.dart                       # Widgetbook 진입점 (ComponentLabApp)
├── component_lab.dart              # 단일 import 배럴 파일 (export)
├── samples/
│   └── sample_screen.dart          # 통합 점검용 SampleLoginScreen
├── foundation/                     # 디자인 토큰 + 테마
│   ├── _swatch.dart                # 토큰 카탈로그용 Swatch 위젯
│   ├── app_color.dart              # AppColor (Palette + Semantic Light/Dark)
│   ├── app_decorate.dart           # AppDecorate, InteractionIntensity/State
│   ├── app_gradient.dart           # AppGradient (Solid/Multiple/Mask)
│   ├── app_radius.dart             # AppRadius (radius2..40 + Pill + semantic)
│   ├── app_shadow.dart             # AppShadows (Primary/Black/Floating)
│   ├── app_spacing.dart            # AppSpacing (palette+semantic+helpers)
│   ├── app_text_style.dart         # AppTextStyles (66 Pretendard styles)
│   ├── app_theme.dart              # AppTheme (Material ThemeData light/dark)
│   ├── coflanet_icons.dart         # CoflanetIcons asset paths + CoflanetIcon
│   ├── opacity_use_cases.dart      # WB: Opacity Scale (15단계)
│   ├── palette_use_cases.dart      # WB: Common/Neutral/Brand/Accent
│   ├── radius_use_cases.dart       # WB: Palette/Semantic/Directional
│   ├── semantic_use_cases.dart     # WB: 11 semantic groups
│   ├── shadow_use_cases.dart       # WB: Black/Primary shadow
│   ├── spacing_use_cases.dart      # WB: 6 spacing groups
│   └── typography_use_cases.dart   # WB: Display..Caption + Emoji
└── components/                     # 21 카테고리
    ├── avatars/      (app_avatar, avatar_use_cases)
    ├── buttons/      (floating/icon/liquid_glass/outlined/section_bottom/social/solid/text + use_cases)
    ├── cards/        (app_card, card_use_cases)
    ├── chips/        (app_chip, action, filter + use_cases)
    ├── contents/     (accordion/banner/cell/coffee_list/coffee_profile/community_list/content_badge/item_list/play_icon_badge/preference_list/recipe_timer/review/section_header/table/tasting_note 15종 + use_cases)
    ├── control_box/  (app_control_box + use_cases)
    ├── controls/     (checkbox/radio/switch + control_use_cases)
    ├── dividers/     (app_divider + use_cases)
    ├── feedback/     (snackbar/toast/tooltip + use_cases)
    ├── forms/        (app_text_field + use_cases)
    ├── gauge/        (app_gauge + use_cases)
    ├── indicators/   (app_indicators, app_progress + use_cases)
    ├── modals/       (app_confirm_dialog + use_cases)
    ├── navigation/   (bottom_navigation/footer/gnb/top_navigation + use_cases)
    ├── pagination/   (app_pagination + use_cases)
    ├── presentation/ (app_bottom_sheet, app_menu + use_cases)
    ├── ratio/        (app_ratio + use_cases)
    ├── scrolls/      (app_scroll_bar + use_cases)
    ├── selection/    (app_select, app_slider + use_cases)
    ├── tabs/         (category/segmented_control/tab_bar + use_cases)
    └── thumbnails/   (app_thumbnail + use_cases)
```

---

## 🛠️ Foundation (Tokens & Theme)

### AppColor
- 파일: `foundation/app_color.dart`
- Kind: `abstract class` (private constructor)
- Props: 정적 토큰만
- Variants: —
- 의존 컴포넌트: —
- 의존 토큰: (self — 2-layer: `colorGlobal*` palette + Light/Dark semantic)

### AppDecorate / InteractionIntensity / InteractionState
- 파일: `foundation/app_decorate.dart`
- Kind: `abstract class` + 2 `enum`
- Variants: `InteractionIntensity{normal, light, strong}`, `InteractionState{normal, hovered, focused, pressed}`
- 의존 토큰: AppColor

### AppGradient
- 파일: `foundation/app_gradient.dart`
- Kind: `abstract class`
- Notes: Solid/Multiple/Mask gradient — 16-stop easing curves

### AppRadius
- 파일: `foundation/app_radius.dart`
- Kind: `abstract class`
- Notes: Palette `radius2..radius40 + Pill` + semantic (Button/Input/Card/Modal/Chip/Checkbox/Avatar) + directional helpers

### AppShadows
- 파일: `foundation/app_shadow.dart`
- Kind: `abstract class`
- Notes: 5-level Primary (Violet) + Black + HeavyBottom + Floating

### AppSpacing
- 파일: `foundation/app_spacing.dart`
- Kind: `abstract class`
- Notes: `space4..space48` + semantic container/element/button/safe-area + `EdgeInsets` 헬퍼

### AppTextStyles
- 파일: `foundation/app_text_style.dart`
- Kind: `abstract class`
- Notes: 66 Pretendard 스타일 (Display/Title/Heading/Headline/Body/Label/Caption + Tabular) + Emoji 5종

### AppTheme
- 파일: `foundation/app_theme.dart`
- Kind: `abstract class`
- 의존 토큰: AppColor, AppRadius, AppTextStyles
- Notes: Material ThemeData light/dark 생성

### CoflanetIcons + CoflanetIcon + CoflanetIconSize
- 파일: `foundation/coflanet_icons.dart`
- Classes:
  - `CoflanetIcons` (abstract — SVG asset path 카탈로그)
  - `CoflanetIcon` (StatelessWidget) — Props: `{ assetPath: String [req, positional], size: CoflanetIconSize, color: Color?, package: String? }`
  - `CoflanetIconSize{tiny, small, medium, normal, large}`
- 의존 토큰: —

### Swatch (내부 헬퍼)
- 파일: `foundation/_swatch.dart`
- Kind: StatelessWidget
- Props: `{ name: String [req], color: Color [req], note: String? }`
- Notes: foundation use_cases 내부에서만 사용

---

## 🧩 Components

### avatars/

#### AppAvatar
- 파일: `components/avatars/app_avatar.dart`
- Props: `{ imageUrl: String?, initials: String?, size: AppAvatarSize, customDiameter: double?, type: AppAvatarType, onTap: VoidCallback? }`
- Variants: `AppAvatarSize{xSmall, small, medium, large, xLarge}`, `AppAvatarType{person, company, academic}`
- 의존 컴포넌트: —
- 의존 토큰: AppColor, AppRadius, AppTextStyles

#### AppAvatarButton
- 파일: `components/avatars/app_avatar.dart`
- Props: `{ imageUrl: String?, showBadge: bool, badge: Widget?, onTap: VoidCallback? }`
- 의존 컴포넌트: AppAvatar
- 의존 토큰: AppColor

#### AppAvatarGroup
- 파일: `components/avatars/app_avatar.dart`
- Props: `{ avatars: List<AppAvatar> [req], overlap: double }`
- 의존 컴포넌트: AppAvatar

### buttons/

#### AppFloatingActionButton
- 파일: `components/buttons/app_floating_action_button.dart`
- Props: `{ icon: IconData [req], onPressed: VoidCallback?, tooltip: String? }`
- Variants: —
- 의존 토큰: AppColor, AppShadows

#### AppIconButton
- 파일: `components/buttons/app_icon_button.dart`
- Props: `{ icon: IconData [req], onPressed, tone: AppIconButtonTone, size: AppIconButtonSize, customSize: double?, showBadge: bool, tooltip: String?, iconColor: Color? }`
- Variants: `AppIconButtonTone{normal, primary, liquidGlassPrimary, liquidGlass, backgroundBlurPrimary, backgroundBlur, liquidGlassGrayPrimary, gray, outlined}`, `AppIconButtonSize{normal, small, custom}`
- 의존 토큰: AppColor, AppRadius

#### AppLiquidGlassButton
- 파일: `components/buttons/app_liquid_glass_button.dart`
- Props: `{ text: String [req], onPressed, leadingIcon: IconData?, trailingIcon: IconData?, size: AppLiquidGlassSize, width: double?, foregroundColor: Color? }`
- Variants: `AppLiquidGlassSize{md, lg, xl}`
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppOutlinedButton
- 파일: `components/buttons/app_outlined_button.dart`
- Props: `{ label: String [req], onPressed, tone: AppOutlinedButtonTone, size: AppOutlinedButtonSize, leftIcon, rightIcon, width }`
- Variants: `AppOutlinedButtonTone{primary, secondary, assistive}`, `AppOutlinedButtonSize{large, medium, small, xsmall}`
- 의존 토큰: AppColor, AppRadius, AppTextStyles

#### AppSectionBottomButton
- 파일: `components/buttons/app_section_bottom_button.dart`
- Props: `{ label: String [req], variant: AppSectionBottomVariant, onPressed, leftIcon, rightIcon, isExpanded: bool, isSlim: bool, useMask: bool }`
- Variants: `AppSectionBottomVariant{topLine, solid, fold}`
- 의존 토큰: AppColor, AppTextStyles

#### AppSocialButton
- 파일: `components/buttons/app_social_button.dart`
- Props: `{ provider: AppSocialProvider [req], onPressed, customText: String?, width: double?, height: double }`
- Variants: `AppSocialProvider{kakao, naver, apple, google}`
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppSolidButton
- 파일: `components/buttons/app_solid_button.dart`
- Props: `{ label: String [req], onPressed, tone: AppSolidButtonTone, size: AppSolidButtonSize, leftIcon, rightIcon, width }`
- Variants: `AppSolidButtonTone{primary, grayPrimary, gray, liquidGlassPrimary, liquidGlass, backgroundBlurPrimary, backgroundBlur}`, `AppSolidButtonSize{large, medium, small, xsmall}`
- 의존 토큰: AppColor, AppRadius, AppTextStyles

#### AppTextButton
- 파일: `components/buttons/app_text_button.dart`
- Props: `{ label: String [req], onPressed, tone: AppTextButtonTone, size: AppTextButtonSize, leftIcon, rightIcon }`
- Variants: `AppTextButtonTone{primary, normal, assistive}`, `AppTextButtonSize{medium, small}`
- 의존 토큰: AppColor, AppTextStyles

### cards/

#### AppCard
- 파일: `components/cards/app_card.dart`
- Props: `{ child: Widget [req], padding: EdgeInsetsGeometry, onTap, variant: AppCardVariant, borderRadius: BorderRadius?, width: double? }`
- Variants: `AppCardVariant{flat, elevated, outlined}`
- 의존 토큰: AppColor, AppRadius, AppShadows, AppSpacing

### chips/

#### AppChip
- 파일: `components/chips/app_chip.dart`
- Props: `{ label: String [req], color: AppChipColor, size: AppChipTagSize, leadingIcon, onTap, onDelete }`
- Variants: `AppChipColor{neutral, primary, red, orange, yellow, lime, green, cyan, lightBlue, blue, pink, violet, brown}`, `AppChipTagSize{sm, md}`
- 의존 토큰: AppColor, AppRadius, AppTextStyles, AppSpacing

#### AppChipAction
- 파일: `components/chips/app_chip_action.dart`
- Props: `{ label: String [req], size: AppChipSize, variant: AppChipActionVariant, leadingIcon, trailingIcon, isActive: bool, onPressed }`
- Variants: `AppChipSize{xsmall, small, medium, large}`, `AppChipActionVariant{solid, outlined}`
- 의존 토큰: AppColor, AppTextStyles

#### AppChipFilter
- 파일: `components/chips/app_chip_filter.dart`
- Props: `{ label: String [req], size: AppChipSize, variant: AppChipFilterVariant, state: AppChipFilterState, isActive: bool, count: int?, onPressed }`
- Variants: `AppChipFilterVariant{solid, outlined}`, `AppChipFilterState{normal, expand}`, `AppChipSize{xsmall, small, medium, large}`
- 의존 컴포넌트: (AppChipSize re-export from action)
- 의존 토큰: AppColor, AppTextStyles

### contents/

#### AppAccordion
- 파일: `components/contents/app_accordion.dart`
- Props: `{ title: String [req], content: Widget [req], subtitle: String?, leading: Widget?, initiallyExpanded: bool, isComplete: bool, fillWidth: bool, padding: AppAccordionPadding, onExpansionChanged }`
- Variants: `AppAccordionPadding{large, medium}`
- 의존 토큰: AppColor, AppSpacing, AppTextStyles

#### AppBanner
- 파일: `components/contents/app_banner.dart`
- Props: `{ title: String [req], body: String?, layout: AppBannerLayout, aspectRatio: double, background: Widget?, thumbnail: Widget?, onTap }`
- Variants: `AppBannerLayout{hero, compact}`
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppCell
- 파일: `components/contents/app_cell.dart`
- Props: `{ title: String [req], subtitle?, description?, leading?, trailing?, onTap, verticalPadding: AppCellVerticalPadding, verticalAlign: AppCellVerticalAlign, fillWidth, textEllipsis, isActive, isDisabled }`
- Variants: `AppCellVerticalPadding{medium, large, small}`, `AppCellVerticalAlign{top, center}`
- 의존 토큰: AppColor, AppDecorate, AppSpacing, AppTextStyles

#### AppCoffeeListItem
- 파일: `components/contents/app_coffee_list.dart`
- Props: `{ brand: String [req], name: String [req], price: int?, discountPercent: int?, attributes: Map<String,double>?, compared: Map<String,double>?, flavorNotes: List<String>, expanded: bool, state: AppCoffeeListItemState, isLiked: bool, onLikeTap, onTap, onDetailTap, onRecipeTap }`
- Variants: `AppCoffeeListItemState{normal, selected, disabled}`, expanded(bool)
- 의존 컴포넌트: AppCoffeeAttributesChart, AppFlavorNotesChips
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppCoffeeAttributeBar / AppCoffeeAttributesChart / AppFlavorNotesChips / AppCoffeeProfileCard
- 파일: `components/contents/app_coffee_profile.dart`
- Props (Card): `{ values: Map<String,double> [req], flavorNotes: List<String> [req], compared: Map<String,double>?, maxValue: double }`
- Variants: single-track / dual-track (`compared` 유무)
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppCommunityListItem
- 파일: `components/contents/app_community_list.dart`
- Props: `{ content: String [req], author: String [req], likeCount: int, commentCount: int, thumbnail: Widget?, hasUnread: bool, onTap }`
- Variants: hasUnread(bool)
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppContentBadge
- 파일: `components/contents/app_content_badge.dart`
- Props: `{ label: String [req], variant: AppContentBadgeVariant, color: AppContentBadgeColor, size: AppContentBadgeSize, leadingIcon, trailingIcon }`
- Variants: `AppContentBadgeVariant{solid, outlined}`, `AppContentBadgeColor{neutral, accent}`, `AppContentBadgeSize{xsmall, small, medium}`
- 의존 토큰: AppColor, AppRadius, AppTextStyles

#### AppItemHeart / AppItemCard
- 파일: `components/contents/app_item_list.dart`
- Props (Card): `{ name: String [req], price: int [req], layout: AppItemCardLayout, image: Widget?, brandTags: List<String>, discountPercent: int?, rating: double?, reviewCount: int?, isLiked: bool, onLikeTap, onTap }`
- Variants: `AppItemCardLayout{vertical, horizontal}`
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppPlayIconBadge
- 파일: `components/contents/app_play_icon_badge.dart`
- Props: `{ size: AppPlayIconBadgeSize, variant: AppPlayIconBadgeVariant, onTap }`
- Variants: `AppPlayIconBadgeSize{small, medium, large}`, `AppPlayIconBadgeVariant{normal, alternative}`
- 의존 토큰: AppColor

#### AppPreferenceItem / AppTasteChip / AppPreferenceFlavorChip
- 파일: `components/contents/app_preference_list.dart`
- Props (Item): `{ title: String [req], summaryTags: List<String>, tasteChips: List<AppTasteChip>?, flavorChips: List<AppPreferenceFlavorChip>?, expanded: bool, state: AppPreferenceItemState, onTap }`
- Variants: `AppPreferenceItemState{normal, selected, disabled}`, `AppTasteLevel{good, normal, bad}`
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppRecipeStepper / AppRecipeCard
- 파일: `components/contents/app_recipe_timer.dart`
- Props (Stepper): `{ label: String [req], value: int [req], unit: String [req], minValue, maxValue, onChanged, placeholderText }`
- Props (Card): `{ title: String [req], steppers: List<AppRecipeStepper> [req], onDelete }`
- Variants: empty(value=0) / filled; disabled(no onChanged)
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppReview
- 파일: `components/contents/app_review.dart`
- Props: `{ rating: double [req], author: String [req], date: String [req], content: String [req], layout: AppReviewLayout, thumbnails: List<Widget>, helpfulCount: int?, onHelpfulTap, onReportTap, onMoreTap }`
- Variants: `AppReviewLayout{compact, multiImage, full}`
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppSectionHeader
- 파일: `components/contents/app_section_header.dart`
- Props: `{ title: String [req], subtitle: String?, size: AppSectionHeaderSize, align: AppSectionHeaderAlign, trailing: Widget?, onTap }`
- Variants: `AppSectionHeaderSize{xsmall, small, medium, large}`, `AppSectionHeaderAlign{inline, multiline}`
- 의존 토큰: AppColor, AppSpacing, AppTextStyles

#### AppTable (+ AppTableColumn data class)
- 파일: `components/contents/app_table.dart`
- Props: `{ columns: List<AppTableColumn> [req], rows: List<List<Widget>> [req], contentType: AppTableContentType, showHeader: bool, onCellTap }`
- Variants: `AppTableContentType{normal, input}`
- 의존 토큰: AppColor, AppSpacing, AppTextStyles

#### AppTastingNote
- 파일: `components/contents/app_tasting_note.dart`
- Props: `{ title: String [req], description: String [req], leading: Widget?, trailingIcon: IconData?, onTap }`
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

### control_box/

#### AppControlBox
- 파일: `components/control_box/app_control_box.dart`
- Props: `{ label: String [req], isSelected: bool [req], onChanged [req], type: AppControlBoxType, subtitle: String?, isDisabled: bool }`
- Variants: `AppControlBoxType{checkbox, radio}`
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

### controls/

#### AppCheckbox
- 파일: `components/controls/app_checkbox.dart`
- Props: `{ value: bool? [req — null=indeterminate], onChanged, label: String?, size: AppCheckboxSize }`
- Variants: `AppCheckboxSize{sm, md}` + checked/unchecked/indeterminate/disabled
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppRadio<T>
- 파일: `components/controls/app_radio.dart`
- Props: `{ value: T [req], groupValue: T? [req], onChanged, label: String? }`
- Variants: selected/unselected/disabled
- 의존 토큰: AppColor, AppSpacing, AppTextStyles

#### AppSwitch
- 파일: `components/controls/app_switch.dart`
- Props: `{ value: bool [req], onChanged, size: AppSwitchSize }`
- Variants: `AppSwitchSize{sm, md}` + on/off/disabled
- 의존 토큰: AppColor

### dividers/

#### AppDivider
- 파일: `components/dividers/app_divider.dart`
- Props: `{ tick: bool, vertical: bool, indent: double, endIndent: double }`
- Variants: tick × vertical
- 의존 토큰: AppColor

### feedback/

#### AppSnackbar
- 파일: `components/feedback/app_snackbar.dart`
- Props: `{ message: String [req], description: String?, actionLabel: String?, onAction, onDismiss, icon: IconData? }`
- 의존 토큰: AppColor, AppRadius, AppShadows, AppSpacing, AppTextStyles

#### AppToast (+ static `AppToast.show()`)
- 파일: `components/feedback/app_toast.dart`
- Props: `{ message: String [req], variant: AppToastVariant, action: String?, onAction, showIcon: bool }`
- Variants: `AppToastVariant{normal, positive, cautionary, negative}`
- 의존 토큰: AppColor, AppRadius, AppShadows, AppSpacing, AppTextStyles

#### AppTooltipCompact / AppTooltipExtended
- 파일: `components/feedback/app_tooltip.dart`
- Props (Compact): `{ message: String [req], variant: AppTooltipVariant }`
- Props (Extended): `{ title: String [req], description: String [req], showCloseButton: bool, onClose }`
- Variants: `AppTooltipVariant{normal, inverse}` (compact), showCloseButton (extended)
- 의존 토큰: AppColor, AppRadius, AppShadows, AppSpacing, AppTextStyles

### forms/

#### AppTextField
- 파일: `components/forms/app_text_field.dart`
- Props: `{ controller, focusNode, label?, hintText?, helperText?, errorText?, isEnabled, obscureText, showPasswordToggle, prefixIcon, suffixIcon, onSuffixTap, onChanged, onSubmitted, keyboardType, textInputAction, inputFormatters, maxLength, maxLines, minLines, autofocus, readOnly, size: AppTextFieldSize }`
- Variants: `AppTextFieldSize{sm, md, lg}` + normal/focused/error/disabled/read-only
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

### gauge/

#### AppGauge
- 파일: `components/gauge/app_gauge.dart`
- Props: `{ value: int [req], maxValue: int, labels: List<String>?, activeColor: Color?, inactiveColor: Color?, height: double, showLabel: bool }`
- Variants: —
- 의존 토큰: AppColor, AppRadius, AppTextStyles

### indicators/

#### AppBadge / AppBadgedItem
- 파일: `components/indicators/app_indicators.dart`
- Props (Badge): `{ count: int?, style: AppBadgeStyle, color: Color? }`
- Props (BadgedItem): `{ child: Widget [req], badge: Widget [req], alignment: Alignment, offset: Offset }`
- Variants: `AppBadgeStyle{dot, count}`
- 의존 토큰: AppColor, AppTextStyles

#### AppPaginationDot / AppPaginationDots
- 파일: `components/indicators/app_indicators.dart`
- Props (Dots): `{ count: int [req], activeIndex: int [req], dotSize: double, gap: double }`
- 의존 토큰: AppColor

#### AppHomeIndicator / AppGrabber
- 파일: `components/indicators/app_indicators.dart`
- Props (HomeIndicator): `{ device: AppHomeIndicatorDevice, orientation: AppHomeIndicatorOrientation }`
- Variants: `AppHomeIndicatorDevice{iPhone, iPad}`, `AppHomeIndicatorOrientation{portrait, landscape}`
- 의존 토큰: AppColor

#### AppLinearProgress / AppCircularProgress / AppLabeledProgress
- 파일: `components/indicators/app_progress.dart`
- Props (Linear): `{ value: double?, height: double, color: Color? }`
- Props (Circular): `{ value: double?, size: double, strokeWidth: double, color: Color? }`
- Props (Labeled): `{ label: String [req], value: double [req], color: Color? }`
- 의존 컴포넌트: AppLinearProgress (in Labeled)
- 의존 토큰: AppColor

### modals/

#### AppConfirmDialog (+ top-level `showAppConfirmDialog`)
- 파일: `components/modals/app_confirm_dialog.dart`
- Props: `{ title: String [req], message: String?, confirmText: String, cancelText: String, isDestructive: bool, onConfirm, onCancel }`
- 의존 컴포넌트: AppSolidButton, AppOutlinedButton
- 의존 토큰: AppColor, AppRadius, AppShadows, AppSpacing, AppTextStyles

### navigation/

#### AppBottomNavigation (+ BottomNavItem)
- 파일: `components/navigation/app_bottom_navigation.dart`
- Props: `{ currentIndex: int [req], items: List<BottomNavItem> [req], onTap, useSafeArea: bool }`
- 의존 토큰: AppColor, AppTextStyles, AppSpacing

#### AppFooter (+ FooterSnsItem)
- 파일: `components/navigation/app_footer.dart`
- Props: `{ snsItems, customerServiceTitle, customerServiceBody, businessInfoTitle, businessInfoBody, backgroundColor }`
- 의존 토큰: AppColor, AppTextStyles, AppSpacing

#### AppGnb (+ GnbAction)
- 파일: `components/navigation/app_gnb.dart`
- Props: `{ logo: Widget [req], actions: List<GnbAction>, backgroundColor }`
- 의존 토큰: AppColor

#### AppTopNavigation (+ TopNavAction)
- 파일: `components/navigation/app_top_navigation.dart`
- Props: `{ title: String?, variant: TopNavigationVariant, leadingIcon, onLeadingPressed, trailingActions, showTitle, toolBar, toolBar2, avatar, backgroundColor }`
- Variants: `TopNavigationVariant{normal, extended, floating}`
- 의존 토큰: AppColor, AppTextStyles

### pagination/

#### AppPaginationCounter
- 파일: `components/pagination/app_pagination.dart`
- Props: `{ totalPages: int [req], currentPage: int [req], size: AppPaginationCounterSize, alternative: bool }`
- Variants: `AppPaginationCounterSize{medium, small}`
- 의존 토큰: AppColor, AppRadius, AppTextStyles

#### AppPaginationNavigation
- 파일: `components/pagination/app_pagination.dart`
- Props: `{ totalPages: int [req], currentPage: int [req], onPageChanged [req], variant: AppPaginationNavigationVariant }`
- Variants: `AppPaginationNavigationVariant{extended, compact, minimize}`
- 의존 토큰: AppColor, AppRadius, AppTextStyles

### presentation/

#### AppBottomSheet (+ static `AppBottomSheet.show()`)
- 파일: `components/presentation/app_bottom_sheet.dart`
- Props: `{ child: Widget [req], title: String?, showHandle: bool, showCloseButton: bool, onClose }`
- Variants: `AppBottomSheetResize{hug, flexible, fill, fixed}` (helper enum)
- 의존 토큰: AppColor, AppDecorate, AppRadius, AppShadows, AppSpacing, AppTextStyles

#### AppModalPopup
- 파일: `components/presentation/app_bottom_sheet.dart`
- Props: `{ child: Widget [req], title: String?, onClose, width: double }`
- 의존 토큰: AppColor, AppRadius, AppShadows

#### AppMenu (+ AppMenuItem)
- 파일: `components/presentation/app_menu.dart`
- Props: `{ items: List<AppMenuItem> [req], onItemTap [req], variant: AppMenuVariant, cellPadding: AppMenuCellPadding, width: double }`
- Variants: `AppMenuVariant{normal, radio, checkbox}`, `AppMenuCellPadding{px12, px8}`
- 의존 토큰: AppColor, AppRadius, AppShadows, AppSpacing, AppTextStyles

### ratio/

#### AppRatioBox / AppRatioBoxVertical
- 파일: `components/ratio/app_ratio.dart`
- Props: `{ child: Widget [req], ratio: AppRatio, borderRadius: BorderRadius?, backgroundColor: Color? }`
- Variants: `AppRatio` 17개 (square, 4x3, 16x9, 21x9, goldenLandscape, … goldenPortrait, 9x16, 9x21 등)
- 의존 토큰: AppColor, AppRadius

### scrolls/

#### AppScrollBar / AppScrollableScrollBar
- 파일: `components/scrolls/app_scroll_bar.dart`
- Props (Static): `{ percent: double [req], position: double, size: AppScrollBarSize, height: double }`
- Props (Scrollable): `{ controller: ScrollController [req], child: Widget [req], size, indicatorRightPadding }`
- Variants: `AppScrollBarSize{normal, small}`
- 의존 토큰: AppColor

### selection/

#### AppSelect<T>
- 파일: `components/selection/app_select.dart`
- Props: `{ items: List<T> [req], itemLabel: String Function(T) [req], selectedItem: T?, onChanged, label, hintText, isDisabled, isError, errorText, helperText }`
- 의존 토큰: AppColor, AppRadius, AppShadows, AppSpacing, AppTextStyles

#### AppSlider
- 파일: `components/selection/app_slider.dart`
- Props: `{ value: double [req], onChanged [req — nullable], min, max, divisions, label, showValue, activeColor, isDisabled }`
- 의존 토큰: AppColor, AppTextStyles

### tabs/

#### AppCategory
- 파일: `components/tabs/app_category.dart`
- Props: `{ items: List<String> [req], selectedIndex: int [req], onChanged [req], variant: AppCategoryVariant, size: AppCategorySize, horizontalPadding: bool }`
- Variants: `AppCategoryVariant{normal, alternative}`, `AppCategorySize{medium, small}`
- 의존 토큰: AppColor, AppRadius, AppSpacing, AppTextStyles

#### AppSegmentedControl (+ AppSegmentItem)
- 파일: `components/tabs/app_segmented_control.dart`
- Props: `{ items: List<AppSegmentItem> [req], selectedIndex [req], onChanged [req], size: AppSegmentedControlSize }`
- Variants: `AppSegmentedControlSize{large, medium, small}`
- 의존 토큰: AppColor, AppRadius, AppTextStyles

#### AppTabBar
- 파일: `components/tabs/app_tab_bar.dart`
- Props: `{ tabs: List<String> [req], selectedIndex [req], onTabChanged [req], size: AppTabBarSize, resize: AppTabBarResize, horizontalPadding: bool, trailingIcon, onTrailingPressed, showGradientMask: bool }`
- Variants: `AppTabBarSize{large, medium, small}`, `AppTabBarResize{hug, fill}`
- 의존 토큰: AppColor, AppGradient, AppSpacing, AppTextStyles

### thumbnails/

#### AppThumbnail
- 파일: `components/thumbnails/app_thumbnail.dart`
- Props: `{ imageUrl: String?, fallbackIcon: IconData?, ratio: AppRatio, showBorder: bool, showRadius: bool, width: double?, onTap }`
- 의존 컴포넌트: AppRatioBox
- 의존 토큰: AppColor, AppRadius

---

## 🎭 Widgetbook Use Cases (Stories)

각 `*_use_cases.dart`는 `List<WidgetbookComponent>` 변수를 export 하며 `main.dart`의 Widgetbook 트리에 마운트됩니다.

| Use Cases 변수 | 파일 | 다루는 컴포넌트 | 비고 |
|---|---|---|---|
| `opacityUseCases` | `foundation/opacity_use_cases.dart` | (foundation/Opacity Scale) | 15단계 0~100 (체커 배경) |
| `paletteUseCases` | `foundation/palette_use_cases.dart` | AppColor | Common / Neutral / Brand / Accent |
| `radiusUseCases` | `foundation/radius_use_cases.dart` | AppRadius | Palette / Semantic / Directional |
| `semanticUseCases` | `foundation/semantic_use_cases.dart` | AppColor (semantic) | 11 semantic groups |
| `shadowUseCases` | `foundation/shadow_use_cases.dart` | AppShadows | Black / Primary |
| `spacingUseCases` | `foundation/spacing_use_cases.dart` | AppSpacing | 6 groups |
| `typographyUseCases` | `foundation/typography_use_cases.dart` | AppTextStyles | Display..Caption + Emoji |
| `avatarUseCases` | `components/avatars/avatar_use_cases.dart` | AppAvatar, AppAvatarGroup | Person/Company/Academic/Fallback/Initials/Group |
| `solidButtonUseCases`, `outlinedButtonUseCases`, `textButtonUseCases`, `iconButtonUseCases`, `fabUseCases`, `sectionBottomUseCases` | `components/buttons/button_use_cases.dart` | 모든 버튼 8종 | Section Bottom Fold는 `_FoldDemo` Stateful 데모 포함 |
| `cardUseCases` | `components/cards/card_use_cases.dart` | AppCard | Variants / Tappable |
| `chipActionUseCases`, `chipFilterUseCases` | `components/chips/chip_use_cases.dart` | AppChipAction, AppChipFilter | 2 variants × 4 sizes |
| `accordionUseCases` | `components/contents/app_accordion_use_cases.dart` | AppAccordion | Basic / Variants / Group |
| `bannerUseCases` | `components/contents/app_banner_use_cases.dart` | AppBanner | Hero / Compact / Stack |
| `cellUseCases` | `components/contents/app_cell_use_cases.dart` | AppCell | Basic / Variations / List |
| `coffeeListUseCases` | `components/contents/app_coffee_list_use_cases.dart` | AppCoffeeListItem | Compact / Expanded / Stack |
| `coffeeProfileUseCases` | `components/contents/app_coffee_profile_use_cases.dart` | AppCoffeeAttributesChart 등 | Attributes / Flavor Notes / Card |
| `communityListUseCases` | `components/contents/app_community_list_use_cases.dart` | AppCommunityListItem | default / unread / stack |
| `contentBadgeUseCases` | `components/contents/app_content_badge_use_cases.dart` | AppContentBadge | Variant / Size / Color |
| `itemListUseCases` | `components/contents/app_item_list_use_cases.dart` | AppItemHeart, AppItemCard | Heart / Vertical / Horizontal |
| `playIconBadgeUseCases` | `components/contents/app_play_icon_badge_use_cases.dart` | AppPlayIconBadge | sizes / alternative / matrix |
| `preferenceListUseCases` | `components/contents/app_preference_list_use_cases.dart` | AppPreferenceItem 등 | Item State / Expanded / Chips / Stack |
| `recipeTimerUseCases` | `components/contents/app_recipe_timer_use_cases.dart` | AppRecipeStepper, AppRecipeCard | Stepper / Card |
| `reviewUseCases` | `components/contents/app_review_use_cases.dart` | AppReview | Compact / MultiImage / Full / Stack |
| `sectionHeaderUseCases` | `components/contents/app_section_header_use_cases.dart` | AppSectionHeader | Size / Trailing / Align / Subtitle |
| `tableUseCases` | `components/contents/app_table_use_cases.dart` | AppTable | Basic / Interactive / Data Types |
| `tastingNoteUseCases` | `components/contents/app_tasting_note_use_cases.dart` | AppTastingNote | default / custom leading / stack |
| `controlBoxUseCases` | `components/control_box/app_control_box_use_cases.dart` | AppControlBox | Checkbox / Radio |
| `switchUseCases`, `checkboxUseCases`, `radioUseCases` | `components/controls/control_use_cases.dart` | AppSwitch, AppCheckbox, AppRadio | 각 3 lists export |
| `dividerUseCases` | `components/dividers/divider_use_cases.dart` | AppDivider | tick × vertical + Indent |
| `snackbarUseCases` | `components/feedback/app_snackbar_use_cases.dart` | AppSnackbar | Basic / Description / Action / Variants |
| `toastUseCases` | `components/feedback/app_toast_use_cases.dart` | AppToast | Normal / Positive / Cautionary / Negative |
| `tooltipUseCases` | `components/feedback/app_tooltip_use_cases.dart` | AppTooltipCompact, AppTooltipExtended | Compact / Extended / Multiple |
| `textFieldUseCases` | `components/forms/text_field_use_cases.dart` | AppTextField | Sizes / Label-Helper-Error / States / Icons / Multiline |
| `gaugeUseCases` | `components/gauge/app_gauge_use_cases.dart` | AppGauge | 5-step variations |
| `indicatorUseCases`, `homeIndicatorUseCases` | `components/indicators/indicator_use_cases.dart` | AppBadge, AppBadgedItem, AppPaginationDots, AppHomeIndicator, AppGrabber | 다중 컴포넌트 |
| `progressUseCases` | `components/indicators/progress_use_cases.dart` | AppLinearProgress, AppCircularProgress, AppLabeledProgress | Determinate/Indeterminate |
| `modalUseCases` | `components/modals/modal_use_cases.dart` | AppConfirmDialog | Inline / Destructive / Title only / Live |
| `bottomNavigationUseCases` | `components/navigation/app_bottom_navigation_use_cases.dart` | AppBottomNavigation | 3 / 4 / 5 Items |
| `footerUseCases` | `components/navigation/app_footer_use_cases.dart` | AppFooter | Basic / Business Info |
| `gnbUseCases` | `components/navigation/app_gnb_use_cases.dart` | AppGnb | Basic / Badge / Multiple |
| `topNavigationUseCases` | `components/navigation/app_top_navigation_use_cases.dart` | AppTopNavigation | Leading & Trailing / Extended / Floating |
| `paginationUseCases` | `components/pagination/app_pagination_use_cases.dart` | AppPaginationCounter, AppPaginationNavigation | Dot / Numeric / Extended / Compact / Minimize |
| `bottomSheetUseCases` | `components/presentation/app_bottom_sheet_use_cases.dart` | AppBottomSheet | Basic / Title / Handle / Close |
| `menuUseCases` | `components/presentation/app_menu_use_cases.dart` | AppMenu | Normal / Radio / Checkbox / Padding |
| `ratioUseCases` | `components/ratio/ratio_use_cases.dart` | AppRatioBox(Vertical) | Landscape / Square / Portrait |
| `scrollUseCases` | `components/scrolls/scroll_use_cases.dart` | AppScrollBar, AppScrollableScrollBar | Size / Percent / Position / Live |
| `selectUseCases` | `components/selection/app_select_use_cases.dart` | AppSelect | Basic / Placeholder / Helper / Error / Disabled / Custom / Many |
| `sliderUseCases` | `components/selection/app_slider_use_cases.dart` | AppSlider | Basic / Label / Divisions / Disabled / Color / Multiple |
| `categoryUseCases` | `components/tabs/app_category_use_cases.dart` | AppCategory | Normal × Medium/Small / Alternative × Medium/Small / Scroll |
| `segmentedControlUseCases` | `components/tabs/app_segmented_control_use_cases.dart` | AppSegmentedControl | Large / Medium / Small / Icons / Two Options |
| `tabBarUseCases` | `components/tabs/app_tab_bar_use_cases.dart` | AppTabBar | Size × Resize × Trailing Icon |
| `thumbnailUseCases` | `components/thumbnails/thumbnail_use_cases.dart` | AppThumbnail | Border × Radius / With Image / Ratios |

---

## 🔧 Utilities / Helpers / Entry

- `main()` + `ComponentLabApp` (StatelessWidget) — `lib/main.dart`. Widgetbook entry; ThemeAddon(Light/Dark) / TextScaleAddon / InspectorAddon / AlignmentAddon 등 등록.
- `component_lab.dart` — 단일 import barrel. foundation 9개 + 모든 App* 컴포넌트 export.
- `samples/sample_screen.dart` — `SampleLoginScreen` (StatefulWidget). 통합 sanity check 화면 (`AppCard`/`AppTextField`/`AppCheckbox`/`AppSolidButton`/`AppTextButton`/`AppDivider`/`AppIconButton`/`CoflanetIcon` 사용).
- `showAppConfirmDialog()` — 최상위 `Future<bool?>` 함수 (`components/modals/app_confirm_dialog.dart`).
- 정적 helper 메서드:
  - `AppToast.show(context, message, …)` — Overlay 기반 토스트 표시
  - `AppBottomSheet.show(context, child, …)` — `showModalBottomSheet` 래퍼
  - `AppModalPopup.show(context, child, …)` — `showDialog` 래퍼
- 데이터(POJO) 클래스 — Props 그룹화용:
  - `BottomNavItem` (navigation)
  - `FooterSnsItem` (navigation)
  - `GnbAction` (navigation)
  - `TopNavAction` (navigation)
  - `AppMenuItem` (presentation)
  - `AppSegmentItem` (tabs)
  - `AppTableColumn` (contents)
- 내부 helper 위젯 (private `_XXX` — 외부 public API 아님):
  - `_FoldDemo` (button_use_cases.dart)
  - `_OpacityChart`, `_CheckerBox`, `_CheckerPainter` (opacity_use_cases)
  - `_R`, `_S`, `_T` (radius/spacing/typography use_cases helper)
  - `_Header`, `_BrandChip`, `_OutlinedActionButton`, `_PrimaryActionButton`, `_Thumbnail`, `_BrandTags`, `_PriceRow`, `_RatingRow`, `_Track`, `_LegendDot`, `_FlavorChip`, `_StarRow`, `_AvatarStarRow`, `_ImageGrid`, `_HelpfulRow`, `_StepperButton` (contents 내부)
  - `_SampleLoginScreenState` (samples)

---

## 📊 카운트

| 분류 | 개수 |
|---|---:|
| 전체 `.dart` 파일 | **121** |
| Foundation token/theme 파일 | 10 (`_swatch`, `app_color`, `app_decorate`, `app_gradient`, `app_radius`, `app_shadow`, `app_spacing`, `app_text_style`, `app_theme`, `coflanet_icons`) |
| Foundation use_cases 파일 | 7 |
| Component 정의 파일 (`app_*.dart`) | 56 |
| Component use_cases 파일 | 45 |
| Entry / Barrel / Sample | 3 (`main.dart`, `component_lab.dart`, `samples/sample_screen.dart`) |
| **공개 컴포넌트 위젯 클래스 (App*)** | **76** |
| 컴포넌트 전용 enum (variant 정의) | 59 |
| Foundation enum | 3 (`InteractionIntensity`, `InteractionState`, `CoflanetIconSize`) |
| Props 그룹화 data 클래스 | 7 (`BottomNavItem`, `FooterSnsItem`, `GnbAction`, `TopNavAction`, `AppMenuItem`, `AppSegmentItem`, `AppTableColumn`) |
| Foundation 토큰 클래스 (abstract) | 9 (`AppColor`, `AppDecorate`, `AppGradient`, `AppRadius`, `AppShadows`, `AppSpacing`, `AppTextStyles`, `AppTheme`, `CoflanetIcons`) |
| Foundation 위젯 (`CoflanetIcon`, `Swatch`) | 2 |
| Top-level 헬퍼 함수 | 1 (`showAppConfirmDialog`) |
| Static show() 헬퍼 메서드 | 3 (`AppToast.show`, `AppBottomSheet.show`, `AppModalPopup.show`) |

**요약**:
- **총 컴포넌트 76개** (App* 공개 위젯; data 클래스·private helper 제외)
- **총 유틸 15개** (foundation 토큰/테마 클래스 11 + 헬퍼 함수 1 + 정적 show 3)
- **총 Widgetbook use_cases 파일 52개** (foundation 7 + components 45; 한 파일에 다중 export 케이스 포함)

---

## ⚠️ 추가 검증 필요

- **`AppRadio<T>`**: 제너릭 generic 위젯이라 Props 표기에 type parameter 누락 — 사용 시 `AppRadio<MyType>` 형태.
- **`AppSelect<T>`**: 마찬가지로 generic.
- **`AppChipFilter` ↔ `app_chip_action.dart`**: `AppChipSize` enum이 `app_chip_action.dart`에 정의되어 있고 filter 파일에서 재사용. 의존성 그래프에서 사실상 chip_action → chip_filter 쌍 의존.
- **`AppCoffeeListItem`** 은 다른 contents 파일 (`app_coffee_profile.dart`)의 `AppCoffeeAttributesChart`/`AppFlavorNotesChips`에 직접 의존 — Phase 3에서 컴포넌트 간 강결합 매핑할 때 명시 필요.
- **Widget 식별이 모호한 entry**:
  - `Swatch` (foundation/_swatch.dart) 는 widget이지만 외부 노출이 아닌 내부 토큰 카탈로그 helper이므로 "Foundation 위젯"으로 따로 분류함.
- **AppHomeIndicator / AppGrabber**: 같은 파일 (`app_indicators.dart`) 안에 6개 위젯이 같이 있음 — 디렉토리 구조와 1:1 매핑되지 않음.
- **`Recipe/Timmer`** (피그마)와 `AppRecipeTimer*` (코드) — 피그마의 오타 `Timmer` 가 코드에는 `Timer`로 정정되어 매핑되어 있음. Phase 3 (피그마↔코드 매핑)에서 명시할 것.
