import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Community List 아이템 — Figma `Contents/Community List`.
///
/// 커뮤니티 게시글 카드. 본문 + 작성자 + 좋아요/댓글 카운트 + 썸네일 +
/// 우상단 알림 dot (옵션).
class AppCommunityListItem extends StatelessWidget {
  const AppCommunityListItem({
    super.key,
    required this.content,
    required this.author,
    this.likeCount = 0,
    this.commentCount = 0,
    this.thumbnail,
    this.hasUnread = false,
    this.onTap,
  });

  final String content;
  final String author;
  final int likeCount;
  final int commentCount;

  /// null 이면 placeholder(아이콘) 표시.
  final Widget? thumbnail;

  /// 우상단 빨간 dot 표시 — 읽지 않은 게시글 강조.
  final bool hasUnread;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    content,
                    style: AppTextStyles.body2NormalRegular.copyWith(
                      color: AppColor.labelNormal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        author,
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.labelAlternative,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 14,
                        color: AppColor.labelAlternative,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$likeCount',
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.labelAlternative,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space8),
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 14,
                        color: AppColor.labelAlternative,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$commentCount',
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.labelAlternative,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radius8),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: thumbnail ??
                        Container(
                          color: AppColor.lineSolidNeutral,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_outlined,
                            size: 18,
                            color: AppColor.labelAlternative,
                          ),
                        ),
                  ),
                ),
                if (hasUnread)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColor.statusNegative,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.backgroundNormalNormal,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
