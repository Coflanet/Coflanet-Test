import 'package:flutter/foundation.dart';
import 'package:coflanet/data/models/brew_log_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

/// Supabase implementation of BrewLogRepository
/// Uses RPC functions for all brew log operations.
class SupabaseBrewLogRepository implements BrewLogRepository {
  SupabaseClient get _db => Supabase.instance.client;

  /// Cached slug → UUID map for brew_methods
  Map<String, String>? _slugToIdCache;

  @override
  Future<Map<String, dynamic>> saveBrewLog(Map<String, dynamic> values) async {
    try {
      // Resolve brew_method_slug → brew_method_id if needed
      // RPC expects UUID brew_method_id, not string slug
      final slug = values.remove('brew_method_slug') as String?;
      if (slug != null && values['brew_method_id'] == null) {
        final methodId = await _resolveBrewMethodId(slug);
        if (methodId != null) {
          values['brew_method_id'] = methodId;
        }
      }

      final result = await _db.rpc(
        'save_brew_log',
        params: {'p_values': values},
      );
      debugPrint('[BrewLogRepo] save_brew_log result: $result');
      return result is Map<String, dynamic> ? result : <String, dynamic>{};
    } catch (e) {
      debugPrint('[BrewLogRepo] saveBrewLog error: $e');
      return {};
    }
  }

  @override
  Future<List<BrewLogModel>> getMyBrewLogs({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final result = await _db.rpc(
        'get_my_brew_logs',
        params: {'p_limit': limit, 'p_offset': offset},
      );
      debugPrint('[BrewLogRepo] get_my_brew_logs: $result');
      if (result == null) return [];

      // RPC returns { logs: [...], total_count, has_more }
      List rows;
      if (result is Map<String, dynamic>) {
        rows = result['logs'] as List? ?? [];
      } else if (result is List) {
        rows = result;
      } else {
        return [];
      }

      return rows
          .map((r) => BrewLogModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[BrewLogRepo] getMyBrewLogs error: $e');
      return [];
    }
  }

  @override
  Future<void> updateBrewLog(String logId, Map<String, dynamic> values) async {
    try {
      await _db.rpc(
        'update_brew_log',
        params: {'p_log_id': logId, 'p_values': values},
      );
    } catch (e) {
      debugPrint('[BrewLogRepo] updateBrewLog error: $e');
    }
  }

  @override
  Future<void> deleteBrewLog(String logId) async {
    try {
      await _db.rpc('delete_brew_log', params: {'p_log_id': logId});
    } catch (e) {
      debugPrint('[BrewLogRepo] deleteBrewLog error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getMyBrewStats() async {
    try {
      final result = await _db.rpc('get_my_brew_stats');
      debugPrint('[BrewLogRepo] get_my_brew_stats: $result');
      if (result is Map<String, dynamic>) return result;
      return null;
    } catch (e) {
      debugPrint('[BrewLogRepo] getMyBrewStats error: $e');
      return null;
    }
  }

  // ─── brew_methods slug → UUID lookup ───

  /// Resolve a coffeeType slug (e.g. 'handDrip') to brew_methods UUID.
  /// Tries exact match, then snake_case normalization.
  Future<String?> _resolveBrewMethodId(String slug) async {
    final map = await _getSlugMap();
    return map[slug] ?? map[_normalizeSlug(slug)];
  }

  Future<Map<String, String>> _getSlugMap() async {
    if (_slugToIdCache != null) return _slugToIdCache!;
    try {
      final rows = await _db.from('brew_methods').select('id, slug');
      final map = <String, String>{};
      for (final r in rows) {
        map[r['slug'] as String] = r['id'] as String;
      }
      _slugToIdCache = map;
      return map;
    } catch (e) {
      debugPrint('[BrewLogRepo] brew_methods query error: $e');
      return {};
    }
  }

  /// handDrip → hand_drip
  String _normalizeSlug(String coffeeType) {
    return coffeeType.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => '_${m.group(0)!.toLowerCase()}',
    );
  }
}
