import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Controller for Select Coffee Section
class SelectCoffeeController extends BaseController {
  /// Coffee repository for CRUD operations
  final CoffeeRepository _coffeeRepository =
      RepositoryProvider.coffeeRepository;

  // List of coffee items
  final _coffeeItems = <CoffeeItem>[].obs;
  List<CoffeeItem> get coffeeItems => _coffeeItems;

  // Visible (non-hidden) coffee items
  List<CoffeeItem> get visibleCoffeeItems =>
      _coffeeItems.where((item) => !item.isHidden).toList();

  // Hidden coffee items
  List<CoffeeItem> get hiddenCoffeeItems =>
      _coffeeItems.where((item) => item.isHidden).toList();

  // Whether to show hidden beans section
  final _showHiddenBeans = false.obs;
  bool get showHiddenBeans => _showHiddenBeans.value;

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

  /// Load coffee items from repository
  Future<void> _loadCoffeeItems() async {
    showLoading();

    // Load from repository (handles dummy vs API internally)
    _coffeeItems.value = await _coffeeRepository.getCoffeeItems();

    // Pre-select first item
    if (_coffeeItems.isNotEmpty) {
      _selectedId.value = _coffeeItems.first.id;
    }

    hideLoading();
  }

  /// Refresh the coffee items list from repository
  Future<void> refreshList() async {
    await _loadCoffeeItems();
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
    _selectedIdsForEdit.refresh();
  }

  /// Check if item is selected in edit mode
  bool isSelectedForEdit(String id) => _selectedIdsForEdit.contains(id);

  /// Delete all selected items in edit mode
  Future<void> deleteSelectedItems() async {
    for (final id in _selectedIdsForEdit.toList()) {
      _coffeeItems.removeWhere((item) => item.id == id);
      await _coffeeRepository.deleteCoffeeItem(id);
    }
    _selectedIdsForEdit.clear();

    // Update normal selection if needed
    if (_selectedId.value != null &&
        !_coffeeItems.any((item) => item.id == _selectedId.value)) {
      _selectedId.value = visibleCoffeeItems.isNotEmpty
          ? visibleCoffeeItems.first.id
          : null;
    }
  }

  /// Toggle visibility of hidden beans section
  void toggleHiddenBeansSection() {
    _showHiddenBeans.value = !_showHiddenBeans.value;
  }

  /// Hide a coffee item (move to hidden section)
  Future<void> hideCoffee(String id) async {
    final index = _coffeeItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _coffeeItems[index];
      _coffeeItems[index] = item.copyWith(isHidden: true);
      _coffeeItems.refresh();
      await _coffeeRepository.updateCoffeeVisibility(id, true);

      // Update selection if hidden item was selected
      if (_selectedId.value == id) {
        _selectedId.value = visibleCoffeeItems.isNotEmpty
            ? visibleCoffeeItems.first.id
            : null;
      }
    }
  }

  /// Unhide a coffee item (restore from hidden section)
  Future<void> unhideCoffee(String id) async {
    final index = _coffeeItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _coffeeItems[index];
      _coffeeItems[index] = item.copyWith(isHidden: false);
      _coffeeItems.refresh();
      await _coffeeRepository.updateCoffeeVisibility(id, false);
    }
  }

  /// Hide all selected items in edit mode
  Future<void> hideSelectedItems() async {
    for (final id in _selectedIdsForEdit.toList()) {
      await hideCoffee(id);
    }
    _selectedIdsForEdit.clear();
  }

  /// Restore all hidden items
  Future<void> restoreAllHiddenItems() async {
    for (int i = 0; i < _coffeeItems.length; i++) {
      if (_coffeeItems[i].isHidden) {
        _coffeeItems[i] = _coffeeItems[i].copyWith(isHidden: false);
        await _coffeeRepository.updateCoffeeVisibility(
          _coffeeItems[i].id,
          false,
        );
      }
    }
  }

  /// Share selected items via system share sheet
  Future<void> shareSelectedItems() async {
    final selected = _coffeeItems
        .where((item) => _selectedIdsForEdit.contains(item.id))
        .toList();
    if (selected.isEmpty) return;

    final lines = selected.map((item) {
      final parts = <String>[item.name];
      if (item.origin != null) parts.add('산지: ${item.origin}');
      if (item.roastLevel != null) parts.add('로스팅: ${item.roastLevel}');
      final tags = item.allFlavorTags;
      if (tags.isNotEmpty) parts.add('향미: ${tags.join(', ')}');
      return parts.join('\n');
    });

    final text = lines.join('\n\n');
    await Share.share(text);
  }

  /// Select a coffee item
  void selectCoffee(String id) {
    _selectedId.value = id;
  }

  /// Delete a coffee item
  Future<void> deleteCoffee(String id) async {
    _coffeeItems.removeWhere((item) => item.id == id);
    await _coffeeRepository.deleteCoffeeItem(id);

    // Clear selection if deleted item was selected
    if (_selectedId.value == id) {
      _selectedId.value = _coffeeItems.isNotEmpty
          ? _coffeeItems.first.id
          : null;
    }
  }

  /// Reorder items
  Future<void> reorderItems(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _coffeeItems.removeAt(oldIndex);
    _coffeeItems.insert(newIndex, item);

    // Persist new order
    final orderedIds = _coffeeItems.map((i) => i.id).toList();
    await _coffeeRepository.reorderCoffeeItems(orderedIds);
  }

  /// Add new coffee - navigates to bean edit page
  Future<void> addNewCoffee() async {
    final result = await Get.toNamed(Routes.beanEdit);
    if (result is CoffeeItem) {
      await _coffeeRepository.addCoffeeItem(result);
      await _loadCoffeeItems();
    }
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
}
