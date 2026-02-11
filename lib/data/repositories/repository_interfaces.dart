import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/data/models/timer_step_model.dart';

/// Repository interfaces for data access abstraction
/// Allows switching between Dummy (local) and API (remote) implementations

// ─────────────────────────────────────────────────────────────────────────────
// Survey Repository
// ─────────────────────────────────────────────────────────────────────────────

/// Repository for survey-related data operations
abstract class SurveyRepository {
  /// Get all survey questions
  Future<List<SurveyQuestionModel>> getQuestions();

  /// Get survey result for current user
  Future<SurveyResultModel?> getSurveyResult();

  /// Save survey result
  Future<void> saveSurveyResult(SurveyResultModel result);

  /// Clear survey result
  Future<void> clearSurveyResult();

  /// Generate survey result from answers (for dummy implementation)
  /// API implementation would send answers to server and receive result
  Future<SurveyResultModel> generateResult(Map<int, List<String>> answers);

  /// Save survey answers (step -> selected option IDs)
  Future<void> saveSurveyAnswers(Map<String, dynamic> answers);

  /// Get saved survey answers
  Future<Map<String, dynamic>?> getSurveyAnswers();

  /// Save selected bean IDs from survey result
  Future<void> saveSelectedBeanIds(List<String> ids);

  /// Get selected bean IDs
  Future<List<String>?> getSelectedBeanIds();

  /// Save survey reasons (why user joined)
  Future<void> saveSurveyReasons(List<String> reasons);
}

// ─────────────────────────────────────────────────────────────────────────────
// Coffee Repository
// ─────────────────────────────────────────────────────────────────────────────

/// Repository for coffee bean data operations
abstract class CoffeeRepository {
  /// Get all coffee items
  Future<List<CoffeeItem>> getCoffeeItems();

  /// Get a single coffee item by ID
  Future<CoffeeItem?> getCoffeeItemById(String id);

  /// Add a new coffee item
  Future<void> addCoffeeItem(CoffeeItem item);

  /// Update an existing coffee item
  Future<void> updateCoffeeItem(CoffeeItem item);

  /// Delete a coffee item
  Future<void> deleteCoffeeItem(String id);

  /// Update coffee item visibility (hide/unhide)
  Future<void> updateCoffeeVisibility(String id, bool isHidden);

  /// Reorder coffee items
  Future<void> reorderCoffeeItems(List<String> orderedIds);

  /// Save coffee items list (for local persistence)
  Future<void> saveCoffeeItems(List<CoffeeItem> items);
}

// ─────────────────────────────────────────────────────────────────────────────
// Recipe Repository
// ─────────────────────────────────────────────────────────────────────────────

/// Repository for coffee recipe/timer data operations
abstract class RecipeRepository {
  /// Get recipe by coffee type (handDrip, espresso, etc.)
  Future<TimerRecipeModel?> getRecipeByType(String coffeeType);

  /// Get all available recipes
  Future<List<TimerRecipeModel>> getAllRecipes();

  /// Get recipe by ID
  Future<TimerRecipeModel?> getRecipeById(String id);

  /// Save a custom recipe
  Future<void> saveRecipe(TimerRecipeModel recipe);

  /// Delete a recipe
  Future<void> deleteRecipe(String id);

  /// Get user's saved/favorite recipes
  Future<List<TimerRecipeModel>> getSavedRecipes();

  /// Add recipe to saved/favorites
  Future<void> addToSavedRecipes(String recipeId);

  /// Remove recipe from saved/favorites
  Future<void> removeFromSavedRecipes(String recipeId);
}

// ─────────────────────────────────────────────────────────────────────────────
// User Preferences Repository
// ─────────────────────────────────────────────────────────────────────────────

/// Repository for user preferences and settings
abstract class UserPreferencesRepository {
  /// Check if onboarding is complete
  Future<bool> isOnboardingComplete();

  /// Set onboarding complete status
  Future<void> setOnboardingComplete(bool complete);

  /// Check if dark mode is enabled
  Future<bool> isDarkMode();

  /// Set dark mode preference
  Future<void> setDarkMode(bool isDark);

  /// Get user name
  Future<String?> getUserName();

  /// Save user name
  Future<void> saveUserName(String name);

  /// Get user ID
  Future<String?> getUserId();

  /// Save user ID
  Future<void> saveUserId(String id);

  /// Clear all user preferences
  Future<void> clearAll();
}
