import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_progress_tracker.dart';

final List<WidgetbookComponent> progressTrackerUseCases = [
  WidgetbookComponent(
    name: 'AppProgressTracker',
    useCases: [
      WidgetbookUseCase(
        name: 'Horizontal — 4 steps, current=1',
        builder: (context) => _bg(
          context,
          const AppProgressTracker(
            steps: [
              AppProgressStep(label: '주문'),
              AppProgressStep(label: '결제'),
              AppProgressStep(label: '준비'),
              AppProgressStep(label: '배송'),
            ],
            currentStep: 1,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Horizontal — all complete',
        builder: (context) => _bg(
          context,
          const AppProgressTracker(
            steps: [
              AppProgressStep(label: '시작'),
              AppProgressStep(label: '중간'),
              AppProgressStep(label: '완료'),
            ],
            currentStep: 3,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Vertical — 4 steps with subLabel',
        builder: (context) => _bg(
          context,
          const AppProgressTracker(
            axis: AppProgressTrackerAxis.vertical,
            steps: [
              AppProgressStep(
                label: '주문 접수',
                subLabel: '2025-05-11 09:14',
              ),
              AppProgressStep(
                label: '결제 완료',
                subLabel: '2025-05-11 09:15',
              ),
              AppProgressStep(label: '상품 준비 중', subLabel: '예상 1~2일'),
              AppProgressStep(label: '배송 시작'),
            ],
            currentStep: 2,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Vertical — all pending',
        builder: (context) => _bg(
          context,
          const AppProgressTracker(
            axis: AppProgressTrackerAxis.vertical,
            steps: [
              AppProgressStep(label: 'Step 1'),
              AppProgressStep(label: 'Step 2'),
              AppProgressStep(label: 'Step 3'),
            ],
            currentStep: 0,
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: AppColor.backgroundNormalNormal,
    padding: const EdgeInsets.all(AppSpacing.s24),
    child: child,
  );
}
