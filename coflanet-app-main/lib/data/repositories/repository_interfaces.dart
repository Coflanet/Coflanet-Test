import 'package:coflanet/data/models/brew_log_model.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/data/models/timer_step_model.dart';
import 'package:coflanet/data/models/user_model.dart';
import 'package:coflanet/data/providers/auth_provider.dart';

/// Repository interfaces for data access abstraction
/// Allows switching between Dummy (local) and API (remote) implementations

// ─────────────────────────────────────────────────────────────────────────────
// Auth Repository
// ─────────────────────────────────────────────────────────────────────────────

/// Repository for authentication and user management
/// Handles server-side token exchange after social login
abstract class AuthRepository {
  /// Exchange social login token for server JWT
  ///
  /// After getting token from social SDK, send to server for validation
  /// and receive server's own JWT tokens.
  ///
  /// [socialToken] - Access token from social provider (Kakao/Naver/Apple)
  /// [provider] - Social login provider type
  /// [socialUser] - User info from social SDK (optional, for registration)
  ///
  /// Returns [UserModel] with server JWT tokens
  Future<UserModel> exchangeToken({
    required String socialToken,
    required SocialLoginType provider,
    UserModel? socialUser,
  });

  /// Refresh server access token using refresh token
  Future<UserModel?> refreshToken(String refreshToken);

  /// Logout from server (invalidate tokens)
  Future<void> logout();

  /// Delete account from server (회원탈퇴)
  Future<void> deleteAccount();

  /// Get current user info from server
  Future<UserModel?> getCurrentUser();

  /// Update user profile on server
  Future<UserModel> updateProfile({String? name, String? profileImageUrl});
}

// ─────────────────────────────────────────────────────────────────────────────
// Survey Repository
// ─────────────────────────────────────────────────────────────────────────────

/// Repository for survey-related data operations
abstract class SurveyRepository {
  /// Get survey questions by type ('standard' or 'lifestyle')
  Future<List<SurveyQuestionModel>> getQuestions({String type = 'standard'});

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

  /// Start a new survey session on the server
  Future<Map<String, dynamic>> startSurvey({String surveyType = 'standard'});

  /// Save answers for current survey step to server
  Future<Map<String, dynamic>> saveSurveyStepAnswers(
    String sessionId,
    List<Map<String, dynamic>> answers,
  );

  /// Complete a survey session on the server
  Future<Map<String, dynamic>> completeSurvey(String sessionId);
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

  /// Add a bean to user's coffee list (from catalog)
  /// [addedFrom] must be: 'recommendation', 'search', or 'manual'
  Future<Map<String, dynamic>> addToCoffeeList(
    String beanId, {
    String addedFrom = 'manual',
  });

  /// Get coffee catalog with optional filters
  Future<Map<String, dynamic>> getCoffeeCatalog({
    Map<String, dynamic>? filters,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Recipe Repository
// ─────────────────────────────────────────────────────────────────────────────

/// Repository for coffee recipe/timer data operations
abstract class RecipeRepository {
  /// Get recipe by coffee type (handDrip, espresso, etc.)
  /// [beanId] optional bean ID for bean-specific custom recipe
  Future<TimerRecipeModel?> getRecipeByType(
    String coffeeType, {
    String? beanId,
  });

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

// ─────────────────────────────────────────────────────────────────────────────
// Brew Log Repository
// ─────────────────────────────────────────────────────────────────────────────

/// Repository for brew log (extraction history) operations
abstract class BrewLogRepository {
  /// Save a new brew log entry
  Future<Map<String, dynamic>> saveBrewLog(Map<String, dynamic> values);

  /// Get paginated list of user's brew logs
  Future<List<BrewLogModel>> getMyBrewLogs({int limit = 20, int offset = 0});

  /// Update an existing brew log entry
  Future<void> updateBrewLog(String logId, Map<String, dynamic> values);

  /// Delete a brew log entry
  Future<void> deleteBrewLog(String logId);

  /// Get user's brewing statistics
  Future<Map<String, dynamic>?> getMyBrewStats();
}
