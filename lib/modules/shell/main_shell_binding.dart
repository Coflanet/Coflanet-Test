import 'package:get/get.dart';
import 'package:coflanet/modules/shell/main_shell_controller.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/modules/home/home_controller.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainShellController>(MainShellController());

    // CoffeeController: selectedBeanId 보존 위해 permanent 유지
    if (!Get.isRegistered<CoffeeController>()) {
      Get.put<CoffeeController>(CoffeeController(), permanent: true);
    }

    // 탭 컨트롤러는 fenix 로 등록한다.
    // 비활성 탭의 컨트롤러가 SmartManagement 로 dispose 되어도,
    // 탭 재진입(설문 등 다른 화면 다녀온 뒤) 시 자동 재생성되어
    // "Controller not found" 를 방지한다.
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<SelectCoffeeController>(
      () => SelectCoffeeController(),
      fenix: true,
    );
    Get.lazyPut<MyPlanetController>(() => MyPlanetController(), fenix: true);
  }
}
