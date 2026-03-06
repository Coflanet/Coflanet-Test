import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/widgets/charts/flavor_radar_chart.dart';
import 'package:coflanet/widgets/navigation/app_bottom_bar.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';

/// Bean Detail View (원두 상세)
///
/// Displays detailed information about a coffee bean including:
/// - Flavor radar chart (산미, 바디감, 단맛, 쓴맛, 밸런스)
/// - Flavor tags (공통 향미, 특성 향미)
/// - Origin, roast level, process method
class BeanDetailView extends StatelessWidget {
  const BeanDetailView({super.key});

  CoffeeItem get _bean {
    final args = Get.arguments as Map<String, dynamic>?;
    return args?['bean'] as CoffeeItem? ?? _defaultBean;
  }

  static const _defaultBean = CoffeeItem(
    id: 'default',
    name: '에티오피아 예가체프',
    description: '과일향, 꽃향이 풍부한 산미 커피',
    color: AppColor.colorGlobalOrange50,
    brand: '스페셜티 로스터스',
    flavorProfile: FlavorProfile(
      acidity: 4.5,
      body: 2.5,
      sweetness: 4.0,
      bitterness: 1.5,
      balance: 4.2,
    ),
    commonFlavors: ['과일 향', '꽃 향'],
    characteristicFlavors: ['자스민', '베리', '시트러스'],
    aromaIntensity: 4.8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorGlobalCommon0,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildFlavorChart(),
                    const SizedBox(height: 32),
                    _buildFlavorTags(),
                    const SizedBox(height: 32),
                    _buildInfoSection(),
                    const SizedBox(height: 100),
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

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              AssetPath.iconArrowBack,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColor.colorGlobalCommon100,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => Get.back(),
          ),
          const Spacer(),
          Text(
            '원두 상세',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: AppColor.colorGlobalCommon100,
              size: 24,
            ),
            onPressed: () async {
              final result = await Get.toNamed(
                Routes.beanEdit,
                arguments: {'bean': _bean},
              );
              if (result is CoffeeItem) {
                await RepositoryProvider.coffeeRepository.updateCoffeeItem(
                  result,
                );
                // Return updated bean to refresh the list
                Get.back(result: result);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          if (_bean.brand != null)
            Text(
              _bean.brand!,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
          const SizedBox(height: 4),
          // Name
          Text(
            _bean.name,
            style: AppTextStyles.title1Bold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            _bean.description,
            style: AppTextStyles.body1NormalRegular.copyWith(
              color: AppColor.colorGlobalCoolNeutral60,
            ),
          ),
          // Origin info row
          if (_bean.origin != null || _bean.roastLevel != null) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (_bean.origin != null)
                  _buildInfoChip(Icons.place_outlined, _bean.origin!),
                if (_bean.roastLevel != null)
                  _buildInfoChip(
                    Icons.local_fire_department_outlined,
                    _bean.roastLevel!,
                  ),
                if (_bean.processMethod != null)
                  _buildInfoChip(
                    Icons.water_drop_outlined,
                    _bean.processMethod!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral15,
        borderRadius: AppRadius.xxxlBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColor.colorGlobalCoolNeutral60),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColor.colorGlobalCoolNeutral60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlavorChart() {
    final profile = _bean.flavorProfile ?? const FlavorProfile();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCoolNeutral15,
          borderRadius: AppRadius.xlBorder,
        ),
        child: Column(
          children: [
            // Aroma intensity
            if (_bean.aromaIntensity != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '향의 진함',
                    style: AppTextStyles.body2NormalMedium.copyWith(
                      color: AppColor.colorGlobalCoolNeutral60,
                    ),
                  ),
                  Text(
                    _bean.aromaIntensity!.toStringAsFixed(1),
                    style: AppTextStyles.body2NormalBold.copyWith(
                      color: AppColor.primaryNormal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildAromaBar(_bean.aromaIntensity!),
              const SizedBox(height: 24),
            ],
            // Radar chart
            Center(
              child: FlavorRadarChart(
                profile: profile,
                size: 220,
                showLabels: true,
                showValues: true,
                animate: true,
                fillColor: AppColor.primaryNormal.withOpacity(0.15),
                strokeColor: AppColor.primaryNormal,
                gridColor: AppColor.colorGlobalCoolNeutral30,
                labelColor: AppColor.colorGlobalCommon100,
              ),
            ),
            const SizedBox(height: 24),
            // Flavor values list
            _buildFlavorValuesList(profile),
          ],
        ),
      ),
    );
  }

  Widget _buildAromaBar(double value) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral25,
        borderRadius: AppRadius.xxxlBorder,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * (value / 100.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryNormal.withOpacity(0.7),
                      AppColor.primaryNormal,
                    ],
                  ),
                  borderRadius: AppRadius.xxxlBorder,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFlavorValuesList(FlavorProfile profile) {
    final items = [
      ('산미', profile.acidity),
      ('바디감', profile.body),
      ('단맛', profile.sweetness),
      ('쓴맛', profile.bitterness),
      ('밸런스', profile.balance),
    ];

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  item.$1,
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: AppColor.colorGlobalCoolNeutral60,
                  ),
                ),
              ),
              Expanded(child: _buildValueBar(item.$2)),
              const SizedBox(width: 12),
              SizedBox(
                width: 30,
                child: Text(
                  item.$2.round().toString(),
                  style: AppTextStyles.body2NormalMedium.copyWith(
                    color: AppColor.colorGlobalCommon100,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildValueBar(double value) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral25,
        borderRadius: AppRadius.xxxlBorder,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              width: constraints.maxWidth * (value / 100.0),
              decoration: BoxDecoration(
                color: AppColor.primaryNormal,
                borderRadius: AppRadius.xxxlBorder,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlavorTags() {
    final hasCommon =
        _bean.commonFlavors != null && _bean.commonFlavors!.isNotEmpty;
    final hasCharacteristic =
        _bean.characteristicFlavors != null &&
        _bean.characteristicFlavors!.isNotEmpty;

    if (!hasCommon && !hasCharacteristic) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasCommon) ...[
            _buildTagSection('공통 향미', _bean.commonFlavors!),
            const SizedBox(height: 20),
          ],
          if (hasCharacteristic)
            _buildTagSection('특성 향미', _bean.characteristicFlavors!),
        ],
      ),
    );
  }

  Widget _buildTagSection(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headline2Bold.copyWith(
            color: AppColor.colorGlobalCommon100,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => _FlavorTagChip(label: tag)).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '원두 정보',
            style: AppTextStyles.headline2Bold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.colorGlobalCoolNeutral15,
              borderRadius: AppRadius.xlBorder,
            ),
            child: Column(
              children: [
                if (_bean.origin != null) _buildInfoRow('원산지', _bean.origin!),
                if (_bean.roastLevel != null)
                  _buildInfoRow('로스팅', _bean.roastLevel!),
                if (_bean.processMethod != null)
                  _buildInfoRow('가공 방식', _bean.processMethod!),
                if (_bean.brand != null) _buildInfoRow('브랜드', _bean.brand!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.colorGlobalCoolNeutral60,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body2NormalMedium.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return AppBottomBar.primaryButton(
      text: '원두 레시피 시작',
      onPressed: () {
        Get.toNamed(Routes.coffeeSettings, arguments: {'bean': _bean});
      },
      padding: const EdgeInsets.all(24),
    );
  }
}

/// Flavor tag chip widget
class _FlavorTagChip extends StatelessWidget {
  final String label;

  const _FlavorTagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.primaryNormal.withOpacity(0.12),
        borderRadius: AppRadius.xxxlBorder,
        border: Border.all(
          color: AppColor.primaryNormal.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.label1NormalMedium.copyWith(
          color: AppColor.primaryNormal,
        ),
      ),
    );
  }
}
