import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../buttons/app_solid_button.dart';
import 'app_confirm_dialog.dart';

final List<WidgetbookComponent> modalUseCases = [
  WidgetbookComponent(
    name: 'AppConfirmDialog',
    useCases: [
      WidgetbookUseCase(
        name: 'Inline preview — title + message + 2 buttons',
        builder: (context) => _bg(
          context,
          AppConfirmDialog(
            title: '저장하시겠어요?',
            message: '변경 사항을 저장하면 이전 내용으로 되돌릴 수 없습니다.',
            onConfirm: () {},
            onCancel: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Destructive — 삭제 등',
        builder: (context) => _bg(
          context,
          AppConfirmDialog(
            title: '정말 삭제하시겠어요?',
            message: '이 작업은 되돌릴 수 없습니다.',
            confirmText: '삭제',
            cancelText: '취소',
            isDestructive: true,
            onConfirm: () {},
            onCancel: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Title only',
        builder: (context) => _bg(
          context,
          AppConfirmDialog(
            title: '계속 진행할까요?',
            onConfirm: () {},
            onCancel: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Live — 버튼 누르면 실제 다이얼로그',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final bg = isDark
              ? AppColor.darkBackgroundNormalNormal
              : AppColor.backgroundNormalNormal;
          return Container(
            color: bg,
            padding: const EdgeInsets.all(24),
            child: Center(
              child: AppSolidButton(
                label: '다이얼로그 띄우기',
                onPressed: () => showAppConfirmDialog(
                  context: context,
                  title: '구독을 취소할까요?',
                  message: '현재까지 받으신 혜택은 유지되지만\n다음 결제부터 청구되지 않습니다.',
                  confirmText: '취소하기',
                  cancelText: '닫기',
                  isDestructive: true,
                ),
              ),
            ),
          );
        },
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  // Modal 뒤 dim 효과 미리보기
  return Stack(
    children: [
      Container(
        color: isDark
            ? AppColor.darkBackgroundNormalNormal
            : AppColor.backgroundNormalNormal,
      ),
      Container(
        color: isDark
            ? AppColor.darkComponentMaterialDimmer
            : AppColor.componentMaterialDimmer,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
        child: child,
      ),
    ],
  );
}
