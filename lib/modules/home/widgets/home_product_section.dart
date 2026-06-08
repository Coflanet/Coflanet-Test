import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/home/widgets/home_empty_card.dart';
import 'package:coflanet/modules/home/widgets/home_section_more_button.dart';
import 'package:coflanet/widgets/cards/product_card.dart';
import 'package:coflanet/widgets/typography/section_title.dart';

/// 홈 상품 섹션 — 섹션 타이틀 + 2열 상품 그리드 (또는 빈 상태 카드) + 하단 '더 보기' 버튼.
///
/// 취향 추천 / 인기 랭킹 / 실시간 인기 등 모든 상품 섹션이 공유한다.
/// 모든 섹션을 풀폭 둥근 섹션 카드(surfaceCard, radius 20)로 통일하며,
/// 그리드 하단에 항상 [HomeSectionMoreButton] 더 보기 버튼을 노출한다.
///
/// 좋아요 반응성: 카드 단위 Obx 로 [isLiked] 를 구독 — 한 카드 토글이
/// 다른 카드를 리빌드하지 않는다 (전체 그리드 단일 Obx 금지).
class HomeProductSection extends StatelessWidget {
  const HomeProductSection({
    super.key,
    required this.title,
    required this.items,
    required this.emptyMessage,
    required this.isLiked,
    required this.onLikeTap,
    this.onMoreTap,
    this.moreLabel = '추천 원두 더 보기',
  });

  /// 섹션 타이틀
  final String title;

  /// 상품 목록 — 비어 있으면 [emptyMessage] 빈 카드 노출
  final List<CoffeeRecommendationModel> items;

  /// 빈 상태 안내 문구
  final String emptyMessage;

  /// 좋아요 여부 조회 (Rx 기반 — 카드별 Obx 안에서 호출됨)
  final bool Function(String id) isLiked;

  /// 좋아요 토글 콜백
  final void Function(String id) onLikeTap;

  /// 더 보기 버튼 탭 콜백 — null 이면 동작 없음 ([백엔드 API 연동 대기])
  final VoidCallback? onMoreTap;

  /// 더 보기 버튼 라벨
  final String moreLabel;

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
          SectionTitle(
            title: title,
            titleStyle: AppTextStyles.body1NormalBold.copyWith(
              color: colors.labelStrong,
            ),
          ),
          const SizedBox(height: 12),
          if (items.isNotEmpty)
            _buildGrid()
          else
            HomeEmptyCard(message: emptyMessage),
          const SizedBox(height: 16),
          HomeSectionMoreButton(label: moreLabel, onTap: onMoreTap),
        ],
      ),
    );
  }

  /// 공통 상품 그리드 (2열).
  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        // 정사각 이미지 + 텍스트(태그/브랜드/이름 2줄/가격) 수용 여유 높이.
        // 오버플로우 방지는 ProductCard 내부 Expanded+Flexible 구조가 보장.
        childAspectRatio: 0.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        // 카드별 Obx — 해당 카드의 좋아요 상태만 구독
        return Obx(
          () => ProductCard(
            name: item.name,
            subtitle: '${item.manufacturer ?? '브랜드명'} | ${item.origin}',
            isLiked: isLiked(item.id),
            onLikeTap: () => onLikeTap(item.id),
            imageUrl: item.imageUrl,
            matchPercent: item.matchPercent,
            discountPercent: item.discountPercent,
            price: item.discountPrice ?? item.originalPrice,
          ),
        );
      },
    );
  }
}
