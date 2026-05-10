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
        name: 'With Image',
        builder: (context) => _wrap(context, [
          AppAvatar(
            imageUrl:
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
            size: AppAvatarSize.medium,
          ),
          AppAvatar(
            imageUrl:
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
            size: AppAvatarSize.large,
          ),
          AppAvatar(
            imageUrl: 'https://invalid-url.example/image.jpg',
            initials: 'FB',
            size: AppAvatarSize.large,
          ),
          AppAvatar(
            imageUrl:
                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
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
