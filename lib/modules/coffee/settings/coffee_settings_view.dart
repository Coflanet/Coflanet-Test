import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/modals/input_modal.dart';
import 'package:coflanet/widgets/modals/time_picker_modal.dart';

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

                    // Recipe parameter cards
                    _buildRecipeParameters(),

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
        Obx(
          () => Row(
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
          ),
        ),
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
          color: enabled ? AppColor.primaryLight : AppColor.componentFillNormal,
          borderRadius: AppRadius.xxxlBorder,
        ),
        child: Icon(
          icon,
          color: enabled ? AppColor.primaryNormal : AppColor.labelDisable,
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
            Obx(
              () => Text(
                controller.strengthLabel,
                style: AppTextStyles.body1NormalMedium.copyWith(
                  color: AppColor.primaryNormal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
          () => SliderTheme(
            data: SliderTheme.of(Get.context!).copyWith(
              activeTrackColor: AppColor.primaryNormal,
              inactiveTrackColor: AppColor.lineNormalAlternative,
              thumbColor: AppColor.primaryNormal,
              overlayColor: AppColor.primaryNormal.withOpacity(0.2),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            ),
            child: Slider(
              value: controller.strength.toDouble(),
              min: 0,
              max: 100,
              onChanged: (value) => controller.strength = value.round(),
            ),
          ),
        ),
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

  Widget _buildRecipeParameters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '레시피 세부 설정',
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Column(
            children: [
              _RecipeParameterCard(
                icon: Icons.coffee_outlined,
                title: '원두량',
                value: '${controller.coffeeAmount}g',
                onTap: () => Get.toNamed(
                  Routes.coffeeSettingDetail,
                  arguments: {'param': 'beanAmount'},
                ),
              ),
              const SizedBox(height: 12),
              _RecipeParameterCard(
                icon: Icons.thermostat_outlined,
                title: '물 온도',
                value: '${controller.waterTemperature}°C',
                onTap: () => Get.toNamed(
                  Routes.coffeeSettingDetail,
                  arguments: {'param': 'waterTemperature'},
                ),
              ),
              const SizedBox(height: 12),
              _RecipeParameterCard(
                icon: Icons.timer_outlined,
                title: '추출 시간',
                value: controller.extractionTimeFormatted,
                onTap: () => Get.toNamed(
                  Routes.coffeeSettingDetail,
                  arguments: {'param': 'extractionTime'},
                ),
              ),
              const SizedBox(height: 12),
              _RecipeParameterCard(
                icon: Icons.water_drop_outlined,
                title: '물 양',
                value: '${controller.waterAmount}ml',
                onTap: () => Get.toNamed(
                  Routes.coffeeSettingDetail,
                  arguments: {'param': 'waterAmount'},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showCoffeeAmountModal() async {
    final result = await InputModal.show(
      title: '원두량 설정',
      message: '원두량을 그램 단위로 입력하세요',
      hint: '예: 15',
      initialValue: controller.coffeeAmount.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) return '값을 입력하세요';
        final amount = int.tryParse(value);
        if (amount == null || amount < 5 || amount > 100) {
          return '5~100g 사이의 값을 입력하세요';
        }
        return null;
      },
    );
    if (result != null) {
      controller.customCoffeeAmount = int.parse(result);
    }
  }

  Future<void> _showWaterTemperatureModal() async {
    final result = await InputModal.show(
      title: '물 온도 설정',
      message: '물 온도를 섭씨 단위로 입력하세요',
      hint: '예: 92',
      initialValue: controller.waterTemperature.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) return '값을 입력하세요';
        final temp = int.tryParse(value);
        if (temp == null || temp < 85 || temp > 100) {
          return '85~100°C 사이의 값을 입력하세요';
        }
        return null;
      },
    );
    if (result != null) {
      controller.waterTemperature = int.parse(result);
    }
  }

  Future<void> _showExtractionTimeModal() async {
    final initialDuration = Duration(seconds: controller.extractionTime);
    final result = await TimePickerModal.show(
      title: '추출 시간 설정',
      initialDuration: initialDuration,
      maxMinutes: 10,
      maxSeconds: 59,
    );
    if (result != null) {
      controller.extractionTime = result.inSeconds;
    }
  }

  Future<void> _showWaterAmountModal() async {
    final result = await InputModal.show(
      title: '물 양 설정',
      message: '물 양을 ml 단위로 입력하세요',
      hint: '예: 250',
      initialValue: controller.waterAmount.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) return '값을 입력하세요';
        final amount = int.tryParse(value);
        if (amount == null || amount < 30 || amount > 1000) {
          return '30~1000ml 사이의 값을 입력하세요';
        }
        return null;
      },
    );
    if (result != null) {
      controller.customWaterAmount = int.parse(result);
    }
  }

  Widget _buildRecipeSummary() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalAlternative,
          borderRadius: AppRadius.xlBorder,
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
      ),
    );
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
        child: PrimaryButton(text: '설정 완료', onPressed: () => Get.back()),
      ),
    );
  }
}

/// A beautiful tappable card for recipe parameters with smooth press animations
class _RecipeParameterCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _RecipeParameterCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  State<_RecipeParameterCard> createState() => _RecipeParameterCardState();
}

class _RecipeParameterCardState extends State<_RecipeParameterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(opacity: _opacityAnimation.value, child: child),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.backgroundNormalAlternative,
            borderRadius: AppRadius.xlBorder,
            border: Border.all(color: AppColor.lineNormalAlternative, width: 1),
          ),
          child: Row(
            children: [
              // Icon container with subtle gradient background
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColor.primaryLight,
                      AppColor.primaryLight.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: AppRadius.lgBorder,
                ),
                child: Icon(
                  widget.icon,
                  color: AppColor.primaryNormal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              // Title and value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.body2NormalRegular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: AppTextStyles.headline2Bold.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                  ],
                ),
              ),
              // Chevron icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColor.componentFillNormal,
                  borderRadius: AppRadius.mdBorder,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: AppColor.labelAssistive,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
