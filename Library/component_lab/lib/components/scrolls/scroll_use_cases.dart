import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import 'app_scroll_bar.dart';

final List<WidgetbookComponent> scrollUseCases = [
  WidgetbookComponent(
    name: 'AppScrollBar',
    useCases: [
      WidgetbookUseCase(
        name: 'Size — normal(bar 7px) / small(bar 3px)',
        builder: (context) => _bg(
          context,
          const Wrap(
            spacing: 24,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              _LabeledBar(
                label: 'normal',
                bar: AppScrollBar(
                  percent: 0.5,
                  size: AppScrollBarSize.normal,
                ),
              ),
              _LabeledBar(
                label: 'small',
                bar: AppScrollBar(
                  percent: 0.5,
                  size: AppScrollBarSize.small,
                ),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Percent — 25/50/75/100%',
        builder: (context) => _bg(
          context,
          const Wrap(
            spacing: 24,
            children: [
              _LabeledBar(
                label: '25%',
                bar: AppScrollBar(percent: 0.25),
              ),
              _LabeledBar(
                label: '50%',
                bar: AppScrollBar(percent: 0.5),
              ),
              _LabeledBar(
                label: '75%',
                bar: AppScrollBar(percent: 0.75),
              ),
              _LabeledBar(
                label: '100%',
                bar: AppScrollBar(percent: 1.0),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Position — Top / Center / Bottom',
        builder: (context) => _bg(
          context,
          const Wrap(
            spacing: 24,
            children: [
              _LabeledBar(
                label: 'Top',
                bar: AppScrollBar(percent: 0.5, position: 0),
              ),
              _LabeledBar(
                label: 'Center',
                bar: AppScrollBar(percent: 0.5, position: 0.5),
              ),
              _LabeledBar(
                label: 'Bottom',
                bar: AppScrollBar(percent: 0.5, position: 1),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Live — ScrollController 연동',
        builder: (context) => const _LiveScrollBarDemo(),
      ),
    ],
  ),
];

class _LabeledBar extends StatelessWidget {
  final String label;
  final Widget bar;
  const _LabeledBar({required this.label, required this.bar});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final altColor = isDark
        ? AppColor.darkLabelAlternative
        : AppColor.labelAlternative;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        bar,
        const SizedBox(height: AppSpacing.s8),
        Text(
          label,
          style: AppTextStyles.caption2Medium.copyWith(color: altColor),
        ),
      ],
    );
  }
}

class _LiveScrollBarDemo extends StatefulWidget {
  const _LiveScrollBarDemo();
  @override
  State<_LiveScrollBarDemo> createState() => _LiveScrollBarDemoState();
}

class _LiveScrollBarDemoState extends State<_LiveScrollBarDemo> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = isDark
        ? AppColor.darkBackgroundNormalNormal
        : AppColor.backgroundNormalNormal;
    final cardBg = isDark
        ? AppColor.darkBackgroundElevatedNormal
        : AppColor.backgroundElevatedNormal;
    final labelColor =
        isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;

    return Container(
      color: pageBg,
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        height: 320,
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: AppRadius.radiusCardBorder,
          ),
          clipBehavior: Clip.antiAlias,
          child: AppScrollableScrollBar(
            controller: _controller,
            child: ListView.builder(
              controller: _controller,
              padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
              itemCount: 30,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Item ${i + 1} — 스크롤하면 우측 인디케이터가 따라옵니다.',
                  style: AppTextStyles.body2NormalRegular
                      .copyWith(color: labelColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
