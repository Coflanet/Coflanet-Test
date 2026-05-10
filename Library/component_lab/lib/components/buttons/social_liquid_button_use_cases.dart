import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_liquid_glass_button.dart';
import 'app_social_button.dart';

final List<WidgetbookComponent> socialButtonUseCases = [
  WidgetbookComponent(
    name: 'AppSocialButton',
    useCases: [
      WidgetbookUseCase(
        name: '4 프로바이더 — Kakao / Naver / Apple / Google',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSocialButton(
                  provider: AppSocialProvider.kakao,
                  onPressed: () {}),
              const SizedBox(height: AppSpacing.space12),
              AppSocialButton(
                  provider: AppSocialProvider.naver,
                  onPressed: () {}),
              const SizedBox(height: AppSpacing.space12),
              AppSocialButton(
                  provider: AppSocialProvider.apple,
                  onPressed: () {}),
              const SizedBox(height: AppSpacing.space12),
              AppSocialButton(
                  provider: AppSocialProvider.google,
                  onPressed: () {}),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Custom text',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSocialButton(
                provider: AppSocialProvider.kakao,
                customText: '카카오로 1초 만에 가입',
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.space12),
              AppSocialButton(
                provider: AppSocialProvider.apple,
                customText: 'Apple ID로 계속',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

final List<WidgetbookComponent> liquidGlassButtonUseCases = [
  WidgetbookComponent(
    name: 'AppLiquidGlassButton',
    useCases: [
      WidgetbookUseCase(
        name: 'Sizes — md / lg / xl (이미지 배경 위)',
        builder: (context) => _imageBg(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLiquidGlassButton(
                  text: 'Medium',
                  size: AppLiquidGlassSize.md,
                  width: 280,
                  onPressed: () {}),
              const SizedBox(height: AppSpacing.space16),
              AppLiquidGlassButton(
                  text: 'Large',
                  size: AppLiquidGlassSize.lg,
                  width: 280,
                  onPressed: () {}),
              const SizedBox(height: AppSpacing.space16),
              AppLiquidGlassButton(
                  text: 'Extra Large',
                  size: AppLiquidGlassSize.xl,
                  width: 280,
                  onPressed: () {}),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With icons',
        builder: (context) => _imageBg(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLiquidGlassButton(
                text: '레시피 시작',
                leadingIcon: Icons.coffee_rounded,
                width: 280,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.space16),
              AppLiquidGlassButton(
                text: '다음으로',
                trailingIcon: Icons.arrow_forward_rounded,
                width: 280,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.space16),
              AppLiquidGlassButton(
                text: '저장하기',
                leadingIcon: Icons.bookmark_rounded,
                trailingIcon: Icons.check_rounded,
                width: 280,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => _imageBg(
          Center(
            child: AppLiquidGlassButton(
              text: 'Disabled',
              width: 280,
              onPressed: null,
            ),
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

/// LiquidGlass는 어두운 이미지 배경 위에서 빛나니 그런 환경 제공.
Widget _imageBg(Widget child) {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=1200',
        ),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      color: AppColor.colorGlobalCommon0.withValues(alpha: 0.25),
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: child,
    ),
  );
}
