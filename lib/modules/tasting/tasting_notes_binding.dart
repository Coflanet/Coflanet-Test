import 'package:get/get.dart';
import 'package:coflanet/modules/tasting/tasting_notes_controller.dart';
import 'package:coflanet/modules/tasting/tasting_write_controller.dart';

/// 커피 저널 리스트 화면 바인딩.
class TastingNotesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TastingNotesController>(() => TastingNotesController());
  }
}

/// 시음 기록 작성 폼 바인딩.
class TastingWriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TastingWriteController>(() => TastingWriteController());
  }
}
