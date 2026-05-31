import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/modules/home/home_controller.dart';

/// Home Content — Figma `Home_Item_yes` 화면 구현
///
/// 섹션 구성:
/// 1. 보유 원두 캐러셀 (스토어 데이터 — 있으면 노출, 없으면 [empty])
/// 2. 노란 취향 배너 (설문 완료 시)
/// 3. 취향 기반 추천 그리드 (백엔드 미연동 → empty)
/// 4. 카테고리별 베스트 (백엔드 미연동 → empty)
/// 5. 실시간 인기 원두 (백엔드 미연동 → empty)
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
                _buildTopBar(),
                const SizedBox(height: 4),
                _buildCarousel(),
                const SizedBox(height: 12),
                _buildMyBeanSection(),
                const SizedBox(height: 8),
                if (controller.hasTasteProfile) _buildTasteBanner(),
                if (controller.hasTasteProfile) const SizedBox(height: 8),
                _buildTasteRecommendationGrid(),
                const SizedBox(height: 12),
                _buildCategoryBestSection(),
                const SizedBox(height: 12),
                _buildRealtimePopularSection(),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ===== 상단 헤더 (로고 SVG + 회색 원 아이콘 3개) =====
  /// 좌측 로고 (assets/images/logo_main.svg) + 우측 검색/알림/장바구니 아이콘.
  /// 다크 배경 위에 흰색 로고/아이콘, 우측 액션은 반투명 회색 원 안에 흰색 아이콘.
  /// [백엔드 API 연동 대기] 각 액션의 실제 동작 (검색, 알림 카운트, 장바구니 카운트)
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 로고 — assets/images/logo_main.svg 의 상단 아이콘 부분만 표시.
          // SVG ViewBox 150x126 중 아이콘은 위쪽 ~88px, "Coflanet" 텍스트는 아래쪽.
          // OverflowBox 로 SVG 자유 크기 + ClipRect 로 상단 28px 영역만 노출.
          // SVG width 48 → 자동 height = 48 * 126/150 = 40.32px, 그 중 28px (≈ 아이콘 88/126) 만 보임.
          Semantics(
            label: 'Coflanet',
            image: true,
            child: SizedBox(
              width: 48,
              height: 28,
              child: ClipRect(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/images/logo_main.svg',
                    width: 48,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildHeaderIconButton(
                svgPath: 'assets/icons/ic_search.svg',
                label: '검색',
                onTap: () {
                  // [백엔드 API 연동 대기] 검색 화면 이동
                },
              ),
              const SizedBox(width: 8),
              _buildHeaderIconButton(
                svgPath: 'assets/icons/ic_bell.svg',
                label: '알림',
                hasNotification: true,
                onTap: () {
                  // [백엔드 API 연동 대기] 알림 화면 이동
                },
              ),
              const SizedBox(width: 8),
              _buildHeaderIconButton(
                svgPath: 'assets/icons/ic_bag.svg',
                label: '장바구니',
                onTap: () {
                  // [백엔드 API 연동 대기] 장바구니 화면 이동
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 반투명 회색 원 안에 SVG 아이콘 (다크 테마 헤더용).
  ///
  /// 배경: 헤더 뒤가 단색 검정이라 BackdropFilter 블러는 시각 효과가 없고
  /// 아이콘 가장자리에 뿌연 샘플링 아티팩트만 유발 → 불투명 회색 fill 로 대체.
  /// 아이콘: SVG `fill="currentColor"` + Colors.white 로 확실한 흰색 tint.
  /// hasNotification true → 우상단에 보라 점 (알림 뱃지).
  Widget _buildHeaderIconButton({
    required String svgPath,
    required String label,
    required VoidCallback onTap,
    bool hasNotification = false,
  }) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 반투명 회색 원형 배경 + 아이콘
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.colorGlobalCoolNeutral60.withValues(
                    alpha: 0.8,
                  ),
                ),
                child: SvgPicture.asset(
                  svgPath,
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // 알림 뱃지 (우상단 보라 점)
              if (hasNotification)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryNormal,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== 광고 캐러셀 =====
  /// 5개 placeholder 페이지 — [백엔드 API 연동 대기] banners 테이블 연동 시 실데이터.
  /// 박스 한 개 안에 placeholder 이미지 + 우상단 인디케이터 + 좌하단 타이틀 모두 통합.
  Widget _buildCarousel() {
    const totalCount = HomeController.carouselTotalCount;
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: controller.carouselController,
        itemCount: totalCount,
        onPageChanged: controller.onCarouselPageChanged,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColor.colorGlobalCoolNeutral90,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 이미지 placeholder — [백엔드 API 연동 대기] 실제 배너 이미지
                Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 72,
                    color: AppColor.colorGlobalCommon100.withValues(alpha: 0.4),
                  ),
                ),
                // 페이지 인디케이터 — 우상단
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.colorGlobalCommon0.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Obx(
                      () => Text(
                        '${controller.carouselIndex.value + 1} / $totalCount',
                        style: AppTextStyles.caption1Medium.copyWith(
                          color: AppColor.colorGlobalCommon100,
                        ),
                      ),
                    ),
                  ),
                ),
                // [백엔드 API 연동 대기] banners 테이블 연동 시 배너 타이틀 표시
              ],
            ),
          );
        },
      ),
    );
  }

  // ===== 1. 보유 원두 캐러셀 =====
  /// 사용자의 스토어 데이터 (보유 원두) 표시.
  /// 데이터 없으면 빈 카드 노출. 좌우 여백 0 — 화면 끝까지 닿음.
  Widget _buildMyBeanSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColor.primaryNormal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '레시피를 시작해볼까요?',
                style: AppTextStyles.body1NormalBold.copyWith(
                  color: AppColor.colorGlobalCommon100,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // [백엔드 API 연동 대기] 편집 화면 이동
                },
                child: Text(
                  '편집하기',
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.colorGlobalCommon100.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (controller.hasMyBeans)
            _buildMyBeanCarousel()
          else
            _buildEmptyMyBean(),
        ],
      ),
    );
  }

  Widget _buildMyBeanCarousel() {
    final items = controller.myBeans.take(3).toList();
    return Column(
      children: [
        for (final item in items)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.colorGlobalCommon100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColor.colorGlobalCoolNeutral95,
                    borderRadius: BorderRadius.circular(8),
                    image: item.displayImageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(item.displayImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: item.displayImageUrl == null
                      ? Icon(Icons.coffee, color: item.color, size: 24)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.brand ?? '브랜드명',
                            style: AppTextStyles.caption1Regular.copyWith(
                              color: AppColor.labelAlternative,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.primaryNormal.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '구독중',
                              style: AppTextStyles.caption2Medium.copyWith(
                                color: AppColor.primaryNormal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.name,
                        style: AppTextStyles.body2NormalBold.copyWith(
                          color: AppColor.labelNormal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.colorGlobalCommon100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              '전체보기',
              style: AppTextStyles.body2NormalBold.copyWith(
                color: AppColor.primaryNormal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 보유 원두가 없을 때의 안내.
  Widget _buildEmptyMyBean() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.colorGlobalCommon100.withValues(alpha: 0.32),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.coffee_outlined,
            color: AppColor.colorGlobalCommon100.withValues(alpha: 0.7),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            '보유 중인 원두가 아직 없어요',
            style: AppTextStyles.body2NormalBold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '구독하거나 레시피를 등록해보세요',
            style: AppTextStyles.caption1Regular.copyWith(
              color: AppColor.colorGlobalCommon100.withValues(alpha: 0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ===== 2. 취향 배너 =====
  /// 노란 배너 — 설문 완료 시 표시. 좌우 여백 0.
  Widget _buildTasteBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE15A), // Figma 노랑
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '어떤 커피를 추천해드릴까요?',
                style: AppTextStyles.body2NormalBold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              Icon(Icons.help_outline, size: 18, color: AppColor.labelNeutral),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    controller.tasteFlavors.isNotEmpty
                        ? controller.tasteFlavors.first.emoji
                        : '☕',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    controller.tasteTypeLabel.isNotEmpty
                        ? controller.tasteTypeLabel
                        : '나의 커피 취향',
                    style: AppTextStyles.body1NormalBold.copyWith(
                      color: AppColor.labelNormal,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.swap_horiz,
                size: 22,
                color: AppColor.labelNeutral,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _buildPreferenceChips(),
          ),
        ],
      ),
    );
  }

  /// 취향 향미 칩 목록 — 최대 3개 + "외 N개"
  List<Widget> _buildPreferenceChips() {
    final flavors = controller.tasteFlavors;
    if (flavors.isEmpty) return const [];
    const maxChips = 3;
    final chips = <Widget>[
      for (final f in flavors.take(maxChips)) _buildPreferenceChip(f.name),
    ];
    if (flavors.length > maxChips) {
      chips.add(_buildPreferenceChip('외 ${flavors.length - maxChips}개'));
    }
    return chips;
  }

  Widget _buildPreferenceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption1Medium.copyWith(
          color: AppColor.labelNormal,
        ),
      ),
    );
  }

  // ===== 3. 취향 기반 추천 그리드 =====
  /// 다크 배경 위 카드 — 좌우 여백 0, 카드 자체 배경은 약간 밝은 다크 그레이.
  Widget _buildTasteRecommendationGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${controller.userName}님의 취향의 원두에요',
            style: AppTextStyles.body1NormalBold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: 12),
          if (controller.hasTasteRecommendations)
            _buildProductGrid(controller.tasteRecommendations)
          else
            _buildEmptyState('취향 분석 결과를 준비 중이에요'),
        ],
      ),
    );
  }

  // ===== 4. 카테고리별 베스트 =====
  /// 다크 배경 위 섹션 헤더 + 그리드. 좌우 여백 0.
  Widget _buildCategoryBestSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coflanet 인기 원두 랭킹',
            style: AppTextStyles.body1NormalBold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: 10),
          if (controller.hasCategoryBest)
            _buildProductGrid(controller.categoryBest)
          else
            _buildEmptyState('인기 랭킹 데이터를 준비 중이에요'),
        ],
      ),
    );
  }

  // ===== 5. 실시간 인기 =====
  Widget _buildRealtimePopularSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이번주 실시간 인기 원두',
            style: AppTextStyles.body1NormalBold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: 10),
          if (controller.hasRealtimePopular)
            _buildProductGrid(controller.realtimePopular)
          else
            _buildEmptyState('실시간 인기 데이터를 준비 중이에요'),
        ],
      ),
    );
  }

  /// 공통 상품 그리드 (2열).
  Widget _buildProductGrid(List<CoffeeRecommendationModel> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildProductCard(items[index]),
    );
  }

  /// 단일 상품 카드 — 추천 데이터(이미지 + 좋아요 + 매치율 + 이름 + 가격).
  Widget _buildProductCard(CoffeeRecommendationModel item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.colorGlobalCoolNeutral95),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 + 좋아요 오버레이
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.colorGlobalCoolNeutral98,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: item.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(item.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: item.imageUrl == null
                      ? Icon(
                          Icons.coffee,
                          size: 48,
                          color: AppColor.primaryNormal,
                        )
                      : null,
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Obx(() {
                  final isLiked = controller.isLiked(item.id);
                  return GestureDetector(
                    onTap: () => controller.toggleLike(item.id),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.colorGlobalCommon100.withValues(
                          alpha: 0.9,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: AppColor.primaryNormal,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 취향 일치율
                if (item.matchPercent > 0) _buildSmallTag('취향 ${item.matchPercent}%'),
                const SizedBox(height: 4),
                Text(
                  '${item.manufacturer ?? '브랜드명'} | ${item.origin}',
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.name,
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColor.labelNormal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _buildPriceRow(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 가격 행 — 할인율 + 가격. 가격 정보 없으면 표시 안 함.
  Widget _buildPriceRow(CoffeeRecommendationModel item) {
    final price = item.discountPrice ?? item.originalPrice;
    if (price == null && item.discountPercent == null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        if (item.discountPercent != null) ...[
          Text(
            '${item.discountPercent}%',
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
          const SizedBox(width: 4),
        ],
        if (price != null)
          Text(
            _formatPrice(price),
            style: AppTextStyles.body2NormalBold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
      ],
    );
  }

  /// 가격 포맷팅 (원 단위, 쉼표 구분)
  String _formatPrice(int price) {
    final priceStr = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < priceStr.length; i++) {
      if (i > 0 && (priceStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(priceStr[i]);
    }
    return '$buffer원';
  }

  Widget _buildSmallTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: AppColor.primaryNormal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption2Medium.copyWith(
          color: AppColor.primaryNormal,
        ),
      ),
    );
  }

  /// 빈 상태 — [백엔드 API 연동 대기]. 다크 테마 적용.
  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral20,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.colorGlobalCoolNeutral25,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: AppColor.colorGlobalCoolNeutral70,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.colorGlobalCoolNeutral90,
            ),
          ),
        ],
      ),
    );
  }
}
