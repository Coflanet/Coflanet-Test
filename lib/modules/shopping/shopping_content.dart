import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/modules/home/widgets/home_carousel.dart';
import 'package:coflanet/modules/home/widgets/home_promo_banner.dart';
import 'package:coflanet/modules/home/widgets/home_taste_banner.dart';
import 'package:coflanet/modules/shopping/shopping_controller.dart';
import 'package:coflanet/modules/shopping/widgets/shopping_countdown_pill.dart';
import 'package:coflanet/modules/shopping/widgets/shopping_filter_chips.dart';
import 'package:coflanet/modules/shopping/widgets/shopping_grid_section.dart';
import 'package:coflanet/modules/shopping/widgets/shopping_horizontal_section.dart';
import 'package:coflanet/modules/shopping/widgets/shopping_ranking_section.dart';

/// 쇼핑 탭 콘텐츠 — Figma `Shopping_Main`(101:28335) 구현.
///
/// Static/Black 캔버스(셸 소유) 위에 카드 섹션을 쌓는다(홈과 동일 카드 시스템).
/// 섹션 순서(Figma Container 101:28336):
/// - 광고 캐러셀(Banner 163:16739) — 둥근 카드 16:9 (재디자인 카드화)
/// - 취향 배너(Select 163:16523) — 노랑 카드
/// - 추천 원두(101:28344) — 가로 스크롤 + 다시 추천
/// - 카테고리별 베스트(101:28357) — 필터 칩 + 2열 그리드
/// - 인기 원두 랭킹(101:28393) — 세로 랭킹
/// - 실시간 인기(101:28404) — 가로 스크롤
/// - 프로모 배너(101:28415)
/// - 타임세일(Time_Sale 101:28419) — 카운트다운 + New/Best 그리드
class ShoppingContent extends GetView<ShoppingController> {
  const ShoppingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final canvas = AppColorScheme.canvas;

    return Obx(() {
      if (controller.isLoading) {
        return Center(
          child: CircularProgressIndicator(color: canvas.primaryNormal),
        );
      }
      return SingleChildScrollView(
        // 셸이 하단 인셋(탭바 클리어)을 적용하므로 호흡값만 추가
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.sectionGap),
            // 광고 캐러셀
            HomeCarousel(
              banners: controller.carouselBanners,
              pageController: controller.carouselController,
              currentIndex: controller.carouselIndex,
              onPageChanged: controller.onCarouselPageChanged,
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            // 취향 배너 (홈과 동일)
            HomeTasteBanner(
              typeLabel: controller.tasteTypeLabel,
              flavors: controller.tasteFlavors,
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            // 추천 원두 (가로 스크롤)
            ShoppingHorizontalSection(
              title: '${controller.userName}님을 위한 추천 원두',
              subtitle: '#${controller.userName}님의 #취향저격',
              items: controller.recommended,
              isLiked: controller.isLiked,
              onLikeTap: controller.toggleLike,
              onItemTap: controller.onProductTap,
              moreLabel: '다시 추천해주세요',
              onMoreTap: controller.reshuffleRecommended,
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            // 카테고리별 베스트 상품 (필터 + 그리드)
            ShoppingGridSection(
              title: '카테고리별 베스트 상품',
              header: const ShoppingFilterChips(
                filters: [
                  (label: '에스프레소 머신', selected: true),
                  (label: '풍미성향', selected: false),
                  (label: '바디감', selected: false),
                ],
              ),
              items: controller.categoryBest,
              isLiked: controller.isLiked,
              onLikeTap: controller.toggleLike,
              onItemTap: controller.onProductTap,
              moreLabel: '베스트 상품 전체보기',
              onMoreTap: controller.showComingSoon,
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            // 인기 원두 랭킹 (세로)
            ShoppingRankingSection(
              title: 'Coflanet 인기 원두 랭킹',
              items: controller.ranking,
              isLiked: controller.isLiked,
              onLikeTap: controller.toggleLike,
              onItemTap: controller.onProductTap,
              moreLabel: '원두 랭킹 전체보기',
              onMoreTap: controller.showComingSoon,
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            // 이번주 실시간 인기 원두 (가로 스크롤)
            ShoppingHorizontalSection(
              title: '이번주 실시간 인기 원두',
              items: controller.realtimePopular,
              isLiked: controller.isLiked,
              onLikeTap: controller.toggleLike,
              onItemTap: controller.onProductTap,
              moreLabel: '실시간 인기 상품 전체보기',
              onMoreTap: controller.showComingSoon,
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            // 프로모 배너
            HomePromoBanner(banner: controller.promoBanner),
            const SizedBox(height: AppSpacing.sectionGap),
            // 타임세일 — 카운트다운 + New/Best 그리드
            ShoppingGridSection(
              title: '오늘만 열리는 커피 행성',
              trailing: Obx(
                () =>
                    ShoppingCountdownPill(time: controller.timeSaleRemaining.value),
              ),
              childAspectRatio: 0.5,
              items: controller.timeSale,
              badgesFor: _timeSaleBadges,
              isLiked: controller.isLiked,
              onLikeTap: controller.toggleLike,
              onItemTap: controller.onProductTap,
              moreLabel: '타임특가 전체보기',
              onMoreTap: controller.showComingSoon,
            ),
          ],
        ),
      );
    });
  }

  /// 타임세일 상품별 New/Best 뱃지 (데모 규칙).
  static List<String> _timeSaleBadges(int index) {
    switch (index) {
      case 0:
        return const ['New', 'Best'];
      case 1:
        return const ['Best'];
      case 2:
        return const ['New'];
      default:
        return const [];
    }
  }
}
