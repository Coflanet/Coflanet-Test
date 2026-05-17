import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../buttons/app_solid_button.dart';
import 'app_action_sheet.dart';

final List<WidgetbookComponent> actionSheetUseCases = [
  WidgetbookComponent(
    name: 'AppActionSheet',
    useCases: [
      WidgetbookUseCase(
        name: 'iOS — 사진 추가',
        builder: (context) => _bg(
          context,
          AppSolidButton(
            label: 'iOS Action Sheet 열기',
            onPressed: () => AppActionSheet.show(
              context,
              title: '사진 추가',
              actions: const [
                AppActionSheetAction(label: '카메라', icon: Icons.camera_alt_rounded),
                AppActionSheetAction(
                    label: '앨범에서 선택', icon: Icons.photo_library_rounded),
                AppActionSheetAction(
                    label: '삭제',
                    icon: Icons.delete_outline_rounded,
                    isDestructive: true),
              ],
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'iOS — with message',
        builder: (context) => _bg(
          context,
          AppSolidButton(
            label: 'iOS w/ message',
            onPressed: () => AppActionSheet.show(
              context,
              title: '계정 삭제',
              message: '삭제하면 되돌릴 수 없습니다.',
              actions: const [
                AppActionSheetAction(label: '삭제', isDestructive: true),
              ],
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Android — drag handle',
        builder: (context) => _bg(
          context,
          AppSolidButton(
            label: 'Android Action Sheet 열기',
            onPressed: () => AppActionSheet.show(
              context,
              style: AppActionSheetStyle.android,
              title: '공유',
              actions: const [
                AppActionSheetAction(label: '메시지', icon: Icons.message_rounded),
                AppActionSheetAction(label: '메일', icon: Icons.email_rounded),
                AppActionSheetAction(label: '링크 복사', icon: Icons.link_rounded),
              ],
            ),
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
    alignment: Alignment.center,
    child: child,
  );
}
