import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class EspressoView extends GetView<CoffeeController> {
  const EspressoView({super.key});

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
          '에스프레소',
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

              // Settings
              Text(
                '추출 설정',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              const SizedBox(height: 16),

              _buildSettingItem(
                icon: Icons.local_drink,
                title: '싱글 샷',
                description: '30ml 추출',
                isSelected: true,
              ),
              _buildSettingItem(
                icon: Icons.local_drink,
                title: '더블 샷',
                description: '60ml 추출',
                isSelected: false,
              ),

              const SizedBox(height: 24),

              // Tips
              Text(
                '팁',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              const SizedBox(height: 16),

              _buildTip('원두는 에스프레소용 분쇄로 곱게 갈아주세요'),
              _buildTip('추출 시간은 25-30초가 적당해요'),
              _buildTip('크레마가 고르게 형성되는지 확인하세요'),

              const SizedBox(height: 32),

              PrimaryButton(
                text: '추출 시작',
                onPressed: () {
                  Get.toNamed(
                    Routes.timerActive,
                    arguments: {'type': 'espresso'},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.colorGlobalViolet50, AppColor.colorGlobalViolet60],
        ),
        borderRadius: AppRadius.xlBorder,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRecipeItem(label: '원두', value: '18g'),
          _buildRecipeItem(label: '물온도', value: '93°C'),
          _buildRecipeItem(label: '추출시간', value: '25초'),
        ],
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

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColor.primaryLight
            : AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: isSelected
              ? AppColor.primaryNormal
              : AppColor.lineNormalNeutral,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? AppColor.primaryNormal
                : AppColor.labelAlternative,
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
                Text(
                  description,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle, color: AppColor.primaryNormal),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: AppColor.colorGlobalYellow50,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
