import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';

/// 커피 선택 화면 평면 카드 — 일반(선택형) / 편집(체크박스+드래그) 모드.
///
/// 아코디언 카드(CoffeeAccordionCard, Shell 탭 화면)와는 디자인이 달라
/// 별개 클래스로 유지한다. controller 미참조 — 값/콜백 주입.
/// [isSelected] 는 호출부 Obx 클로저 안에서 평가해 주입한다.
class SelectCoffeeCard extends StatelessWidget {
  const SelectCoffeeCard({
    super.key,
    required this.item,
    required this.isEditing,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    this.onHide,
    this.onDetail,
    required this.index,
    this.showHideOption = false,
  });

  /// 원두 데이터
  final CoffeeItem item;

  /// 편집 모드 여부
  final bool isEditing;

  /// 선택 여부
  final bool isSelected;

  /// 카드 탭 콜백
  final VoidCallback onTap;

  /// 삭제 콜백
  final VoidCallback onDelete;

  /// 숨김 콜백
  final VoidCallback? onHide;

  /// 상세 이동 콜백 — null 이면 chevron 미표시
  final VoidCallback? onDetail;

  /// 리스트 인덱스 (편집 모드 드래그 핸들용)
  final int index;

  /// 숨김 옵션 노출 여부
  final bool showHideOption;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    if (isEditing) {
      return _buildEditingCard(colors);
    }
    return _buildNormalCard(colors);
  }

  Widget _buildNormalCard(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primaryNormal.withValues(alpha: 0.08)
                : colors.backgroundNormalNormal,
            borderRadius: AppRadius.xlBorder,
            border: Border.all(
              color: isSelected
                  ? colors.primaryNormal
                  : colors.lineNormalNeutral,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? AppShadows.shadowPrimaryNormalList : null,
          ),
          child: Row(
            children: [
              // 커피 아이콘
              _buildCoffeeIcon(),
              const SizedBox(width: 16),
              // 커피 정보
              _buildCoffeeInfo(colors),
              // 상세 버튼
              if (onDetail != null)
                GestureDetector(
                  onTap: onDetail,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.chevron_right,
                      color: colors.labelAssistive,
                      size: 24,
                    ),
                  ),
                ),
              // 선택 표시
              _buildSelectionIndicator(colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditingCard(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: colors.backgroundNormalNormal,
            borderRadius: AppRadius.lgBorder,
          ),
          child: Row(
            children: [
              // 체크박스
              _buildCheckbox(colors),
              const SizedBox(width: 12),
              // 커피 백 썸네일
              _buildCoffeeThumbnail(colors),
              const SizedBox(width: 12),
              // 커피 정보 (컴팩트)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '브랜드명',
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: colors.labelAssistive,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.name,
                      style: AppTextStyles.body2NormalMedium.copyWith(
                        color: colors.labelNormal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 드래그 핸들
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.drag_handle,
                    color: colors.labelAssistive,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(AppColorScheme colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? colors.primaryNormal : AppColor.transparent,
        border: Border.all(
          color: isSelected
              ? colors.primaryNormal
              : colors.interactionInactive,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 16, color: AppColor.staticLabelWhiteStrong)
          : null,
    );
  }

  Widget _buildCoffeeThumbnail(AppColorScheme colors) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colors.backgroundNormalAlternative,
        borderRadius: AppRadius.mdBorder,
      ),
      child: Center(child: Icon(Icons.coffee, color: item.color, size: 24)),
    );
  }

  Widget _buildCoffeeIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            item.color.withValues(alpha: 0.2),
            item.color.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: AppRadius.lgBorder,
      ),
      child: Icon(Icons.coffee, color: item.color, size: 28),
    );
  }

  Widget _buildCoffeeInfo(AppColorScheme colors) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: AppTextStyles.headline2Bold.copyWith(
              color: colors.labelNormal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: colors.labelAlternative,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionIndicator(AppColorScheme colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? colors.primaryNormal : AppColor.transparent,
        border: Border.all(
          color: isSelected
              ? colors.primaryNormal
              : colors.interactionInactive,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 16, color: AppColor.staticLabelWhiteStrong)
          : null,
    );
  }
}
