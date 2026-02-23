/// Data source type for repository implementations
enum DataSource { dummy, supabase, api }

/// Configuration for repository implementations
/// Controls which data source (dummy/supabase/api) is used
class RepositoryConfig {
  RepositoryConfig._();

  /// Current data source (change this one line to switch)
  static const DataSource dataSource = DataSource.supabase;

  /// API base URL (used when dataSource is api)
  static const String apiBaseUrl = 'https://api.coflanet.com/v1';

  /// Timeout for API requests in seconds
  static const int apiTimeoutSeconds = 30;

  /// Whether to cache API responses locally
  static const bool enableLocalCache = true;

  /// Cache expiration time in minutes
  static const int cacheExpirationMinutes = 60;
}
