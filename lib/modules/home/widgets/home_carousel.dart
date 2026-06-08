import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/banner_model.dart';

/// 홈 광고 캐러셀 — 서버 배너(home_carousel 슬롯) 기반. 독립 둥근 카드.
///
/// [banners] 가 비어 있으면 placeholder 카드 1장을 표시한다 (타이틀 없음).
/// 각 페이지는 풀폭 둥근 이미지 카드 하나로 구성되며, 배너 타이틀(최대 2줄)은
/// 이미지 카드 내부 하단에 오버레이된다 (하단 그라데이션 딤으로 가독성 확보).
/// 이미지 카드 우상단에 페이지 인디케이터를 통합 — [currentIndex](RxInt)를
/// 내부 Obx 로 구독해 페이지 변경에 반응한다.
class HomeCarousel extends StatelessWidget {
  const HomeCarousel({
    super.key,
    required this.banners,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    this.onBannerTap,
  });

  /// 캐러셀 슬롯 배너 목록 — 비어 있으면 placeholder 1장
  final List<BannerModel> banners;

  /// PageView 컨트롤러 (Flutter 객체 — GetX 컨트롤러 아님)
  final PageController pageController;

  /// 현재 페이지 인덱스 (반응형)
  final RxInt currentIndex;

  /// 페이지 변경 콜백
  final ValueChanged<int> onPageChanged;

  /// 배너 탭 콜백 (action_type 분기는 호출부 담당)
  final void Function(BannerModel banner)? onBannerTap;

  @override
  Widget build(BuildContext context) {
    final pageCount = banners.isEmpty ? 1 : banners.length;

    return SizedBox(
      height: 376,
      child: PageView.builder(
        controller: pageController,
        itemCount: pageCount,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          final banner = banners.isEmpty ? null : banners[index];
          return _buildBannerCard(banner, pageCount);
        },
      ),
    );
  }

  /// 둥근 이미지 카드 — 타이틀을 카드 내부 하단에 오버레이한다.
  /// 홈 섹션 카드 기본 베이스: 풀폭(좌우 마진 0) + radius 20.
  Widget _buildBannerCard(BannerModel? banner, int pageCount) {
    final hasTitle = banner != null && banner.title.isNotEmpty;
    final card = Container(
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral90,
        borderRadius: AppRadius.xxlBorder,
        image: banner?.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(banner!.imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 이미지 없는 배너/placeholder 의 안내 아이콘
          if (banner?.imageUrl == null)
            Center(
              child: Icon(
                Icons.image_outlined,
                size: 72,
                color: AppColor.colorGlobalCommon100.withValues(alpha: 0.4),
              ),
            ),
          // 하단 딤 그라데이션 — 흰색 타이틀 가독성 확보 (타이틀 있을 때만)
          if (hasTitle)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColor.colorGlobalCommon0.withValues(alpha: 0.6),
                      AppColor.colorGlobalCommon0.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          // 배너 타이틀 — 카드 내부 하단 오버레이
          if (hasTitle)
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Text(
                banner.title,
                style: AppTextStyles.heading2Bold.copyWith(
                  color: AppColor.colorGlobalCommon100,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          // 페이지 인디케이터 — 우상단 (2개 이상일 때만)
          if (pageCount > 1)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCommon0.withValues(alpha: 0.5),
                  borderRadius: AppRadius.fullBorder,
                ),
                child: Obx(
                  () => Text(
                    '${currentIndex.value + 1} / $pageCount',
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: AppColor.colorGlobalCommon100,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (banner == null || onBannerTap == null) return card;
    return GestureDetector(onTap: () => onBannerTap!(banner), child: card);
  }
}
