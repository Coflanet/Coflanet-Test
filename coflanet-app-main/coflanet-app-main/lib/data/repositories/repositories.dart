/// Barrel export for all repository files
library repositories;

export 'repository_interfaces.dart';
export 'repository_config.dart';
export 'repository_provider.dart';

// Dummy implementations
export 'dummy/dummy_brew_log_repository.dart';
export 'dummy/dummy_survey_repository.dart';
export 'dummy/dummy_coffee_repository.dart';
export 'dummy/dummy_recipe_repository.dart';
export 'dummy/dummy_user_preferences_repository.dart';

// Supabase implementations
export 'supabase/supabase_auth_repository.dart';
export 'supabase/supabase_brew_log_repository.dart';
export 'supabase/supabase_survey_repository.dart';
export 'supabase/supabase_coffee_repository.dart';
export 'supabase/supabase_recipe_repository.dart';
export 'supabase/supabase_user_preferences_repository.dart';

// API implementations
export 'api/api_survey_repository.dart';
export 'api/api_coffee_repository.dart';
export 'api/api_recipe_repository.dart';
export 'api/api_user_preferences_repository.dart';
