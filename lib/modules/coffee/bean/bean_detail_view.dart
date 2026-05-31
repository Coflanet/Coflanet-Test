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
///
/// 원두 데이터는 목록 화면에서 `Get.arguments['bean']` 으로 전달받는다.
/// 인자가 없는 비정상 진입 시에는 '정보를 불러올 수 없음' 상태를 표시한다.
class BeanDetailView extends StatelessWidget {
  const BeanDetailView({super.key});

  CoffeeItem? get _beanArg {
    final args = Get.arguments as Map<String, dynamic>?;
    return args?['bean'] as CoffeeItem?;
  }

  @override
  Widget build(BuildContext context) {
    final bean = _beanArg;
    if (bean == null) {
      return _buildNotFound();
    }
    return _buildDetail(bean);
  }

  Widget _buildDetail(CoffeeItem bean) {
    return Scaffold(
      backgroundColor: AppColor.colorGlobalCommon0,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(bean),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(bean),
                    const SizedBox(height: 24),
                    _buildFlavorChart(bean),
                    const SizedBox(height: 32),
                    _buildFlavorTags(bean),
                    const SizedBox(height: 32),
                    _buildInfoSection(bean),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            _buildBottomBar(bean),
          ],
        ),
      ),
    );
  }

  /// 인자 없이 진입한 경우 표시되는 안내 화면
  Widget _buildNotFound() {
    return Scaffold(
      backgroundColor: AppColor.colorGlobalCommon0,
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.coffee_outlined,
                      size: 48,
                      color: AppColor.colorGlobalCoolNeutral50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '원두 정보를 불러올 수 없어요.',
                      style: AppTextStyles.body1NormalMedium.copyWith(
                        color: AppColor.colorGlobalCoolNeutral60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(CoffeeItem bean) {
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
                arguments: {'bean': bean},
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

  Widget _buildHeader(CoffeeItem bean) {
    final displayImage = bean.displayImageUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 원두 이미지 (네이버 이미지 우선)
          if (displayImage != null) ...[
            Center(
              child: ClipRRect(
                borderRadius: AppRadius.xlBorder,
                child: Image.network(
                  displayImage,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColor.colorGlobalCoolNeutral15,
                      borderRadius: AppRadius.xlBorder,
                    ),
                    child: Icon(
                      Icons.coffee,
                      size: 64,
                      color: bean.color,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          // Brand
          if (bean.brand != null)
            Text(
              bean.brand!,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
          const SizedBox(height: 4),
          // Name
          Text(
            bean.name,
            style: AppTextStyles.title1Bold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            bean.description,
            style: AppTextStyles.body1NormalRegular.copyWith(
              color: AppColor.colorGlobalCoolNeutral60,
            ),
          ),
          // 네이버 쇼핑 가격 정보
          if (bean.naverLprice != null) ...[
            const SizedBox(height: 12),
            _buildPriceRow(bean),
          ],
          // Origin info row
          if (bean.origin != null || bean.roastLevel != null) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (bean.origin != null)
                  _buildInfoChip(Icons.place_outlined, bean.origin!),
                if (bean.roastLevel != null)
                  _buildInfoChip(
                    Icons.local_fire_department_outlined,
                    bean.roastLevel!,
                  ),
                if (bean.processMethod != null)
                  _buildInfoChip(
                    Icons.water_drop_outlined,
                    bean.processMethod!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 네이버 쇼핑 가격 정보 행
  Widget _buildPriceRow(CoffeeItem bean) {
    final formatter = _formatPrice(bean.naverLprice!);
    final mallName = bean.naverMallName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral15,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Row(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 18,
            color: AppColor.primaryNormal,
          ),
          const SizedBox(width: 8),
          Text(
            formatter,
            style: AppTextStyles.body1NormalBold.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
          if (bean.naverHprice != null &&
              bean.naverHprice != bean.naverLprice) ...[
            Text(
              ' ~ ${_formatPrice(bean.naverHprice!)}',
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
          ],
          const Spacer(),
          if (mallName != null)
            Text(
              mallName,
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
        ],
      ),
    );
  }

  /// 가격 포맷팅 (원 단위, 쉼표 구분)
  String _formatPrice(int price) {
    final priceStr = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < priceStr.length; i++) {
      if (i > 0 && (priceStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(priceStr[i]);
    }
    return '$buffer원';
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

  Widget _buildFlavorChart(CoffeeItem bean) {
    final profile = bean.flavorProfile ?? const FlavorProfile();

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
            if (bean.aromaIntensity != null) ...[
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
                    bean.aromaIntensity!.round().toString(),
                    style: AppTextStyles.body2NormalBold.copyWith(
                      color: AppColor.primaryNormal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildAromaBar(bean.aromaIntensity!),
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
                fillColor: AppColor.primaryNormal.withValues(alpha: 0.15),
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
                      AppColor.primaryNormal.withValues(alpha: 0.7),
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

  Widget _buildFlavorTags(CoffeeItem bean) {
    final hasCommon =
        bean.commonFlavors != null && bean.commonFlavors!.isNotEmpty;
    final hasCharacteristic =
        bean.characteristicFlavors != null &&
        bean.characteristicFlavors!.isNotEmpty;

    if (!hasCommon && !hasCharacteristic) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasCommon) ...[
            _buildTagSection('공통 향미', bean.commonFlavors!),
            const SizedBox(height: 20),
          ],
          if (hasCharacteristic)
            _buildTagSection('특성 향미', bean.characteristicFlavors!),
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

  Widget _buildInfoSection(CoffeeItem bean) {
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
                if (bean.origin != null) _buildInfoRow('원산지', bean.origin!),
                if (bean.roastLevel != null)
                  _buildInfoRow('로스팅', bean.roastLevel!),
                if (bean.processMethod != null)
                  _buildInfoRow('가공 방식', bean.processMethod!),
                if (bean.brand != null) _buildInfoRow('브랜드', bean.brand!),
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

  Widget _buildBottomBar(CoffeeItem bean) {
    return AppBottomBar.primaryButton(
      text: '원두 레시피 시작',
      onPressed: () {
        Get.toNamed(Routes.coffeeSettings, arguments: {'bean': bean});
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
        color: AppColor.primaryNormal.withValues(alpha: 0.12),
        borderRadius: AppRadius.xxxlBorder,
        border: Border.all(
          color: AppColor.primaryNormal.withValues(alpha: 0.3),
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
