import 'package:get/get.dart';

/// 전역 GetX initialBinding placeholder.
///
/// 실제 의존성 (LocalStorage / ThemeController / AuthService / SurveyService /
/// ApiClient) 은 `main()` 에서 runApp 직전에 동기/await 등록한다.
/// 이유: `Get.putAsync` 는 initialBinding 컨텍스트에서 await 되지 않아
/// SplashController 가 SurveyService 등록 전에 onInit 실행 시 not found 에러 발생.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // 등록은 main() 에서 await 으로 보장됨
  }
}
