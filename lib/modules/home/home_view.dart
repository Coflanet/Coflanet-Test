import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/home/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverToBoxAdapter(child: _buildAppBar()),

            // Welcome section
            SliverToBoxAdapter(child: _buildWelcomeSection()),

            // Quick actions
            SliverToBoxAdapter(child: _buildQuickActions()),

            // Feature cards
            SliverToBoxAdapter(child: _buildFeatureCards()),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          // Logo Symbol (Primary color for white background)
          Image.asset(
            AssetPath.logoSymbolPrimary,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColor.primaryNormal,
                borderRadius: AppRadius.smBorder,
              ),
              child: Icon(
                Icons.coffee,
                size: 20,
                color: AppColor.staticLabelWhiteStrong,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Coflanet',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.logout, color: AppColor.labelAlternative),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '안녕하세요, ${controller.userName}님!',
            style: AppTextStyles.heading1Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '오늘도 좋은 커피 한 잔 어떠세요?',
            style: AppTextStyles.body1NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.coffee,
                  label: '커피 마시기',
                  color: AppColor.primaryNormal,
                  onTap: () => controller.navigateToCoffee(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.favorite_outline,
                  label: '내 취향',
                  color: AppColor.accentForegroundPink,
                  onTap: () => controller.navigateToMyTaste(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.public_rounded,
                  label: '나의 행성',
                  color: AppColor.colorGlobalCyan50,
                  onTap: () => controller.navigateToMyPlanet(),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: SizedBox(),
              ), // Placeholder for future action
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: AppRadius.xlBorder,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.body1NormalMedium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '추천 메뉴',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 16),

          // Hand drip card
          _buildFeatureCard(
            title: '핸드드립',
            description: '직접 내리는 커피의 즐거움',
            imagePath: AssetPath.coffeeHandDrip,
            fallbackIcon: Icons.local_cafe,
            accentColor: AppColor.colorGlobalOrange50,
            onTap: () => Get.toNamed('/coffee/hand-drip'),
          ),

          const SizedBox(height: 12),

          // Espresso card
          _buildFeatureCard(
            title: '에스프레소',
            description: '진한 한 잔의 풍미',
            imagePath: AssetPath.coffeeEspresso,
            fallbackIcon: Icons.coffee_maker,
            accentColor: AppColor.colorGlobalViolet50,
            onTap: () => Get.toNamed('/coffee/espresso'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required String imagePath,
    required IconData fallbackIcon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: AppRadius.xlBorder,
          boxShadow: [
            BoxShadow(
              color: AppColor.labelNormal.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Coffee image thumbnail
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
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
                      Icon(fallbackIcon, color: accentColor, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Text content
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
            // Arrow icon
            SvgPicture.asset(
              AssetPath.iconArrowForward,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                AppColor.labelAssistive,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
