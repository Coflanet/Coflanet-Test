import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 향미 설명 리스트 — Profile 카드 안의 흰 카드(향미 노트 컨테이너).
///
/// Figma(Survey_Result `2208:17318` TastingNotes_Container): 흰 카드 radius 40,
/// px24/py10. 행(py20·gap8)마다 48 원형 아이콘 + 이름(17 SemiBold)/설명
/// (13 Regular) + 우측 chevron(24, label/assistive). 행 사이 1px 디바이더
/// (line/normal/alternative). 그림자 없음.
class FlavorNotesList extends StatelessWidget {
  const FlavorNotesList({super.key, required this.descriptions});

  /// 향미 설명 데이터 목록
  final List<FlavorDescriptionModel> descriptions;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space24,
        vertical: AppSpacing.space10,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundNormalNormal,
        borderRadius: AppRadius.sectionRadiusBorder,
      ),
      child: Column(
        children: [
          for (int i = 0; i < descriptions.length; i++) ...[
            if (i > 0)
              Container(height: 1, color: colors.lineNormalAlternative),
            _buildRow(colors, descriptions[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(AppColorScheme colors, FlavorDescriptionModel desc) {
    final aromaImage = _getAromaImage(desc.name);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space20),
      child: Row(
        children: [
          // 향미 아이콘 — componentFillNormal 원형(48)
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(AppSpacing.space4),
            decoration: BoxDecoration(
              color: colors.componentFillNormal,
              borderRadius: AppRadius.fullBorder,
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: aromaImage != null
                ? Image.asset(
                    aromaImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Text(desc.emoji, style: AppTextStyles.emojiMedium),
                  )
                : Text(desc.emoji, style: AppTextStyles.emojiMedium),
          ),
          const SizedBox(width: AppSpacing.space12),

          // 이름 + 설명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc.name,
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: colors.labelNormal,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  desc.description,
                  style: AppTextStyles.label2Regular.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space8),

          // chevron
          Icon(
            Icons.chevron_right,
            size: 24,
            color: colors.labelAssistive,
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
