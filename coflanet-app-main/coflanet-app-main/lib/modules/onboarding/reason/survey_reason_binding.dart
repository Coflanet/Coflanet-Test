import 'package:get/get.dart';
import 'package:coflanet/modules/onboarding/reason/survey_reason_controller.dart';

/// Binding for Survey Reason screen
class SurveyReasonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SurveyReasonController());
  }
}
