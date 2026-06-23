import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/core/services/cart_service.dart';
import 'package:coflanet/core/services/notification_service.dart';
import 'package:coflanet/modules/home/home_controller.dart';
import 'package:coflanet/modules/home/widgets/home_carousel.dart';
import 'package:coflanet/modules/home/widgets/home_footer.dart';
import 'package:coflanet/modules/home/widgets/home_maker_section.dart';
import 'package:coflanet/modules/home/widgets/home_my_bean_section.dart';
import 'package:coflanet/modules/home/widgets/home_product_section.dart';
import 'package:coflanet/modules/home/widgets/home_promo_banner.dart';
import 'package:coflanet/modules/home/widgets/home_taste_banner.dart';
import 'package:coflanet/modules/home/widgets/home_top_bar.dart';
import 'package:coflanet/modules/shell/main_shell_controller.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Home Content — Figma `Home_Item_yes` 화면 구현
///
/// 섹션 구성 (위젯은 modules/home/widgets/ 에 분리, 각 섹션은 독립 카드):
/// - 상단 헤더 (HomeTopBar) — 검정 배경 위 보라 로고 + 아이콘 (카드 아님)
/// - 광고 캐러셀 (HomeCarousel) — 서버 배너(home_carousel 슬롯) 둥근 카드
/// - 보유 원두 (HomeMyBeanSection) — 보라 둥근 카드
/// - 취향 배너 (HomeTasteBanner) — 설문 완료 시
/// - 상품 섹션 (HomeProductSection) — 취향 추천 (취향 배너 위)
/// - 프로모 배너 (HomePromoBanner) — 서버 배너(home_promo 슬롯) 있을 때만
/// - 상품 섹션 (HomeProductSection) — '새로운 맛을 찾아볼까요?'
/// - 커피 메이커 섹션 (HomeMakerSection)
/// - 커피 기록 커뮤니티 (HomeCommunitySection)
/// - 푸터 (HomeFooter)
///
/// 빈 데이터일 때는 카드 구조는 유지하고 안내 텍스트로 [empty] 표시.
class HomeContent extends GetView<HomeController> {
  const HomeContent({super.key});

  /// 최상위 섹션 사이 공통 간격
  static const double _sectionGap = 12;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Obx(() {
      if (controller.isLoading) {
        return Container(
          color: colors.backgroundNormalAlternative,
          child: Center(
            child: CircularProgressIndicator(color: colors.primaryNormal),
          ),
        );
      }
      // 페이지 배경 — 다크: 순검정(Figma), 라이트: 밝은 회색 위 흰 카드
      return Container(
        color: colors.backgroundNormalAlternative,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 상단 헤더 — 검정 배경 위 (카드 아님).
                // 알림 dot / 장바구니 뱃지 — 중첩 Obx 로 서비스 변경 시 헤더만 리빌드
                Obx(
                  () => HomeTopBar(
                    hasUnread: NotificationService.to.hasUnread,
                    cartBadgeCount: CartService.to.distinctCount,
                    onSearchTap: () => Get.toNamed(Routes.search),
                    onNotificationTap: () => Get.toNamed(Routes.notification),
                    onCartTap: () => Get.toNamed(Routes.cart),
                  ),
                ),
                const SizedBox(height: _sectionGap),
                // 광고 캐러셀 — 서버 배너(home_carousel 슬롯), 없으면 placeholder 1장
                HomeCarousel(
                  banners: controller.carouselBanners,
                  pageController: controller.carouselController,
                  currentIndex: controller.carouselIndex,
                  onPageChanged: controller.onCarouselPageChanged,
                  onBannerTap: controller.onBannerTap,
                ),
                const SizedBox(height: _sectionGap),
                // 보유 원두 — 보라 둥근 카드
                HomeMyBeanSection(
                  beans: controller.myBeans,
                  onEditTap: _goToCoffeeTab,
                  onViewAllTap: _goToCoffeeTab,
                  onBeanTap: (bean) =>
                      Get.toNamed(Routes.beanDetail, arguments: {'bean': bean}),
                ),
                const SizedBox(height: _sectionGap),
                if (controller.hasTasteProfile) ...[
                  HomeTasteBanner(
                    typeLabel: controller.tasteTypeLabel,
                    flavors: controller.tasteFlavors,
                  ),
                  const SizedBox(height: _sectionGap),
                ],
                HomeProductSection(
                  title: '${controller.userName}님의 취향의 원두에요',
                  items: controller.tasteRecommendations,
                  emptyMessage: '취향 분석 결과를 준비 중이에요',
                  isLiked: controller.isLiked,
                  onLikeTap: controller.toggleLike,
                  onMoreTap: _goToShoppingTab,
                ),
                const SizedBox(height: _sectionGap),
                // 프로모 배너 — 서버 배너(home_promo 슬롯) 있을 때만 노출
                if (controller.promoBanner != null) ...[
                  HomePromoBanner(
                    banner: controller.promoBanner!,
                    onTap: () =>
                        controller.onBannerTap(controller.promoBanner!),
                  ),
                  const SizedBox(height: _sectionGap),
                ],
                // [백엔드 API 연동 대기] 실시간 인기 전용 API 연동 시 추가 섹션 검토.
                HomeProductSection(
                  title: '새로운 맛을 찾아볼까요?',
                  items: controller.categoryBest,
                  emptyMessage: '추천 데이터를 준비 중이에요',
                  isLiked: controller.isLiked,
                  onLikeTap: controller.toggleLike,
                  onMoreTap: _goToShoppingTab,
                ),
                const SizedBox(height: _sectionGap),
                HomeMakerSection(userName: controller.userName),
                const SizedBox(height: _sectionGap),
                // 커뮤니티 섹션은 커뮤니티 탭 비노출(MVP)에 맞춰 제거.
                const HomeFooter(),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// 원두 목록(원두 탭)으로 이동
  void _goToCoffeeTab() {
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().goToCoffee();
    }
  }

  /// 쇼핑 탭으로 이동
  void _goToShoppingTab() {
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().goToShopping();
    }
  }
}
