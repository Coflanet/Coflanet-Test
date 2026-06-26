import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/tasting_note_model.dart';
import 'package:coflanet/modules/tasting/tasting_notes_controller.dart';

/// 시음 기록 작성 폼 컨트롤러 — 입력 상태 보유 + 저장.
class TastingWriteController extends BaseController {
  final LocalStorage _storage = LocalStorage();

  /// 원두명 입력
  final TextEditingController beanNameController = TextEditingController();

  /// 메모 입력
  final TextEditingController memoController = TextEditingController();

  /// 별점 (0=미선택 ~ 5)
  final rating = 0.obs;

  /// 원두명 (저장 가능 여부 reactive 판단용 — 텍스트필드 onChanged 로 동기화)
  final beanName = ''.obs;

  /// 맛 5축 값 (0~5)
  final RxMap<String, double> tasteValues =
      RxMap<String, double>(TastingNoteModel.defaultTasteValues);

  /// 선택된 향미 태그
  final RxSet<String> selectedTags = <String>{}.obs;

  /// 저장 가능 여부 — 원두명과 별점은 필수. ([beanName]/[rating] reactive).
  bool get canSave => beanName.value.trim().isNotEmpty && rating.value > 0;

  void setRating(int value) => rating.value = value;

  void setTaste(String key, double value) {
    tasteValues[key] = value;
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  /// 폼 입력으로 노트를 만들어 저장하고 리스트 화면을 갱신한 뒤 닫는다.
  Future<void> save() async {
    if (!canSave) return;

    final note = TastingNoteModel(
      id: 'note_${DateTime.now().microsecondsSinceEpoch}',
      beanName: beanNameController.text.trim(),
      date: DateTime.now(),
      rating: rating.value,
      tasteValues: Map<String, double>.from(tasteValues),
      flavorTags: selectedTags.toList(),
      memo: memoController.text.trim(),
    );

    await _storage.addTastingNote(note);

    // 리스트 컨트롤러가 떠 있으면 즉시 갱신 (저널 → 작성 진입 동선).
    if (Get.isRegistered<TastingNotesController>()) {
      Get.find<TastingNotesController>().loadNotes();
    }

    Get.back();
  }

  @override
  void onClose() {
    beanNameController.dispose();
    memoController.dispose();
    super.onClose();
  }
}
