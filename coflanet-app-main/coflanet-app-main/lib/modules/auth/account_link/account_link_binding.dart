import 'package:get/get.dart';
import 'package:coflanet/modules/auth/account_link/account_link_controller.dart';

class AccountLinkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountLinkController());
  }
}
