import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/tasting_note_model.dart';

/// 커피 저널(시음 노트) 컨트롤러 — 로컬 저장 기반 reactive 리스트.
class TastingNotesController extends BaseController {
  final LocalStorage _storage = LocalStorage();

  /// 저장된 시음 노트 (최신순)
  final RxList<TastingNoteModel> notes = <TastingNoteModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  /// 저장소에서 노트 목록을 다시 읽어 reactive 리스트에 반영.
  void loadNotes() {
    notes.assignAll(_storage.getTastingNotes());
  }

  /// 노트 추가 후 목록 갱신.
  Future<void> addNote(TastingNoteModel note) async {
    await _storage.addTastingNote(note);
    loadNotes();
  }

  /// 노트 삭제 후 목록 갱신.
  Future<void> deleteNote(String id) async {
    await _storage.deleteTastingNote(id);
    loadNotes();
  }
}
