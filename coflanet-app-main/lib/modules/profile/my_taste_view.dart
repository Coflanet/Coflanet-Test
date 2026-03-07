import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/profile/my_taste_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

class MyTasteView extends GetView<MyTasteController> {
  const MyTasteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasResult) {
          return _buildNoResultState();
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Summary card
              _buildSummaryCard(),

              // Taste chart
              _buildTasteChart(),

              // Action buttons
              _buildActionButtons(),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.backgroundNormalNormal,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(AppColor.labelNormal, BlendMode.srcIn),
        ),
        onPressed: () => controller.goBack(),
      ),
      title: Text(
        '내 취향',
        style: AppTextStyles.headline1Bold.copyWith(
          color: AppColor.labelNormal,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildNoResultState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated coffee bean illustration
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.colorGlobalOrange90,
                          AppColor.colorGlobalOrange95,
                        ],
                      ),
                      borderRadius: AppRadius.fullBorder,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.colorGlobalOrange50.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 64,
                      color: AppColor.colorGlobalOrange50,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              '아직 취향을 설정하지 않으셨어요',
              style: AppTextStyles.headline1Bold.copyWith(
                color: AppColor.labelNormal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '간단한 테스트로 나만의 커피 취향을\n발견해보세요',
              style: AppTextStyles.body1NormalRegular.copyWith(
                color: AppColor.labelAlternative,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            PrimaryButton(
              text: '취향 테스트 시작하기',
              onPressed: () => controller.retakeSurvey(),
              width: 220,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final result = controller.surveyResult!;

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.colorGlobalOrange95,
            AppColor.backgroundNormalNormal,
          ],
        ),
        borderRadius: AppRadius.xxxlBorder,
        border: Border.all(
          color: AppColor.colorGlobalOrange50.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Coffee type badge
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.colorGlobalOrange50,
                        AppColor.colorGlobalOrange70,
                      ],
                    ),
                    borderRadius: AppRadius.xxlBorder,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.colorGlobalOrange50.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.coffee,
                    color: AppColor.staticLabelWhiteStrong,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${controller.userName}님은',
                        style: AppTextStyles.label1NormalMedium.copyWith(
                          color: AppColor.labelAlternative,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.coffeeType,
                        style: AppTextStyles.title3Bold.copyWith(
                          color: AppColor.colorGlobalOrange50,
                        ),
                      ),
                    ],
                  ),
                ),
                // View detail button
                GestureDetector(
                  onTap: () => controller.viewMatchingResult(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundNormalNormal,
                      borderRadius: AppRadius.lgBorder,
                      boxShadow: AppShadows.shadowBlackNormal,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColor.labelAlternative,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            color: AppColor.lineNormalAlternative,
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              result.coffeeTypeDescription,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.labelNeutral,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasteChart() {
    final profile = controller.tasteProfile;
    if (profile == null) return const SizedBox.shrink();

    final tasteData = [
      _TasteData('산미', profile.acidity, AppColor.colorGlobalYellow50),
      _TasteData('단맛', profile.sweetness, AppColor.colorGlobalPink50),
      _TasteData('쓴맛', profile.bitterness, AppColor.colorGlobalOrange50),
      _TasteData('바디감', profile.body, AppColor.colorGlobalViolet50),
      _TasteData('향', profile.aroma, AppColor.colorGlobalGreen50),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.xxxlBorder,
        boxShadow: AppShadows.shadowBlackEmphasize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColor.primaryLight,
                  borderRadius: AppRadius.lgPlusBorder,
                ),
                child: Icon(
                  Icons.coffee,
                  color: AppColor.staticLabelWhiteStrong,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '선호 맛 프로필',
                    style: AppTextStyles.headline1Bold.copyWith(
                      color: AppColor.labelNormal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '나의 커피 취향 분석 결과',
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Bar chart
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: tasteData.map((data) {
                return Expanded(child: _buildBarChartItem(data));
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBarChartItem(_TasteData data) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: data.value / 100),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Value label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.12),
                  borderRadius: AppRadius.mdBorder,
                ),
                child: Text(
                  '${data.value}',
                  style: AppTextStyles.caption1Bold.copyWith(color: data.color),
                ),
              ),
              const SizedBox(height: 8),
              // Bar
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barHeight = constraints.maxHeight * animValue;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: math.max(barHeight, 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [data.color, data.color.withOpacity(0.7)],
                          ),
                          borderRadius: AppRadius.mdBorder,
                          boxShadow: [
                            BoxShadow(
                              color: data.color.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Label
              Text(
                data.label,
                style: AppTextStyles.caption1Medium.copyWith(
                  color: AppColor.labelAlternative,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // View matching result
          _buildActionTile(
            icon: Icons.coffee_rounded,
            iconColor: AppColor.colorGlobalOrange50,
            iconBgColor: AppColor.colorGlobalOrange95,
            title: '매칭 결과 자세히 보기',
            subtitle: '추천 원두와 상세 분석 확인',
            onTap: () => controller.viewMatchingResult(),
          ),

          const SizedBox(height: 12),

          // Retake survey
          _buildActionTile(
            icon: Icons.refresh_rounded,
            iconColor: AppColor.primaryNormal,
            iconBgColor: AppColor.primaryLight,
            title: '취향 다시 설정하기',
            subtitle: '새로운 취향 테스트로 업데이트',
            onTap: () => controller.retakeSurvey(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: AppRadius.xxlBorder,
          border: Border.all(color: AppColor.lineNormalNeutral, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: AppRadius.xlBorder,
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headline2Bold.copyWith(
                      color: AppColor.labelNormal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.labelAssistive,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _TasteData {
  final String label;
  final int value;
  final Color color;

  _TasteData(this.label, this.value, this.color);
}
