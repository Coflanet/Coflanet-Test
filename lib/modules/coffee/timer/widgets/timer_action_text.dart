import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 타이머 액션 안내 텍스트 — 수치(g/ml/초/번/회/분/μm)를 보라색으로 하이라이트.
///
/// 순수 표시 위젯 (controller/Rx 미참조) — 텍스트만 주입.
class TimerActionText extends StatelessWidget {
  const TimerActionText({super.key, required this.text});

  /// 안내 문구 (수치 패턴이 자동 강조됨)
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    // 강조 패턴: 숫자 + 단위 (g, ml, 초, 번, 회, 분, μm)
    final regex = RegExp(r'(\d+\s*(?:g|ml|초|번|회|분|μm))');
    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: colors.labelNormal,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: AppTextStyles.body1NormalBold.copyWith(
            color: colors.primaryNormal,
          ),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastEnd),
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: colors.labelNormal,
          ),
        ),
      );
    }

    // 매칭 없으면 일반 텍스트
    if (spans.isEmpty) {
      spans.add(
        TextSpan(
          text: text,
          style: AppTextStyles.body1NormalMedium.copyWith(
            color: colors.labelNormal,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surfaceCardStrong,
        borderRadius: AppRadius.lgBorder,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: spans),
      ),
    );
  }
}
