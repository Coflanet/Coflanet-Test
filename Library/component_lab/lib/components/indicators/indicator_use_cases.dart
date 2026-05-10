import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_indicators.dart';

final List<WidgetbookComponent> indicatorUseCases = [
  WidgetbookComponent(
    name: 'AppBadge',
    useCases: [
      WidgetbookUseCase(
        name: 'Dot / Count / 99+',
        builder: (context) => _bg(
          context,
          const Wrap(
            spacing: 24,
            runSpacing: 24,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppBadge(style: AppBadgeStyle.dot),
              AppBadge(count: 1),
              AppBadge(count: 5),
              AppBadge(count: 12),
              AppBadge(count: 99),
              AppBadge(count: 100), // 99+
              AppBadge(count: 500), // 99+
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Custom color',
        builder: (context) => _bg(
          context,
          const Wrap(
            spacing: 24,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppBadge(count: 3, color: AppColor.colorGlobalGreen50),
              AppBadge(count: 7, color: AppColor.colorGlobalOrange50),
              AppBadge(count: 12, color: AppColor.colorGlobalBlue50),
              AppBadge(count: 24, color: AppColor.colorGlobalViolet50),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'AppBadgedItem',
    useCases: [
      WidgetbookUseCase(
        name: '아이콘 + Badge',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 32,
            runSpacing: 32,
            children: [
              AppBadgedItem(
                badge: const AppBadge(count: 3),
                child:
                    const Icon(Icons.notifications_outlined, size: 32),
              ),
              AppBadgedItem(
                badge: const AppBadge(style: AppBadgeStyle.dot),
                child:
                    const Icon(Icons.mail_outline_rounded, size: 32),
              ),
              AppBadgedItem(
                badge: const AppBadge(count: 99),
                child: const Icon(Icons.shopping_cart_outlined, size: 32),
              ),
              AppBadgedItem(
                badge: const AppBadge(count: 250),
                child: const Icon(Icons.chat_bubble_outline, size: 32),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'AppPaginationDots',
    useCases: [
      WidgetbookUseCase(
        name: '페이지 인디케이터 — 정적 진행',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppPaginationDots(count: 3, activeIndex: 0),
              SizedBox(height: AppSpacing.space16),
              AppPaginationDots(count: 3, activeIndex: 1),
              SizedBox(height: AppSpacing.space16),
              AppPaginationDots(count: 3, activeIndex: 2),
              SizedBox(height: AppSpacing.space24),
              AppPaginationDots(count: 5, activeIndex: 2),
              SizedBox(height: AppSpacing.space16),
              AppPaginationDots(count: 7, activeIndex: 3, dotSize: 6),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Interactive — PageView',
        builder: (context) => const _PaginationDemo(),
      ),
    ],
  ),
];

class _PaginationDemo extends StatefulWidget {
  const _PaginationDemo();
  @override
  State<_PaginationDemo> createState() => _PaginationDemoState();
}

class _PaginationDemoState extends State<_PaginationDemo> {
  final _controller = PageController();
  int _index = 0;
  static const _pages = ['Page 1', 'Page 2', 'Page 3', 'Page 4'];

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
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  _pages[i],
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          AppPaginationDots(
            count: _pages.length,
            activeIndex: _index,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

final List<WidgetbookComponent> homeIndicatorUseCases = [
  WidgetbookComponent(
    name: 'AppHomeIndicator',
    useCases: [
      WidgetbookUseCase(
        name: 'Device × Orientation',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Text('iPhone Portrait (h=34)'),
              AppHomeIndicator(),
              SizedBox(height: AppSpacing.space16),
              Text('iPhone Landscape (h=21)'),
              AppHomeIndicator(
                orientation: AppHomeIndicatorOrientation.landscape,
              ),
              SizedBox(height: AppSpacing.space16),
              Text('iPad Portrait (h=20)'),
              AppHomeIndicator(
                device: AppHomeIndicatorDevice.iPad,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'AppGrabber',
    useCases: [
      WidgetbookUseCase(
        name: 'Grabber',
        builder: (context) => _bg(
          context,
          const AppGrabber(),
        ),
      ),
    ],
  ),
];

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
