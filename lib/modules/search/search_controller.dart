import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/cart_service.dart';
import 'package:coflanet/data/models/cart_item_model.dart';
import 'package:coflanet/data/models/catalog_bean_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';

/// 원두 검색 컨트롤러
///
/// `get_coffee_catalog` RPC 의 `search` 필터로 서버 검색(name ILIKE)을 수행한다.
class SearchController extends BaseController {
  final CoffeeRepository _coffeeRepository =
      RepositoryProvider.coffeeRepository;

  final _query = ''.obs;
  String get query => _query.value;

  final _results = <CatalogBean>[].obs;
  List<CatalogBean> get results => _results;

  final _isSearching = false.obs;
  bool get isSearching => _isSearching.value;

  /// 한 번이라도 검색을 수행했는지 — 초기 안내 vs 결과 없음 구분
  final _hasSearched = false.obs;
  bool get hasSearched => _hasSearched.value;

  @override
  void onInit() {
    super.onInit();
    // 입력 디바운스 — 마지막 입력 후 350ms 뒤 검색
    debounce<String>(
      _query,
      (_) => _runSearch(),
      time: const Duration(milliseconds: 350),
    );
  }

  /// 검색어 변경 (TextField onChanged)
  void onQueryChanged(String value) {
    _query.value = value;
    if (value.trim().isEmpty) {
      _results.clear();
      _hasSearched.value = false;
    }
  }

  Future<void> _runSearch() async {
    final q = _query.value.trim();
    if (q.isEmpty) return;
    _isSearching.value = true;
    _hasSearched.value = true;
    try {
      final res = await _coffeeRepository.getCoffeeCatalog(
        filters: {'search': q, 'limit': 50},
      );
      final beans = (res['beans'] as List?) ?? const [];
      _results.assignAll(
        beans.map((e) => CatalogBean.fromJson(e as Map<String, dynamic>)),
      );
    } catch (e) {
      debugPrint('[SearchController] search error: $e');
      _results.clear();
    } finally {
      _isSearching.value = false;
    }
  }

  /// 검색 결과 원두를 장바구니에 담기
  Future<void> addToCart(CatalogBean bean) async {
    await CartService.to.add(
      CartItem(
        beanId: bean.id,
        name: bean.name,
        imageUrl: bean.imageUrl,
        brand: bean.originLabel.isNotEmpty ? bean.originLabel : null,
        price: bean.displayPrice ?? 0,
      ),
    );
    Get.snackbar(
      '장바구니',
      '${bean.name}을(를) 담았어요',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.primaryNormal,
      colorText: AppColor.staticLabelWhiteStrong,
      duration: const Duration(seconds: 2),
    );
  }
}
