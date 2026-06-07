import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 홈 다크 테마 인라인 빈 상태 카드 — [백엔드 API 연동 대기] 섹션 placeholder.
///
/// 공통 AppEmptyState 는 라이트 테마(원형 아이콘 + 액션 버튼) 전제라
/// 홈 다크 배경의 인라인 카드형 empty 와 디자인이 달라 별도 위젯으로 둔다.
class HomeEmptyCard extends StatelessWidget {
  const HomeEmptyCard({super.key, required this.message});

  /// 안내 문구
  final String message;

  @override
  Widget build(BuildContext context) {
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
