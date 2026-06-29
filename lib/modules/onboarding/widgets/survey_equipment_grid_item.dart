import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 추출 기구 선택 그리드 셀 — 기구 이미지 placeholder + 라벨.
///
/// 선택 시 보라 단색 강조 (primaryLight 배경 + primaryNormal 보더).
/// 호출부 Obx 클로저 안에서 [isSelected] 를 읽어 주입한다 (controller 미참조).
class SurveyEquipmentGridItem extends StatelessWidget {
  const SurveyEquipmentGridItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.imagePath,
  });

  /// 기구 이름
  final String label;

  /// 선택 여부
  final bool isSelected;

  /// 탭 콜백
  final VoidCallback onTap;

  /// 기구 일러스트 에셋 경로 — null 이면 아이콘 폴백.
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Figma Check Box with img(1841:46867): padding px20/py16, gap8
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space20,
          vertical: AppSpacing.space16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryLight : colors.componentFillNormal,
          // Figma 기구 카드: Round/32 + 선택 시에만 1px primary 보더
          borderRadius: AppRadius.roundBorder,
          border: isSelected
              ? Border.all(color: colors.primaryNormal, width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 기구 이미지 placeholder — [백엔드 API 연동 대기] 실제 기구 이미지
            // Figma: 이미지 영역이 카드 폭을 채우고 라벨은 하단에 위치
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.backgroundNormalAlternative,
                  borderRadius: AppRadius.xlBorder,
                ),
                clipBehavior: Clip.antiAlias,
                child: imagePath != null
                    ? Padding(
                        padding: const EdgeInsets.all(AppSpacing.space8),
                        child: Image.asset(
                          imagePath!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.coffee_rounded,
                            color: isSelected
                                ? colors.primaryNormal
                                : colors.labelAlternative,
                            size: 32,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.coffee_rounded,
                        color: isSelected
                            ? colors.primaryNormal
                            : colors.labelAlternative,
                        size: 32,
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              label,
              // Figma: Label/1/Normal SemiBold(14), 선택 시 violet
              style: AppTextStyles.label1NormalBold.copyWith(
                color: isSelected ? colors.primaryNormal : colors.labelNormal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
