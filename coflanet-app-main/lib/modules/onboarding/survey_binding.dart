import 'package:get/get.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';

class SurveyBinding extends Bindings {
  @override
  void dependencies() {
    // Use permanent to keep controller alive across survey screens
    Get.put<SurveyController>(SurveyController(), permanent: true);
  }
}
