import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/data/models/brew_log_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';

class ExtractionListController extends BaseController {
  final BrewLogRepository _brewLogRepository =
      RepositoryProvider.brewLogRepository;

  // ─── Observable state ───
  final _brewLogs = <BrewLogModel>[].obs;
  List<BrewLogModel> get brewLogs => _brewLogs;

  final _stats = Rxn<Map<String, dynamic>>();
  Map<String, dynamic>? get stats => _stats.value;

  final _hasMore = true.obs;
  bool get hasMore => _hasMore.value;

  final _isLoadingMore = false.obs;
  bool get isLoadingMore => _isLoadingMore.value;

  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadBrewLogs();
    loadStats();
  }

  /// Load initial page of brew logs
  Future<void> loadBrewLogs() async {
    showLoading();
    try {
      final logs = await _brewLogRepository.getMyBrewLogs(
        limit: _pageSize,
        offset: 0,
      );
      _brewLogs.value = logs;
      _hasMore.value = logs.length >= _pageSize;
      hideLoading();
    } catch (e) {
      debugPrint('[ExtractionList] loadBrewLogs error: $e');
      hideLoading(); // Show empty state rather than error
    }
  }

  /// Load next page (pagination)
  Future<void> loadMore() async {
    if (_isLoadingMore.value || !_hasMore.value) return;
    _isLoadingMore.value = true;
    try {
      final logs = await _brewLogRepository.getMyBrewLogs(
        limit: _pageSize,
        offset: _brewLogs.length,
      );
      _brewLogs.addAll(logs);
      _hasMore.value = logs.length >= _pageSize;
    } catch (e) {
      debugPrint('[ExtractionList] loadMore error: $e');
    } finally {
      _isLoadingMore.value = false;
    }
  }

  /// Load brewing statistics
  Future<void> loadStats() async {
    try {
      _stats.value = await _brewLogRepository.getMyBrewStats();
    } catch (e) {
      debugPrint('[ExtractionList] loadStats error: $e');
    }
  }

  /// Delete a brew log entry
  Future<void> deleteLog(String logId) async {
    try {
      await _brewLogRepository.deleteBrewLog(logId);
      _brewLogs.removeWhere((log) => log.id == logId);
      loadStats(); // Refresh stats
    } catch (e) {
      debugPrint('[ExtractionList] deleteLog error: $e');
    }
  }

  /// Pull-to-refresh
  Future<void> refreshLogs() async {
    await Future.wait([loadBrewLogs(), loadStats()]);
  }
}
