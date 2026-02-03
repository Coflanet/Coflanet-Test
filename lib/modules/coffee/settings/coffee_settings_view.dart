import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class CoffeeSettingsView extends GetView<CoffeeController> {
  const CoffeeSettingsView({super.key});

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
          '상세 설정',
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cups selector
                    _buildCupsSelector(),

                    const SizedBox(height: 32),

                    // Strength slider
                    _buildStrengthSlider(),

                    const SizedBox(height: 32),

                    // Recipe summary
                    _buildRecipeSummary(),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCupsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '잔 수',
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => Row(
              children: [
                _buildCupsButton(
                  onPressed: controller.decrementCups,
                  icon: Icons.remove,
                  enabled: controller.cupsCount > 1,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${controller.cupsCount}잔',
                      style: AppTextStyles.title2Bold.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                  ),
                ),
                _buildCupsButton(
                  onPressed: controller.incrementCups,
                  icon: Icons.add,
                  enabled: controller.cupsCount < 4,
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildCupsButton({
    required VoidCallback onPressed,
    required IconData icon,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled
              ? AppColor.primaryLight
              : AppColor.componentFillNormal,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          icon,
          color: enabled
              ? AppColor.primaryNormal
              : AppColor.labelDisable,
        ),
      ),
    );
  }

  Widget _buildStrengthSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '진하기',
              style: AppTextStyles.headline1Bold.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
            Obx(() => Text(
                  controller.strengthLabel,
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: AppColor.primaryNormal,
                  ),
                )),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => SliderTheme(
              data: SliderTheme.of(Get.context!).copyWith(
                activeTrackColor: AppColor.primaryNormal,
                inactiveTrackColor: AppColor.lineNormalAlternative,
                thumbColor: AppColor.primaryNormal,
                overlayColor: AppColor.primaryNormal.withOpacity(0.2),
                trackHeight: 8,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 14,
                ),
              ),
              child: Slider(
                value: controller.strength.toDouble(),
                min: 0,
                max: 100,
                onChanged: (value) => controller.strength = value.round(),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '연하게',
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.labelAssistive,
              ),
            ),
            Text(
              '진하게',
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.labelAssistive,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecipeSummary() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.backgroundNormalAlternative,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '레시피 요약',
                style: AppTextStyles.headline2Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow('잔 수', '${controller.cupsCount}잔'),
              _buildSummaryRow('원두량', '${controller.coffeeAmount}g'),
              _buildSummaryRow('물', '${controller.waterAmount}ml'),
              _buildSummaryRow('농도', controller.strengthLabel),
            ],
          ),
        ));
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body2NormalMedium.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        boxShadow: AppShadows.shadowBlackHeavyBottom,
      ),
      child: SafeArea(
        child: PrimaryButton(
          text: '설정 완료',
          onPressed: () => Get.back(),
        ),
      ),
    );
  }
}
