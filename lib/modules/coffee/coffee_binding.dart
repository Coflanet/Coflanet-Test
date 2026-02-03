import 'package:get/get.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';

class CoffeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CoffeeController>(CoffeeController(), permanent: true);
  }
}
