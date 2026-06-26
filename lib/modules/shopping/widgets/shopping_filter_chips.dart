import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 카테고리 베스트 섹션의 필터 칩 행 — Figma `category best` 필터(101:28357).
///
/// 첫 칩은 선택된 값(강조 pill), 나머지는 드롭다운 placeholder. 데모 데이터라
/// 표시 전용이며, 가로로 넘칠 경우 스크롤된다(필터 API 연동 시 동작 부여).
class ShoppingFilterChips extends StatelessWidget {
  const ShoppingFilterChips({super.key, required this.filters});

  /// (라벨, 선택여부) 목록 — 선택 칩은 강조(다크) 스타일.
  final List<({String label, bool selected})> filters;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return SizedBox(
      height: AppSpacing.space40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final f = filters[index];
          final bg = f.selected
              ? colors.labelStrong
              : colors.componentFillAlternative;
          final fg = f.selected ? colors.backgroundNormalNormal : colors.labelNormal;
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: AppRadius.fullBorder,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  f.label,
                  style: AppTextStyles.label1NormalMedium.copyWith(color: fg),
                ),
                const SizedBox(width: AppSpacing.space2),
                Icon(Icons.keyboard_arrow_down, size: AppSpacing.space16, color: fg),
              ],
            ),
          );
        },
      ),
    );
  }
}
