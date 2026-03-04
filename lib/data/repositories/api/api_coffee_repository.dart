import 'dart:ui' show Color;
import 'package:coflanet/core/api/api_client.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/widgets/charts/flavor_radar_chart.dart'
    show FlavorProfile;
import 'package:get/get.dart';

/// API implementation of CoffeeRepository
/// Connects to backend API for coffee bean data
class ApiCoffeeRepository implements CoffeeRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // API endpoints
  static const String _baseEndpoint = '/coffees';

  @override
  Future<List<CoffeeItem>> getCoffeeItems() async {
    try {
      final response = await _apiClient.get(_baseEndpoint);
      final List<dynamic> data = response.data['coffees'];
      return data.map((e) => _coffeeItemFromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CoffeeItem?> getCoffeeItemById(String id) async {
    try {
      final response = await _apiClient.get('$_baseEndpoint/$id');
      if (response.data != null && response.data['coffee'] != null) {
        return _coffeeItemFromJson(response.data['coffee']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addCoffeeItem(CoffeeItem item) async {
    try {
      await _apiClient.post(_baseEndpoint, data: _coffeeItemToJson(item));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCoffeeItem(CoffeeItem item) async {
    try {
      await _apiClient.put(
        '$_baseEndpoint/${item.id}',
        data: _coffeeItemToJson(item),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCoffeeItem(String id) async {
    try {
      await _apiClient.delete('$_baseEndpoint/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCoffeeVisibility(String id, bool isHidden) async {
    try {
      await _apiClient.patch(
        '$_baseEndpoint/$id/visibility',
        data: {'is_hidden': isHidden},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> reorderCoffeeItems(List<String> orderedIds) async {
    try {
      await _apiClient.post(
        '$_baseEndpoint/reorder',
        data: {'ordered_ids': orderedIds},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveCoffeeItems(List<CoffeeItem> items) async {
    try {
      final jsonList = items.map((i) => _coffeeItemToJson(i)).toList();
      await _apiClient.post(
        '$_baseEndpoint/batch',
        data: {'coffees': jsonList},
      );
    } catch (e) {
      rethrow;
    }
  }

  // ─── JSON Conversion Helpers ───

  Map<String, dynamic> _coffeeItemToJson(CoffeeItem item) {
    return {
      'id': item.id,
      'name': item.name,
      'description': item.description,
      'color': item.color.value,
      'image_url': item.imageUrl,
      'brand': item.brand,
      'flavor_profile': item.flavorProfile != null
          ? {
              'acidity': item.flavorProfile!.acidity,
              'body': item.flavorProfile!.body,
              'sweetness': item.flavorProfile!.sweetness,
              'bitterness': item.flavorProfile!.bitterness,
              'balance': item.flavorProfile!.balance,
            }
          : null,
      'common_flavors': item.commonFlavors,
      'characteristic_flavors': item.characteristicFlavors,
      'aroma_intensity': item.aromaIntensity,
      'origin': item.origin,
      'roast_level': item.roastLevel,
      'process_method': item.processMethod,
      'is_hidden': item.isHidden,
      'sort_order': item.sortOrder,
    };
  }

  @override
  Future<Map<String, dynamic>> addToCoffeeList(
    String beanId, {
    String addedFrom = 'manual',
  }) async {
    throw UnimplementedError('API addToCoffeeList not implemented');
  }

  @override
  Future<Map<String, dynamic>> getCoffeeCatalog({
    Map<String, dynamic>? filters,
  }) async {
    throw UnimplementedError('API getCoffeeCatalog not implemented');
  }

  CoffeeItem _coffeeItemFromJson(Map<String, dynamic> json) {
    return CoffeeItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      color: Color(json['color'] as int),
      imageUrl: json['image_url'] as String?,
      brand: json['brand'] as String?,
      flavorProfile: json['flavor_profile'] != null
          ? FlavorProfile(
              acidity: (json['flavor_profile']['acidity'] as num).toDouble(),
              body: (json['flavor_profile']['body'] as num).toDouble(),
              sweetness: (json['flavor_profile']['sweetness'] as num)
                  .toDouble(),
              bitterness: (json['flavor_profile']['bitterness'] as num)
                  .toDouble(),
              balance: (json['flavor_profile']['balance'] as num).toDouble(),
            )
          : null,
      commonFlavors: (json['common_flavors'] as List<dynamic>?)?.cast<String>(),
      characteristicFlavors: (json['characteristic_flavors'] as List<dynamic>?)
          ?.cast<String>(),
      aromaIntensity: (json['aroma_intensity'] as num?)?.toDouble(),
      origin: json['origin'] as String?,
      roastLevel: json['roast_level'] as String?,
      processMethod: json['process_method'] as String?,
      isHidden: json['is_hidden'] as bool? ?? false,
      sortOrder: json['sort_order'] as int?,
    );
  }
}
