import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 설문 결과 상단 보라 그라디언트 배너 — 취향 타입 헤드라인.
///
/// Figma: 좌측 정렬, "OOO님은" 캡션 + "진하고 깊은 풍미를\n즐기시네요! ☕" 헤드라인.
class ResultBanner extends StatelessWidget {
  const ResultBanner({
    super.key,
    required this.userName,
    required this.description,
  });

  /// 사용자 이름
  final String userName;

  /// 취향 타입 설명 (예: '진하고 깊은 풍미를')
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.colorGlobalViolet60, AppColor.colorGlobalViolet50],
        ),
        borderRadius: AppRadius.xlBorder,
        boxShadow: AppShadows.shadowPrimaryStrong,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사용자 이름 라인 — 반투명 캡션 (Figma 12-14px)
          Text(
            '$userName님은',
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColor.staticLabelWhiteStrong.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),

          // 메인 헤드라인 — 2줄 + 이모지 (Figma 20-24px Bold)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$description\n즐기시네요!',
                  style: AppTextStyles.heading1Bold.copyWith(
                    color: AppColor.staticLabelWhiteStrong,
                    height: 1.4,
                  ),
                ),
                const TextSpan(text: ' ☕', style: TextStyle(fontSize: 22)),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
