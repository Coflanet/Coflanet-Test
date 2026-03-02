import 'dart:convert';
import 'dart:ui' show Color;
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/dummy/dummy_coffee_data.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/widgets/charts/flavor_radar_chart.dart'
    show FlavorProfile;
import 'package:get/get.dart';

/// Dummy implementation of CoffeeRepository
/// Uses local storage for persistence and dummy data for initial load
class DummyCoffeeRepository implements CoffeeRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();

  static const String _storageKey = 'coffee_items';
  static const String _orderKey = 'coffee_items_order';
  static const String _hiddenKey = 'coffee_items_hidden';

  /// In-memory cache of coffee items
  List<CoffeeItem>? _cachedItems;

  @override
  Future<List<CoffeeItem>> getCoffeeItems() async {
    if (_cachedItems != null) {
      return _cachedItems!;
    }

    // Try to load from storage first
    final storedData = _storage.read<String>(_storageKey);
    if (storedData != null) {
      try {
        final List<dynamic> jsonList = json.decode(storedData);
        _cachedItems = jsonList.map((e) => _coffeeItemFromJson(e)).toList();
        return _cachedItems!;
      } catch (_) {
        // Fall through to dummy data
      }
    }

    // Load dummy data and apply any saved order/hidden state
    final items = DummyCoffeeData.coffeeItems.toList();

    // Apply saved hidden states
    final hiddenIds =
        _storage.read<List<dynamic>>(_hiddenKey)?.cast<String>() ?? [];
    for (int i = 0; i < items.length; i++) {
      if (hiddenIds.contains(items[i].id)) {
        items[i] = items[i].copyWith(isHidden: true);
      }
    }

    // Apply saved order
    final savedOrder = _storage.read<List<dynamic>>(_orderKey)?.cast<String>();
    if (savedOrder != null && savedOrder.isNotEmpty) {
      items.sort((a, b) {
        final aIndex = savedOrder.indexOf(a.id);
        final bIndex = savedOrder.indexOf(b.id);
        if (aIndex == -1 && bIndex == -1) return 0;
        if (aIndex == -1) return 1;
        if (bIndex == -1) return -1;
        return aIndex.compareTo(bIndex);
      });
    }

    _cachedItems = items;
    return items;
  }

  @override
  Future<CoffeeItem?> getCoffeeItemById(String id) async {
    final items = await getCoffeeItems();
    return items.firstWhereOrNull((item) => item.id == id);
  }

  @override
  Future<void> addCoffeeItem(CoffeeItem item) async {
    final items = await getCoffeeItems();
    items.add(item);
    _cachedItems = items;
    await _persistItems(items);
  }

  @override
  Future<void> updateCoffeeItem(CoffeeItem item) async {
    final items = await getCoffeeItems();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      _cachedItems = items;
      await _persistItems(items);
    }
  }

  @override
  Future<void> deleteCoffeeItem(String id) async {
    final items = await getCoffeeItems();
    items.removeWhere((item) => item.id == id);
    _cachedItems = items;
    await _persistItems(items);
  }

  @override
  Future<void> updateCoffeeVisibility(String id, bool isHidden) async {
    final items = await getCoffeeItems();
    final index = items.indexWhere((i) => i.id == id);
    if (index != -1) {
      items[index] = items[index].copyWith(isHidden: isHidden);
      _cachedItems = items;

      // Persist hidden state separately for quick access
      final hiddenIds = items
          .where((i) => i.isHidden)
          .map((i) => i.id)
          .toList();
      await _storage.write(_hiddenKey, hiddenIds);
    }
  }

  @override
  Future<void> reorderCoffeeItems(List<String> orderedIds) async {
    await _storage.write(_orderKey, orderedIds);

    // Update cache order
    if (_cachedItems != null) {
      _cachedItems!.sort((a, b) {
        final aIndex = orderedIds.indexOf(a.id);
        final bIndex = orderedIds.indexOf(b.id);
        if (aIndex == -1 && bIndex == -1) return 0;
        if (aIndex == -1) return 1;
        if (bIndex == -1) return -1;
        return aIndex.compareTo(bIndex);
      });
    }
  }

  @override
  Future<void> saveCoffeeItems(List<CoffeeItem> items) async {
    _cachedItems = items;
    await _persistItems(items);
  }

  @override
  Future<Map<String, dynamic>> addToCoffeeList(
    String beanId, {
    String addedFrom = 'manual',
  }) async {
    return {'status': 'ok'};
  }

  @override
  Future<Map<String, dynamic>> getCoffeeCatalog({
    Map<String, dynamic>? filters,
  }) async {
    return {'beans': [], 'total': 0};
  }

  Future<void> _persistItems(List<CoffeeItem> items) async {
    final jsonList = items.map((i) => _coffeeItemToJson(i)).toList();
    await _storage.write(_storageKey, json.encode(jsonList));
  }

  /// Convert CoffeeItem to JSON (for storage)
  Map<String, dynamic> _coffeeItemToJson(CoffeeItem item) {
    return {
      'id': item.id,
      'name': item.name,
      'description': item.description,
      'color': item.color.value,
      'imageUrl': item.imageUrl,
      'brand': item.brand,
      'flavorProfile': item.flavorProfile != null
          ? {
              'acidity': item.flavorProfile!.acidity,
              'body': item.flavorProfile!.body,
              'sweetness': item.flavorProfile!.sweetness,
              'bitterness': item.flavorProfile!.bitterness,
              'balance': item.flavorProfile!.balance,
            }
          : null,
      'commonFlavors': item.commonFlavors,
      'characteristicFlavors': item.characteristicFlavors,
      'aromaIntensity': item.aromaIntensity,
      'origin': item.origin,
      'roastLevel': item.roastLevel,
      'processMethod': item.processMethod,
      'isHidden': item.isHidden,
      'sortOrder': item.sortOrder,
    };
  }

  /// Convert JSON to CoffeeItem (from storage)
  CoffeeItem _coffeeItemFromJson(Map<String, dynamic> json) {
    return CoffeeItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      color: Color(json['color'] as int),
      imageUrl: json['imageUrl'] as String?,
      brand: json['brand'] as String?,
      flavorProfile: json['flavorProfile'] != null
          ? FlavorProfile(
              acidity: (json['flavorProfile']['acidity'] as num).toDouble(),
              body: (json['flavorProfile']['body'] as num).toDouble(),
              sweetness: (json['flavorProfile']['sweetness'] as num).toDouble(),
              bitterness: (json['flavorProfile']['bitterness'] as num)
                  .toDouble(),
              balance: (json['flavorProfile']['balance'] as num).toDouble(),
            )
          : null,
      commonFlavors: (json['commonFlavors'] as List<dynamic>?)?.cast<String>(),
      characteristicFlavors: (json['characteristicFlavors'] as List<dynamic>?)
          ?.cast<String>(),
      aromaIntensity: (json['aromaIntensity'] as num?)?.toDouble(),
      origin: json['origin'] as String?,
      roastLevel: json['roastLevel'] as String?,
      processMethod: json['processMethod'] as String?,
      isHidden: json['isHidden'] as bool? ?? false,
      sortOrder: json['sortOrder'] as int?,
    );
  }
}
