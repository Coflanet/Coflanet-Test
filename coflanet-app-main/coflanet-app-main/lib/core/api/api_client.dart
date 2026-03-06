import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/repositories/repository_config.dart';

/// API Client using Dio for HTTP requests
/// Handles authentication, error handling, and request/response interceptors
class ApiClient extends GetxService {
  late final Dio _dio;
  final LocalStorage _storage = Get.find<LocalStorage>();

  /// Initialize the API client
  Future<ApiClient> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: RepositoryConfig.apiBaseUrl,
        connectTimeout: Duration(seconds: RepositoryConfig.apiTimeoutSeconds),
        receiveTimeout: Duration(seconds: RepositoryConfig.apiTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_authInterceptor());

    return this;
  }

  /// Auth interceptor - adds access token to requests
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized - try to refresh token
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the failed request
            final retryResponse = await _retry(error.requestOptions);
            return handler.resolve(retryResponse);
          }
        }
        return handler.next(error);
      },
    );
  }

  /// Refresh access token using refresh token
  Future<bool> _refreshToken() async {
    final refreshToken = _storage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      final newAccessToken = response.data['access_token'] as String?;
      final newRefreshToken = response.data['refresh_token'] as String?;

      if (newAccessToken != null) {
        await _storage.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await _storage.saveRefreshToken(newRefreshToken);
        }
        return true;
      }
    } catch (e) {
      // Token refresh failed - user needs to re-authenticate
      await _storage.clearTokens();
    }

    return false;
  }

  /// Retry a failed request with new token
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // ─── HTTP Methods ───

  /// GET request
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  /// POST request
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT request
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PATCH request
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE request
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

/// API Exception for handling errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';

  /// Create from Dio error
  factory ApiException.fromDioError(DioException error) {
    String message;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = '연결 시간이 초과되었습니다. 다시 시도해주세요.';
        break;
      case DioExceptionType.connectionError:
        message = '네트워크 연결을 확인해주세요.';
        break;
      case DioExceptionType.badResponse:
        message = _getMessageFromStatusCode(error.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = '요청이 취소되었습니다.';
        break;
      default:
        message = '알 수 없는 오류가 발생했습니다.';
    }

    return ApiException(
      message,
      statusCode: error.response?.statusCode,
      data: error.response?.data,
    );
  }

  static String _getMessageFromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '잘못된 요청입니다.';
      case 401:
        return '인증이 필요합니다.';
      case 403:
        return '접근 권한이 없습니다.';
      case 404:
        return '요청한 데이터를 찾을 수 없습니다.';
      case 500:
        return '서버 오류가 발생했습니다.';
      default:
        return '오류가 발생했습니다. (코드: $statusCode)';
    }
  }
}
