import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';

/// 푸시 알림 빨간 점 뱃지 — GNB / TopNavigation 우측 아이콘 위에 표시되는
/// 8×8 원형 인디케이터. 알림이 있을 때만 표시.
///
/// 외곽에 배경색 1.5px 보더로 아이콘과 겹쳐도 깔끔하게 분리됨.
class AppPushBadgeDot extends StatelessWidget {
  const AppPushBadgeDot({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: c.statusNegative,
        shape: BoxShape.circle,
        border: Border.all(
          color: c.backgroundNormalNormal,
          width: 1.5,
        ),
      ),
    );
  }
}
