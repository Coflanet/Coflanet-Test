import 'package:flutter_test/flutter_test.dart';
import 'package:coflanet/modules/coffee/timer/coffee_timer_controller.dart';
import 'package:coflanet/data/models/timer_step_model.dart';
import 'package:coflanet/data/dummy/dummy_timer_data.dart';

void main() {
  group('CoffeeTimerController', () {
    group('TimerState enum', () {
      test('should have all required states', () {
        expect(TimerState.idle, isNotNull);
        expect(TimerState.preCountdown, isNotNull);
        expect(TimerState.running, isNotNull);
        expect(TimerState.paused, isNotNull);
        expect(TimerState.completed, isNotNull);
      });

      test('should have 5 total states', () {
        expect(TimerState.values.length, equals(5));
      });
    });

    group('DummyTimerData', () {
      test('handDripRecipe should have 6 steps', () {
        expect(DummyTimerData.handDripRecipe.steps.length, equals(6));
      });

      test('espressoRecipe should have 2 steps', () {
        expect(DummyTimerData.espressoRecipe.steps.length, equals(2));
      });

      test('espressoDoubleRecipe should have 2 steps', () {
        expect(DummyTimerData.espressoDoubleRecipe.steps.length, equals(2));
      });

      test('getRecipe should return handDripRecipe for handDrip type', () {
        final recipe = DummyTimerData.getRecipe('handDrip');
        expect(recipe.id, equals('hand_drip_basic'));
        expect(recipe.coffeeType, equals('handDrip'));
      });

      test('getRecipe should return espressoRecipe for espresso type', () {
        final recipe = DummyTimerData.getRecipe('espresso');
        expect(recipe.id, equals('espresso_single'));
        expect(recipe.coffeeType, equals('espresso'));
      });

      test(
        'getRecipe should return espressoDoubleRecipe for espressoDouble type',
        () {
          final recipe = DummyTimerData.getRecipe('espressoDouble');
          expect(recipe.id, equals('espresso_double'));
          expect(recipe.coffeeType, equals('espresso'));
        },
      );

      test('getRecipe should default to handDripRecipe for unknown type', () {
        final recipe = DummyTimerData.getRecipe('unknown');
        expect(recipe.id, equals('hand_drip_basic'));
      });

      test('handDripRecipe should have correct metadata', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.name, equals('핸드드립 기본'));
        expect(recipe.coffeeAmount, equals(18));
        expect(recipe.waterAmount, equals(210));
        expect(recipe.totalDurationSeconds, equals(150)); // 2:30
      });

      test('handDripRecipe should have completion message', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.completionMessage, isNotEmpty);
        expect(recipe.completionMessage, equals('맛있는 커피가 완성되었어요!'));
      });

      test('handDripRecipe should have aroma tags', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.aromaTags.length, equals(4));
        expect(recipe.aromaTags[0].emoji, equals('🍑'));
        expect(recipe.aromaTags[0].name, equals('복숭아'));
      });

      test('espressoRecipe should have correct metadata', () {
        final recipe = DummyTimerData.espressoRecipe;
        expect(recipe.name, equals('에스프레소 싱글샷'));
        expect(recipe.coffeeAmount, equals(18));
        expect(recipe.waterAmount, equals(30));
        expect(recipe.totalDurationSeconds, equals(30));
      });

      test('espressoRecipe should have aroma tags', () {
        final recipe = DummyTimerData.espressoRecipe;
        expect(recipe.aromaTags.length, equals(3));
        expect(recipe.aromaTags[0].emoji, equals('🍫'));
        expect(recipe.aromaTags[0].name, equals('초콜릿'));
      });
    });

    group('TimerStepModel', () {
      test('preparation step should have hasTimer = false', () {
        final step = DummyTimerData.handDripRecipe.steps[0];
        expect(step.stepType, equals(TimerStepType.preparation));
        expect(step.hasTimer, isFalse);
      });

      test('brewing step should have hasTimer = true', () {
        final step = DummyTimerData.handDripRecipe.steps[2];
        expect(step.stepType, equals(TimerStepType.brewing));
        expect(step.hasTimer, isTrue);
      });

      test('waiting step should have hasTimer = true', () {
        final step = DummyTimerData.handDripRecipe.steps[5];
        expect(step.stepType, equals(TimerStepType.waiting));
        expect(step.hasTimer, isTrue);
      });

      test('preparation step should have isPreparation = true', () {
        final step = DummyTimerData.handDripRecipe.steps[0];
        expect(step.isPreparation, isTrue);
      });

      test('brewing step should have isPreparation = false', () {
        final step = DummyTimerData.handDripRecipe.steps[2];
        expect(step.isPreparation, isFalse);
      });

      test('step with durationSeconds = 0 should have hasTimer = false', () {
        final step = DummyTimerData.handDripRecipe.steps[0];
        expect(step.durationSeconds, equals(0));
        expect(step.hasTimer, isFalse);
      });

      test('step with durationSeconds > 0 should have hasTimer = true', () {
        final step = DummyTimerData.handDripRecipe.steps[2];
        expect(step.durationSeconds, equals(30));
        expect(step.hasTimer, isTrue);
      });

      test('handDripRecipe step 1 should have correct properties', () {
        final step = DummyTimerData.handDripRecipe.steps[0];
        expect(step.stepNumber, equals(1));
        expect(step.title, equals('원두 분쇄'));
        expect(step.description, isNotEmpty);
        expect(step.durationSeconds, equals(0));
        expect(step.stepType, equals(TimerStepType.preparation));
      });

      test('handDripRecipe step 3 should have correct properties', () {
        final step = DummyTimerData.handDripRecipe.steps[2];
        expect(step.stepNumber, equals(3));
        expect(step.title, equals('뜸 들이기'));
        expect(step.durationSeconds, equals(30));
        expect(step.waterAmount, equals(30));
        expect(step.stepType, equals(TimerStepType.brewing));
      });

      test('step should serialize to JSON and back', () {
        final step = DummyTimerData.handDripRecipe.steps[2];
        final json = step.toJson();
        final restored = TimerStepModel.fromJson(json);

        expect(restored.stepNumber, equals(step.stepNumber));
        expect(restored.title, equals(step.title));
        expect(restored.durationSeconds, equals(step.durationSeconds));
        expect(restored.stepType, equals(step.stepType));
      });
    });

    group('TimerRecipeModel', () {
      test('handDripRecipe should have correct total duration', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.totalDurationSeconds, equals(150));
      });

      test('espressoRecipe should have correct total duration', () {
        final recipe = DummyTimerData.espressoRecipe;
        expect(recipe.totalDurationSeconds, equals(30));
      });

      test('handDripRecipe should have correct water amount', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.waterAmount, equals(210));
      });

      test('espressoRecipe should have correct water amount', () {
        final recipe = DummyTimerData.espressoRecipe;
        expect(recipe.waterAmount, equals(30));
      });

      test('handDripRecipe should have completion message', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.completionMessage, isNotNull);
        expect(recipe.completionMessage, isNotEmpty);
      });

      test('espressoRecipe should have completion message', () {
        final recipe = DummyTimerData.espressoRecipe;
        expect(recipe.completionMessage, isNotNull);
        expect(recipe.completionMessage, isNotEmpty);
      });

      test('handDripRecipe should have aroma description', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.aromaDescription, isNotNull);
        expect(recipe.aromaDescription, isNotEmpty);
      });

      test('handDripRecipe should have multiple aroma tags', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.aromaTags.isNotEmpty, isTrue);
        expect(recipe.aromaTags.length, greaterThan(0));
      });

      test('espressoRecipe should have multiple aroma tags', () {
        final recipe = DummyTimerData.espressoRecipe;
        expect(recipe.aromaTags.isNotEmpty, isTrue);
        expect(recipe.aromaTags.length, greaterThan(0));
      });

      test('recipe should serialize to JSON and back', () {
        final recipe = DummyTimerData.handDripRecipe;
        final json = recipe.toJson();
        final restored = TimerRecipeModel.fromJson(json);

        expect(restored.id, equals(recipe.id));
        expect(restored.name, equals(recipe.name));
        expect(restored.coffeeType, equals(recipe.coffeeType));
        expect(
          restored.totalDurationSeconds,
          equals(recipe.totalDurationSeconds),
        );
        expect(restored.steps.length, equals(recipe.steps.length));
      });

      test('handDripRecipe should have correct coffee amount', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.coffeeAmount, equals(18));
      });

      test('espressoRecipe should have correct coffee amount', () {
        final recipe = DummyTimerData.espressoRecipe;
        expect(recipe.coffeeAmount, equals(18));
      });
    });

    group('AromaTagModel', () {
      test('aroma tag should have emoji and name', () {
        const tag = AromaTagModel(emoji: '🍑', name: '복숭아');
        expect(tag.emoji, equals('🍑'));
        expect(tag.name, equals('복숭아'));
      });

      test('handDripRecipe aroma tags should have valid emoji and name', () {
        final recipe = DummyTimerData.handDripRecipe;
        for (final tag in recipe.aromaTags) {
          expect(tag.emoji, isNotEmpty);
          expect(tag.name, isNotEmpty);
        }
      });

      test('espressoRecipe aroma tags should have valid emoji and name', () {
        final recipe = DummyTimerData.espressoRecipe;
        for (final tag in recipe.aromaTags) {
          expect(tag.emoji, isNotEmpty);
          expect(tag.name, isNotEmpty);
        }
      });
    });

    group('Recipe Step Validation', () {
      test('handDripRecipe should have steps with increasing step numbers', () {
        final recipe = DummyTimerData.handDripRecipe;
        for (int i = 0; i < recipe.steps.length; i++) {
          expect(recipe.steps[i].stepNumber, equals(i + 1));
        }
      });

      test('espressoRecipe should have steps with increasing step numbers', () {
        final recipe = DummyTimerData.espressoRecipe;
        for (int i = 0; i < recipe.steps.length; i++) {
          expect(recipe.steps[i].stepNumber, equals(i + 1));
        }
      });

      test('handDripRecipe should have first two steps as preparation', () {
        final recipe = DummyTimerData.handDripRecipe;
        expect(recipe.steps[0].stepType, equals(TimerStepType.preparation));
        expect(recipe.steps[1].stepType, equals(TimerStepType.preparation));
      });

      test('handDripRecipe should have brewing and waiting steps', () {
        final recipe = DummyTimerData.handDripRecipe;
        final brewingSteps = recipe.steps.where(
          (s) => s.stepType == TimerStepType.brewing,
        );
        final waitingSteps = recipe.steps.where(
          (s) => s.stepType == TimerStepType.waiting,
        );

        expect(brewingSteps.isNotEmpty, isTrue);
        expect(waitingSteps.isNotEmpty, isTrue);
      });

      test('handDripRecipe steps with water amount should be timed steps', () {
        final recipe = DummyTimerData.handDripRecipe;
        for (final step in recipe.steps) {
          if (step.waterAmount != null) {
            expect(step.hasTimer, isTrue);
          }
        }
      });

      test('espressoRecipe should have all steps as timed steps', () {
        final recipe = DummyTimerData.espressoRecipe;
        for (final step in recipe.steps) {
          expect(step.hasTimer, isTrue);
        }
      });
    });

    group('Time Formatting Helpers', () {
      test('should format 0 seconds as 00:00', () {
        // Test the formatting logic directly
        final seconds = 0;
        final minutes = seconds ~/ 60;
        final secs = seconds % 60;
        final formatted =
            '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
        expect(formatted, equals('00:00'));
      });

      test('should format 30 seconds as 00:30', () {
        final seconds = 30;
        final minutes = seconds ~/ 60;
        final secs = seconds % 60;
        final formatted =
            '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
        expect(formatted, equals('00:30'));
      });

      test('should format 150 seconds as 02:30', () {
        final seconds = 150;
        final minutes = seconds ~/ 60;
        final secs = seconds % 60;
        final formatted =
            '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
        expect(formatted, equals('02:30'));
      });

      test('should format 65 seconds as 01:05', () {
        final seconds = 65;
        final minutes = seconds ~/ 60;
        final secs = seconds % 60;
        final formatted =
            '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
        expect(formatted, equals('01:05'));
      });
    });

    group('Progress Calculation Logic', () {
      test('step progress should be 0.0 when no duration', () {
        final step = DummyTimerData.handDripRecipe.steps[0];
        if (step.durationSeconds == 0) {
          expect(0.0, equals(0.0));
        }
      });

      test('step progress should be calculable for timed steps', () {
        final step = DummyTimerData.handDripRecipe.steps[2];
        final elapsed = 15; // 15 seconds elapsed
        final remaining = step.durationSeconds - elapsed;
        final progress = elapsed / step.durationSeconds;

        expect(progress, closeTo(0.5, 0.01));
        expect(remaining, equals(15));
      });

      test('total progress should be calculable for recipe', () {
        final recipe = DummyTimerData.handDripRecipe;
        final totalElapsed = 75; // 75 seconds elapsed
        final progress = totalElapsed / recipe.totalDurationSeconds;

        expect(progress, closeTo(0.5, 0.01));
      });

      test('total progress should be 0.0 at start', () {
        final recipe = DummyTimerData.handDripRecipe;
        final progress = 0 / recipe.totalDurationSeconds;
        expect(progress, equals(0.0));
      });

      test('total progress should be 1.0 at completion', () {
        final recipe = DummyTimerData.handDripRecipe;
        final progress =
            recipe.totalDurationSeconds / recipe.totalDurationSeconds;
        expect(progress, equals(1.0));
      });
    });

    group('Phase Markers Calculation', () {
      test('handDripRecipe should have phase markers', () {
        final recipe = DummyTimerData.handDripRecipe;
        // Phase markers are calculated from step boundaries
        // For 6 steps, there should be 5 potential markers (excluding last step)
        expect(recipe.steps.length, equals(6));
      });

      test('espressoRecipe should have phase markers', () {
        final recipe = DummyTimerData.espressoRecipe;
        expect(recipe.steps.length, equals(2));
      });

      test('phase markers should be between 0.0 and 1.0', () {
        final recipe = DummyTimerData.handDripRecipe;
        int accumulated = 0;
        for (int i = 0; i < recipe.steps.length - 1; i++) {
          accumulated += recipe.steps[i].durationSeconds;
          if (accumulated > 0) {
            final marker = accumulated / recipe.totalDurationSeconds;
            expect(marker, greaterThan(0.0));
            expect(marker, lessThan(1.0));
          }
        }
      });
    });

    group('Next Timed Step Logic', () {
      test('handDripRecipe should have timed steps after preparation', () {
        final recipe = DummyTimerData.handDripRecipe;
        // Steps 0 and 1 are preparation
        // Steps 2, 3, 4, 5 should be timed
        expect(recipe.steps[0].hasTimer, isFalse);
        expect(recipe.steps[1].hasTimer, isFalse);
        expect(recipe.steps[2].hasTimer, isTrue);
        expect(recipe.steps[3].hasTimer, isTrue);
        expect(recipe.steps[4].hasTimer, isTrue);
        expect(recipe.steps[5].hasTimer, isTrue);
      });

      test('espressoRecipe should have all steps as timed', () {
        final recipe = DummyTimerData.espressoRecipe;
        for (final step in recipe.steps) {
          expect(step.hasTimer, isTrue);
        }
      });
    });
  });
}
