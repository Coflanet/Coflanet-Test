import 'dart:ui' show Color;
import 'package:flutter/foundation.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/widgets/charts/flavor_radar_chart.dart'
    show FlavorProfile;
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

/// Supabase implementation of CoffeeRepository
/// Uses RPC functions for list operations, direct queries for individual items.
class SupabaseCoffeeRepository implements CoffeeRepository {
  SupabaseClient get _db => Supabase.instance.client;

  @override
  Future<List<CoffeeItem>> getCoffeeItems() async {
    try {
      final result = await _db.rpc('get_my_bean_list');
      debugPrint('[CoffeeRepo] get_my_bean_list: $result');

      if (result == null) return [];

      final rows = result is List ? result : [];
      return rows
          .map((r) => _coffeeItemFromRow(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[CoffeeRepo] getCoffeeItems error: $e');
      return [];
    }
  }

  @override
  Future<CoffeeItem?> getCoffeeItemById(String id) async {
    final items = await getCoffeeItems();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addCoffeeItem(CoffeeItem item) async {
    try {
      final values = _buildBeanData(item);
      final result = await _db.rpc(
        'add_custom_bean',
        params: {'p_values': values},
      );
      debugPrint('[CoffeeRepo] add_custom_bean result: $result');
    } catch (e) {
      debugPrint('[CoffeeRepo] addCoffeeItem error: $e');
    }
  }

  @override
  Future<void> updateCoffeeItem(CoffeeItem item) async {
    try {
      final values = _buildBeanData(item);
      final result = await _db.rpc(
        'update_custom_bean',
        params: {'p_bean_id': item.id, 'p_values': values},
      );
      debugPrint('[CoffeeRepo] update_custom_bean result: $result');
    } catch (e) {
      debugPrint('[CoffeeRepo] updateCoffeeItem error: $e');
    }
  }

  @override
  Future<void> deleteCoffeeItem(String id) async {
    try {
      await _db.rpc('remove_from_coffee_list', params: {'p_bean_id': id});
    } catch (e) {
      debugPrint('[CoffeeRepo] deleteCoffeeItem error: $e');
    }
  }

  @override
  Future<void> updateCoffeeVisibility(String id, bool isHidden) async {
    // user_bean_lists table does not have is_hidden column
    // Visibility is handled locally only
    debugPrint(
      '[CoffeeRepo] updateCoffeeVisibility: no server column, local only',
    );
  }

  @override
  Future<void> reorderCoffeeItems(List<String> orderedIds) async {
    try {
      await _db.rpc('reorder_coffee_list', params: {'p_bean_ids': orderedIds});
    } catch (e) {
      debugPrint('[CoffeeRepo] reorderCoffeeItems error: $e');
    }
  }

  @override
  Future<void> saveCoffeeItems(List<CoffeeItem> items) async {
    // No-op: individual CRUD operations are used instead
  }

  // ─── Helpers ───

  /// Build column data for coffee_beans table insert/update.
  /// Only includes non-null values to avoid schema mismatch errors.
  ///
  /// coffee_beans table known columns:
  /// id, name, description, origin, roast_level, process_method,
  /// flavor_tags, image_url, created_at
  /// NOTE: brand, created_by, user_id columns do NOT exist.
  /// Build jsonb payload for add_custom_bean / update_custom_bean RPCs.
  /// Column names must match actual coffee_beans schema.
  Map<String, dynamic> _buildBeanData(CoffeeItem item) {
    final data = <String, dynamic>{'name': item.name};
    if (item.description.isNotEmpty) data['description'] = item.description;
    if (item.origin != null) data['origin'] = [item.origin]; // TEXT[] column
    if (item.roastLevel != null) data['roast_level'] = item.roastLevel;
    if (item.processMethod != null) data['processing'] = item.processMethod;
    // flavor_tags → bean_flavor_tags 별도 테이블이므로 여기서 보내지 않음
    return data;
  }

  // ─── Row conversion ───

  CoffeeItem _coffeeItemFromRow(Map<String, dynamic> row) {
    // get_my_bean_list returns nested structure:
    //   { id: <list_entry_id>, bean: { id: <bean_id>, name: ..., ... }, sort_order: 0 }
    // Flatten: merge bean fields into top-level, preserving sort_order from outer row
    final bean = row['bean'] as Map<String, dynamic>?;
    final data = bean != null
        ? {...bean, 'sort_order': row['sort_order']}
        : row;

    // Build flavor profile from individual fields (Supabase coffee_beans uses flat columns)
    FlavorProfile? flavorProfile;
    final hasFlavorFields = data['acidity'] != null || data['body'] != null;
    if (hasFlavorFields) {
      flavorProfile = FlavorProfile(
        acidity: _toDouble(data['acidity']),
        body: _toDouble(data['body']),
        sweetness: _toDouble(data['sweetness']),
        bitterness: _toDouble(data['bitterness']),
        balance: _toDouble(data['balance']),
      );
    } else {
      // Fallback: check nested flavor_profile / taste_profile maps
      final fp =
          data['flavor_profile'] as Map<String, dynamic>? ??
          data['taste_profile'] as Map<String, dynamic>?;
      if (fp != null) {
        flavorProfile = FlavorProfile(
          acidity: _toDouble(fp['acidity']),
          body: _toDouble(fp['body']),
          sweetness: _toDouble(fp['sweetness']),
          bitterness: _toDouble(fp['bitterness']),
          balance: _toDouble(fp['balance']),
        );
      }
    }

    // color may not exist on server — default to a neutral color
    final colorValue = data['color'] as int?;
    final color = colorValue != null
        ? Color(colorValue)
        : const Color(0xFF8B6F47);

    // Handle origin — may be a string or List<String> from server
    String? origin;
    final rawOrigin = data['origin'];
    if (rawOrigin is String) {
      origin = rawOrigin;
    } else if (rawOrigin is List) {
      origin = rawOrigin.join(', ');
    }

    return CoffeeItem(
      id: (data['id'] ?? row['bean_id'] ?? '').toString(),
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      color: color,
      imageUrl: data['image_url'] as String? ?? data['imageUrl'] as String?,
      brand: data['brand'] as String? ?? data['manufacturer'] as String?,
      flavorProfile: flavorProfile,
      commonFlavors: _toStringList(
        data['common_flavors'] ?? data['flavor_tags'],
      ),
      characteristicFlavors: _toStringList(data['characteristic_flavors']),
      aromaIntensity: _toDoubleNullable(
        data['aroma_intensity'] ?? data['aroma'],
      ),
      origin: origin,
      roastLevel:
          data['roast_level'] as String? ?? data['roastLevel'] as String?,
      processMethod:
          data['processing'] as String? ?? data['process_method'] as String?,
      isHidden: data['is_hidden'] as bool? ?? false,
      sortOrder: data['sort_order'] as int?,
    );
  }

  double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  double? _toDoubleNullable(dynamic value) {
    if (value == null) return null;
    return _toDouble(value);
  }

  List<String>? _toStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) return value.map((e) => e.toString()).toList();
    return null;
  }

  @override
  Future<Map<String, dynamic>> addToCoffeeList(
    String beanId, {
    // Server CHECK: 'recommendation', 'search', 'manual'
    String addedFrom = 'manual',
  }) async {
    try {
      final result = await _db.rpc(
        'add_to_coffee_list',
        params: {'p_bean_id': beanId, 'p_added_from': addedFrom},
      );
      debugPrint('[CoffeeRepo] add_to_coffee_list result: $result');
      return result is Map<String, dynamic> ? result : <String, dynamic>{};
    } catch (e) {
      debugPrint('[CoffeeRepo] addToCoffeeList error: $e');
      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> getCoffeeCatalog({
    Map<String, dynamic>? filters,
  }) async {
    try {
      final result = await _db.rpc(
        'get_coffee_catalog',
        params: filters != null ? {'p_filters': filters} : {},
      );
      debugPrint('[CoffeeRepo] get_coffee_catalog result: $result');
      return result is Map<String, dynamic> ? result : <String, dynamic>{};
    } catch (e) {
      debugPrint('[CoffeeRepo] getCoffeeCatalog error: $e');
      return {};
    }
  }
}
