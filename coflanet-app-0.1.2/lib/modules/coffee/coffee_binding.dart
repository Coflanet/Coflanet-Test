import 'package:get/get.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';

class CoffeeBinding extends Bindings {
  @override
  void dependencies() {
    // Use lazyPut to preserve existing controller if already registered
    // This prevents overwriting selectedBeanId when navigating
    if (!Get.isRegistered<CoffeeController>()) {
      Get.put<CoffeeController>(CoffeeController());
    }
  }
}
