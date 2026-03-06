import 'package:get/get.dart';
import 'package:coflanet/modules/auth/signin/signin_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}
