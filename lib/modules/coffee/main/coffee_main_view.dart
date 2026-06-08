import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';

class CoffeeMainView extends GetView<CoffeeController> {
  const CoffeeMainView({super.key});

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
        automaticallyImplyLeading: false,
        title: Text(
          '커피 마시기',
          style: AppTextStyles.headline1Bold.copyWith(
            color: colors.labelNormal,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '어떤 방식으로\n커피를 즐기시겠어요?',
                style: _screenHeaderStyle(colors),
              ),

              const SizedBox(height: 32),

              // Coffee type cards
              _buildCoffeeTypeCard(
                colors: colors,
                type: CoffeeType.handDrip,
                title: '핸드드립',
                description: '직접 손으로 내리는 커피',
                imagePath: AssetPath.coffeeHandDrip,
                fallbackIcon: Icons.local_cafe,
                color: AppColor.colorGlobalOrange50,
              ),

              const SizedBox(height: 16),

              _buildCoffeeTypeCard(
                colors: colors,
                type: CoffeeType.espresso,
                title: '에스프레소 머신',
                description: '기계로 추출하는 진한 커피',
                imagePath: AssetPath.coffeeEspresso,
                fallbackIcon: Icons.coffee_maker,
                color: AppColor.colorGlobalViolet50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoffeeTypeCard({
    required AppColorScheme colors,
    required CoffeeType type,
    required String title,
    required String description,
    required String imagePath,
    required IconData fallbackIcon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => controller.selectType(type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.backgroundNormalNormal,
          borderRadius: AppRadius.xlBorder,
          boxShadow: [
            BoxShadow(
              color: colors.labelNormal.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Coffee type image with fallback icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: AppRadius.mdBorder,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.mdBorder,
                child: Image.asset(
                  imagePath,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(fallbackIcon, color: color, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headline1Bold.copyWith(
                      color: colors.labelNormal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.body2NormalRegular.copyWith(
                      color: colors.labelAlternative,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AssetPath.iconArrowForward,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                colors.labelAssistive,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
