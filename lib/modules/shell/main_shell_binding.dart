import 'package:get/get.dart';
import 'package:coflanet/modules/shell/main_shell_controller.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';
import 'package:coflanet/modules/extraction/extraction_list_controller.dart';
import 'package:coflanet/modules/tasting/tasting_notes_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellController>(() => MainShellController());
    Get.lazyPut<CoffeeController>(() => CoffeeController());
    Get.lazyPut<MyPlanetController>(() => MyPlanetController());
    Get.lazyPut<ExtractionListController>(() => ExtractionListController());
    Get.lazyPut<TastingNotesController>(() => TastingNotesController());
  }
}
