import 'package:get/get.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';

class SelectCoffeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectCoffeeController>(() => SelectCoffeeController());
  }
}
