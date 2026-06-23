import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/planet/widgets/planet_pill_button.dart';

/// 마이플래닛 빈 상태 콘텐츠 — 앉은 마스코트 + 설문 CTA.
///
/// Figma node 1341-16217. 설문 미완료 시 노출.
/// 카드 표면/패딩은 부모 [CardSection](프로필 섹션)이 소유하므로 이 위젯은
/// 콘텐츠(헤드라인·마스코트·CTA)만 그린다 — 카드 안이라 색은 `of(context)`.
/// 마스코트 에셋 로드 실패 시 보라 그라데이션 원 + 아이콘 폴백.
class PlanetEmptyCard extends StatelessWidget {
  const PlanetEmptyCard({super.key, required this.onSurveyTap});

  /// '취향 설문 하기' CTA 탭 콜백
  final VoidCallback onSurveyTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Column(
      children: [
        // 헤드라인 — Figma: Bold, 중앙 정렬
        Text(
          '내 커피 취향을\n찾아볼까요?',
          style: AppTextStyles.title3Bold.copyWith(
            color: colors.labelNormal,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        // 앉은 마스코트 일러스트
        _buildMascot(),
        const SizedBox(height: AppSpacing.xl),
        // CTA — Figma: 옅은 fill, violet text, pill shape
        PlanetPillButton(text: '취향 설문 하기', onTap: onSurveyTap),
      ],
    );
  }

  /// 마스코트 이미지 — 로드 실패 시 보라 그라데이션 원 폴백
  Widget _buildMascot() {
    return Image.asset(
      AssetPath.charSitting,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.colorGlobalViolet80,
                AppColor.colorGlobalViolet50,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.smart_toy_rounded,
              size: 64,
              color: AppColor.staticLabelWhiteStrong,
            ),
          ),
        );
      },
    );
  }
}
