import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 설문 레이팅 칩 크기.
/// - [large]  : 3분할 (싫어요/보통/좋아요) — 이모지 36px, body1NormalBold, 세로 패딩 20
/// - [xlarge] : 2분할 (싫어요/좋아요) — 이모지 48px, headline1Bold, 세로 패딩 24
///
/// 멀티레이팅의 소형 버튼은 색 체계가 다르므로(보라 단색)
/// 이 위젯이 아닌 SurveyMultiRatingItem 내부 버튼을 사용한다.
enum RatingChipSize { large, xlarge }

/// 레이팅 의미색 — dislike(빨강) / neutral(회색) / like(파랑)
enum RatingSentiment { dislike, neutral, like }

/// 설문 평가 칩 (이모지 + 라벨) — ternary/binary 레이팅 전용.
///
/// 의미색(빨강/파랑)은 테마별로 톤을 달리한다:
/// - 라이트: Figma 원본 파스텔 (Red95/Blue95 배경 + Red90/Blue90 보더)
/// - 다크: 반투명 틴트 (Red50/Blue50 @16% 배경 + @40% 보더) — 파스텔이
///   검정 배경 위에서 혼자 밝게 떠 보이는 문제 방지
/// - 선택 시: Red50/Blue50 솔리드 + 흰 라벨 (양 테마 공통)
/// - neutral 은 시맨틱 스킴(componentFill/label 계열)을 그대로 따른다
class SurveyRatingChip extends StatelessWidget {
  const SurveyRatingChip({
    super.key,
    required this.emoji,
    required this.label,
    required this.sentiment,
    required this.isSelected,
    required this.onTap,
    this.size = RatingChipSize.large,
  });

  /// 이모지 문자
  final String emoji;

  /// 라벨 텍스트
  final String label;

  /// 의미색 분기
  final RatingSentiment sentiment;

  /// 선택 여부
  final bool isSelected;

  /// 탭 콜백
  final VoidCallback onTap;

  /// 크기 variant
  final RatingChipSize size;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double verticalPadding = switch (size) {
      RatingChipSize.large => 20,
      RatingChipSize.xlarge => 24,
    };
    final double emojiSize = switch (size) {
      RatingChipSize.large => 36,
      RatingChipSize.xlarge => 48,
    };
    final double gap = switch (size) {
      RatingChipSize.large => 8,
      RatingChipSize.xlarge => 12,
    };
    final TextStyle labelBase = switch (size) {
      RatingChipSize.large => AppTextStyles.body1NormalBold,
      RatingChipSize.xlarge => AppTextStyles.headline1Bold,
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          color: _backgroundColor(colors, isDark),
          borderRadius: AppRadius.lgBorder,
          border: Border.all(color: _borderColor(colors, isDark), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: emojiSize)),
            SizedBox(height: gap),
            Text(
              label,
              style: labelBase.copyWith(color: _labelColor(colors, isDark)),
            ),
          ],
        ),
      ),
    );
  }

  // 의미색(빨강/파랑)은 테마별 톤 분기 — 라이트: 파스텔 / 다크: 반투명 틴트.
  // neutral 은 시맨틱 스킴 토큰을 그대로 사용한다.
  Color _backgroundColor(AppColorScheme colors, bool isDark) {
    if (isSelected) {
      return switch (sentiment) {
        RatingSentiment.dislike => AppColor.colorGlobalRed50,
        RatingSentiment.neutral => colors.labelAssistive,
        RatingSentiment.like => AppColor.colorGlobalBlue50,
      };
    }
    if (isDark) {
      return switch (sentiment) {
        RatingSentiment.dislike =>
          AppColor.colorGlobalRed50.withValues(alpha: 0.16),
        RatingSentiment.neutral => colors.componentFillNormal,
        RatingSentiment.like =>
          AppColor.colorGlobalBlue50.withValues(alpha: 0.16),
      };
    }
    return switch (sentiment) {
      RatingSentiment.dislike => AppColor.colorGlobalRed95,
      RatingSentiment.neutral => colors.componentFillNormal,
      RatingSentiment.like => AppColor.colorGlobalBlue95,
    };
  }

  Color _borderColor(AppColorScheme colors, bool isDark) {
    if (isSelected) {
      return switch (sentiment) {
        RatingSentiment.dislike => AppColor.colorGlobalRed40,
        RatingSentiment.neutral => colors.labelNormal,
        RatingSentiment.like => AppColor.colorGlobalBlue40,
      };
    }
    if (isDark) {
      return switch (sentiment) {
        RatingSentiment.dislike =>
          AppColor.colorGlobalRed50.withValues(alpha: 0.4),
        RatingSentiment.neutral => colors.lineNormalNeutral,
        RatingSentiment.like =>
          AppColor.colorGlobalBlue50.withValues(alpha: 0.4),
      };
    }
    return switch (sentiment) {
      RatingSentiment.dislike => AppColor.colorGlobalRed90,
      RatingSentiment.neutral => colors.lineNormalNeutral,
      RatingSentiment.like => AppColor.colorGlobalBlue90,
    };
  }

  Color _labelColor(AppColorScheme colors, bool isDark) {
    if (isSelected) return AppColor.colorGlobalCommon100;
    if (isDark) {
      // 다크 틴트 배경 위 가독성을 위해 한 단계 밝은 의미색
      return switch (sentiment) {
        RatingSentiment.dislike => AppColor.colorGlobalRed60,
        RatingSentiment.neutral => colors.labelNormal,
        RatingSentiment.like => AppColor.colorGlobalBlue60,
      };
    }
    return switch (sentiment) {
      RatingSentiment.dislike => AppColor.colorGlobalRed50,
      RatingSentiment.neutral => colors.labelNormal,
      RatingSentiment.like => AppColor.colorGlobalBlue50,
    };
  }
}
