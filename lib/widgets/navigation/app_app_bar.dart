import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// 앱 바 스타일
enum AppBarStyle {
  /// 기본 스타일 (배경 있음)
  standard,

  /// 투명 스타일 (배경 없음)
  transparent,

  /// 그라데이션 배경
  gradient,
}

/// 앱 바
///
/// Figma: 🧭 Navigation 페이지
///
/// Usage:
/// ```dart
/// // 기본 앱바
/// AppAppBar(title: '설정')
///
/// // 뒤로가기 버튼 자동
/// AppAppBar(
///   title: '상세 페이지',
///   showBackButton: true,
/// )
///
/// // 액션 버튼
/// AppAppBar(
///   title: '홈',
///   actions: [
///     IconButton(icon: Icon(Icons.search), onPressed: () {}),
///     IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
///   ],
/// )
///
/// // 투명 스타일
/// AppAppBar(
///   title: '프로필',
///   style: AppBarStyle.transparent,
/// )
/// ```
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 타이틀 텍스트
  final String? title;

  /// 타이틀 위젯 (title과 중복 사용 불가)
  final Widget? titleWidget;

  /// 왼쪽 위젯
  final Widget? leading;

  /// 뒤로가기 버튼 표시 여부
  final bool showBackButton;

  /// 뒤로가기 콜백 (null이면 Get.back())
  final VoidCallback? onBack;

  /// 오른쪽 액션 버튼들
  final List<Widget>? actions;

  /// 타이틀 중앙 정렬 여부
  final bool centerTitle;

  /// 스타일
  final AppBarStyle style;

  /// 배경색 (style이 standard일 때)
  final Color? backgroundColor;

  /// 그라데이션 (style이 gradient일 때)
  final Gradient? gradient;

  /// 그림자 표시 여부
  final bool showShadow;

  /// 하단 위젯 (예: TabBar)
  final PreferredSizeWidget? bottom;

  /// 높이
  final double height;

  /// 상태바 스타일 (null이면 자동)
  final SystemUiOverlayStyle? systemOverlayStyle;

  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.showBackButton = false,
    this.onBack,
    this.actions,
    this.centerTitle = true,
    this.style = AppBarStyle.standard,
    this.backgroundColor,
    this.gradient,
    this.showShadow = false,
    this.bottom,
    this.height = 56,
    this.systemOverlayStyle,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  bool get _isDarkBackground {
    if (style == AppBarStyle.transparent) return false;
    if (backgroundColor != null) {
      return ThemeData.estimateBrightnessForColor(backgroundColor!) ==
          Brightness.dark;
    }
    return false;
  }

  SystemUiOverlayStyle get _systemOverlayStyle {
    if (systemOverlayStyle != null) return systemOverlayStyle!;
    if (_isDarkBackground || style == AppBarStyle.transparent) {
      return SystemUiOverlayStyle.light;
    }
    return SystemUiOverlayStyle.dark;
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    Widget appBar = Container(
      height: preferredSize.height + statusBarHeight,
      padding: EdgeInsets.only(top: statusBarHeight),
      decoration: _buildDecoration(),
      child: Column(
        children: [
          SizedBox(height: height, child: _buildContent(context)),
          if (bottom != null) bottom!,
        ],
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemOverlayStyle,
      child: appBar,
    );
  }

  BoxDecoration? _buildDecoration() {
    switch (style) {
      case AppBarStyle.standard:
        return BoxDecoration(
          color: backgroundColor ?? AppColor.backgroundElevatedNormal,
          boxShadow: showShadow ? AppShadows.shadowBlackNormal : null,
        );
      case AppBarStyle.transparent:
        return null;
      case AppBarStyle.gradient:
        return BoxDecoration(
          gradient:
              gradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.primaryNormal, AppColor.primaryStrong],
              ),
          boxShadow: showShadow ? AppShadows.shadowPrimaryEmphasize : null,
        );
    }
  }

  Widget _buildContent(BuildContext context) {
    final effectiveLeading = leading ?? _buildLeading();
    final textColor = _getTextColor();

    return Row(
      children: [
        // Leading
        SizedBox(width: 56, child: effectiveLeading),

        // Title
        Expanded(
          child: centerTitle
              ? Center(child: _buildTitle(textColor))
              : _buildTitle(textColor),
        ),

        // Actions
        SizedBox(
          width: actions != null ? null : 56,
          child: actions != null
              ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget? _buildLeading() {
    if (!showBackButton) return null;

    return _BackButton(
      onTap: onBack ?? () => Get.back(),
      color: _getTextColor(),
    );
  }

  Widget _buildTitle(Color textColor) {
    if (titleWidget != null) return titleWidget!;
    if (title == null) return const SizedBox.shrink();

    return Text(
      title!,
      style: AppTextStyles.headline1Bold.copyWith(color: textColor),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Color _getTextColor() {
    switch (style) {
      case AppBarStyle.standard:
        if (_isDarkBackground) return AppColor.staticLabelWhiteStrong;
        return AppColor.labelNormal;
      case AppBarStyle.transparent:
        return AppColor.labelNormal;
      case AppBarStyle.gradient:
        return AppColor.staticLabelWhiteStrong;
    }
  }
}

/// 뒤로가기 버튼
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;

  const _BackButton({required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.space16),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: color, size: 20),
        ),
      ),
    );
  }
}

/// 슬리버 앱바 (스크롤 시 접히는 앱바)
///
/// Usage:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     AppSliverAppBar(
///       title: '프로필',
///       expandedHeight: 200,
///       flexibleSpace: Image.network(...),
///     ),
///     SliverList(...),
///   ],
/// )
/// ```
class AppSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool centerTitle;
  final double expandedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final Color? backgroundColor;

  const AppSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.showBackButton = false,
    this.onBack,
    this.actions,
    this.centerTitle = true,
    this.expandedHeight = 200,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      backgroundColor: backgroundColor ?? AppColor.backgroundElevatedNormal,
      foregroundColor: AppColor.labelNormal,
      elevation: 0,
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: onBack ?? () => Get.back(),
            )
          : leading,
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.headline1Bold.copyWith(
                    color: AppColor.labelNormal,
                  ),
                )
              : null),
      actions: actions,
      flexibleSpace: flexibleSpace != null
          ? FlexibleSpaceBar(background: flexibleSpace)
          : null,
    );
  }
}
