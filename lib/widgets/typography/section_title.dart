import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 섹션 타이틀 + 선택적 서브텍스트.
///
/// 홈 섹션 헤더와 온보딩 결과 화면의 "추천 원두" 헤더가 공유한다.
/// 화면마다 폰트 스케일/색이 달라 [titleStyle] 은 호출부가 **반드시 명시**한다
/// (기본값 의존으로 인한 폰트 축소 회귀 차단).
///
/// Row 안에서도 안전하도록 mainAxisSize.min 으로 수축한다.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.spacing = 6,
  });

  /// 타이틀 텍스트
  final String title;

  /// 타이틀 스타일 — 색 포함 완성형으로 주입
  final TextStyle titleStyle;

  /// 서브텍스트 — null 이면 미표시
  final String? subtitle;

  /// 서브텍스트 스타일 — null 이면 body2NormalRegular + labelAlternative
  final TextStyle? subtitleStyle;

  /// 타이틀-서브텍스트 간격
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        if (subtitle != null) ...[
          SizedBox(height: spacing),
          Text(
            subtitle!,
            style:
                subtitleStyle ??
                AppTextStyles.body2NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                ),
          ),
        ],
      ],
    );
  }
}
