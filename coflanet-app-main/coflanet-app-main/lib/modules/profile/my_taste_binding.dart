import 'package:get/get.dart';
import 'package:coflanet/modules/profile/my_taste_controller.dart';

class MyTasteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTasteController>(() => MyTasteController());
  }
}
