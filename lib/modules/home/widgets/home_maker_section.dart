import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/home/widgets/home_empty_card.dart';
import 'package:coflanet/widgets/cards/card_section.dart';

/// 홈 '커피 메이커가 필요하신가요?' 섹션 — iyumi 큰 카드([CardSection]).
///
/// 타이틀+부제가 한 쌍이라 CardSection title 대신 child 안에서 직접 그린다
/// (CardSection title 은 아래 md 갭이 붙어 부제와 떨어짐). 카드 안이라 of(context).
/// [백엔드 API 연동 대기] 커피 메이커 상품 API 연동 전까지 빈 상태 카드 노출.
class HomeMakerSection extends StatelessWidget {
  const HomeMakerSection({super.key, required this.userName});

  /// 사용자 이름 — '#OOO님의 #취향저격' 부제에 사용
  final String userName;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return CardSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '커피 메이커가 필요하신가요?',
            // Figma Home 섹션 타이틀: SemiBold 20 = heading2Bold
            style: AppTextStyles.heading2Bold.copyWith(
              color: colors.labelStrong,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '#$userName님의 #취향저격',
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelAlternative,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // [백엔드 API 연동 대기] 커피 메이커 상품 가로 스크롤 리스트
          const HomeEmptyCard(message: '커피 메이커 상품을 준비 중이에요'),
        ],
      ),
    );
  }
}
