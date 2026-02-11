import 'package:coflanet/data/repositories/repository_config.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
// Dummy implementations
import 'package:coflanet/data/repositories/dummy/dummy_survey_repository.dart';
import 'package:coflanet/data/repositories/dummy/dummy_coffee_repository.dart';
import 'package:coflanet/data/repositories/dummy/dummy_recipe_repository.dart';
import 'package:coflanet/data/repositories/dummy/dummy_user_preferences_repository.dart';
// API implementations
import 'package:coflanet/data/repositories/api/api_survey_repository.dart';
import 'package:coflanet/data/repositories/api/api_coffee_repository.dart';
import 'package:coflanet/data/repositories/api/api_recipe_repository.dart';
import 'package:coflanet/data/repositories/api/api_user_preferences_repository.dart';

/// Provider for repository instances
/// Returns dummy or API implementations based on RepositoryConfig
class RepositoryProvider {
  RepositoryProvider._();

  static SurveyRepository? _surveyRepository;
  static CoffeeRepository? _coffeeRepository;
  static RecipeRepository? _recipeRepository;
  static UserPreferencesRepository? _userPreferencesRepository;

  /// Get SurveyRepository instance
  static SurveyRepository get surveyRepository {
    _surveyRepository ??= RepositoryConfig.useDummyData
        ? DummySurveyRepository()
        : ApiSurveyRepository();
    return _surveyRepository!;
  }

  /// Get CoffeeRepository instance
  static CoffeeRepository get coffeeRepository {
    _coffeeRepository ??= RepositoryConfig.useDummyData
        ? DummyCoffeeRepository()
        : ApiCoffeeRepository();
    return _coffeeRepository!;
  }

  /// Get RecipeRepository instance
  static RecipeRepository get recipeRepository {
    _recipeRepository ??= RepositoryConfig.useDummyData
        ? DummyRecipeRepository()
        : ApiRecipeRepository();
    return _recipeRepository!;
  }

  /// Get UserPreferencesRepository instance
  static UserPreferencesRepository get userPreferencesRepository {
    _userPreferencesRepository ??= RepositoryConfig.useDummyData
        ? DummyUserPreferencesRepository()
        : ApiUserPreferencesRepository();
    return _userPreferencesRepository!;
  }

  /// Reset all repositories (useful for testing)
  static void reset() {
    _surveyRepository = null;
    _coffeeRepository = null;
    _recipeRepository = null;
    _userPreferencesRepository = null;
  }
}
