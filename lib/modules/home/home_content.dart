import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/core/services/cart_service.dart';
import 'package:coflanet/core/services/notification_service.dart';
import 'package:coflanet/modules/home/home_controller.dart';
import 'package:coflanet/modules/home/widgets/home_carousel.dart';
import 'package:coflanet/modules/home/widgets/home_my_bean_section.dart';
import 'package:coflanet/modules/home/widgets/home_product_section.dart';
import 'package:coflanet/modules/home/widgets/home_taste_banner.dart';
import 'package:coflanet/modules/home/widgets/home_top_bar.dart';
import 'package:coflanet/modules/shell/main_shell_controller.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Home Content — Figma `Home_Item_yes` 화면 구현
///
/// 섹션 구성 (위젯은 modules/home/widgets/ 에 분리):
/// 1. 상단 헤더 (HomeTopBar) — 로고 + 검색/알림/장바구니
/// 2. 광고 캐러셀 (HomeCarousel) — [백엔드 API 연동 대기]
/// 3. 보유 원두 (HomeMyBeanSection) — 스토어 데이터, 없으면 empty
/// 4. 취향 배너 (HomeTasteBanner) — 설문 완료 시
/// 5~7. 상품 섹션 (HomeProductSection) — 취향 추천 / 인기 랭킹 / 실시간 인기
///
/// 빈 데이터일 때는 카드 구조는 유지하고 안내 텍스트로 [empty] 표시.
class HomeContent extends GetView<HomeController> {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return Container(
          color: AppColor.colorGlobalCommon0,
          child: Center(
            child: CircularProgressIndicator(color: AppColor.primaryNormal),
          ),
        );
      }
      // 다크 배경 — 홈 전체 검은색
      return Container(
        color: AppColor.colorGlobalCommon0,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                const SizedBox(height: 4),
                HomeCarousel(
                  pageController: controller.carouselController,
                  currentIndex: controller.carouselIndex,
                  totalCount: HomeController.carouselTotalCount,
                  onPageChanged: controller.onCarouselPageChanged,
                ),
                const SizedBox(height: 12),
                HomeMyBeanSection(
                  beans: controller.myBeans,
                  onEditTap: _goToCoffeeTab,
                  onViewAllTap: _goToCoffeeTab,
                ),
                const SizedBox(height: 8),
                if (controller.hasTasteProfile) ...[
                  HomeTasteBanner(
                    typeLabel: controller.tasteTypeLabel,
                    flavors: controller.tasteFlavors,
                  ),
                  const SizedBox(height: 8),
                ],
                HomeProductSection(
                  title: '${controller.userName}님의 취향의 원두에요',
                  items: controller.tasteRecommendations,
                  emptyMessage: '취향 분석 결과를 준비 중이에요',
                  isLiked: controller.isLiked,
                  onLikeTap: controller.toggleLike,
                  backgroundColor: AppColor.colorGlobalCoolNeutral15,
                ),
                const SizedBox(height: 12),
                HomeProductSection(
                  title: 'Coflanet 인기 원두 랭킹',
                  items: controller.categoryBest,
                  emptyMessage: '인기 랭킹 데이터를 준비 중이에요',
                  isLiked: controller.isLiked,
                  onLikeTap: controller.toggleLike,
                ),
                const SizedBox(height: 12),
                HomeProductSection(
                  title: '이번주 실시간 인기 원두',
                  items: controller.realtimePopular,
                  emptyMessage: '실시간 인기 데이터를 준비 중이에요',
                  isLiked: controller.isLiked,
                  onLikeTap: controller.toggleLike,
                ),
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
}
