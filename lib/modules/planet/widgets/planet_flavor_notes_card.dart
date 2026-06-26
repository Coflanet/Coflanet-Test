import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';

/// 마이플래닛 향미 노트 카드 — 아로마 이미지 + 이름/설명 행 리스트.
///
/// [FlavorDescription] 은 my_planet_controller.dart 정의 데이터 클래스
/// ([리팩토링 대상] — 모델 파일 이동은 영향 범위 대비 이득이 작아 유지).
/// 현재 데이터는 컨트롤러의 const 정적 안내 목록 — 서버 연동 시에도 이 시그니처
/// (List 주입)는 유지 가능.
///
/// 온보딩 FlavorDescriptionRow 와는 컨테이너(행 리스트 vs 독립 카드)/아바타
/// (ClipOval 40 vs 그라데이션 원 48)/폰트/간격이 전부 달라 통합하지 않는다.
/// 아로마 경로 매핑도 폴백 시맨틱이 달라(항상 이미지 vs null→이모지) 공유
/// 유틸로 합치지 않는다 (planet 전용).
class PlanetFlavorNotesCard extends StatelessWidget {
  const PlanetFlavorNotesCard({super.key, required this.flavors});

  /// 향미 설명 목록
  final List<FlavorDescription> flavors;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    // Figma(2208:17420): 회색 프로필 카드 안의 흰 향미노트 컨테이너, radius 40.
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.sectionRadiusBorder,
      ),
      child: Column(
        children: List.generate(flavors.length, (index) {
          final flavor = flavors[index];
          return Column(
            children: [
              _buildFlavorNoteItem(flavor, colors),
              // 마지막 항목 뒤에는 구분선 없음.
              // Figma(2208:17422): 컨테이너 패딩(24) 안에서 풀폭 — 아바타 아래까지 가로지름.
              // 색은 line/normal/alternative.
              if (index < flavors.length - 1)
                Divider(
                  height: 1,
                  indent: AppSpacing.xl,
                  endIndent: AppSpacing.xl,
                  color: colors.lineNormalAlternative,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFlavorNoteItem(FlavorDescription flavor, AppColorScheme colors) {
    return Padding(
      // Figma(2208:17421): 컨테이너 px24 / 행 py20
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          // 아로마 아바타 — Figma: 48px 원 + componentFillNormal 배경 + 일러스트
          Container(
            width: AppSpacing.xxxl,
            height: AppSpacing.xxxl,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.componentFillNormal,
            ),
            child: Image.asset(
              _flavorImagePath(flavor.title),
              width: AppSpacing.xxxl,
              height: AppSpacing.xxxl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    _flavorIcon(flavor.title),
                    size: 24,
                    color: colors.labelAlternative,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flavor.title,
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: colors.labelNormal,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  flavor.description,
                  // Figma: Label 2/Regular 13px, label/alternative
                  style: AppTextStyles.label2Regular.copyWith(
                    color: colors.labelAlternative,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Figma: 행 우측 chevron (콘텐츠와 8px 간격)
          const SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.chevron_right_rounded,
            size: 24,
            color: colors.labelAssistive,
          ),
        ],
      ),
    );
  }

  /// 향미 이름 → 아로마 에셋 경로 (미매칭 시 과일 이미지 폴백)
  String _flavorImagePath(String title) {
    if (title.contains('과일')) return AssetPath.aromaFruit;
    if (title.contains('꽃')) return AssetPath.aromaFlower;
    if (title.contains('견과')) return AssetPath.aromaNutChoco;
    if (title.contains('로스팅')) return AssetPath.aromaRoasting;
    return AssetPath.aromaFruit;
  }

  /// 향미 이름 → 폴백 아이콘
  IconData _flavorIcon(String title) {
    if (title.contains('과일')) return Icons.energy_savings_leaf_rounded;
    if (title.contains('꽃')) return Icons.local_florist_rounded;
    if (title.contains('견과')) return Icons.cookie_rounded;
    if (title.contains('로스팅')) return Icons.local_fire_department_rounded;
    return Icons.coffee_rounded;
  }
}
