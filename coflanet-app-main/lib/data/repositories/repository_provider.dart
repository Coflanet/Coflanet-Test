import 'package:coflanet/data/repositories/repository_config.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
// Dummy implementations
import 'package:coflanet/data/repositories/dummy/dummy_auth_repository.dart';
import 'package:coflanet/data/repositories/dummy/dummy_brew_log_repository.dart';
import 'package:coflanet/data/repositories/dummy/dummy_survey_repository.dart';
import 'package:coflanet/data/repositories/dummy/dummy_coffee_repository.dart';
import 'package:coflanet/data/repositories/dummy/dummy_recipe_repository.dart';
import 'package:coflanet/data/repositories/dummy/dummy_user_preferences_repository.dart';
// Supabase implementations
import 'package:coflanet/data/repositories/supabase/supabase_auth_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_brew_log_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_survey_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_coffee_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_recipe_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_user_preferences_repository.dart';
// API implementations
import 'package:coflanet/data/repositories/api/api_auth_repository.dart';
import 'package:coflanet/data/repositories/api/api_survey_repository.dart';
import 'package:coflanet/data/repositories/api/api_coffee_repository.dart';
import 'package:coflanet/data/repositories/api/api_recipe_repository.dart';
import 'package:coflanet/data/repositories/api/api_user_preferences_repository.dart';

/// Provider for repository instances
/// Returns dummy, supabase, or API implementations based on RepositoryConfig
class RepositoryProvider {
  RepositoryProvider._();

  static AuthRepository? _authRepository;
  static SurveyRepository? _surveyRepository;
  static CoffeeRepository? _coffeeRepository;
  static RecipeRepository? _recipeRepository;
  static UserPreferencesRepository? _userPreferencesRepository;
  static BrewLogRepository? _brewLogRepository;

  /// Get AuthRepository instance
  static AuthRepository get authRepository {
    _authRepository ??= switch (RepositoryConfig.dataSource) {
      DataSource.dummy => DummyAuthRepository(),
      DataSource.supabase => SupabaseAuthRepository(),
      DataSource.api => ApiAuthRepository(),
    };
    return _authRepository!;
  }

  /// Get SurveyRepository instance
  static SurveyRepository get surveyRepository {
    _surveyRepository ??= switch (RepositoryConfig.dataSource) {
      DataSource.dummy => DummySurveyRepository(),
      DataSource.supabase => SupabaseSurveyRepository(),
      DataSource.api => ApiSurveyRepository(),
    };
    return _surveyRepository!;
  }

  /// Get CoffeeRepository instance
  static CoffeeRepository get coffeeRepository {
    _coffeeRepository ??= switch (RepositoryConfig.dataSource) {
      DataSource.dummy => DummyCoffeeRepository(),
      DataSource.supabase => SupabaseCoffeeRepository(),
      DataSource.api => ApiCoffeeRepository(),
    };
    return _coffeeRepository!;
  }

  /// Get RecipeRepository instance
  static RecipeRepository get recipeRepository {
    _recipeRepository ??= switch (RepositoryConfig.dataSource) {
      DataSource.dummy => DummyRecipeRepository(),
      DataSource.supabase => SupabaseRecipeRepository(),
      DataSource.api => ApiRecipeRepository(),
    };
    return _recipeRepository!;
  }

  /// Get UserPreferencesRepository instance
  static UserPreferencesRepository get userPreferencesRepository {
    _userPreferencesRepository ??= switch (RepositoryConfig.dataSource) {
      DataSource.dummy => DummyUserPreferencesRepository(),
      DataSource.supabase => SupabaseUserPreferencesRepository(),
      DataSource.api => ApiUserPreferencesRepository(),
    };
    return _userPreferencesRepository!;
  }

  /// Get BrewLogRepository instance
  static BrewLogRepository get brewLogRepository {
    _brewLogRepository ??= switch (RepositoryConfig.dataSource) {
      DataSource.dummy => DummyBrewLogRepository(),
      DataSource.supabase => SupabaseBrewLogRepository(),
      DataSource.api => DummyBrewLogRepository(), // API stub uses dummy
    };
    return _brewLogRepository!;
  }

  /// Reset all repositories (useful for testing)
  static void reset() {
    _authRepository = null;
    _surveyRepository = null;
    _coffeeRepository = null;
    _recipeRepository = null;
    _userPreferencesRepository = null;
    _brewLogRepository = null;
  }
}
