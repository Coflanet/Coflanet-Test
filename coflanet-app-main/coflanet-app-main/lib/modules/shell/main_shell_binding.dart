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

    // IMPORTANT: Check if CoffeeController already exists before creating new one
    // This preserves selectedBeanId when navigating back to MainShell
    if (!Get.isRegistered<CoffeeController>()) {
      Get.put<CoffeeController>(CoffeeController(), permanent: true);
    }

    // Other controllers can be safely recreated as they don't hold navigation state
    if (!Get.isRegistered<SelectCoffeeController>()) {
      Get.put<SelectCoffeeController>(SelectCoffeeController());
    }
    if (!Get.isRegistered<MyPlanetController>()) {
      Get.put<MyPlanetController>(MyPlanetController());
    }
    if (!Get.isRegistered<ExtractionListController>()) {
      Get.put<ExtractionListController>(ExtractionListController());
    }
    if (!Get.isRegistered<TastingNotesController>()) {
      Get.put<TastingNotesController>(TastingNotesController());
    }
  }
}
