import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_text_field.dart';

final List<WidgetbookComponent> textFieldUseCases = [
  WidgetbookComponent(
    name: 'AppTextField',
    useCases: [
      WidgetbookUseCase(
        name: 'Sizes — sm / md / lg',
        builder: (context) => _wrap(
          context,
          [
            const AppTextField(
              size: AppTextFieldSize.sm,
              hintText: 'Small (40px)',
            ),
            const AppTextField(
              size: AppTextFieldSize.md,
              hintText: 'Medium (48px) — default',
            ),
            const AppTextField(
              size: AppTextFieldSize.lg,
              hintText: 'Large (56px)',
            ),
          ],
        ),
      ),
      WidgetbookUseCase(
        name: 'With Label / Helper / Error',
        builder: (context) => _wrap(
          context,
          [
            const AppTextField(
              label: '이메일',
              hintText: 'name@example.com',
            ),
            const AppTextField(
              label: '비밀번호',
              hintText: '8자 이상',
              obscureText: true,
              showPasswordToggle: true,
              helperText: '영문·숫자·특수문자 조합',
            ),
            const AppTextField(
              label: '닉네임',
              hintText: '닉네임을 입력하세요',
              errorText: '이미 사용 중인 닉네임이에요',
            ),
          ],
        ),
      ),
      WidgetbookUseCase(
        name: 'States',
        builder: (context) => _wrap(
          context,
          [
            const AppTextField(label: 'Normal', hintText: '입력하세요'),
            const AppTextField(
              label: 'Focused (자동 포커스)',
              hintText: '클릭 또는 탭',
              autofocus: true,
            ),
            const AppTextField(
              label: 'Error',
              hintText: '입력하세요',
              errorText: '오류 메시지',
            ),
            const AppTextField(
              label: 'Disabled',
              hintText: '입력 불가',
              isEnabled: false,
            ),
            const AppTextField(
              label: 'Read-only',
              hintText: '읽기 전용',
              readOnly: true,
              helperText: '탭은 가능하지만 수정 불가',
            ),
          ],
        ),
      ),
      WidgetbookUseCase(
        name: 'With Icons',
        builder: (context) => _wrap(
          context,
          [
            const AppTextField(
              hintText: '검색어를 입력하세요',
              prefixIcon: Icons.search,
            ),
            const AppTextField(
              hintText: '이메일',
              prefixIcon: Icons.email_outlined,
              suffixIcon: Icons.clear,
            ),
          ],
        ),
      ),
      WidgetbookUseCase(
        name: 'Multiline',
        builder: (context) => _wrap(
          context,
          [
            const AppTextField(
              label: '자기소개',
              hintText: '자유롭게 입력해주세요',
              maxLines: 4,
              minLines: 3,
              maxLength: 200,
              helperText: '최대 200자',
            ),
          ],
        ),
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final child in children) ...[
          child,
          const SizedBox(height: AppSpacing.space20),
        ],
      ],
    ),
  );
}
