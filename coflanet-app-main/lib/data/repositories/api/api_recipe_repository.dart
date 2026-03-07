import 'package:coflanet/core/api/api_client.dart';
import 'package:coflanet/data/models/timer_step_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';

/// API implementation of RecipeRepository
/// Connects to backend API for recipe data
class ApiRecipeRepository implements RecipeRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // API endpoints
  static const String _baseEndpoint = '/recipes';
  static const String _savedEndpoint = '/recipes/saved';

  @override
  Future<TimerRecipeModel?> getRecipeByType(
    String coffeeType, {
    String? beanId,
  }) async {
    try {
      final response = await _apiClient.get('$_baseEndpoint/type/$coffeeType');
      if (response.data != null && response.data['recipe'] != null) {
        return TimerRecipeModel.fromJson(response.data['recipe']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<TimerRecipeModel>> getAllRecipes() async {
    try {
      final response = await _apiClient.get(_baseEndpoint);
      final List<dynamic> data = response.data['recipes'];
      return data.map((e) => TimerRecipeModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TimerRecipeModel?> getRecipeById(String id) async {
    try {
      final response = await _apiClient.get('$_baseEndpoint/$id');
      if (response.data != null && response.data['recipe'] != null) {
        return TimerRecipeModel.fromJson(response.data['recipe']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveRecipe(TimerRecipeModel recipe) async {
    try {
      await _apiClient.post(_baseEndpoint, data: recipe.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    try {
      await _apiClient.delete('$_baseEndpoint/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TimerRecipeModel>> getSavedRecipes() async {
    try {
      final response = await _apiClient.get(_savedEndpoint);
      final List<dynamic> data = response.data['recipes'];
      return data.map((e) => TimerRecipeModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addToSavedRecipes(String recipeId) async {
    try {
      await _apiClient.post('$_savedEndpoint/$recipeId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromSavedRecipes(String recipeId) async {
    try {
      await _apiClient.delete('$_savedEndpoint/$recipeId');
    } catch (e) {
      rethrow;
    }
  }
}
