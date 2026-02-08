import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// Coffee equipment types available for selection.
enum CoffeeEquipment {
  handDrip,
  espressoMachine,
  semiAutoMachine,
  autoMachine,
  capsuleMachine,
  mokaPot,
}

/// Extension to provide Korean labels and icons for equipment types.
extension CoffeeEquipmentExtension on CoffeeEquipment {
  String get label {
    switch (this) {
      case CoffeeEquipment.handDrip:
        return '핸드드립';
      case CoffeeEquipment.espressoMachine:
        return '에스프레소 머신';
      case CoffeeEquipment.semiAutoMachine:
        return '반자동 머신';
      case CoffeeEquipment.autoMachine:
        return '자동 커피머신';
      case CoffeeEquipment.capsuleMachine:
        return '캡슐 머신';
      case CoffeeEquipment.mokaPot:
        return '모카포트';
    }
  }

  IconData get icon {
    switch (this) {
      case CoffeeEquipment.handDrip:
        return Icons.coffee_maker_outlined;
      case CoffeeEquipment.espressoMachine:
        return Icons.coffee;
      case CoffeeEquipment.semiAutoMachine:
        return Icons.precision_manufacturing_outlined;
      case CoffeeEquipment.autoMachine:
        return Icons.smart_toy_outlined;
      case CoffeeEquipment.capsuleMachine:
        return Icons.circle_outlined;
      case CoffeeEquipment.mokaPot:
        return Icons.local_cafe_outlined;
    }
  }

  String get description {
    switch (this) {
      case CoffeeEquipment.handDrip:
        return '드리퍼와 필터로 추출';
      case CoffeeEquipment.espressoMachine:
        return '고압 추출 방식';
      case CoffeeEquipment.semiAutoMachine:
        return '수동 조작 필요';
      case CoffeeEquipment.autoMachine:
        return '원터치 자동 추출';
      case CoffeeEquipment.capsuleMachine:
        return '캡슐 사용';
      case CoffeeEquipment.mokaPot:
        return '스토브 위 추출';
    }
  }
}

/// A modal for selecting coffee brewing equipment.
///
/// Figma: 커피 기구 선택 Modal
///
/// Usage:
/// ```dart
/// final equipment = await EquipmentSelectionModal.show(
///   selectedEquipment: CoffeeEquipment.handDrip,
/// );
/// if (equipment != null) {
///   // Use the selected equipment
/// }
/// ```
class EquipmentSelectionModal extends StatefulWidget {
  final CoffeeEquipment? selectedEquipment;
  final List<CoffeeEquipment>? availableEquipments;
  final String? title;
  final bool barrierDismissible;

  const EquipmentSelectionModal({
    super.key,
    this.selectedEquipment,
    this.availableEquipments,
    this.title,
    this.barrierDismissible = true,
  });

  /// Shows the equipment selection modal and returns the selected equipment.
  /// Returns null if cancelled.
  static Future<CoffeeEquipment?> show({
    CoffeeEquipment? selectedEquipment,
    List<CoffeeEquipment>? availableEquipments,
    String? title,
    bool barrierDismissible = true,
  }) async {
    return Get.dialog<CoffeeEquipment?>(
      EquipmentSelectionModal(
        selectedEquipment: selectedEquipment,
        availableEquipments: availableEquipments,
        title: title,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: AppColor.componentMaterialDimmer,
    );
  }

  @override
  State<EquipmentSelectionModal> createState() =>
      _EquipmentSelectionModalState();
}

class _EquipmentSelectionModalState extends State<EquipmentSelectionModal>
    with SingleTickerProviderStateMixin {
  late CoffeeEquipment? _selectedEquipment;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  List<CoffeeEquipment> get _equipments =>
      widget.availableEquipments ?? CoffeeEquipment.values;

  @override
  void initState() {
    super.initState();
    _selectedEquipment = widget.selectedEquipment;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onEquipmentSelected(CoffeeEquipment equipment) {
    setState(() {
      _selectedEquipment = equipment;
    });
  }

  void _onConfirm() {
    Get.back(result: _selectedEquipment);
  }

  void _onCancel() {
    Get.back(result: null);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            decoration: BoxDecoration(
              color: AppColor.backgroundElevatedNormal,
              borderRadius: AppRadius.modalBorder,
              boxShadow: AppShadows.shadowBlackHeavy,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildEquipmentGrid(),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Text(
        widget.title ?? '커피 기구 선택',
        style: AppTextStyles.heading1Bold.copyWith(color: AppColor.labelNormal),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEquipmentGrid() {
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _equipments.map((equipment) {
            final isSelected = _selectedEquipment == equipment;
            return _EquipmentCard(
              equipment: equipment,
              isSelected: isSelected,
              onTap: () => _onEquipmentSelected(equipment),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.labelNormal,
                  side: BorderSide(color: AppColor.lineNormalNormal),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonBorder,
                  ),
                ),
                child: Text('취소', style: AppTextStyles.headline2Bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedEquipment != null ? _onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryNormal,
                  foregroundColor: AppColor.staticLabelWhiteStrong,
                  disabledBackgroundColor: AppColor.interactionInactive,
                  disabledForegroundColor: AppColor.labelDisable,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonBorder,
                  ),
                ),
                child: Text('확인', style: AppTextStyles.headline2Bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual equipment card for the grid.
class _EquipmentCard extends StatelessWidget {
  final CoffeeEquipment equipment;
  final bool isSelected;
  final VoidCallback onTap;

  const _EquipmentCard({
    required this.equipment,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate width for 2 items per row with spacing
    final cardWidth = (MediaQuery.of(context).size.width - 48 - 32 - 12) / 2;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: cardWidth,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryNormal.withOpacity(0.08)
              : AppColor.componentFillNormal,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(
            color: isSelected ? AppColor.primaryNormal : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryNormal.withOpacity(0.15)
                    : AppColor.backgroundNormalAlternative,
                borderRadius: AppRadius.mdBorder,
              ),
              child: Icon(
                equipment.icon,
                color: isSelected
                    ? AppColor.primaryNormal
                    : AppColor.labelAlternative,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            // Label
            Text(
              equipment.label,
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: isSelected
                    ? AppColor.primaryNormal
                    : AppColor.labelNormal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              equipment.description,
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.labelAssistive,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
