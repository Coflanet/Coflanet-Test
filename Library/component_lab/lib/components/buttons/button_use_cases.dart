import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_floating_action_button.dart';
import 'app_icon_button.dart';
import 'app_outlined_button.dart';
import 'app_section_bottom_button.dart';
import 'app_solid_button.dart';
import 'app_text_button.dart';

// ═══════════════════════════════════════════════════════════════
// SOLID — Figma `Button/Solid/*` 7 tone × 4 size
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> solidButtonUseCases = [
  WidgetbookComponent(
    name: 'Solid',
    useCases: [
      WidgetbookUseCase(
        name: '7 Tones — Large',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppSolidButtonTone.values
                .map((t) => AppSolidButton(
                    label: _toneLabel(t.name), tone: t, onPressed: () {}))
                .toList(),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Sizes — Large/Medium/Small/XSmall (Primary)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: AppSolidButtonSize.values
                .map((s) => AppSolidButton(
                    label: 'Label',
                    size: s,
                    onPressed: () {}))
                .toList(),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With icons (Large × all tones)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppSolidButtonTone.values
                .map((t) => AppSolidButton(
                      label: _toneLabel(t.name),
                      tone: t,
                      leftIcon: Icons.coffee_rounded,
                      rightIcon: Icons.arrow_forward_rounded,
                      onPressed: () {},
                    ))
                .toList(),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              AppSolidButton(label: 'Primary', tone: AppSolidButtonTone.primary),
              AppSolidButton(label: 'Gray', tone: AppSolidButtonTone.gray),
              AppSolidButton(
                  label: 'GrayPrimary', tone: AppSolidButtonTone.grayPrimary),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Full width (sequence)',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSolidButton(
                  label: '확인',
                  width: double.infinity,
                  onPressed: () {}),
              const SizedBox(height: AppSpacing.space12),
              AppSolidButton(
                label: '계속',
                width: double.infinity,
                tone: AppSolidButtonTone.gray,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════
// OUTLINED — Figma `Button/Outlined/*` 3 tone × 4 size
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> outlinedButtonUseCases = [
  WidgetbookComponent(
    name: 'Outlined',
    useCases: [
      WidgetbookUseCase(
        name: '3 Tones — Large',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppOutlinedButtonTone.values
                .map((t) => AppOutlinedButton(
                    label: _toneLabel(t.name), tone: t, onPressed: () {}))
                .toList(),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Sizes (Primary)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: AppOutlinedButtonSize.values
                .map((s) => AppOutlinedButton(
                    label: 'Label', size: s, onPressed: () {}))
                .toList(),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With icons',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppOutlinedButtonTone.values
                .map((t) => AppOutlinedButton(
                      label: _toneLabel(t.name),
                      tone: t,
                      leftIcon: Icons.add_rounded,
                      onPressed: () {},
                    ))
                .toList(),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => _bg(
          context,
          const Wrap(
            spacing: 12,
            children: [
              AppOutlinedButton(label: 'Primary'),
              AppOutlinedButton(
                  label: 'Secondary', tone: AppOutlinedButtonTone.secondary),
              AppOutlinedButton(
                  label: 'Assistive', tone: AppOutlinedButtonTone.assistive),
            ],
          ),
        ),
      ),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════
// TEXT — Figma `Button/Text/*` 3 tone × 2 size
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> textButtonUseCases = [
  WidgetbookComponent(
    name: 'Text',
    useCases: [
      WidgetbookUseCase(
        name: '3 Tones × 2 Sizes',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Medium'),
              const SizedBox(height: AppSpacing.space8),
              Wrap(
                spacing: 16,
                children: AppTextButtonTone.values
                    .map((t) => AppTextButton(
                        label: _toneLabel(t.name), tone: t, onPressed: () {}))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.space24),
              const Text('Small'),
              const SizedBox(height: AppSpacing.space8),
              Wrap(
                spacing: 16,
                children: AppTextButtonTone.values
                    .map((t) => AppTextButton(
                          label: _toneLabel(t.name),
                          tone: t,
                          size: AppTextButtonSize.small,
                          onPressed: () {},
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With icons',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              AppTextButton(
                label: '뒤로',
                leftIcon: Icons.arrow_back_rounded,
                onPressed: () {},
              ),
              AppTextButton(
                label: '다음',
                rightIcon: Icons.arrow_forward_rounded,
                onPressed: () {},
              ),
              AppTextButton(
                label: '추가',
                tone: AppTextButtonTone.normal,
                leftIcon: Icons.add_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════
// ICON — Figma `Button/Icon/*` 9 tone
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> iconButtonUseCases = [
  WidgetbookComponent(
    name: 'Icon',
    useCases: [
      WidgetbookUseCase(
        name: '9 Tones (Normal size)',
        builder: (context) {
          // LiquidGlass·BackgroundBlur는 어두운 배경에서 잘 보임
          return _imageBg(
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppIconButtonTone.values
                  .map((t) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIconButton(
                            icon: Icons.favorite_rounded,
                            tone: t,
                            onPressed: () {},
                            iconColor: t == AppIconButtonTone.normal ||
                                    t == AppIconButtonTone.liquidGlass ||
                                    t == AppIconButtonTone.backgroundBlur ||
                                    t == AppIconButtonTone.gray
                                ? AppColor.staticLabelWhiteStrong
                                : null,
                          ),
                          const SizedBox(height: 4),
                          Text(t.name,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColor.staticLabelWhiteStrong)),
                        ],
                      ))
                  .toList(),
            ),
          );
        },
      ),
      WidgetbookUseCase(
        name: 'Sizes — normal / small (Primary)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppIconButton(
                icon: Icons.search_rounded,
                tone: AppIconButtonTone.primary,
                onPressed: () {},
              ),
              AppIconButton(
                icon: Icons.search_rounded,
                tone: AppIconButtonTone.primary,
                size: AppIconButtonSize.small,
                onPressed: () {},
              ),
              AppIconButton(
                icon: Icons.search_rounded,
                tone: AppIconButtonTone.primary,
                size: AppIconButtonSize.custom,
                customSize: 56,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Normal (24×24) — Badge',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 24,
            children: [
              AppIconButton(
                icon: Icons.notifications_outlined,
                onPressed: () {},
              ),
              AppIconButton(
                icon: Icons.notifications_outlined,
                showBadge: true,
                onPressed: () {},
              ),
              AppIconButton(
                icon: Icons.mail_outline_rounded,
                showBadge: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════
// FAB — Figma `Button/Floating Action`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> fabUseCases = [
  WidgetbookComponent(
    name: 'Floating Action',
    useCases: [
      WidgetbookUseCase(
        name: 'Default / Disabled',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 24,
            children: [
              AppFloatingActionButton(
                icon: Icons.add_rounded,
                onPressed: () {},
                tooltip: 'Add',
              ),
              const AppFloatingActionButton(icon: Icons.add_rounded), // disabled
            ],
          ),
        ),
      ),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════
// SECTION BOTTOM — Figma `Button/Section Bottom/*` 3 variants
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> sectionBottomUseCases = [
  WidgetbookComponent(
    name: 'Section Bottom',
    useCases: [
      WidgetbookUseCase(
        name: 'Top Line — 화면 최하단 안내 버튼',
        builder: (context) => _bg(
          context,
          AppSectionBottomButton(
            label: '약관 자세히 보기',
            rightIcon: Icons.chevron_right_rounded,
            onPressed: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Solid — 그라데이션 페이드',
        builder: (context) => _bg(
          context,
          AppSectionBottomButton(
            label: '계속하기',
            variant: AppSectionBottomVariant.solid,
            onPressed: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Fold — 펼침/접힘',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              const _FoldDemo(),
            ],
          ),
        ),
      ),
    ],
  ),
];

class _FoldDemo extends StatefulWidget {
  const _FoldDemo();
  @override
  State<_FoldDemo> createState() => _FoldDemoState();
}

class _FoldDemoState extends State<_FoldDemo> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AppSectionBottomButton(
      label: 'Fold',
      variant: AppSectionBottomVariant.fold,
      isExpanded: _expanded,
      onPressed: () => setState(() => _expanded = !_expanded),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════
String _toneLabel(String name) {
  // CamelCase → 띄어쓰기
  final r = name.replaceAllMapped(
      RegExp(r'([A-Z])'), (m) => ' ${m.group(0)}');
  return r.isEmpty ? name : r[0].toUpperCase() + r.substring(1);
}

Widget _bg(BuildContext context, Widget child) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bg = isDark
      ? AppColor.darkBackgroundNormalNormal
      : AppColor.backgroundNormalNormal;
  return Container(
    color: bg,
    padding: const EdgeInsets.all(24),
    child: child,
  );
}

/// LiquidGlass·BackgroundBlur 톤은 어두운 배경에서 잘 보이게 — 그라디언트 BG.
///
/// 외부 이미지 의존 0. 그라디언트는 Violet 계열로 LiquidGlass tone 가독성을 확보한다.
Widget _imageBg(Widget child) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColor.colorGlobalViolet40,
          AppColor.colorGlobalCoolNeutral15,
        ],
      ),
    ),
    child: Container(
      color: AppColor.colorGlobalCommon0.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(24),
      child: child,
    ),
  );
}
