import 'package:get/get.dart';
import 'package:coflanet/modules/coffee/timer/coffee_timer_controller.dart';

class CoffeeTimerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoffeeTimerController>(() => CoffeeTimerController());
  }
}
