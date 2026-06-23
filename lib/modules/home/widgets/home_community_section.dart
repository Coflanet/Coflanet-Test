import 'package:flutter/material.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/modules/home/widgets/home_empty_card.dart';
import 'package:coflanet/modules/home/widgets/home_section_more_button.dart';
import 'package:coflanet/widgets/cards/card_section.dart';

/// 홈 '커피 기록 커뮤니티' 섹션 — iyumi 큰 카드([CardSection]).
///
/// 현재 홈에서는 커뮤니티 탭 비노출(MVP)에 맞춰 미렌더이지만, 재노출 대비
/// 다른 상품 섹션과 동일한 CardSection 패턴으로 유지한다.
/// [백엔드 API 연동 대기] 커뮤니티 API 연동 전까지 빈 상태 카드 노출.
class HomeCommunitySection extends StatelessWidget {
  const HomeCommunitySection({super.key, this.onMoreTap});

  /// '커뮤니티 더 보기' 탭 콜백 — null 이면 동작 없음
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: '커피 기록 커뮤니티',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // [백엔드 API 연동 대기] 커뮤니티 기록 리스트
          const HomeEmptyCard(message: '커뮤니티 기록을 준비 중이에요'),
          const SizedBox(height: AppSpacing.md),
          HomeSectionMoreButton(label: '커뮤니티 더 보기', onTap: onMoreTap),
        ],
      ),
    );
  }
}
