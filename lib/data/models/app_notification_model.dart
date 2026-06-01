/// 앱 내 알림 항목 모델
///
/// [백엔드 API 연동 대기] 현재는 로컬(NotificationService)에서만 관리.
/// 서버 알림 테이블/푸시 연동 시 동일 스키마로 매핑한다.
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  /// 읽음 여부 — 안 읽은 알림이 있으면 헤더에 dot 표시
  final bool isRead;

  /// 알림 종류 (예: system, promotion, recommendation) — 선택
  final String? type;

  /// 탭 시 이동할 라우트 — 선택 (딥링크)
  final String? linkRoute;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.type,
    this.linkRoute,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      type: type,
      linkRoute: linkRoute,
    );
  }

  /// DB(snake_case) / 로컬(camelCase) 양방향 fallback 파싱
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final created =
        json['created_at']?.toString() ?? json['createdAt']?.toString();
    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      body: (json['body'] ?? json['message']) as String? ?? '',
      createdAt: DateTime.tryParse(created ?? '') ?? DateTime.now(),
      isRead: (json['is_read'] ?? json['isRead'] ?? false) as bool,
      type: json['type'] as String?,
      linkRoute: (json['link_route'] ?? json['linkRoute']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'type': type,
      'link_route': linkRoute,
    };
  }
}
