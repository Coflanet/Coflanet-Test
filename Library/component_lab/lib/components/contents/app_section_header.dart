import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Section Header 사이즈 — Figma `Contents/Section Header` size.
enum AppSectionHeaderSize {
  /// 14px caption
  xsmall,

  /// 16px label
  small,

  /// 18px headline2 (default)
  medium,

  /// 22px headline1
  large,
}

/// Section Header 정렬 — Figma `Contents/Section Header` align.
enum AppSectionHeaderAlign {
  /// 한 줄 — 우측에 trailing 위젯이 있을 때 horizontally laid
  inline,

  /// 두 줄 — 제목이 길거나 trailing이 아래로 떨어질 때
  multiline,
}

/// Section Header — Figma `Contents/Section Header`.
///
/// 콘텐츠 페이지의 각 구역을 구분하는 제목 영역.
/// `trailing` 위젯에 텍스트 / 칩 / 화살표 / 드롭다운 등 어떤 것이든 들어갈 수 있다.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.size = AppSectionHeaderSize.medium,
    this.align = AppSectionHeaderAlign.inline,
    this.trailing,
    this.onTap,
  });

  final String title;

  /// 보조 설명 — 제목 아래 작은 라인.
  final String? subtitle;

  final AppSectionHeaderSize size;
  final AppSectionHeaderAlign align;

  /// 우측 영역 — 텍스트, 아이콘, 드롭다운, 버튼 등 자유.
  final Widget? trailing;

  final VoidCallback? onTap;

  TextStyle _titleStyle() {
    switch (size) {
      case AppSectionHeaderSize.xsmall:
        return AppTextStyles.caption1Bold;
      case AppSectionHeaderSize.small:
        return AppTextStyles.label1NormalBold;
      case AppSectionHeaderSize.medium:
        return AppTextStyles.headline2Bold;
      case AppSectionHeaderSize.large:
        return AppTextStyles.headline1Bold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
      style: _titleStyle().copyWith(color: AppColor.labelNormal),
    );
    final subtitleWidget = subtitle == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle!,
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
          );

    final body = align == AppSectionHeaderAlign.inline
        ? Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titleWidget,
                    if (subtitleWidget != null) subtitleWidget,
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.space12),
                trailing!,
              ],
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              titleWidget,
              if (subtitleWidget != null) subtitleWidget,
              if (trailing != null) ...[
                const SizedBox(height: AppSpacing.space8),
                trailing!,
              ],
            ],
          );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space12,
        ),
        child: body,
      ),
    );
  }
}
