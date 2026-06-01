import 'package:get/get.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/cart_service.dart';
import 'package:coflanet/data/models/cart_item_model.dart';

/// 장바구니 화면 컨트롤러
class CartController extends BaseController {
  final CartService _service = CartService.to;

  List<CartItem> get items => _service.items;
  bool get isEmpty => _service.isEmpty;
  int get totalPrice => _service.totalPrice;
  int get totalQuantity => _service.totalQuantity;

  Future<void> increase(String beanId) async {
    final item = _service.items.firstWhereOrNull((i) => i.beanId == beanId);
    if (item != null) {
      await _service.setQuantity(beanId, item.quantity + 1);
    }
  }

  Future<void> decrease(String beanId) async {
    final item = _service.items.firstWhereOrNull((i) => i.beanId == beanId);
    if (item != null) {
      await _service.setQuantity(beanId, item.quantity - 1);
    }
  }

  Future<void> removeItem(String beanId) async => _service.remove(beanId);

  Future<void> clearCart() async => _service.clear();

  /// 주문하기 — [백엔드 API 연동 대기] 결제/주문 API 연동 예정
  void checkout() {
    AppUtil.underConstructionPopup();
  }
}
