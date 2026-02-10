import 'package:get/get.dart';
import 'package:coflanet/modules/shell/main_shell_controller.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';
import 'package:coflanet/modules/extraction/extraction_list_controller.dart';
import 'package:coflanet/modules/tasting/tasting_notes_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    // Use put instead of lazyPut to ensure controllers are initialized immediately
    // This prevents race conditions when accessing controllers in the view
    Get.put<MainShellController>(MainShellController());
    Get.put<CoffeeController>(CoffeeController(), permanent: true);
    Get.put<SelectCoffeeController>(SelectCoffeeController());
    Get.put<MyPlanetController>(MyPlanetController());
    Get.put<ExtractionListController>(ExtractionListController());
    Get.put<TastingNotesController>(TastingNotesController());
  }
}
