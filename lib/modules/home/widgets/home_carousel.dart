import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 홈 광고 캐러셀 — placeholder 페이지.
///
/// [백엔드 API 연동 대기] banners 테이블 연동 시 실데이터.
/// banners 부재로 현재 1개만 표시. 박스 안에 placeholder 이미지 + 인디케이터 통합.
/// 인디케이터는 [currentIndex](RxInt)를 내부 Obx 로 구독해 페이지 변경에 반응한다.
class HomeCarousel extends StatelessWidget {
  const HomeCarousel({
    super.key,
    required this.pageController,
    required this.currentIndex,
    required this.totalCount,
    required this.onPageChanged,
  });

  /// PageView 컨트롤러 (Flutter 객체 — GetX 컨트롤러 아님)
  final PageController pageController;

  /// 현재 페이지 인덱스 (반응형)
  final RxInt currentIndex;

  /// 전체 배너 수
  final int totalCount;

  /// 페이지 변경 콜백
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: pageController,
        itemCount: totalCount,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(color: AppColor.colorGlobalCoolNeutral90),
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
                // 페이지 인디케이터 — 우상단 (2개 이상일 때만)
                if (totalCount > 1)
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
                          '${currentIndex.value + 1} / $totalCount',
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
}
