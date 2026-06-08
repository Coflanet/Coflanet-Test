import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/home/widgets/home_empty_card.dart';
import 'package:coflanet/modules/home/widgets/home_section_more_button.dart';

/// 홈 '커피 기록 커뮤니티' 섹션 — 테마 반응 섹션 카드 안에 기록 리스트를 표시한다.
///
/// [백엔드 API 연동 대기] 커뮤니티 API 연동 전까지 목데이터 없이
/// 빈 상태 카드를 노출한다 (다른 상품 섹션과 동일 패턴).
class HomeCommunitySection extends StatelessWidget {
  const HomeCommunitySection({super.key, this.onMoreTap});

  /// '커뮤니티 더 보기' 탭 콜백 — null 이면 동작 없음
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.xxlBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '커피 기록 커뮤니티',
            style: AppTextStyles.body1NormalBold.copyWith(
              color: colors.labelStrong,
            ),
          ),
          const SizedBox(height: 16),
          // [백엔드 API 연동 대기] 커뮤니티 기록 리스트
          const HomeEmptyCard(message: '커뮤니티 기록을 준비 중이에요'),
          const SizedBox(height: 16),
          HomeSectionMoreButton(label: '커뮤니티 더 보기', onTap: onMoreTap),
        ],
      ),
    );
  }
}
