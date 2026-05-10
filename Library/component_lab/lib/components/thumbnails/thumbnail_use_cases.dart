import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../ratio/app_ratio.dart';
import 'app_thumbnail.dart';

final List<WidgetbookComponent> thumbnailUseCases = [
  WidgetbookComponent(
    name: 'AppThumbnail',
    useCases: [
      WidgetbookUseCase(
        name: 'Border × Radius 조합',
        builder: (context) => _bg(
          context,
          const Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: AppThumbnail(
                  showBorder: false,
                  showRadius: false,
                ),
              ),
              SizedBox(
                width: 120,
                child: AppThumbnail(
                  showBorder: true,
                  showRadius: false,
                ),
              ),
              SizedBox(
                width: 120,
                child: AppThumbnail(
                  showBorder: false,
                  showRadius: true,
                ),
              ),
              SizedBox(
                width: 120,
                child: AppThumbnail(
                  showBorder: true,
                  showRadius: true,
                ),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Image',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              AppThumbnail(
                width: 160,
                fallbackIcon: Icons.coffee_rounded,
                showBorder: true,
                showRadius: true,
              ),
              AppThumbnail(
                width: 160,
                ratio: AppRatio.ratio16x9,
                fallbackIcon: Icons.landscape_rounded,
                showRadius: true,
              ),
              AppThumbnail(
                width: 160,
                fallbackIcon: Icons.broken_image_outlined,
                showRadius: true,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Ratios',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              AppThumbnail(
                width: 160,
                ratio: AppRatio.square,
                fallbackIcon: Icons.coffee_rounded,
                showRadius: true,
              ),
              AppThumbnail(
                width: 160,
                ratio: AppRatio.ratio16x9,
                fallbackIcon: Icons.coffee_rounded,
                showRadius: true,
              ),
              AppThumbnail(
                width: 160,
                ratio: AppRatio.ratio3x4,
                fallbackIcon: Icons.coffee_rounded,
                showRadius: true,
              ),
            ],
          ),
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
