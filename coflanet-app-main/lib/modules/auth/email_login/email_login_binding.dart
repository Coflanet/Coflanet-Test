import 'package:get/get.dart';
import 'package:coflanet/modules/auth/email_login/email_login_controller.dart';

class EmailLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailLoginController>(() => EmailLoginController());
  }
}
