import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// iyumi 카드 패턴의 **화면 틀**.
///
/// - 배경: Static/Black 캔버스(라이트·다크 공통, task 4 방향 B).
/// - 헤더: 상단 마진 [AppSpacing.screenTopMargin](32) + [title]를 title2Bold 로.
///   카드 밖이므로 색은 캔버스 스킴([AppColorScheme.canvas] = 다크)을 써서
///   검정 위에서 밝게 보인다.
/// - 푸시 화면: [showBack] 기본 true → 자동 back 버튼.
/// - 셸 탭 내부 화면: [useScaffold]=false (배경은 셸이 소유, 캔버스 색만 보장).
/// - [scrollable]=true: 본문을 스크롤 + 하단 [AppSpacing.bottomScrollInset].
///   자체 스크롤(ListView/TabBarView)을 가진 화면은 false 로 두고 리스트 하단에
///   `AppSpacing.bottomScrollInset(context)` 를 직접 적용한다.
class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    required this.child,
    this.title,
    this.useScaffold = true,
    this.scrollable = true,
    this.showBack = true,
    this.trailing,
  });

  /// 화면 본문
  final Widget child;

  /// 최상단 타이틀 (없고 back·trailing 도 없으면 헤더 생략)
  final String? title;

  /// 자체 Scaffold 사용 여부 (셸 탭 내부는 false)
  final bool useScaffold;

  /// 본문 스크롤 래핑 여부
  final bool scrollable;

  /// back 버튼 노출 여부
  final bool showBack;

  /// 헤더 우측 액션
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    // 카드 밖(캔버스)은 항상 다크 스킴 (방향 B)
    final canvas = AppColorScheme.canvas;

    final bool hasHeader = title != null || showBack || trailing != null;
    final Widget header = hasHeader
        ? Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.headerHorizontalPadding,
              AppSpacing.screenTopMargin,
              AppSpacing.headerHorizontalPadding,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                if (showBack) ...[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.chevron_left,
                      color: canvas.labelNormal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Expanded(
                  child: Text(
                    title ?? '',
                    style: AppTextStyles.title2Bold.copyWith(
                      color: canvas.labelNormal,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          )
        : const SizedBox.shrink();

    final Widget body = scrollable
        ? SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: AppSpacing.bottomScrollInset(context),
            ),
            child: child,
          )
        : child;

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Expanded(child: body),
      ],
    );

    if (!useScaffold) {
      // 셸 탭 내부 — 배경은 셸이 소유하지만 캔버스 색을 보장.
      return ColoredBox(
        color: AppColor.staticBlack,
        child: SafeArea(child: content),
      );
    }
    return Scaffold(
      backgroundColor: AppColor.staticBlack,
      body: SafeArea(child: content),
    );
  }
}
