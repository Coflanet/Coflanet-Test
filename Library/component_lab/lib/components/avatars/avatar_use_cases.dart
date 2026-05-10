import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import 'app_avatar.dart';

final List<WidgetbookComponent> avatarUseCases = [
  WidgetbookComponent(
    name: 'AppAvatar',
    useCases: [
      WidgetbookUseCase(
        name: 'Person — sizes',
        builder: (context) => _wrap(context, const [
          AppAvatar(initials: 'YJ', size: AppAvatarSize.xSmall),
          AppAvatar(initials: 'YJ', size: AppAvatarSize.small),
          AppAvatar(initials: 'YJ', size: AppAvatarSize.medium),
          AppAvatar(initials: 'YJ', size: AppAvatarSize.large),
          AppAvatar(initials: 'YJ', size: AppAvatarSize.xLarge),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Company — rounded square',
        builder: (context) => _wrap(context, const [
          AppAvatar(
            type: AppAvatarType.company,
            size: AppAvatarSize.xSmall,
          ),
          AppAvatar(
            type: AppAvatarType.company,
            size: AppAvatarSize.small,
          ),
          AppAvatar(
            type: AppAvatarType.company,
            size: AppAvatarSize.medium,
          ),
          AppAvatar(
            type: AppAvatarType.company,
            size: AppAvatarSize.large,
          ),
          AppAvatar(
            type: AppAvatarType.company,
            size: AppAvatarSize.xLarge,
          ),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Academic — rounded square',
        builder: (context) => _wrap(context, const [
          AppAvatar(
            type: AppAvatarType.academic,
            size: AppAvatarSize.medium,
          ),
          AppAvatar(
            type: AppAvatarType.academic,
            size: AppAvatarSize.large,
          ),
          AppAvatar(
            type: AppAvatarType.academic,
            size: AppAvatarSize.xLarge,
          ),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Fallback — initials / icon',
        builder: (context) => _wrap(context, const [
          AppAvatar(initials: 'A', size: AppAvatarSize.large),
          AppAvatar(initials: 'YJ', size: AppAvatarSize.large),
          AppAvatar(initials: '택림', size: AppAvatarSize.large),
          AppAvatar(size: AppAvatarSize.large), // 아이콘 fallback
        ]),
      ),
      WidgetbookUseCase(
        name: 'With Initials',
        builder: (context) => _wrap(context, [
          AppAvatar(
            initials: 'JD',
            size: AppAvatarSize.medium,
          ),
          AppAvatar(
            initials: 'AB',
            size: AppAvatarSize.large,
          ),
          AppAvatar(
            initials: 'FB',
            size: AppAvatarSize.large,
          ),
          AppAvatar(
            initials: 'CK',
            size: AppAvatarSize.xLarge,
          ),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Avatar Group',
        builder: (context) => _wrap(context, [
          AppAvatarGroup(
            avatars: const [
              AppAvatar(initials: 'A', size: AppAvatarSize.small),
              AppAvatar(initials: 'B', size: AppAvatarSize.small),
              AppAvatar(initials: 'C', size: AppAvatarSize.small),
              AppAvatar(initials: 'D', size: AppAvatarSize.small),
            ],
          ),
        ]),
      ),
    ],
  ),
];

Widget _wrap(BuildContext context, List<Widget> children) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bg = isDark
      ? AppColor.darkBackgroundNormalNormal
      : AppColor.backgroundNormalNormal;
  return Container(
    color: bg,
    padding: const EdgeInsets.all(24),
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    ),
  );
}
