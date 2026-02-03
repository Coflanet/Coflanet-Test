import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/core/network/api_client.dart';

/// Global app bindings for dependency injection
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.put<LocalStorage>(LocalStorage(), permanent: true);
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Initialize API client
    Get.find<ApiClient>().init();
  }
}
