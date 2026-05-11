import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Banner 레이아웃 — Figma `banner` 5 variants.
///
/// Figma는 column(1/2) × ratio(3:2 / 16:9 / 9:21 / 1:1) 매트릭스로 변형을
/// 정의. 코드에서는 각 변형을 시맨틱 이름으로 노출.
enum AppBannerLayout {
  /// 큰 배경 이미지 위에 텍스트 오버레이 — 정사각 히어로 (Figma 1col 3:2 근접).
  hero,

  /// 좌측 텍스트 + 우측 작은 썸네일 — 리스트 카드용.
  compact,

  /// 와이드 히어로 (Figma `1col Ratio=16:9`).
  wide,

  /// 세로형 스토리 (Figma `1col Ratio=9:21`).
  vertical,

  /// 2열 그리드의 정사각 카드 (Figma `2col Ratio=1:1`).
  square,
}

/// Banner — Figma `Contents/Card/Banner`.
///
/// 큰 배경 이미지 / 그라디언트 위에 타이틀 텍스트가 얹어진 콘텐츠 배너.
/// hero 레이아웃은 정사각/와이드 비율, compact 은 가로 카드 형식.
class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
    required this.title,
    this.body,
    this.layout = AppBannerLayout.hero,
    this.aspectRatio = 1,
    this.background,
    this.thumbnail,
    this.onTap,
  });

  /// 큰 굵은 타이틀 — 최대 2줄 권장.
  final String title;

  /// compact 레이아웃에서 타이틀 아래 본문.
  final String? body;

  final AppBannerLayout layout;

  /// hero 레이아웃의 비율 (1=square, 16/9=wide).
  final double aspectRatio;

  /// 배경 위젯. null 이면 회색 placeholder. (외부 URL 의존 0 — 호출자가 위젯 주입.)
  final Widget? background;

  /// compact 레이아웃 우측 작은 썸네일.
  final Widget? thumbnail;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: switch (layout) {
        AppBannerLayout.hero => _buildHero(context, ratioOverride: null),
        AppBannerLayout.compact => _buildCompact(context),
        AppBannerLayout.wide =>
          _buildHero(context, ratioOverride: 16 / 9),
        AppBannerLayout.vertical =>
          _buildHero(context, ratioOverride: 9 / 21),
        AppBannerLayout.square =>
          _buildHero(context, ratioOverride: 1),
      },
    );
  }

  Widget _buildHero(BuildContext context, {double? ratioOverride}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radius12),
      child: AspectRatio(
        aspectRatio: ratioOverride ?? aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            background ??
                Container(
                  color: AppColor.lineSolidNormal,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_outlined,
                    size: 32,
                    color: AppColor.labelAlternative,
                  ),
                ),
            Positioned(
              left: AppSpacing.space16,
              right: AppSpacing.space16,
              top: AppSpacing.space16,
              child: Text(
                title,
                style: AppTextStyles.body1NormalBold.copyWith(
                  color: AppColor.staticLabelBlackNormal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
      ),
      padding: const EdgeInsets.all(AppSpacing.space12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.label1NormalBold.copyWith(
                    color: AppColor.labelNormal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (body != null) ...[
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    body!,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.radius8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: thumbnail ??
                  Container(
                    color: AppColor.lineSolidNormal,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_outlined,
                      size: 18,
                      color: AppColor.labelAlternative,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
