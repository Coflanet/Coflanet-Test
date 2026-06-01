import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/notification_service.dart';
import 'package:coflanet/data/models/app_notification_model.dart';

/// 알림 화면 컨트롤러
///
/// 화면 진입 시 모두 읽음 처리하여 헤더 dot 을 제거한다.
class NotificationController extends BaseController {
  final NotificationService _service = NotificationService.to;

  List<AppNotification> get notifications => _service.notifications;
  bool get isEmpty => _service.isEmpty;

  @override
  void onReady() {
    super.onReady();
    // 사용자가 알림 화면을 열었으므로 모두 읽음 처리 → dot 사라짐
    _service.markAllRead();
  }

  Future<void> clearAll() async => _service.clear();
}
