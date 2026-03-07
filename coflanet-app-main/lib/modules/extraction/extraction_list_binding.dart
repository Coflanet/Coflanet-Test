import 'package:get/get.dart';
import 'package:coflanet/modules/extraction/extraction_list_controller.dart';

class ExtractionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExtractionListController>(() => ExtractionListController());
  }
}
