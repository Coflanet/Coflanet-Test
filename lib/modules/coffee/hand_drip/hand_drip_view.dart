import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class HandDripView extends GetView<CoffeeController> {
  const HandDripView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.labelNormal),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '핸드드립',
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColor.labelAlternative),
            onPressed: () => controller.goToSettings(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe info card
              _buildRecipeCard(),

              const SizedBox(height: 24),

              // Steps
              Text(
                '추출 단계',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              const SizedBox(height: 16),

              _buildStep(1, '물 끓이기', '92-96°C가 적당해요'),
              _buildStep(2, '필터 세팅', '드리퍼에 필터를 놓고 린싱하세요'),
              _buildStep(3, '원두 갈기', '중간 굵기로 분쇄하세요'),
              _buildStep(4, '뜸 들이기', '30초간 뜸을 들이세요'),
              _buildStep(5, '추출하기', '원을 그리며 천천히 부어주세요'),

              const SizedBox(height: 32),

              PrimaryButton(
                text: '타이머 시작',
                icon: Icons.play_arrow,
                onPressed: () => Get.toNamed(
                  Routes.timerActive,
                  arguments: {'type': 'handDrip'},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.colorGlobalOrange50,
              AppColor.colorGlobalOrange60,
            ],
          ),
          borderRadius: AppRadius.xlBorder,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRecipeItem(
                  label: '잔 수',
                  value: '${controller.cupsCount}잔',
                ),
                _buildRecipeItem(
                  label: '원두',
                  value: '${controller.coffeeAmount}g',
                ),
                _buildRecipeItem(
                  label: '물',
                  value: '${controller.waterAmount}ml',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColor.staticLabelWhiteStrong,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${controller.strengthLabel} 농도로 설정되어 있어요',
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.staticLabelWhiteStrong.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeItem({required String label, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading1Bold.copyWith(
            color: AppColor.staticLabelWhiteStrong,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption1Regular.copyWith(
            color: AppColor.staticLabelWhiteStrong.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(int number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColor.primaryLight,
              borderRadius: AppRadius.xlBorder,
            ),
            child: Center(
              child: Text(
                '$number',
                style: AppTextStyles.label1NormalBold.copyWith(
                  color: AppColor.primaryNormal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: AppColor.labelNormal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
