import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 취향 화면 액션 타일 — 아이콘 박스 + 제목/부제 + 셰브론.
///
/// my_taste 화면 전용 ('매칭 결과 자세히 보기', '취향 다시 설정하기').
/// 아이콘 색/배경색은 항목별 의미색이라 호출부에서 주입한다.
class TasteActionTile extends StatelessWidget {
  const TasteActionTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  /// 좌측 아이콘
  final IconData icon;

  /// 아이콘 색
  final Color iconColor;

  /// 아이콘 박스 배경색
  final Color iconBgColor;

  /// 제목
  final String title;

  /// 부제
  final String subtitle;

  /// 탭 콜백
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: AppRadius.xxlBorder,
          border: Border.all(color: colors.lineNormalNeutral, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: AppRadius.xlBorder,
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headline2Bold.copyWith(
                      color: colors.labelNormal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: colors.labelAlternative,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.labelAssistive,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
