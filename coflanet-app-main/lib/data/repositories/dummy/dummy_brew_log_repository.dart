import 'dart:convert';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/brew_log_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// Dummy implementation of BrewLogRepository
/// Uses local storage for persistence
class DummyBrewLogRepository implements BrewLogRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();
  static const String _storageKey = 'brew_logs';

  @override
  Future<Map<String, dynamic>> saveBrewLog(Map<String, dynamic> values) async {
    final logs = await _readAll();
    final id = const Uuid().v4();
    values['id'] = id;
    values['brewed_at'] ??= DateTime.now().toIso8601String();
    logs.insert(0, values);
    await _writeAll(logs);
    return {'id': id, 'status': 'ok'};
  }

  @override
  Future<List<BrewLogModel>> getMyBrewLogs({
    int limit = 20,
    int offset = 0,
  }) async {
    final logs = await _readAll();
    final end = (offset + limit).clamp(0, logs.length);
    if (offset >= logs.length) return [];
    return logs
        .sublist(offset, end)
        .map((r) => BrewLogModel.fromJson(r))
        .toList();
  }

  @override
  Future<void> updateBrewLog(String logId, Map<String, dynamic> values) async {
    final logs = await _readAll();
    final index = logs.indexWhere((l) => l['id'] == logId);
    if (index != -1) {
      logs[index] = {...logs[index], ...values};
      await _writeAll(logs);
    }
  }

  @override
  Future<void> deleteBrewLog(String logId) async {
    final logs = await _readAll();
    logs.removeWhere((l) => l['id'] == logId);
    await _writeAll(logs);
  }

  @override
  Future<Map<String, dynamic>?> getMyBrewStats() async {
    final logs = await _readAll();
    if (logs.isEmpty) return null;
    final beanIds = <String>{};
    final methodIds = <String>{};
    int totalRating = 0;
    int ratedCount = 0;
    for (final log in logs) {
      final beanId = log['bean_id'] as String?;
      if (beanId != null) beanIds.add(beanId);
      final methodId =
          log['brew_method_slug'] as String? ??
          log['brew_method_id'] as String?;
      if (methodId != null) methodIds.add(methodId);
      final rating = log['rating'] as int?;
      if (rating != null) {
        totalRating += rating;
        ratedCount++;
      }
    }
    return {
      'total_brews': logs.length,
      'unique_beans': beanIds.length,
      'unique_methods': methodIds.length,
      'avg_rating': ratedCount > 0 ? totalRating / ratedCount : null,
    };
  }

  Future<List<Map<String, dynamic>>> _readAll() async {
    final data = _storage.read<String>(_storageKey);
    if (data == null) return [];
    try {
      final list = json.decode(data) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> _writeAll(List<Map<String, dynamic>> logs) async {
    await _storage.write(_storageKey, json.encode(logs));
  }
}
