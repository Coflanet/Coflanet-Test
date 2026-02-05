import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';

class CoffeeMainView extends GetView<CoffeeController> {
  const CoffeeMainView({super.key});

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
          '커피 마시기',
          style: AppTextStyles.headline1Bold.copyWith(
            color: AppColor.labelNormal,
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
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // Coffee type cards
              _buildCoffeeTypeCard(
                type: CoffeeType.handDrip,
                title: '핸드드립',
                description: '직접 손으로 내리는 커피',
                icon: Icons.local_cafe,
                color: AppColor.colorGlobalOrange50,
              ),

              const SizedBox(height: 16),

              _buildCoffeeTypeCard(
                type: CoffeeType.espresso,
                title: '에스프레소 머신',
                description: '기계로 추출하는 진한 커피',
                icon: Icons.coffee_maker,
                color: AppColor.colorGlobalViolet50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoffeeTypeCard({
    required CoffeeType type,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => controller.selectType(type),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: AppRadius.xlBorder,
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: AppRadius.roundBorder,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headline1Bold.copyWith(
                      color: AppColor.labelNormal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.body2NormalRegular.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor.labelAssistive,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
