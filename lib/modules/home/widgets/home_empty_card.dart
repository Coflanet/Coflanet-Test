import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 홈 인라인 빈 상태 카드 — [백엔드 API 연동 대기] 섹션 placeholder.
///
/// 공통 AppEmptyState 는 원형 아이콘 + 액션 버튼 구성이라
/// 홈 섹션 카드의 인라인 카드형 empty 와 디자인이 달라 별도 위젯으로 둔다.
/// 색은 테마 스킴 기반 — 다크: 짙은 회색 카드, 라이트: 옅은 회색 카드.
class HomeEmptyCard extends StatelessWidget {
  const HomeEmptyCard({super.key, required this.message});

  /// 안내 문구
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surfaceCardStrong,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.lineSolidNormal,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: colors.labelAssistive,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: colors.labelAlternative,
            ),
          ),
        ],
      ),
    );
  }
}
