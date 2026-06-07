import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';
import 'package:coflanet/modules/coffee/bean/widgets/bean_detail_header.dart';
import 'package:coflanet/modules/coffee/bean/widgets/bean_flavor_chart_card.dart';
import 'package:coflanet/modules/coffee/bean/widgets/bean_info_section.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/navigation/app_bottom_bar.dart';
import 'package:coflanet/widgets/tags/flavor_tag.dart';
import 'package:coflanet/widgets/typography/section_title.dart';

/// Bean Detail View (원두 상세)
///
/// 헤더/향미 차트/원두 정보는 widgets/ 로 분리, 향미 태그는 공통
/// FlavorTag(primary) 재사용 (기존 _FlavorTagChip 과 픽셀 동일 — 토큰 6속성 일치).
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
                    BeanDetailHeader(bean: bean),
                    const SizedBox(height: 24),
                    BeanFlavorChartCard(bean: bean),
                    const SizedBox(height: 32),
                    _buildFlavorTags(bean),
                    const SizedBox(height: 32),
                    BeanInfoSection(bean: bean),
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
                // 수정된 원두를 반환해 목록 갱신
                Get.back(result: result);
              }
            },
          ),
        ],
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
        SectionTitle(
          title: title,
          titleStyle: AppTextStyles.headline2Bold.copyWith(
            color: AppColor.colorGlobalCommon100,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          // 공통 FlavorTag 기본 스타일(primary)이 기존 칩과 픽셀 동일
          children: tags.map((tag) => FlavorTag(label: tag)).toList(),
        ),
      ],
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
