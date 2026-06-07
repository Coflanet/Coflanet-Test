import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 홈 광고 캐러셀 — placeholder 페이지. 검정 배경 위 독립 둥근 카드.
///
/// 각 페이지는 풀폭 둥근 이미지 카드 하나로 구성되며, 배너 타이틀(최대 2줄)은
/// 이미지 카드 내부 하단에 오버레이된다 (하단 그라데이션 딤으로 가독성 확보).
/// 이미지 카드 우상단에 페이지 인디케이터를 통합 — [currentIndex](RxInt)를
/// 내부 Obx 로 구독해 페이지 변경에 반응한다.
///
/// [백엔드 API 연동 대기] banners 테이블 연동 시 실데이터.
/// banners 부재로 현재 1개만 표시.
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
      height: 376,
      child: PageView.builder(
        controller: pageController,
        itemCount: totalCount,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          // 둥근 이미지 카드 — 타이틀을 카드 내부 하단에 오버레이한다.
          // 홈 섹션 카드 기본 베이스: 풀폭(좌우 마진 0) + radius 20.
          return Container(
            decoration: BoxDecoration(
              color: AppColor.colorGlobalCoolNeutral90,
              borderRadius: AppRadius.xxlBorder,
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
                // 하단 딤 그라데이션 — 흰색 타이틀 가독성 확보
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
                // [백엔드 API 연동 대기] banners 테이블 연동 시 실제 배너 타이틀
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Text(
                    '타이틀을 입력해주세요.\n최대 2줄까지 입력가능합니다.',
                    style: AppTextStyles.heading2Bold.copyWith(
                      color: AppColor.colorGlobalCommon100,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                        borderRadius: AppRadius.fullBorder,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
