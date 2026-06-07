import 'package:flutter/material.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 준비 스텝 일러스트 — 스텝 제목에 매칭되는 에셋 이미지, 없으면 이모지 placeholder.
///
/// 순수 표시 위젯 (controller/Rx 미참조) — 제목/이모지만 주입.
/// [illustrationEmoji] 는 원본과 동일하게 nullable + '☕' fallback.
class TimerStepIllustration extends StatelessWidget {
  const TimerStepIllustration({
    super.key,
    required this.title,
    this.illustrationEmoji,
  });

  /// 스텝 제목 (에셋 매핑 키)
  final String title;

  /// 대체 이모지 — null 이면 '☕'
  final String? illustrationEmoji;

  @override
  Widget build(BuildContext context) {
    final assetPath = _getIllustrationAsset(title);

    if (assetPath != null) {
      // 실제 일러스트 이미지 사용
      return Image.asset(
        assetPath,
        width: 280,
        height: 280,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // 이미지 로드 실패 시 이모지 fallback
          return _buildEmojiPlaceholder(illustrationEmoji ?? '☕');
        },
      );
    }

    // 이모지 placeholder fallback
    return _buildEmojiPlaceholder(illustrationEmoji ?? '☕');
  }

  /// 스텝 제목 → 일러스트 에셋 매핑
  String? _getIllustrationAsset(String stepTitle) {
    switch (stepTitle) {
      case '원두 분쇄':
        return AssetPath.timerStepGrinder;
      case '예열하기':
        return AssetPath.timerStepPourover;
      default:
        return null;
    }
  }

  Widget _buildEmojiPlaceholder(String emoji) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: AppTextStyles.emojiLarge),
    );
  }
}
