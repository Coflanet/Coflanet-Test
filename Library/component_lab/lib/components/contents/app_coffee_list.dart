import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import '../../util/format.dart';
import '../chips/app_mini_chip.dart';
import 'app_coffee_profile.dart';

/// Coffee List 아이템 상태 — Figma `Contents/Coffee List`.
enum AppCoffeeListItemState {
  /// 기본
  normal,

  /// 선택됨 (보라 테두리 + 체크 배지)
  selected,

  /// 비활성
  disabled,
}

/// Coffee List 아이템 — Figma `Contents/Coffee List` Button Touch.
///
/// Compact: 작은 원두 아이콘 + "브랜드명" 칩 + 이름.
/// Expanded: + 가격 + 5축 속성 차트(듀얼 트랙) + flavor 칩 + 원두 상세 / 레시피 실행 버튼.
class AppCoffeeListItem extends StatelessWidget {
  const AppCoffeeListItem({
    super.key,
    required this.brand,
    required this.name,
    this.price,
    this.discountPercent,
    this.attributes,
    this.compared,
    this.flavorNotes = const [],
    this.expanded = false,
    this.state = AppCoffeeListItemState.normal,
    this.isLiked = false,
    this.onLikeTap,
    this.onTap,
    this.onDetailTap,
    this.onRecipeTap,
  });

  /// 브랜드 칩 라벨 (예: 브랜드명, 구독중).
  final String brand;
  final String name;
  final int? price;
  final int? discountPercent;
  final Map<String, double>? attributes;
  final Map<String, double>? compared;
  final List<String> flavorNotes;
  final bool expanded;
  final AppCoffeeListItemState state;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onTap;
  final VoidCallback? onDetailTap;
  final VoidCallback? onRecipeTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = state == AppCoffeeListItemState.selected;
    final isDisabled = state == AppCoffeeListItemState.disabled;
    final borderColor = isSelected
        ? AppColor.primaryNormal
        : AppColor.lineNormalNormal;
    final borderWidth = isSelected ? 1.5 : 1.0;

    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isDisabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.backgroundNormalNormal,
            borderRadius: BorderRadius.circular(AppRadius.radius12),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          padding: const EdgeInsets.all(AppSpacing.space12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                brand: brand,
                name: name,
                price: price,
                discountPercent: discountPercent,
                isSelected: isSelected,
                isLiked: isLiked,
                expanded: expanded,
                onLikeTap: onLikeTap,
              ),
              if (expanded && attributes != null) ...[
                const SizedBox(height: AppSpacing.space12),
                AppCoffeeAttributesChart(
                  values: attributes!,
                  compared: compared,
                ),
              ],
              if (expanded && flavorNotes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space12),
                AppFlavorNotesChips(notes: flavorNotes),
              ],
              if (expanded &&
                  (onDetailTap != null || onRecipeTap != null)) ...[
                const SizedBox(height: AppSpacing.space16),
                Row(
                  children: [
                    if (onDetailTap != null)
                      Expanded(
                        child: _OutlinedActionButton(
                          label: '원두 상세',
                          onPressed: onDetailTap,
                        ),
                      ),
                    if (onDetailTap != null && onRecipeTap != null)
                      const SizedBox(width: AppSpacing.space8),
                    if (onRecipeTap != null)
                      Expanded(
                        child: _PrimaryActionButton(
                          label: '레시피 실행',
                          onPressed: onRecipeTap,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.brand,
    required this.name,
    required this.isSelected,
    required this.isLiked,
    required this.expanded,
    this.price,
    this.discountPercent,
    this.onLikeTap,
  });

  final String brand;
  final String name;
  final int? price;
  final int? discountPercent;
  final bool isSelected;
  final bool isLiked;
  final bool expanded;
  final VoidCallback? onLikeTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bean thumbnail or selected check badge
        Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.backgroundElevatedAlternative,
                borderRadius: BorderRadius.circular(AppRadius.radius8),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.local_cafe_outlined,
                size: 20,
                color: AppColor.labelAlternative,
              ),
            ),
            if (isSelected)
              Positioned(
                top: -4,
                left: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColor.primaryNormal,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.backgroundNormalNormal,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check,
                      size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AppMiniChip(label: brand, tone: AppMiniChipTone.primary),
                  if (expanded && price != null) ...[
                    const SizedBox(width: AppSpacing.space8),
                    Text(
                      '실시간시세',
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: AppTextStyles.body2NormalMedium.copyWith(
                  color: AppColor.labelNormal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (expanded && price != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (discountPercent != null) ...[
                      Text(
                        '$discountPercent%',
                        style: AppTextStyles.label1NormalBold.copyWith(
                          color: AppColor.statusNegative,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      formatPrice(price!),
                      style: AppTextStyles.label1NormalBold.copyWith(
                        color: AppColor.labelNormal,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (onLikeTap != null && expanded)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onLikeTap,
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: isLiked
                  ? AppColor.primaryNormal
                  : AppColor.labelAlternative,
            ),
          )
        else if (!expanded)
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24,
            color: AppColor.labelAlternative,
          ),
      ],
    );
  }

}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          border: Border.all(color: AppColor.lineNormalNormal),
        ),
        child: Text(
          label,
          style: AppTextStyles.label1NormalMedium.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.primaryNormal,
          borderRadius: BorderRadius.circular(AppRadius.radius8),
        ),
        child: Text(
          label,
          style: AppTextStyles.label1NormalBold.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
