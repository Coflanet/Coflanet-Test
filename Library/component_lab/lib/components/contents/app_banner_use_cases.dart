import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_banner.dart';

// ═══════════════════════════════════════════════════════════════
// BANNER — Figma `Contents/Card/Banner`
// ═══════════════════════════════════════════════════════════════

Widget _gradientBg() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.colorGlobalViolet80,
            AppColor.colorGlobalViolet40,
          ],
        ),
      ),
    );

final List<WidgetbookComponent> bannerUseCases = [
  WidgetbookComponent(
    name: 'Banner — Hero',
    useCases: [
      WidgetbookUseCase(
        name: 'Square (1:1)',
        builder: (context) => _bg(
          context,
          SizedBox(
            width: 240,
            child: AppBanner(
              title: '타이틀을 입력해주세요.\n최대 2줄까지 입력가능합니다.',
              aspectRatio: 1,
              background: _gradientBg(),
              onTap: () {},
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Wide (16:9)',
        builder: (context) => _bg(
          context,
          SizedBox(
            width: 320,
            child: AppBanner(
              title: '타이틀을 입력해주세요.\n최대 2줄까지 입력가능합니다.',
              aspectRatio: 16 / 9,
              background: _gradientBg(),
              onTap: () {},
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Portrait (3:4)',
        builder: (context) => _bg(
          context,
          SizedBox(
            width: 200,
            child: AppBanner(
              title: '타이틀을 입력해주세요.\n최대 2줄까지 입력가능',
              aspectRatio: 3 / 4,
              background: _gradientBg(),
              onTap: () {},
            ),
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Banner — Compact',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => _bg(
          context,
          AppBanner(
            layout: AppBannerLayout.compact,
            title: '타이틀 입력',
            body: '본문을 입력해주세요. 최대 2줄 입니다.',
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Without body',
        builder: (context) => _bg(
          context,
          AppBanner(
            layout: AppBannerLayout.compact,
            title: '타이틀 입력',
            onTap: () {},
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Banner — Stack',
    useCases: [
      WidgetbookUseCase(
        name: 'Hero row + compact list',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: double.infinity,
                child: AppBanner(
                  title: '오늘의 큐레이션 — 가을 산미',
                  aspectRatio: 16 / 9,
                  background: _gradientBg(),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: AppSpacing.space12),
              AppBanner(
                layout: AppBannerLayout.compact,
                title: '바리스타 추천 시그니처',
                body: '주니어 바리스타가 직접 큐레이션한 시그니처 메뉴',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.space8),
              AppBanner(
                layout: AppBannerLayout.compact,
                title: '핸드드립 입문 가이드',
                body: '처음 시작하는 분들을 위한 5단계 가이드',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: Theme.of(context).canvasColor,
    padding: const EdgeInsets.all(AppSpacing.space16),
    child: child,
  );
}
