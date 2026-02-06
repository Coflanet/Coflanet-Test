import 'package:get/get.dart';
import 'package:coflanet/modules/tasting/tasting_notes_controller.dart';

class TastingNotesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TastingNotesController>(() => TastingNotesController());
  }
}
