import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';

/// 디자인 시스템 Divider — Figma `Basic/Divider` 컴포넌트.
///
/// 피그마 variant:
/// - `Tick`    : off (1px 가는 선) / on (10px 두꺼운 구분 영역)
/// - `Vertical`: False (가로) / True (세로, Tick=off만)
///
/// 피그마 boundVariables:
/// - Tick=off : fill `line/normal/normal`       (0x70737C @ 22%)
/// - Tick=on  : fill `line/normal/alternative`   (0x70737C @ 8%)
/// - Vertical : fill `line/normal/normal`        (0x70737C @ 22%), width 1
class AppDivider extends StatelessWidget {
  /// Tick on = 두꺼운 구분 영역(10px). Tick off = 가는 선(1px).
  final bool tick;

  /// 세로 방향 — Tick=off 일 때만 유효. Tick=on에선 항상 가로.
  final bool vertical;

  /// 가로 패딩 (좌측 여백).
  final double indent;

  /// 가로 패딩 (우측 여백).
  final double endIndent;

  const AppDivider({
    super.key,
    this.tick = false,
    this.vertical = false,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    // Tick=on: line/normal/alternative (8% opacity)
    // Tick=off: line/normal/normal (22% opacity)
    final color = tick
        ? (c.lineNormalAlternative)
        : (c.lineNormalNormal);

    // 세로 Divider
    if (vertical && !tick) {
      return Padding(
        padding: EdgeInsets.only(top: indent, bottom: endIndent),
        child: Container(width: 1, color: color),
      );
    }

    // 가로 Divider
    final height = tick ? 10.0 : 1.0;
    return Padding(
      padding: EdgeInsets.only(left: indent, right: endIndent),
      child: Container(height: height, color: color),
    );
  }
}
