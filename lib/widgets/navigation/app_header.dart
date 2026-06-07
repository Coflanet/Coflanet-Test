import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 좌측정렬 타이틀 + 뒤로가기 + 선택적 우측 액션 헤더.
///
/// 장바구니/알림 화면이 공유하는 동일 토큰 패턴
/// (padding fromLTRB(8,8,12,8), arrow_back/labelNormal,
/// headline2Bold/labelNormal 좌측정렬).
///
/// 중앙정렬 헤더(레시피 폼/원두 편집 등)는 정렬·아이콘·폰트 토큰이 달라
/// 이 위젯의 대상이 아니다 — 억지 variant 통합 금지.
///
/// [trailing] 에 반응형이 필요하면 호출부에서 Obx 로 감싼 위젯을 주입한다.
/// (trailing Obx 의 controller 는 호출부 GetView 의 것을 클로저 캡처)
class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.title, this.onBack, this.trailing});

  /// 좌측정렬 타이틀
  final String title;

  /// 뒤로가기 콜백 — null 이면 Get.back
  final VoidCallback? onBack;

  /// 우측 액션 위젯 — null 이면 미표시
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          Semantics(
            label: '뒤로가기',
            button: true,
            child: IconButton(
              onPressed: onBack ?? Get.back,
              icon: Icon(Icons.arrow_back, color: AppColor.labelNormal),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.headline2Bold.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
