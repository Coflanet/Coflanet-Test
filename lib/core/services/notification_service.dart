import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/app_notification_model.dart';

/// 알림 전역 상태 서비스
///
/// 헤더 종 아이콘의 dot 은 [hasUnread] 를 구독한다.
/// 기본값은 빈 목록 → dot 없음. [push] 로 알림이 도착하면 안 읽은 알림이 생겨
/// dot 이 표시되고, 알림 화면 진입 시 [markAllRead] 로 dot 이 사라진다.
///
/// [백엔드 API 연동 대기] 서버 알림/푸시 연동 시 [push] 를 수신 핸들러에 연결.
class NotificationService extends GetxService {
  static NotificationService get to => Get.find();

  final LocalStorage _storage = LocalStorage();
  static const String _storageKey = 'app_notifications';

  final RxList<AppNotification> _notifications = <AppNotification>[].obs;

  /// 최신순 정렬된 알림 목록
  List<AppNotification> get notifications =>
      _notifications.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  /// 안 읽은 알림 수
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// 안 읽은 알림 존재 여부 — 헤더 dot 표시 조건
  bool get hasUnread => unreadCount > 0;

  bool get isEmpty => _notifications.isEmpty;

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
      _notifications.assignAll(
        list.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[NotificationService] load error: $e');
    }
  }

  Future<void> _persist() async {
    await _storage.write(
      _storageKey,
      json.encode(_notifications.map((e) => e.toJson()).toList()),
    );
  }

  /// 새 알림 도착 — 호출 시 안 읽은 알림이 추가되어 헤더 dot 이 표시된다.
  Future<void> push({
    required String title,
    required String body,
    String? type,
    String? linkRoute,
  }) async {
    _notifications.add(
      AppNotification(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        body: body,
        createdAt: DateTime.now(),
        type: type,
        linkRoute: linkRoute,
      ),
    );
    await _persist();
  }

  /// 모두 읽음 처리 — 알림 화면 진입 시 호출 → dot 제거
  Future<void> markAllRead() async {
    if (unreadCount == 0) return;
    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _notifications.refresh();
    await _persist();
  }

  /// 전체 삭제
  Future<void> clear() async {
    _notifications.clear();
    await _storage.remove(_storageKey);
  }
}
