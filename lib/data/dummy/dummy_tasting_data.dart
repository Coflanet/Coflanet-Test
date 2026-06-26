import 'package:coflanet/data/models/tasting_note_model.dart';

/// 시음 노트(커피 저널) 더미 데이터.
///
/// 앱 첫 실행 시 저널이 비지 않도록 시드한다(이미 데이터가 있으면 스킵 —
/// 시드 여부는 [LocalStorage] 가 판단).
class DummyTastingData {
  DummyTastingData._();

  /// 작성 폼의 향미 태그 후보 (다중 선택)
  static const List<String> flavorTagCandidates = [
    '과일향',
    '꽃향',
    '견과류',
    '초콜릿',
    '캐러멜',
    '시트러스',
    '베리',
    '자스민',
    '바닐라',
    '꿀',
    '스모키',
    '와인',
  ];

  /// 첫 실행 시드 노트 (최신순)
  static List<TastingNoteModel> seedNotes() {
    final now = DateTime.now();
    return [
      TastingNoteModel(
        id: 'seed_1',
        beanName: '에티오피아 예가체프',
        date: now.subtract(const Duration(days: 1)),
        rating: 5,
        tasteValues: const {
          'acidity': 4.2,
          'body': 2.4,
          'sweetness': 3.8,
          'bitterness': 1.6,
          'balance': 4.0,
        },
        flavorTags: const ['꽃향', '시트러스', '베리'],
        memo: '화사한 꽃향과 밝은 산미. 식으면서 베리류 단맛이 또렷해진다.',
      ),
      TastingNoteModel(
        id: 'seed_2',
        beanName: '콜롬비아 수프리모',
        date: now.subtract(const Duration(days: 4)),
        rating: 4,
        tasteValues: const {
          'acidity': 2.8,
          'body': 3.6,
          'sweetness': 3.4,
          'bitterness': 2.6,
          'balance': 3.8,
        },
        flavorTags: const ['견과류', '캐러멜', '초콜릿'],
        memo: '균형 잡힌 바디와 고소한 견과류. 무난하게 매일 마시기 좋다.',
      ),
      TastingNoteModel(
        id: 'seed_3',
        beanName: '과테말라 안티구아',
        date: now.subtract(const Duration(days: 9)),
        rating: 4,
        tasteValues: const {
          'acidity': 3.2,
          'body': 4.0,
          'sweetness': 3.0,
          'bitterness': 3.2,
          'balance': 3.6,
        },
        flavorTags: const ['초콜릿', '스모키', '캐러멜'],
        memo: '묵직한 바디에 다크초콜릿 뉘앙스. 진하게 내려도 쓴맛이 거칠지 않다.',
      ),
    ];
  }
}
