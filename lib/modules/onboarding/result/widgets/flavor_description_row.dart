import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 향미 설명 행 — 아로마 이미지(보라 그라디언트 원) + 이름/설명.
///
/// 향미 이름에 매칭되는 아로마 에셋이 있으면 이미지, 없으면 이모지 표시.
class FlavorDescriptionRow extends StatelessWidget {
  const FlavorDescriptionRow({super.key, required this.description});

  /// 향미 설명 데이터 (이름/이모지/설명)
  final FlavorDescriptionModel description;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    final aromaImage = _getAromaImage(description.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundNormalNormal,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: colors.lineNormalNeutral),
        boxShadow: AppShadows.shadowBlackNormal,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 아로마 아이콘 — 보라 그라디언트 원 안에 이미지/이모지
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primaryLight,
                  colors.primaryNormal.withValues(alpha: 0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(
              child: aromaImage != null
                  ? Image.asset(
                      aromaImage,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Text(
                        description.emoji,
                        style: AppTextStyles.emojiMedium,
                      ),
                    )
                  : Text(description.emoji, style: AppTextStyles.emojiMedium),
            ),
          ),
          const SizedBox(width: 14),

          // 이름 + 설명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description.name,
                  style: AppTextStyles.label1NormalBold.copyWith(
                    color: colors.labelNormal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description.description,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 향미 이름 → 아로마 에셋 경로 매핑
  String? _getAromaImage(String flavorName) {
    if (flavorName.contains('과일')) {
      return AssetPath.aromaFruit;
    } else if (flavorName.contains('꽃')) {
      return AssetPath.aromaFlower;
    } else if (flavorName.contains('견과류') || flavorName.contains('초콜릿')) {
      return AssetPath.aromaNutChoco;
    } else if (flavorName.contains('로스팅')) {
      return AssetPath.aromaRoasting;
    }
    return null;
  }
}
