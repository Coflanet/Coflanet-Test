import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/cart_item_model.dart';

/// 장바구니 전역 상태 서비스
///
/// 헤더 장바구니 아이콘의 수량 뱃지는 [distinctCount] 를 구독한다.
/// 기본값은 빈 목록. [add] 로 담으면 뱃지가 표시된다.
///
/// [백엔드 API 연동 대기] 서버 장바구니/주문 API 연동 시 메서드 본문 교체.
class CartService extends GetxService {
  static CartService get to => Get.find();

  final LocalStorage _storage = LocalStorage();
  static const String _storageKey = 'shopping_cart';

  final RxList<CartItem> _items = <CartItem>[].obs;
  List<CartItem> get items => _items;

  bool get isEmpty => _items.isEmpty;

  /// 담긴 상품 종류 수 — 헤더 뱃지 숫자
  int get distinctCount => _items.length;

  /// 총 수량 합
  int get totalQuantity => _items.fold(0, (sum, i) => sum + i.quantity);

  /// 총 금액 합
  int get totalPrice => _items.fold(0, (sum, i) => sum + i.lineTotal);

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    final raw = _storage.read<String>(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = json.decode(raw) as List<dynamic>;
      _items.assignAll(
        list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[CartService] load error: $e');
    }
  }

  Future<void> _persist() async {
    await _storage.write(
      _storageKey,
      json.encode(_items.map((e) => e.toJson()).toList()),
    );
  }

  bool contains(String beanId) => _items.any((i) => i.beanId == beanId);

  /// 담기 — 이미 있으면 수량 누적
  Future<void> add(CartItem item) async {
    final index = _items.indexWhere((i) => i.beanId == item.beanId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    _items.refresh();
    await _persist();
  }

  Future<void> remove(String beanId) async {
    _items.removeWhere((i) => i.beanId == beanId);
    await _persist();
  }

  /// 수량 설정 — 0 이하면 항목 제거
  Future<void> setQuantity(String beanId, int quantity) async {
    if (quantity <= 0) {
      await remove(beanId);
      return;
    }
    final index = _items.indexWhere((i) => i.beanId == beanId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      _items.refresh();
      await _persist();
    }
  }

  Future<void> clear() async {
    _items.clear();
    await _storage.remove(_storageKey);
  }
}
