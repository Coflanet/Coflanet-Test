import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../navigation/app_top_navigation.dart';

/// Full Screen Modal — Figma `Modal/Full Modal`.
///
/// 풀스크린 push/pop 방식의 모달. 2 variants:
/// - `withNavigation`: `AppTopNavigation`(normal)과 함께 표시 (default)
/// - `bare`: 자체 nav UI 없이 콘텐츠만 (호출자가 자체 헤더 구성)
///
/// 표시:
/// ```dart
/// AppFullModal.show(
///   context,
///   title: '약관 동의',
///   onClose: () => Navigator.pop(context),
///   builder: (ctx) => const TermsContent(),
/// );
/// ```
class AppFullModal extends StatelessWidget {
  const AppFullModal({
    super.key,
    required this.builder,
    this.title,
    this.onClose,
    this.trailingActions = const [],
    this.withNavigation = true,
    this.backgroundColor,
  });

  /// 콘텐츠 빌더.
  final WidgetBuilder builder;

  /// `withNavigation: true`일 때 상단 nav 타이틀.
  final String? title;

  /// 좌측 close 버튼 콜백. null이면 `Navigator.pop`.
  final VoidCallback? onClose;

  /// 우측 액션들 (`AppTopNavigation`의 trailingActions에 그대로 전달).
  final List<TopNavAction> trailingActions;

  /// false면 자체 TopNavigation 미표시 (호출자가 직접 구성).
  final bool withNavigation;

  /// 화면 배경. null이면 `backgroundNormalNormal`.
  final Color? backgroundColor;

  /// 풀스크린 push 헬퍼.
  ///
  /// 반환값은 push된 라우트의 결과(`Navigator.pop(value)`).
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    String? title,
    VoidCallback? onClose,
    List<TopNavAction> trailingActions = const [],
    bool withNavigation = true,
    Color? backgroundColor,
    bool fullscreenDialog = true,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        fullscreenDialog: fullscreenDialog,
        builder: (ctx) => AppFullModal(
          title: title,
          onClose: onClose,
          trailingActions: trailingActions,
          withNavigation: withNavigation,
          backgroundColor: backgroundColor,
          builder: builder,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ??
        (isDark
            ? AppColor.darkBackgroundNormalNormal
            : AppColor.backgroundNormalNormal);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (withNavigation)
              AppTopNavigation(
                title: title ?? '',
                variant: TopNavigationVariant.normal,
                leadingIcon: Icons.close_rounded,
                onLeadingPressed:
                    onClose ?? () => Navigator.maybePop(context),
                trailingActions: trailingActions,
              ),
            Expanded(child: Builder(builder: builder)),
          ],
        ),
      ),
    );
  }
}
