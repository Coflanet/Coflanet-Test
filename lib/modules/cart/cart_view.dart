import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/data/models/cart_item_model.dart';
import 'package:coflanet/modules/cart/cart_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/feedback/app_empty_state.dart';
import 'package:coflanet/widgets/navigation/app_header.dart';

/// 장바구니 화면 — 담은 상품 목록 / 빈 상태 + 합계 바
class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(colors),
            Expanded(child: _buildBody(colors)),
            _buildBottomBar(colors),
          ],
        ),
      ),
    );
  }

  /// 공통 AppHeader 재사용 — 비우기 버튼은 Obx 로 감싸 trailing 슬롯에 주입
  Widget _buildHeader(AppColorScheme colors) {
    return AppHeader(
      title: '장바구니',
      trailing: Obx(() {
        if (controller.isEmpty) return const SizedBox.shrink();
        return Semantics(
          label: '장바구니 비우기',
          button: true,
          child: TextButton(
            onPressed: controller.clearCart,
            child: Text(
              '비우기',
              style: AppTextStyles.caption1Medium.copyWith(
                color: colors.labelAlternative,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBody(AppColorScheme colors) {
    return Obx(() {
      if (controller.isEmpty) {
        return const AppEmptyState(
          icon: Icons.shopping_bag_outlined,
          title: '장바구니가 비어있어요',
          description: '마음에 드는 원두를 담아보세요',
        );
      }
      final items = controller.items;
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: colors.lineSolidNormal),
        itemBuilder: (context, index) => _buildCartTile(colors, items[index]),
      );
    });
  }

  Widget _buildCartTile(AppColorScheme colors, CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.surfaceCardStrong,
              borderRadius: BorderRadius.circular(8),
              image: item.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.imageUrl == null
                ? Icon(Icons.coffee, color: colors.primaryNormal, size: 28)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.brand != null && item.brand!.isNotEmpty) ...[
                  Text(
                    item.brand!,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: colors.labelAlternative,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  item.name,
                  style: AppTextStyles.body2NormalBold.copyWith(
                    color: colors.labelNormal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppUtil.changeNumberToWon(item.lineTotal),
                      style: AppTextStyles.body1NormalBold.copyWith(
                        color: colors.labelNormal,
                      ),
                    ),
                    _buildQuantityStepper(colors, item),
                  ],
                ),
              ],
            ),
          ),
          Semantics(
            label: '${item.name} 삭제',
            button: true,
            child: GestureDetector(
              onTap: () => controller.removeItem(item.beanId),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: colors.labelAssistive,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityStepper(AppColorScheme colors, CartItem item) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.lineNormalNormal),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _stepperButton(
            colors: colors,
            icon: Icons.remove,
            label: '수량 감소',
            onTap: () => controller.decrease(item.beanId),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: colors.labelNormal,
              ),
            ),
          ),
          _stepperButton(
            colors: colors,
            icon: Icons.add,
            label: '수량 증가',
            onTap: () => controller.increase(item.beanId),
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required AppColorScheme colors,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, size: 16, color: colors.labelNeutral),
        ),
      ),
    );
  }

  Widget _buildBottomBar(AppColorScheme colors) {
    return Obx(() {
      if (controller.isEmpty) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: colors.backgroundNormalNormal,
          border: Border(top: BorderSide(color: colors.lineSolidNormal)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 ${controller.totalQuantity}개',
                  style: AppTextStyles.body2NormalMedium.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
                Text(
                  AppUtil.changeNumberToWon(controller.totalPrice),
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: colors.labelNormal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(text: '주문하기', onPressed: controller.checkout),
          ],
        ),
      );
    });
  }
}
