import 'package:get/get.dart';

/// Base controller with common functionality for all controllers
abstract class BaseController extends GetxController {
  /// Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  /// Error message
  final _errorMessage = Rxn<String>();
  String? get errorMessage => _errorMessage.value;
  set errorMessage(String? value) => _errorMessage.value = value;

  /// Success state
  final _isSuccess = false.obs;
  bool get isSuccess => _isSuccess.value;
  set isSuccess(bool value) => _isSuccess.value = value;

  /// Clear error message
  void clearError() {
    _errorMessage.value = null;
  }

  /// Show loading state
  void showLoading() {
    _isLoading.value = true;
    clearError();
  }

  /// Hide loading state
  void hideLoading() {
    _isLoading.value = false;
  }

  /// Set error state
  void setError(String message) {
    _errorMessage.value = message;
    _isLoading.value = false;
  }

  /// Execute an async operation with loading state
  Future<T?> executeWithLoading<T>(Future<T> Function() operation) async {
    try {
      showLoading();
      final result = await operation();
      hideLoading();
      return result;
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }

  /// Validate required fields
  bool validateRequired(Map<String, dynamic> fields) {
    for (final entry in fields.entries) {
      if (entry.value == null ||
          (entry.value is String && (entry.value as String).isEmpty)) {
        setError('${entry.key}은(는) 필수 입력 항목입니다.');
        return false;
      }
    }
    return true;
  }
}
