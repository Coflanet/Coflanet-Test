import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import '../chips/app_mini_chip.dart';

/// Preference List 아이템 상태 — Figma `Contents/Preference List`.
enum AppPreferenceItemState {
  /// 기본
  normal,

  /// 선택됨 (보라 테두리)
  selected,

  /// 비활성 (회색, 입력 불가)
  disabled,
}

/// 맛 선호도 강도 — Figma `Contents/Preference List`.
///
/// 색상 매핑:
/// - good (좋음): blue
/// - normal (보통): yellow
/// - bad (싫음): red
enum AppTasteLevel { good, normal, bad }

/// 맛 선호도 칩 — Figma `Contents/Preference List/맛 선호도`.
///
/// 위쪽에 라벨(예: 산미), 아래쪽에 강도 텍스트(좋음/보통/싫음).
class AppTasteChip extends StatelessWidget {
  const AppTasteChip({
    super.key,
    required this.label,
    required this.level,
    this.onTap,
  });

  final String label;
  final AppTasteLevel level;
  final VoidCallback? onTap;

  ({Color bg, Color fg}) _colors() {
    switch (level) {
      case AppTasteLevel.good:
        return (
          bg: AppColor.colorGlobalBlue95,
          fg: AppColor.colorGlobalBlue50,
        );
      case AppTasteLevel.normal:
        return (
          bg: AppColor.colorGlobalYellow95,
          fg: AppColor.colorGlobalYellow40,
        );
      case AppTasteLevel.bad:
        return (
          bg: AppColor.colorGlobalRed95,
          fg: AppColor.colorGlobalRed40,
        );
    }
  }

  String _levelText() {
    switch (level) {
      case AppTasteLevel.good:
        return '좋음';
      case AppTasteLevel.normal:
        return '보통';
      case AppTasteLevel.bad:
        return '싫음';
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg: bg, fg: fg) = _colors();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.radius8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.caption1Regular.copyWith(color: fg),
            ),
            const SizedBox(height: 2),
            Text(
              _levelText(),
              style: AppTextStyles.label2Bold.copyWith(color: fg),
            ),
          ],
        ),
      ),
    );
  }
}

/// Flavor 칩 (선호 향) — Figma `Contents/Preference List/좋아하는 향`.
///
/// `AppMiniChip(tone: neutral)`의 얇은 별칭 — `AppPreferenceItem.flavorChips`
/// 매개변수 타입 호환을 위해 별도 클래스로 유지.
class AppPreferenceFlavorChip extends StatelessWidget {
  const AppPreferenceFlavorChip({
    super.key,
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppMiniChip(label: label, onTap: onTap);
  }
}

/// Preference List 아이템 — Figma `Contents/Preference List`.
///
/// 펼침/접기 헤더(제목 + 요약 칩) + 펼친 상태에서 맛 선호도 + 좋아하는 향.
class AppPreferenceItem extends StatefulWidget {
  const AppPreferenceItem({
    super.key,
    required this.title,
    this.summaryTags = const [],
    this.tasteChips,
    this.flavorChips,
    this.expanded = false,
    this.state = AppPreferenceItemState.normal,
    this.onTap,
  });

  /// 헤더 좌측 타이틀 (예: "제목을 입력해주세요").
  final String title;

  /// 헤더 아래에 표시되는 요약 칩 라벨.
  final List<String> summaryTags;

  /// 펼친 상태에서 보여줄 맛 선호도 칩들. `AppTasteChip` 권장이지만 임의의 chip
  /// 위젯(`AppMiniChip` 등) 주입 가능.
  final List<Widget>? tasteChips;

  /// 펼친 상태에서 보여줄 향 선호 칩들. `AppPreferenceFlavorChip`/`AppMiniChip` 등.
  final List<Widget>? flavorChips;

  final bool expanded;
  final AppPreferenceItemState state;
  final VoidCallback? onTap;

  @override
  State<AppPreferenceItem> createState() => _AppPreferenceItemState();
}

class _AppPreferenceItemState extends State<AppPreferenceItem> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded;
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.state == AppPreferenceItemState.disabled;
    final isSelected = widget.state == AppPreferenceItemState.selected;
    final borderColor = isSelected
        ? AppColor.primaryNormal
        : AppColor.lineNormalNormal;
    final borderWidth = isSelected ? 1.5 : 1.0;

    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(AppRadius.radius12),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isDisabled
                  ? null
                  : () {
                      widget.onTap?.call();
                      setState(() => _expanded = !_expanded);
                    },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppTextStyles.body1NormalMedium.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 24,
                    color: AppColor.labelAlternative,
                  ),
                ],
              ),
            ),
            if (widget.summaryTags.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.space8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.summaryTags
                    .map(
                      (t) => AppPreferenceFlavorChip(label: t),
                    )
                    .toList(),
              ),
            ],
            // Expand 영역 — AnimatedSize로 AppAccordion과 동일한 부드러운 토글.
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.tasteChips != null &&
                            widget.tasteChips!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.space16),
                          Text(
                            '맛 선호도',
                            style: AppTextStyles.label2Regular.copyWith(
                              color: AppColor.labelAlternative,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.space8),
                          Wrap(
                            spacing: AppSpacing.space8,
                            runSpacing: AppSpacing.space8,
                            children: widget.tasteChips!,
                          ),
                        ],
                        if (widget.flavorChips != null &&
                            widget.flavorChips!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.space16),
                          Text(
                            '좋아하는 향',
                            style: AppTextStyles.label2Regular.copyWith(
                              color: AppColor.labelAlternative,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.space8),
                          Wrap(
                            spacing: AppSpacing.space8,
                            runSpacing: AppSpacing.space8,
                            children: widget.flavorChips!,
                          ),
                        ],
                      ],
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      ),
    );
  }
}
