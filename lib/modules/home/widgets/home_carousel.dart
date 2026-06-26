import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
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

  /// 배너 카드 종횡비 — Figma Home `banner`(115:15774) 360×203 ≈ 16:9
  static const double _bannerAspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final pageCount = banners.isEmpty ? 1 : banners.length;

    return AspectRatio(
      aspectRatio: _bannerAspectRatio,
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
  /// 홈 섹션 카드 기본 베이스: 풀폭(좌우 마진 0) + radius 40.
  Widget _buildBannerCard(BannerModel? banner, int pageCount) {
    final hasTitle = banner != null && banner.title.isNotEmpty;
    final bool hasImage = banner?.imageUrl != null;
    // 이미지 없는 배너는 서버 bg_color 기반 그라데이션으로 채운다 (Figma 색 배너 대체).
    final Color baseColor =
        _bannerColor(banner) ?? AppColor.colorGlobalCoolNeutral90;
    final card = Container(
      decoration: BoxDecoration(
        gradient: hasImage
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  baseColor,
                  Color.lerp(baseColor, AppColor.staticBlack, 0.45) ?? baseColor,
                ],
              ),
        color: hasImage ? AppColor.colorGlobalCoolNeutral90 : null,
        borderRadius: AppRadius.sectionRadiusBorder,
        image: hasImage
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
          // 하단 딤 그라데이션 — 흰색 타이틀 가독성 확보 (이미지 배너에서만,
          // 색 배너는 베이스 그라데이션이 이미 대비를 확보).
          if (hasTitle && hasImage)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                // Figma Gradient/Solid(115:15798): 하단 113px 딤
                height: AppSpacing.space80 + AppSpacing.space32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColor.colorGlobalCommon0.withValues(alpha: 0.52),
                      AppColor.colorGlobalCommon0.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          // 배너 타이틀 — 카드 내부 하단 오버레이 (Figma left/bottom 24)
          if (hasTitle)
            Positioned(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              bottom: AppSpacing.xl,
              child: Text(
                banner.title,
                // Figma banner 타이틀(115:15776): SemiBold 22 = heading1Bold
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.colorGlobalCommon100,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          // 페이지 인디케이터 — 우상단 (2개 이상일 때만). Figma top/right 24.
          if (pageCount > 1)
            Positioned(
              top: AppSpacing.xl,
              right: AppSpacing.xl,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space10,
                  vertical: AppSpacing.space4,
                ),
                decoration: BoxDecoration(
                  // Figma Pagination/Counter 배경: cool-neutral/30 @61%
                  color: AppColor.colorGlobalCoolNeutral30.withValues(
                    alpha: 0.61,
                  ),
                  borderRadius: AppRadius.fullBorder,
                ),
                child: Obx(
                  () => Text(
                    '${currentIndex.value + 1} / $pageCount',
                    // Figma Pagination/Counter(143:14149): SemiBold 13 = label2Bold
                    style: AppTextStyles.label2Bold.copyWith(
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

  /// 서버 hex 문자열(`bg_color`) → Color (런타임 데이터 파싱 — 하드코딩 아님).
  Color? _bannerColor(BannerModel? banner) {
    final hex = banner?.bgColor?.replaceFirst('#', '');
    if (hex != null && hex.length == 6) {
      final value = int.tryParse('FF$hex', radix: 16);
      if (value != null) return Color(value);
    }
    return null;
  }
}
