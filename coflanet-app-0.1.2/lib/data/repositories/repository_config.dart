/// Data source type for repository implementations
enum DataSource { dummy, supabase, api }

/// Configuration for repository implementations
/// Controls which data source (dummy/supabase/api) is used
class RepositoryConfig {
  RepositoryConfig._();

  /// CI test mode (passed via --dart-define=CI_TEST=true)
  static const bool isCiTest = bool.fromEnvironment('CI_TEST');

  /// Dev menu mode — true로 바꾸면 앱 시작 시 Dev Menu가 먼저 뜹니다.
  /// 원하는 화면을 골라서 바로 이동할 수 있습니다.
  static const bool devMenuEnabled = bool.fromEnvironment(
    'DEV_MENU',
    defaultValue: true,
  );

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
