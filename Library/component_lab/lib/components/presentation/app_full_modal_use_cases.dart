import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import '../buttons/app_solid_button.dart';
import 'app_full_modal.dart';

final List<WidgetbookComponent> fullModalUseCases = [
  WidgetbookComponent(
    name: 'AppFullModal',
    useCases: [
      WidgetbookUseCase(
        name: 'Trigger — with TopNavigation',
        builder: (context) => _bg(
          context,
          AppSolidButton(
            label: 'Full Modal 열기',
            onPressed: () => AppFullModal.show(
              context,
              title: '약관 동의',
              builder: (_) => const _DemoBody(
                text: 'TopNavigation이 자동으로 포함된 풀스크린 모달.\n'
                    'leading X를 누르면 닫힙니다.',
              ),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Trigger — bare (no navigation)',
        builder: (context) => _bg(
          context,
          AppSolidButton(
            label: 'Bare Modal 열기',
            onPressed: () => AppFullModal.show(
              context,
              withNavigation: false,
              builder: (ctx) => SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Bare full modal',
                        style: AppTextStyles.title2Bold.copyWith(
                          color: AppColor.labelNormal,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      AppSolidButton(
                        label: '닫기',
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
];

class _DemoBody extends StatelessWidget {
  const _DemoBody({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Text(
        text,
        style: AppTextStyles.body1NormalRegular.copyWith(
          color: AppColor.labelNormal,
        ),
      ),
    );
  }
}

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: AppColor.backgroundNormalNormal,
    padding: const EdgeInsets.all(AppSpacing.s24),
    alignment: Alignment.center,
    child: child,
  );
}
