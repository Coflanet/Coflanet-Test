import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/home/widgets/home_empty_card.dart';

/// 홈 '커피 메이커가 필요하신가요?' 섹션 — 테마 반응 섹션 카드.
///
/// [백엔드 API 연동 대기] 커피 메이커 상품 API 연동 전까지 목데이터 없이
/// 빈 상태 카드를 노출한다 (다른 상품 섹션과 동일 패턴).
class HomeMakerSection extends StatelessWidget {
  const HomeMakerSection({super.key, required this.userName});

  /// 사용자 이름 — '#OOO님의 #취향저격' 부제에 사용
  final String userName;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.xxlBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '커피 메이커가 필요하신가요?',
            style: AppTextStyles.body1NormalBold.copyWith(
              color: colors.labelStrong,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '#$userName님의 #취향저격',
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelAlternative,
            ),
          ),
          const SizedBox(height: 12),
          // [백엔드 API 연동 대기] 커피 메이커 상품 가로 스크롤 리스트
          const HomeEmptyCard(message: '커피 메이커 상품을 준비 중이에요'),
        ],
      ),
    );
  }
}
