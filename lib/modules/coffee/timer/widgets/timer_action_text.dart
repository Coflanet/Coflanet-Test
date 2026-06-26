import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 타이머 액션 안내 텍스트 — 수치(g/ml/초/번/회/분/μm)를 보라색으로 하이라이트.
///
/// Figma(레시피 타이머): 카드 배경 없이 가운데 정렬 본문(Headline 1, 18px).
/// 수치는 SemiBold 보라, 나머지는 Regular label/neutral.
///
/// 순수 표시 위젯 (controller/Rx 미참조) — 텍스트만 주입.
class TimerActionText extends StatelessWidget {
  const TimerActionText({super.key, required this.text});

  /// 안내 문구 (수치 패턴이 자동 강조됨)
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    // 강조 패턴: 숫자(천단위 콤마 포함) + 단위 (g, ml, 초, 번, 회, 분, μm)
    final regex = RegExp(r'([\d,]+\s*(?:g|ml|초|번|회|분|μm))');
    final base = AppTextStyles.headline1Regular.copyWith(
      color: colors.labelNeutral,
    );
    final highlight = AppTextStyles.headline1Bold.copyWith(
      color: colors.primaryNormal,
    );
    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(text: match.group(0), style: highlight));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }
    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(style: base, children: spans),
    );
  }
}
