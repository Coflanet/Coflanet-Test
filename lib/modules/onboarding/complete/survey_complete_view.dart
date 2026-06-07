import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class SurveyCompleteView extends GetView<SurveyController> {
  const SurveyCompleteView({super.key});

  // Figma 사양: Pretendard SemiBold 22 / lineHeight 1.36 / letterSpacing -0.4268
  // 색상은 Label/strong (#000000) 토큰 매핑
  // Auth 카테고리에서 통일한 페이지 헤더 스타일과 동일
  TextStyle _screenHeaderStyle(AppColorScheme colors) =>
      AppTextStyles.heading1Bold.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.36,
        letterSpacing: -0.4268,
        color: colors.labelStrong,
      );

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '취향 분석',
          style: AppTextStyles.headline2Bold.copyWith(
            color: colors.labelNormal,
          ),
        ),
        leading: const SizedBox.shrink(), // 뒤로 가기 버튼 없음 — offNamed로 진입
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AssetPath.iconSettings,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                colors.labelAlternative,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              // 설정 화면 연결 (추후 구현)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Figma 순서: 안내 텍스트가 일러스트 위에 위치
                  Text(
                    '${controller.userName}님의\n커피 취향을 찾았어요!',
                    textAlign: TextAlign.center,
                    style: _screenHeaderStyle(colors),
                  ),

                  const Spacer(flex: 1),

                  // 토끼 일러스트 — 브랜드 아이덴티티 유지
                  ClipRRect(
                    borderRadius: AppRadius.fullBorder,
                    child: Image.asset(
                      AssetPath.charGift,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: colors.primaryLight,
                          borderRadius: AppRadius.fullBorder,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.card_giftcard_rounded,
                              size: 64,
                              color: colors.primaryNormal,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mascot',
                              style: AppTextStyles.caption1Regular.copyWith(
                                color: colors.primaryNormal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),

          // Bottom CTA area (BottomSheet_CTA style)
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
            decoration: BoxDecoration(color: colors.backgroundNormalNormal),
            child: PrimaryButton(
              text: '내 취향 커피 만나러 가기',
              onPressed: () => controller.viewResult(),
            ),
          ),
        ],
      ),
    );
  }
}
