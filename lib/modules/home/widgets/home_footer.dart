import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 홈 최하단 푸터 — 페이지 배경 위 보조 톤 텍스트 (카드 아님). 좌우 여백 0.
///
/// 소셜 채널 아이콘 + 고객센터 안내 + 사업자 정보 펼침 행으로 구성된다.
class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // [스펙 미확정] 소셜 채널 링크/아이콘 확정 시 교체
          Row(
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 20,
                color: colors.labelAlternative,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: colors.labelAlternative,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.alternate_email,
                size: 20,
                color: colors.labelAlternative,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '고객센터 (평일 오전 9시 ~ 오후 6시 운영)',
            style: AppTextStyles.caption1Medium.copyWith(
              color: colors.labelAlternative,
            ),
          ),
          const SizedBox(height: 8),
          // [백엔드 API 연동 대기] 연락처/메일은 목업 표기 그대로 (placeholder)
          Text(
            '문의전화 0000-0000',
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelAssistive,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '고객문의 메일 : help.info@gmail.com',
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelAssistive,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '사업제휴 메일 : coplanet.biz@gmail.com',
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelAssistive,
            ),
          ),
          const SizedBox(height: 16),
          // [스펙 미확정] 사업자 정보 펼침 동작
          Row(
            children: [
              Text(
                '커플래닛 사업자 정보',
                style: AppTextStyles.caption1Medium.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: colors.labelAlternative,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
