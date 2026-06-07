import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/tasting/tasting_notes_controller.dart';

/// 시음 기록 — 준비 중 placeholder 화면.
///
/// 이전에는 Scaffold 배경 미지정 + 흰 텍스트 고정이라 배치 위치에 따라
/// 깨졌다. 테마 스킴 기반으로 배경을 명시하고 라벨 토큰을 사용한다.
class TastingNotesView extends GetView<TastingNotesController> {
  const TastingNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundNormalAlternative,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with gradient background — 오렌지 그라데이션 고정색
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColor.colorGlobalOrange80,
                      AppColor.colorGlobalOrange50,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.edit_note_rounded,
                    size: 40,
                    color: AppColor.staticLabelWhiteStrong,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                '시음 기록',
                style: AppTextStyles.title2Bold.copyWith(
                  color: colors.labelStrong,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              Text(
                '준비 중입니다',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  '커피의 맛과 향을 기록하고\n나만의 시음 노트를 만들어보세요',
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: colors.labelAlternative,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
