import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_text_style.dart';
import '../../foundation/app_spacing.dart';

// ─────────────────────────────────────────────────────────────
// Footer — Figma "Footer/Footer"
//
// 구조:
//   1. SNS 아이콘 행 (Instagram, Kakao, YouTube)
//   2. 고객센터 (제목 + 연락처 정보)
//   3. 사업자정보 (접이식)
//
// Tokens:
//   Label/normal       → AppColor.labelNormal
//   Label/alternative  → AppColor.labelAlternative
//   Label/assistive    → AppColor.labelAssistive
//   Line/normal/alternative → AppColor.lineNormalAlternative
//   Background/normal/alternative → AppColor.backgroundNormalAlternative
// ─────────────────────────────────────────────────────────────

/// SNS 링크 모델.
class FooterSnsItem {
  /// 아이콘
  final IconData icon;

  /// 탭 콜백
  final VoidCallback? onPressed;

  const FooterSnsItem({required this.icon, this.onPressed});
}

/// 커플래닛 Footer.
///
/// ```dart
/// AppFooter(
///   snsItems: [
///     FooterSnsItem(icon: Icons.camera_alt_outlined),
///     FooterSnsItem(icon: Icons.chat_bubble_outline),
///     FooterSnsItem(icon: Icons.play_circle_outline),
///   ],
///   customerServiceTitle: '고객센터 (평일 오전 9시 ~ 오후 5시 운영)',
///   customerServiceBody: '문의전화 0000-0000\n고객전용 메일 : help@example.com',
///   businessInfoTitle: '커플래닛 사업자 정보',
///   businessInfoBody: '대표이사: 홍길동\n사업자등록번호: 000-00-00000',
/// )
/// ```
class AppFooter extends StatefulWidget {
  /// SNS 아이콘 목록.
  final List<FooterSnsItem> snsItems;

  /// 고객센터 제목.
  final String customerServiceTitle;

  /// 고객센터 본문 (전화번호, 이메일 등).
  final String customerServiceBody;

  /// 사업자정보 제목.
  final String businessInfoTitle;

  /// 사업자정보 본문 (접이식).
  final String? businessInfoBody;

  /// 배경색.
  final Color? backgroundColor;

  const AppFooter({
    super.key,
    this.snsItems = const [],
    this.customerServiceTitle = '',
    this.customerServiceBody = '',
    this.businessInfoTitle = '',
    this.businessInfoBody,
    this.backgroundColor,
  });

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  bool _businessInfoExpanded = false;

  static const double _horizontalPadding = 20.0;
  static const double _sectionSpacing = 24.0;
  static const double _snsIconSize = 24.0;
  static const double _snsSpacing = 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: widget.backgroundColor ?? AppColor.backgroundNormalAlternative,
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _sectionSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: _sectionSpacing,
        children: [
          // ─── SNS 아이콘 행 ───
          if (widget.snsItems.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: _snsSpacing,
              children: widget.snsItems.map((item) {
                return GestureDetector(
                  onTap: item.onPressed,
                  child: Icon(
                    item.icon,
                    size: _snsIconSize,
                    color: AppColor.labelAlternative,
                  ),
                );
              }).toList(),
            ),

          // ─── 고객센터 ───
          if (widget.customerServiceTitle.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.space8,
              children: [
                Text(
                  widget.customerServiceTitle,
                  style: AppTextStyles.caption1Bold.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
                if (widget.customerServiceBody.isNotEmpty)
                  Text(
                    widget.customerServiceBody,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.labelAssistive,
                    ),
                  ),
              ],
            ),

          // ─── 사업자정보 (접이식) ───
          if (widget.businessInfoTitle.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.businessInfoBody != null) {
                      setState(
                        () => _businessInfoExpanded = !_businessInfoExpanded,
                      );
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.space4,
                    children: [
                      Text(
                        widget.businessInfoTitle,
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.labelAssistive,
                        ),
                      ),
                      if (widget.businessInfoBody != null)
                        Icon(
                          _businessInfoExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 16,
                          color: AppColor.labelAssistive,
                        ),
                    ],
                  ),
                ),
                if (widget.businessInfoBody != null)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: _businessInfoExpanded
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: AppSpacing.space8),
                            child: Text(
                              widget.businessInfoBody!,
                              style: AppTextStyles.caption2Regular.copyWith(
                                color: AppColor.labelAssistive,
                              ),
                            ),
                          )
                        : const SizedBox(width: double.infinity, height: 0),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
