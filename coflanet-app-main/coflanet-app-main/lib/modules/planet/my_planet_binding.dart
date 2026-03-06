import 'package:get/get.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';

class MyPlanetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPlanetController>(() => MyPlanetController());
  }
}
