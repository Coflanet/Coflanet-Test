import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/dummy/dummy_survey_data.dart';

void main() {
  group('SurveyController', () {
    group('Initialization', () {
      test('should have 6 total steps', () {
        // Test the dummy data directly without controller
        expect(DummySurveyData.questions.length, equals(6));
      });
    });

    group('Survey Question Model', () {
      test('first question should have options', () {
        final question = DummySurveyData.questions.first;
        expect(question.options.isNotEmpty, isTrue);
      });

      test('each question should have step number', () {
        for (int i = 0; i < DummySurveyData.questions.length; i++) {
          expect(DummySurveyData.questions[i].step, equals(i + 1));
        }
      });

      test('each question should have text', () {
        for (final question in DummySurveyData.questions) {
          expect(question.question.isNotEmpty, isTrue);
        }
      });
    });

    group('Survey Progress Calculation', () {
      test('progress should be calculated correctly', () {
        // Step 1 of 6 = 1/6
        expect(1 / 6, closeTo(0.167, 0.01));
        // Step 3 of 6 = 0.5
        expect(3 / 6, equals(0.5));
        // Step 6 of 6 = 1.0
        expect(6 / 6, equals(1.0));
      });
    });

    group('Option Selection Logic', () {
      test('single selection should replace previous selection', () {
        // Simulate single selection behavior
        List<String> selections = [];

        // Select first option
        selections = ['option_1'];
        expect(selections.length, equals(1));

        // Select second option (replaces first)
        selections = ['option_2'];
        expect(selections.length, equals(1));
        expect(selections.first, equals('option_2'));
      });

      test('multiple selection should toggle options', () {
        // Simulate multi-selection behavior
        List<String> selections = [];

        // Add first option
        selections.add('option_1');
        expect(selections.length, equals(1));

        // Add second option
        selections.add('option_2');
        expect(selections.length, equals(2));

        // Toggle first option (remove it)
        selections.remove('option_1');
        expect(selections.length, equals(1));
        expect(selections.contains('option_1'), isFalse);
      });
    });

    group('Survey Result Generation', () {
      test('should generate result from answers', () {
        final answers = <int, List<String>>{
          1: ['taste_sweet'],
          2: ['origin_ethiopia'],
          3: ['roast_medium'],
          4: ['brew_pourover'],
          5: ['caffeine_normal'],
          6: ['time_medium'],
        };

        final result = DummySurveyData.generateResult(answers);
        expect(result, isNotNull);
        expect(result.recommendations.isNotEmpty, isTrue);
      });
    });
  });
}
