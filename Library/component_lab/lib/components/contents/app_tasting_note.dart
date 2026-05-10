import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Tasting Note 아이템 — Figma `Contents/TastingNote`.
///
/// 좌측 원형 아이콘 / 일러스트 + 제목(시트러스 등) + 보조 설명 +
/// 우측 chevron 으로 구성된 작은 네비 카드.
class AppTastingNote extends StatelessWidget {
  const AppTastingNote({
    super.key,
    required this.title,
    required this.description,
    this.leading,
    this.trailingIcon = Icons.chevron_right_rounded,
    this.onTap,
  });

  final String title;
  final String description;

  /// 좌측 원형 영역에 들어갈 위젯 (아이콘 / 일러스트 / 작은 이미지).
  /// null 이면 placeholder 아이콘.
  final Widget? leading;

  /// 우측 화살표 아이콘. null 로 설정하면 미표시.
  final IconData? trailingIcon;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(AppRadius.radius12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.space12,
        ),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 36,
                height: 36,
                color: AppColor.colorGlobalOrange95,
                alignment: Alignment.center,
                child: leading ??
                    Icon(
                      Icons.local_florist_outlined,
                      size: 20,
                      color: AppColor.accentForegroundOrange,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body2NormalMedium.copyWith(
                      color: AppColor.labelNormal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: AppSpacing.space8),
              Icon(
                trailingIcon,
                size: 18,
                color: AppColor.labelAlternative,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
