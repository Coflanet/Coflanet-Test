import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';

/// 추천 카드 썸네일 위 좋아요 토글 버튼 (28x28 흰 원 + 하트).
///
/// RecommendationCard 의 likeButton 슬롯에 주입한다.
/// 호출부에서 Obx 로 감싸 좋아요 상태만 좁게 구독한다
/// (카드 전체 리빌드 방지 — 원본의 중첩 Obx 입자 보존).
class RecommendationLikeButton extends StatelessWidget {
  const RecommendationLikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  /// 좋아요 여부
  final bool isLiked;

  /// 토글 콜백
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Semantics(
      label: isLiked ? '좋아요 취소' : '좋아요',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColor.colorGlobalCommon100.withValues(alpha: 0.92),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.colorGlobalCommon0.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: colors.primaryNormal,
          ),
        ),
      ),
    );
  }
}
