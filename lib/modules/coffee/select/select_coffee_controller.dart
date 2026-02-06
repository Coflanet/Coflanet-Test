import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/data/dummy/dummy_coffee_data.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';

/// Controller for Select Coffee Section
class SelectCoffeeController extends BaseController {
  // List of coffee items
  final _coffeeItems = <CoffeeItem>[].obs;
  List<CoffeeItem> get coffeeItems => _coffeeItems;

  // Currently selected coffee ID (for normal mode)
  final _selectedId = Rxn<String>();
  String? get selectedId => _selectedId.value;

  // Editing mode flag
  final _isEditing = false.obs;
  bool get isEditing => _isEditing.value;

  // Multi-select for editing mode
  final _selectedIdsForEdit = <String>{}.obs;
  Set<String> get selectedIdsForEdit => _selectedIdsForEdit;
  int get selectedEditCount => _selectedIdsForEdit.length;

  @override
  void onInit() {
    super.onInit();
    _loadCoffeeItems();
  }

  /// Load coffee items from storage/API
  Future<void> _loadCoffeeItems() async {
    showLoading();

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Load dummy data
    _coffeeItems.value = DummyCoffeeData.coffeeItems.toList();

    // Pre-select first item
    if (_coffeeItems.isNotEmpty) {
      _selectedId.value = _coffeeItems.first.id;
    }

    hideLoading();
  }

  /// Toggle edit mode
  void toggleEditMode() {
    _isEditing.value = !_isEditing.value;
    if (!_isEditing.value) {
      // Clear edit selections when exiting edit mode
      _selectedIdsForEdit.clear();
    }
  }

  /// Toggle item selection in edit mode
  void toggleEditSelection(String id) {
    if (_selectedIdsForEdit.contains(id)) {
      _selectedIdsForEdit.remove(id);
    } else {
      _selectedIdsForEdit.add(id);
    }
  }

  /// Check if item is selected in edit mode
  bool isSelectedForEdit(String id) => _selectedIdsForEdit.contains(id);

  /// Delete all selected items in edit mode
  void deleteSelectedItems() {
    for (final id in _selectedIdsForEdit.toList()) {
      _coffeeItems.removeWhere((item) => item.id == id);
    }
    _selectedIdsForEdit.clear();

    // Update normal selection if needed
    if (_selectedId.value != null &&
        !_coffeeItems.any((item) => item.id == _selectedId.value)) {
      _selectedId.value = _coffeeItems.isNotEmpty
          ? _coffeeItems.first.id
          : null;
    }
  }

  /// Share selected items (placeholder for future implementation)
  void shareSelectedItems() {
    // TODO: Implement share functionality
    Get.snackbar(
      '공유',
      '$selectedEditCount개 항목 공유 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Select a coffee item
  void selectCoffee(String id) {
    _selectedId.value = id;
  }

  /// Delete a coffee item
  void deleteCoffee(String id) {
    _coffeeItems.removeWhere((item) => item.id == id);

    // Clear selection if deleted item was selected
    if (_selectedId.value == id) {
      _selectedId.value = _coffeeItems.isNotEmpty
          ? _coffeeItems.first.id
          : null;
    }
  }

  /// Reorder items
  void reorderItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _coffeeItems.removeAt(oldIndex);
    _coffeeItems.insert(newIndex, item);
  }

  /// Add new coffee
  void addNewCoffee() {
    // Show input modal or navigate to add screen
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    _coffeeItems.add(
      CoffeeItem(
        id: newId,
        name: '새 커피 ${_coffeeItems.length + 1}',
        description: '커피 설명을 입력하세요',
        color: _getRandomColor(),
      ),
    );
  }

  /// Confirm selection and go back
  void confirmSelection() {
    if (_selectedId.value != null) {
      final selected = _coffeeItems.firstWhereOrNull(
        (item) => item.id == _selectedId.value,
      );
      if (selected != null) {
        Get.back(result: selected);
      }
    }
  }

  /// Get random color for new coffee
  Color _getRandomColor() {
    final colors = [
      AppColor.colorGlobalOrange50,
      AppColor.colorGlobalGreen50,
      AppColor.colorGlobalRed50,
      AppColor.colorGlobalViolet50,
      AppColor.colorGlobalBlue50,
      AppColor.colorGlobalPink50,
      AppColor.colorGlobalCyan50,
      AppColor.colorGlobalYellow50,
    ];
    return colors[_coffeeItems.length % colors.length];
  }
}
