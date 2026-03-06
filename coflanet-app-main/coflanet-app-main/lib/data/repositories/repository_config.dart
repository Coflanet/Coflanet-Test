/// Data source type for repository implementations
enum DataSource { dummy, supabase, api }

/// Configuration for repository implementations
/// Controls which data source (dummy/supabase/api) is used
class RepositoryConfig {
  RepositoryConfig._();

  /// CI test mode (passed via --dart-define=CI_TEST=true)
  static const bool isCiTest = bool.fromEnvironment('CI_TEST');

  /// Current data source (change this one line to switch)
  /// In CI test mode, always use dummy to avoid external dependencies
  static const DataSource dataSource = isCiTest
      ? DataSource.dummy
      : DataSource.supabase;

  /// API base URL (used when dataSource is api)
  static const String apiBaseUrl = 'https://api.coflanet.com/v1';

  /// Timeout for API requests in seconds
  static const int apiTimeoutSeconds = 30;

  /// Whether to cache API responses locally
  static const bool enableLocalCache = true;

  /// Cache expiration time in minutes
  static const int cacheExpirationMinutes = 60;
}
