import 'package:flutter_test/flutter_test.dart';
import 'package:coflanet/data/repositories/supabase/supabase_survey_repository.dart';

/// 설문 매핑 테이블 & score_value 순수 로직 유닛 테스트
/// Supabase 연결 불필요 — `flutter test test/survey_score_test.dart` 실행 가능.
void main() {
  group('Preference question keys', () {
    test('10개 항목이 정의되어 있어야 한다', () {
      final keys = SupabaseSurveyRepository.preferenceQuestionKeys;
      expect(keys.length, equals(10));
    });

    test('step 0~9 모두 키가 존재해야 한다', () {
      final keys = SupabaseSurveyRepository.preferenceQuestionKeys;
      for (int i = 0; i < 10; i++) {
        expect(keys.containsKey(i), isTrue, reason: 'step $i 누락');
      }
    });

    test('예상 question_key 값이 올바르다', () {
      final keys = SupabaseSurveyRepository.preferenceQuestionKeys;
      expect(keys[0], equals('brew_method'));
      expect(keys[1], equals('experience_level'));
      expect(keys[2], equals('pref_acidity'));
      expect(keys[3], equals('pref_body'));
      expect(keys[4], equals('pref_sweetness'));
      expect(keys[5], equals('pref_bitterness'));
      expect(keys[6], equals('pref_aroma_fruity'));
      expect(keys[7], equals('pref_aroma_floral'));
      expect(keys[8], equals('pref_aroma_nutty_cocoa'));
      expect(keys[9], equals('pref_aroma_roasted'));
    });
  });

  group('Lifestyle question keys', () {
    test('12개 항목이 정의되어 있어야 한다', () {
      final keys = SupabaseSurveyRepository.lifestyleQuestionKeys;
      expect(keys.length, equals(12));
    });

    test('step 0~11 모두 키가 존재해야 한다', () {
      final keys = SupabaseSurveyRepository.lifestyleQuestionKeys;
      for (int i = 0; i < 12; i++) {
        expect(keys.containsKey(i), isTrue, reason: 'step $i 누락');
      }
    });

    test('예상 question_key 값이 올바르다', () {
      final keys = SupabaseSurveyRepository.lifestyleQuestionKeys;
      expect(keys[0], equals('brew_method'));
      expect(keys[1], equals('experience_level'));
      expect(keys[2], equals('life_morning'));
      expect(keys[11], equals('life_decision'));
    });
  });

  group('Score value computation', () {
    // Taste questions: steps 2-5
    test('taste step에서 dislike → 1', () {
      expect(
        SupabaseSurveyRepository.computeScoreValue(2, ['dislike']),
        equals(1),
      );
      expect(
        SupabaseSurveyRepository.computeScoreValue(5, ['dislike']),
        equals(1),
      );
    });

    test('taste step에서 neutral → 2', () {
      expect(
        SupabaseSurveyRepository.computeScoreValue(3, ['neutral']),
        equals(2),
      );
    });

    test('taste step에서 like → 3', () {
      expect(
        SupabaseSurveyRepository.computeScoreValue(4, ['like']),
        equals(3),
      );
    });

    // Aroma questions: steps 6-9
    test('aroma step에서 dislike → 0', () {
      expect(
        SupabaseSurveyRepository.computeScoreValue(6, ['dislike']),
        equals(0),
      );
      expect(
        SupabaseSurveyRepository.computeScoreValue(9, ['dislike']),
        equals(0),
      );
    });

    test('aroma step에서 like → 1', () {
      expect(
        SupabaseSurveyRepository.computeScoreValue(7, ['like']),
        equals(1),
      );
    });

    // Non-scored steps: 0, 1
    test('비해당 step (0, 1)은 null 반환', () {
      expect(
        SupabaseSurveyRepository.computeScoreValue(0, ['espresso']),
        isNull,
      );
      expect(
        SupabaseSurveyRepository.computeScoreValue(1, ['beginner']),
        isNull,
      );
    });

    // Edge cases
    test('빈 옵션 리스트는 null 반환', () {
      expect(SupabaseSurveyRepository.computeScoreValue(3, []), isNull);
    });

    test('인식 불가 옵션은 null 반환', () {
      expect(
        SupabaseSurveyRepository.computeScoreValue(3, ['unknown_option']),
        isNull,
      );
    });

    test('step 10+ 는 null 반환', () {
      expect(SupabaseSurveyRepository.computeScoreValue(10, ['like']), isNull);
    });
  });
}
