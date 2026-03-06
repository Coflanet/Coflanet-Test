import 'dart:convert';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/dummy/dummy_timer_data.dart';
import 'package:coflanet/data/models/timer_step_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';

/// Dummy implementation of RecipeRepository
/// Uses local storage for custom recipes and dummy data for built-in recipes
class DummyRecipeRepository implements RecipeRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();

  static const String _customRecipesKey = 'custom_recipes';
  static const String _savedRecipeIdsKey = 'saved_recipe_ids';

  /// Built-in recipe IDs (from DummyTimerData)
  static const List<String> _builtInRecipeIds = [
    'hand_drip_basic',
    'espresso_single',
    'espresso_double',
    'moka_pot_basic',
    'french_press_basic',
    'aeropress_basic',
    'cold_brew_basic',
    'chemex_basic',
    'siphon_basic',
    'turkish_basic',
    'vietnamese_basic',
    'clever_dripper_basic',
  ];

  @override
  Future<TimerRecipeModel?> getRecipeByType(
    String coffeeType, {
    String? beanId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return DummyTimerData.getRecipe(coffeeType);
  }

  @override
  Future<List<TimerRecipeModel>> getAllRecipes() async {
    // Get built-in recipes
    final builtInRecipes = <TimerRecipeModel>[
      DummyTimerData.handDripRecipe,
      DummyTimerData.espressoRecipe,
      DummyTimerData.espressoDoubleRecipe,
      DummyTimerData.mokaPotRecipe,
      DummyTimerData.frenchPressRecipe,
      DummyTimerData.aeropressRecipe,
      DummyTimerData.coldBrewRecipe,
      DummyTimerData.chemexRecipe,
      DummyTimerData.siphonRecipe,
      DummyTimerData.turkishRecipe,
      DummyTimerData.vietnameseRecipe,
      DummyTimerData.cleverDripperRecipe,
    ];

    // Get custom recipes from storage
    final customRecipes = await _getCustomRecipes();

    return [...builtInRecipes, ...customRecipes];
  }

  @override
  Future<TimerRecipeModel?> getRecipeById(String id) async {
    // Check built-in recipes first
    if (_builtInRecipeIds.contains(id)) {
      return _getBuiltInRecipeById(id);
    }

    // Check custom recipes
    final customRecipes = await _getCustomRecipes();
    return customRecipes.firstWhereOrNull((r) => r.id == id);
  }

  @override
  Future<void> saveRecipe(TimerRecipeModel recipe) async {
    final customRecipes = await _getCustomRecipes();

    // Update if exists, otherwise add
    final index = customRecipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      customRecipes[index] = recipe;
    } else {
      customRecipes.add(recipe);
    }

    await _saveCustomRecipes(customRecipes);
  }

  @override
  Future<void> deleteRecipe(String id) async {
    // Cannot delete built-in recipes
    if (_builtInRecipeIds.contains(id)) {
      return;
    }

    final customRecipes = await _getCustomRecipes();
    customRecipes.removeWhere((r) => r.id == id);
    await _saveCustomRecipes(customRecipes);

    // Also remove from saved recipes
    await removeFromSavedRecipes(id);
  }

  @override
  Future<List<TimerRecipeModel>> getSavedRecipes() async {
    final savedIds = await _getSavedRecipeIds();
    final allRecipes = await getAllRecipes();

    return allRecipes.where((r) => savedIds.contains(r.id)).toList();
  }

  @override
  Future<void> addToSavedRecipes(String recipeId) async {
    final savedIds = await _getSavedRecipeIds();
    if (!savedIds.contains(recipeId)) {
      savedIds.add(recipeId);
      await _storage.write(_savedRecipeIdsKey, savedIds);
    }
  }

  @override
  Future<void> removeFromSavedRecipes(String recipeId) async {
    final savedIds = await _getSavedRecipeIds();
    savedIds.remove(recipeId);
    await _storage.write(_savedRecipeIdsKey, savedIds);
  }

  // ─── Private helpers ───

  Future<List<TimerRecipeModel>> _getCustomRecipes() async {
    final data = _storage.read<String>(_customRecipesKey);
    if (data == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList
          .map((e) => TimerRecipeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveCustomRecipes(List<TimerRecipeModel> recipes) async {
    final jsonList = recipes.map((r) => r.toJson()).toList();
    await _storage.write(_customRecipesKey, json.encode(jsonList));
  }

  Future<List<String>> _getSavedRecipeIds() async {
    final data = _storage.read<List<dynamic>>(_savedRecipeIdsKey);
    return data?.cast<String>() ?? [];
  }

  TimerRecipeModel? _getBuiltInRecipeById(String id) {
    switch (id) {
      case 'hand_drip_basic':
        return DummyTimerData.handDripRecipe;
      case 'espresso_single':
        return DummyTimerData.espressoRecipe;
      case 'espresso_double':
        return DummyTimerData.espressoDoubleRecipe;
      case 'moka_pot_basic':
        return DummyTimerData.mokaPotRecipe;
      case 'french_press_basic':
        return DummyTimerData.frenchPressRecipe;
      case 'aeropress_basic':
        return DummyTimerData.aeropressRecipe;
      case 'cold_brew_basic':
        return DummyTimerData.coldBrewRecipe;
      case 'chemex_basic':
        return DummyTimerData.chemexRecipe;
      case 'siphon_basic':
        return DummyTimerData.siphonRecipe;
      case 'turkish_basic':
        return DummyTimerData.turkishRecipe;
      case 'vietnamese_basic':
        return DummyTimerData.vietnameseRecipe;
      case 'clever_dripper_basic':
        return DummyTimerData.cleverDripperRecipe;
      default:
        return null;
    }
  }
}
