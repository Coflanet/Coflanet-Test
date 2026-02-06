import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 일반적인 비율 프리셋
enum AspectRatioPreset {
  /// 1:1 정사각형
  square,

  /// 4:3 표준
  standard,

  /// 3:2 DSLR
  dslr,

  /// 16:9 와이드스크린
  widescreen,

  /// 21:9 울트라와이드
  ultrawide,

  /// 9:16 세로 영상
  vertical,

  /// 3:4 세로 표준
  verticalStandard,

  /// 2:3 세로 DSLR
  verticalDslr,
}

/// 비율 컨테이너
///
/// Figma: 📏 Ratio 페이지
///
/// 이미지나 비디오의 비율을 유지하는 컨테이너
///
/// Usage:
/// ```dart
/// // 프리셋 사용
/// AppAspectRatio(
///   preset: AspectRatioPreset.widescreen,
///   child: Image.network(...),
/// )
///
/// // 커스텀 비율
/// AppAspectRatio.custom(
///   aspectRatio: 2.35, // 시네마스코프
///   child: VideoPlayer(...),
/// )
///
/// // 플레이스홀더 포함
/// AppAspectRatio(
///   preset: AspectRatioPreset.square,
///   placeholder: Icon(Icons.image),
///   child: isLoading ? null : Image.network(...),
/// )
/// ```
class AppAspectRatio extends StatelessWidget {
  /// 비율 프리셋
  final AspectRatioPreset? preset;

  /// 커스텀 비율 (width / height)
  final double? aspectRatio;

  /// 자식 위젯
  final Widget? child;

  /// 플레이스홀더 위젯
  final Widget? placeholder;

  /// 배경색
  final Color? backgroundColor;

  /// 테두리 반경
  final BorderRadius? borderRadius;

  /// 테두리
  final BoxBorder? border;

  /// 클리핑 여부
  final bool clip;

  const AppAspectRatio({
    super.key,
    this.preset = AspectRatioPreset.square,
    this.child,
    this.placeholder,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.clip = true,
  }) : aspectRatio = null;

  const AppAspectRatio.custom({
    super.key,
    required this.aspectRatio,
    this.child,
    this.placeholder,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.clip = true,
  }) : preset = null;

  double get _aspectRatio {
    if (aspectRatio != null) return aspectRatio!;

    switch (preset!) {
      case AspectRatioPreset.square:
        return 1.0;
      case AspectRatioPreset.standard:
        return 4 / 3;
      case AspectRatioPreset.dslr:
        return 3 / 2;
      case AspectRatioPreset.widescreen:
        return 16 / 9;
      case AspectRatioPreset.ultrawide:
        return 21 / 9;
      case AspectRatioPreset.vertical:
        return 9 / 16;
      case AspectRatioPreset.verticalStandard:
        return 3 / 4;
      case AspectRatioPreset.verticalDslr:
        return 2 / 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = AspectRatio(
      aspectRatio: _aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColor.componentFillNormal,
          borderRadius: borderRadius,
          border: border,
        ),
        child: child ?? placeholder ?? _buildDefaultPlaceholder(),
      ),
    );

    if (clip && borderRadius != null) {
      content = ClipRRect(borderRadius: borderRadius!, child: content);
    }

    return content;
  }

  Widget _buildDefaultPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 32,
        color: AppColor.labelAssistive,
      ),
    );
  }
}

/// 이미지 비율 컨테이너 (네트워크 이미지용)
///
/// Usage:
/// ```dart
/// AppAspectRatioImage(
///   imageUrl: 'https://example.com/image.jpg',
///   preset: AspectRatioPreset.widescreen,
/// )
/// ```
class AppAspectRatioImage extends StatelessWidget {
  /// 이미지 URL
  final String? imageUrl;

  /// 로컬 에셋 경로
  final String? assetPath;

  /// 비율 프리셋
  final AspectRatioPreset preset;

  /// 커스텀 비율
  final double? aspectRatio;

  /// 테두리 반경
  final BorderRadius? borderRadius;

  /// 이미지 핏
  final BoxFit fit;

  /// 로딩 위젯
  final Widget? loadingWidget;

  /// 에러 위젯
  final Widget? errorWidget;

  const AppAspectRatioImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.preset = AspectRatioPreset.square,
    this.aspectRatio,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.loadingWidget,
    this.errorWidget,
  }) : assert(imageUrl != null || assetPath != null);

  double get _aspectRatio {
    if (aspectRatio != null) return aspectRatio!;

    switch (preset) {
      case AspectRatioPreset.square:
        return 1.0;
      case AspectRatioPreset.standard:
        return 4 / 3;
      case AspectRatioPreset.dslr:
        return 3 / 2;
      case AspectRatioPreset.widescreen:
        return 16 / 9;
      case AspectRatioPreset.ultrawide:
        return 21 / 9;
      case AspectRatioPreset.vertical:
        return 9 / 16;
      case AspectRatioPreset.verticalStandard:
        return 3 / 4;
      case AspectRatioPreset.verticalDslr:
        return 2 / 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = AspectRatio(
      aspectRatio: _aspectRatio,
      child: _buildImage(),
    );

    if (borderRadius != null) {
      content = ClipRRect(borderRadius: borderRadius!, child: content);
    }

    return content;
  }

  Widget _buildImage() {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildErrorWidget();
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: fit,
      placeholder: (context, url) => loadingWidget ?? _buildLoadingWidget(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: AppColor.componentFillNormal,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppColor.primaryNormal),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: AppColor.componentFillNormal,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 32,
          color: AppColor.labelAssistive,
        ),
      ),
    );
  }
}

/// 반응형 그리드 아이템 (비율 유지)
///
/// Usage:
/// ```dart
/// GridView.builder(
///   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
///     crossAxisCount: 2,
///     childAspectRatio: 1,
///   ),
///   itemBuilder: (context, index) => AppGridItem(
///     aspectRatio: 1,
///     child: Card(...),
///   ),
/// )
/// ```
class AppGridItem extends StatelessWidget {
  /// 비율
  final double aspectRatio;

  /// 자식 위젯
  final Widget child;

  /// 패딩
  final EdgeInsets? padding;

  const AppGridItem({
    super.key,
    this.aspectRatio = 1,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = AspectRatio(aspectRatio: aspectRatio, child: child);

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}
