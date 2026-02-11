/// Configuration for repository implementations
/// Controls whether to use dummy (local) or API (remote) data sources
class RepositoryConfig {
  RepositoryConfig._();

  /// Whether to use dummy data instead of API
  /// Set to false when API is ready for production
  static const bool useDummyData = true;

  /// API base URL (used when useDummyData is false)
  static const String apiBaseUrl = 'https://api.coflanet.com/v1';

  /// Timeout for API requests in seconds
  static const int apiTimeoutSeconds = 30;

  /// Whether to cache API responses locally
  static const bool enableLocalCache = true;

  /// Cache expiration time in minutes
  static const int cacheExpirationMinutes = 60;
}
