import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';
import '../../foundation/app_radius.dart';
import '../ratio/app_ratio.dart';

/// Figma `Thumbnail` 컴포넌트.
///
/// Props (피그마 variant):
/// - `Border` (True / False) → [showBorder]
/// - `Radius` (True / False) → [showRadius]
///
/// 피그마 boundVariables:
/// - Border stroke: `line/normal/normal` (0x70737C @ 22%)
/// - cornerRadius (Radius=True): 12 → `AppRadius.radius12`
///
/// 이미지 비율은 [ratio]로 제어하며, 가로 크기는 부모가 결정합니다.
/// 고정 크기가 필요한 경우 [width]를 직접 지정할 수 있습니다.
class AppThumbnail extends StatelessWidget {
  /// 이미지 URL. null이면 fallback 아이콘 표시.
  final String? imageUrl;

  /// fallback 아이콘 (기본 Icons.image_outlined).
  final IconData? fallbackIcon;

  /// 비율 프리셋. 기본 1:1.
  final AppRatio ratio;

  /// Figma `Border` prop — 1px 내부 보더 표시 여부.
  final bool showBorder;

  /// Figma `Radius` prop — 12px 모서리 둥글림 여부.
  final bool showRadius;

  /// 가로 폭 고정값. null이면 부모 제약을 따름.
  final double? width;

  /// 탭 핸들러.
  final VoidCallback? onTap;

  const AppThumbnail({
    super.key,
    this.imageUrl,
    this.fallbackIcon,
    this.ratio = AppRatio.square,
    this.showBorder = false,
    this.showRadius = true,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final radius =
        showRadius ? AppRadius.radius12Border : BorderRadius.zero;

    // fallback 배경·전경
    final fallbackBg = c.componentFillNormal;
    final fallbackFg =
        c.labelAssistive;

    // 이미지 또는 fallback
    final image = imageUrl != null && imageUrl!.isNotEmpty
        ? Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                _fallback(fallbackBg, fallbackFg),
          )
        : _fallback(fallbackBg, fallbackFg);

    // 비율 컨테이너
    Widget body = AppRatioBox(
      ratio: ratio,
      borderRadius: radius,
      child: image,
    );

    // Border 오버레이 — Figma `line/normal/normal`
    if (showBorder) {
      final borderColor = c.lineNormalNormal;

      body = Stack(
        children: [
          body,
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: Border.all(color: borderColor, width: 1),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // 고정 폭
    if (width != null) {
      body = SizedBox(width: width, child: body);
    }

    // 탭
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: body,
        ),
      );
    }
    return body;
  }

  Widget _fallback(Color bg, Color fg) {
    return Container(
      color: bg,
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon ?? Icons.image_outlined,
        size: 24,
        color: fg,
      ),
    );
  }
}
