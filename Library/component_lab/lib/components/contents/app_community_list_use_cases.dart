import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_community_list.dart';

// ═══════════════════════════════════════════════════════════════
// COMMUNITY LIST — Figma `Contents/Community List`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> communityListUseCases = [
  WidgetbookComponent(
    name: 'Community List',
    useCases: [
      WidgetbookUseCase(
        name: 'Default item',
        builder: (context) => _bg(
          context,
          AppCommunityListItem(
            content: '안녕하세요. 커피를 마시고 느낀점과 음용 방법을 기록...',
            author: '하얀동람보르기니',
            likeCount: 56,
            commentCount: 16,
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With unread dot',
        builder: (context) => _bg(
          context,
          AppCommunityListItem(
            content: '안녕하세요. 커피를 마시고 느낀점과 음용 방법을 기록...',
            author: '하얀동람보르기니',
            likeCount: 56,
            commentCount: 16,
            hasUnread: true,
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Stack (3 items)',
        builder: (context) => _bg(
          context,
          Column(
            children: [
              AppCommunityListItem(
                content: '오늘의 원두 추천 — 에티오피아 예가체프',
                author: '커피러버',
                likeCount: 42,
                commentCount: 8,
                hasUnread: true,
                onTap: () {},
              ),
              AppCommunityListItem(
                content: '핸드드립 추출 시간이 너무 짧으면 어떻게 되나요?',
                author: '하얀동람보르기니',
                likeCount: 56,
                commentCount: 16,
                onTap: () {},
              ),
              AppCommunityListItem(
                content: '에스프레소 머신 청소 주기 어떻게 하시나요?',
                author: '바리스타준',
                likeCount: 18,
                commentCount: 4,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: Theme.of(context).canvasColor,
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.space8),
    child: child,
  );
}
