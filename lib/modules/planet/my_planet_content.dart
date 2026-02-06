import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';

/// Content widget for My Planet screen (without Scaffold/bottom nav)
/// Used inside MainShellView's IndexedStack
class MyPlanetContent extends GetView<MyPlanetController> {
  const MyPlanetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.colorGlobalViolet50,
            ),
          );
        }
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header - User name
              _buildHeader(),
              const SizedBox(height: 24),
              // Main content: empty or filled
              if (controller.hasTasteProfile)
                _buildFilledContent()
              else
                _buildEmptyContent(),
              const SizedBox(height: 24),
              // Bottom section: logout + withdraw
              _buildBottomActions(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  // ==================== HEADER ====================

  Widget _buildHeader() {
    // Fixed per Figma CSS: Shell screens use black bg, white text
    const textColor = AppColor.colorGlobalCommon100; // White text on black bg

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            controller.userName,
            style: AppTextStyles.heading1Bold.copyWith(color: textColor),
          ),
          const Spacer(),
          // Debug toggle
          GestureDetector(
            onTap: () => controller.toggleDemoData(),
            child: Icon(
              Icons.science_outlined,
              color: AppColor.colorGlobalCoolNeutral50,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY STATE ====================

  Widget _buildEmptyContent() {
    // Empty state uses light theme: white card on light gray background
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100, // White card
          borderRadius: AppRadius.xxlBorder,
        ),
        child: Column(
          children: [
            // Headline - black text on white card
            Text(
              '내 커피 취향을\n찾아볼까요?',
              style: AppTextStyles.title2Bold.copyWith(
                color: AppColor.labelNormal, // Black text
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Mascot placeholder
            _buildMascotPlaceholder(),
            const SizedBox(height: 32),
            // CTA Button - secondary style (light gray bg + violet text)
            GestureDetector(
              onTap: () => controller.goToSurvey(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColor.componentFillNormal, // Light gray
                  borderRadius: AppRadius.lgPlusBorder,
                ),
                child: Text(
                  '취향 설문 하기',
                  style: AppTextStyles.headline1Bold.copyWith(
                    color: AppColor.primaryNormal, // Violet text
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMascotPlaceholder() {
    return Image.asset(
      AssetPath.onboardingComplete,
      width: 180,
      height: 180,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to icon if image fails to load
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.colorGlobalViolet80,
                AppColor.colorGlobalViolet50,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.smart_toy_rounded,
              size: 64,
              color: AppColor.colorGlobalCommon100,
            ),
          ),
        );
      },
    );
  }

  // ==================== FILLED STATE ====================

  Widget _buildFilledContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category taste pills (horizontal scroll)
        _buildTasteCards(),
        const SizedBox(height: 20),
        // Flavor description list
        _buildFlavorList(),
        const SizedBox(height: 16),
        // Retake survey button
        _buildRetakeSurveyButton(),
      ],
    );
  }

  Widget _buildTasteCards() {
    final preferences = controller.tastePreferences;
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: preferences.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final pref = preferences[index];
          return KeyedSubtree(
            key: ValueKey(pref.category),
            child: _buildTastePill(pref),
          );
        },
      ),
    );
  }

  Widget _buildTastePill(TastePreference pref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors(pref.gradientType),
        ),
        borderRadius: AppRadius.xlBorder,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pref.category,
            style: AppTextStyles.caption1Bold.copyWith(
              color: AppColor.colorGlobalCoolNeutral10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pref.level,
            style: AppTextStyles.headline2Bold.copyWith(
              color: AppColor.colorGlobalCoolNeutral10,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _gradientColors(TasteGradientType type) {
    switch (type) {
      case TasteGradientType.blue:
        return [AppColor.colorGlobalLightBlue90, AppColor.colorGlobalCyan90];
      case TasteGradientType.yellow:
        return [AppColor.colorGlobalYellow90, AppColor.colorGlobalOrange90];
      case TasteGradientType.pink:
        return [AppColor.colorGlobalPink90, AppColor.colorGlobalRed90];
    }
  }

  Widget _buildFlavorList() {
    final flavors = controller.flavorDescriptions;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100,
          borderRadius: AppRadius.xxlBorder,
        ),
        child: Column(
          children: List.generate(flavors.length, (index) {
            final flavor = flavors[index];
            return Column(
              children: [
                _buildFlavorItem(flavor),
                if (index < flavors.length - 1)
                  Divider(
                    height: 1,
                    indent: 72,
                    endIndent: 20,
                    color: AppColor.lineSolidNeutral,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFlavorItem(FlavorDescription flavor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Circle icon placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.componentFillNormal,
            ),
            child: Center(
              child: Icon(
                _flavorIcon(flavor.title),
                size: 20,
                color: AppColor.labelAlternative,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flavor.title,
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: AppColor.labelNormal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  flavor.description,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _flavorIcon(String title) {
    if (title.contains('과일')) return Icons.energy_savings_leaf_rounded;
    if (title.contains('꽃')) return Icons.local_florist_rounded;
    if (title.contains('견과')) return Icons.cookie_rounded;
    if (title.contains('로스팅')) return Icons.local_fire_department_rounded;
    return Icons.coffee_rounded;
  }

  Widget _buildRetakeSurveyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => controller.retakeSurvey(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColor.componentFillNormal,
            borderRadius: AppRadius.lgPlusBorder,
          ),
          child: Text(
            '취향 설문 다시 하기',
            style: AppTextStyles.headline2Bold.copyWith(
              color: AppColor.primaryNormal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // ==================== BOTTOM ACTIONS ====================

  Widget _buildBottomActions() {
    // Both states use white card background
    // Filled: 로그아웃=black, 회원탈퇴=red
    // Empty: 로그아웃=black, 회원탈퇴=violet
    final isFilled = controller.hasTasteProfile;
    final withdrawColor = isFilled
        ? AppColor
              .colorGlobalRed50 // Red for filled state
        : AppColor.primaryNormal; // Violet for empty state

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100, // White card
          borderRadius: AppRadius.xxlBorder,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => controller.logout(),
              child: Text(
                '로그아웃',
                style: AppTextStyles.body2NormalMedium.copyWith(
                  color: AppColor.labelNormal, // Black
                ),
              ),
            ),
            Container(
              width: 1,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColor.lineSolidNormal,
            ),
            GestureDetector(
              onTap: () => controller.withdrawAccount(),
              child: Text(
                '회원탈퇴',
                style: AppTextStyles.body2NormalMedium.copyWith(
                  color: withdrawColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
