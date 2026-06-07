import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/data/models/app_notification_model.dart';
import 'package:coflanet/modules/notification/notification_controller.dart';
import 'package:coflanet/widgets/feedback/app_empty_state.dart';
import 'package:coflanet/widgets/navigation/app_header.dart';

/// 알림 화면 — 알림 목록 / 빈 상태
class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  /// 공통 AppHeader 재사용 — 전체 삭제 버튼은 Obx 로 감싸 trailing 슬롯에 주입
  Widget _buildHeader() {
    return AppHeader(
      title: '알림',
      trailing: Obx(() {
        if (controller.isEmpty) return const SizedBox.shrink();
        return Semantics(
          label: '알림 전체 삭제',
          button: true,
          child: TextButton(
            onPressed: controller.clearAll,
            child: Text(
              '전체 삭제',
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isEmpty) {
        return const AppEmptyState(
          icon: Icons.notifications_none,
          title: '도착한 알림이 없어요',
          description: '새로운 소식이 오면 여기에서 알려드릴게요',
        );
      }
      final items = controller.notifications;
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: AppColor.lineSolidNormal),
        itemBuilder: (context, index) => _buildNotificationTile(items[index]),
      );
    });
  }

  Widget _buildNotificationTile(AppNotification item) {
    return Container(
      color: item.isRead
          ? AppColor.transparent
          : AppColor.primaryLight.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications,
              size: 20,
              color: AppColor.primaryNormal,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.body2NormalBold.copyWith(
                    color: AppColor.labelNormal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppUtil.changeDateToAgo(item.createdAt.toIso8601String()),
                  style: AppTextStyles.caption2Regular.copyWith(
                    color: AppColor.labelAssistive,
                  ),
                ),
              ],
            ),
          ),
          if (!item.isRead) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryNormal,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
