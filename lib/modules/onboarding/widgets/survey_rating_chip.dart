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
/// 선택/미선택 색은 원본 의미색 체계를 1:1 보존한다:
/// - dislike: Red50/95 배경, Red40/90 보더, 라벨 Red50
/// - neutral: labelAssistive/componentFillNormal 배경, labelNormal/lineNormalNeutral 보더
/// - like: Blue50/95 배경, Blue40/90 보더, 라벨 Blue50
/// - 선택 시 라벨은 공통 흰색(colorGlobalCommon100)
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
          color: _backgroundColor(colors),
          borderRadius: AppRadius.lgBorder,
          border: Border.all(color: _borderColor(colors), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: emojiSize)),
            SizedBox(height: gap),
            Text(label, style: labelBase.copyWith(color: _labelColor(colors))),
          ],
        ),
      ),
    );
  }

  // dislike(빨강)/like(파랑) 은 의미색이라 raw 팔레트 유지,
  // neutral 의 회색/라벨 계열만 시맨틱 스킴으로 교체한다.
  Color _backgroundColor(AppColorScheme colors) {
    if (isSelected) {
      return switch (sentiment) {
        RatingSentiment.dislike => AppColor.colorGlobalRed50,
        RatingSentiment.neutral => colors.labelAssistive,
        RatingSentiment.like => AppColor.colorGlobalBlue50,
      };
    }
    return switch (sentiment) {
      RatingSentiment.dislike => AppColor.colorGlobalRed95,
      RatingSentiment.neutral => colors.componentFillNormal,
      RatingSentiment.like => AppColor.colorGlobalBlue95,
    };
  }

  Color _borderColor(AppColorScheme colors) {
    if (isSelected) {
      return switch (sentiment) {
        RatingSentiment.dislike => AppColor.colorGlobalRed40,
        RatingSentiment.neutral => colors.labelNormal,
        RatingSentiment.like => AppColor.colorGlobalBlue40,
      };
    }
    return switch (sentiment) {
      RatingSentiment.dislike => AppColor.colorGlobalRed90,
      RatingSentiment.neutral => colors.lineNormalNeutral,
      RatingSentiment.like => AppColor.colorGlobalBlue90,
    };
  }

  Color _labelColor(AppColorScheme colors) {
    if (isSelected) return AppColor.colorGlobalCommon100;
    return switch (sentiment) {
      RatingSentiment.dislike => AppColor.colorGlobalRed50,
      RatingSentiment.neutral => colors.labelNormal,
      RatingSentiment.like => AppColor.colorGlobalBlue50,
    };
  }
}
