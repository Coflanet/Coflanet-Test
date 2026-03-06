import 'package:get/get.dart';
import 'package:coflanet/modules/coffee/espresso/espresso_settings_controller.dart';

/// Binding for EspressoSettingsView
class EspressoSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EspressoSettingsController>(() => EspressoSettingsController());
  }
}
