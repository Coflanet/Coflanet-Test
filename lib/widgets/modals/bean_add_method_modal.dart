import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 원두 추가 방식 선택 결과
enum BeanAddMethod {
  /// 검색으로 원두 추가
  search,

  /// 직접 입력으로 원두 추가
  manual,
}

/// 원두 추가 방식 선택 바텀시트 (검색하기 / 직접 추가하기)
///
/// Figma Design Spec:
/// - Drag handle (40x4px, pill, light gray)
/// - Title "원두 추가" (center) + Close button (X, top right)
/// - 두 개의 카드 (검색하기 / 직접 추가하기)
///   - 검색하기: 보라 테두리 + 연보라 배경 + 보라 라벨 (강조)
///   - 직접 추가하기: 회색 배경 + 회색 라벨
///
/// Usage:
/// ```dart
/// final method = await BeanAddMethodModal.show();
/// if (method == BeanAddMethod.search) { ... }
/// ```
class BeanAddMethodModal extends StatelessWidget {
  const BeanAddMethodModal({super.key});

  /// 바텀시트를 띄우고 선택한 방식을 반환한다. 닫히면 null.
  static Future<BeanAddMethod?> show({bool barrierDismissible = true}) {
    return Get.bottomSheet<BeanAddMethod>(
      const BeanAddMethodModal(),
      isDismissible: barrierDismissible,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      barrierColor: AppColor.componentMaterialDimmer,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      exitBottomSheetDuration: const Duration(milliseconds: 200),
    );
  }

  void _onClose() => Get.back(result: null);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundElevatedNormal,
        borderRadius: AppRadius.top(AppRadius.xxl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          _buildContent(),
          // iOS Home Indicator 영역
          SizedBox(height: bottomPadding > 0 ? bottomPadding : 20),
        ],
      ),
    );
  }

  /// Drag handle - 40x4px pill
  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColor.lineSolidNormal,
        borderRadius: AppRadius.fullBorder,
      ),
    );
  }

  /// 헤더 - 제목(중앙) + 닫기 버튼(우측)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
      child: Row(
        children: [
          // 우측 닫기 버튼(40px)과 균형을 맞춰 제목을 중앙 정렬
          const SizedBox(width: 40),
          Expanded(
            child: Text(
              '원두 추가',
              style: AppTextStyles.headline1Bold.copyWith(
                color: AppColor.labelNormal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: _onClose,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.close, size: 24, color: AppColor.labelNormal),
            ),
          ),
        ],
      ),
    );
  }

  /// 두 개의 방식 카드
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MethodCard(
              label: '검색하기',
              isHighlighted: true,
              onTap: () => Get.back(result: BeanAddMethod.search),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MethodCard(
              label: '직접 추가하기',
              isHighlighted: false,
              onTap: () => Get.back(result: BeanAddMethod.manual),
            ),
          ),
        ],
      ),
    );
  }
}

/// 원두 추가 방식 카드 - 이미지 placeholder + 라벨
class _MethodCard extends StatelessWidget {
  final String label;

  /// true 면 보라 강조(검색하기), false 면 회색(직접 추가하기)
  final bool isHighlighted;
  final VoidCallback onTap;

  const _MethodCard({
    required this.label,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isHighlighted
        ? AppColor.primaryNormal.withValues(alpha: 0.06)
        : AppColor.colorGlobalCoolNeutral97;
    final borderColor = isHighlighted
        ? AppColor.primaryNormal
        : AppColor.transparent;
    final placeholderColor = isHighlighted
        ? AppColor.primaryNormal.withValues(alpha: 0.12)
        : AppColor.colorGlobalCoolNeutral96;
    final iconColor = isHighlighted
        ? AppColor.primaryNormal.withValues(alpha: 0.45)
        : AppColor.labelAssistive;
    final labelColor = isHighlighted
        ? AppColor.primaryNormal
        : AppColor.labelAlternative;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: AppRadius.xxxlBorder,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 이미지 placeholder - 정사각형
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: placeholderColor,
                  borderRadius: AppRadius.lgBorder,
                ),
                child: Icon(
                  Icons.image_outlined,
                  size: 32,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: labelColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
