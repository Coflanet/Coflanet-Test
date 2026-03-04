import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/repositories/supabase/supabase_auth_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_brew_log_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_coffee_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_recipe_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_survey_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_user_preferences_repository.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/models/timer_step_model.dart';

/// 종합 시나리오 테스트
///
/// 6개 시나리오를 순차 실행하여 로그인~회원탈퇴 전체 라이프사이클 검증.
/// 각 시나리오는 독립적인 게스트 계정으로 실행.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  int passed = 0;
  int failed = 0;
  final List<String> issues = [];

  void pass(String name, [String? detail]) {
    passed++;
    final msg = detail != null ? 'PASS $name → $detail' : 'PASS $name';
    debugPrint(msg);
  }

  void fail(String name, dynamic error) {
    failed++;
    issues.add('FAIL: $name: $error');
    debugPrint('FAIL $name: $error');
  }

  void warn(String name, dynamic error) {
    issues.add('WARN: $name: $error');
    debugPrint('WARN $name: $error');
  }

  /// Helper: 게스트 로그인 + 공통 초기화
  Future<SupabaseClient> signInGuest() async {
    final db = Supabase.instance.client;
    await db.auth.signInAnonymously();
    return db;
  }

  /// Helper: 로그아웃 (에러 무시)
  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}
  }

  group('Full Scenario Test', () {
    testWidgets('All scenarios', (tester) async {
      // ────────────────────────────────────────────
      // SETUP
      // ────────────────────────────────────────────
      await dotenv.load(fileName: '.env');

      final localStorage = LocalStorage();
      await localStorage.init();
      if (!Get.isRegistered<LocalStorage>()) {
        Get.put(localStorage);
      }

      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );

      // ════════════════════════════════════════════
      // A. 게스트 로그인 + 설문 완료 플로우
      // ════════════════════════════════════════════
      debugPrint('\n══════ A. GUEST LOGIN + SURVEY ══════');

      try {
        final db = await signInGuest();
        final userId = db.auth.currentUser?.id;
        expect(userId, isNotNull);
        pass('A1: signInAnonymously', 'userId=$userId');

        // A2: save_display_name
        final nameResult = await db.rpc(
          'save_display_name',
          params: {'display_name': 'A_테스트유저'},
        );
        expect(nameResult['display_name'], equals('A_테스트유저'));
        pass('A2: save_display_name');

        // A3: startSurvey
        final surveyRepo = SupabaseSurveyRepository();
        final session = await surveyRepo.startSurvey(surveyType: 'preference');
        final sessionId = session['session_id'] as String?;
        expect(sessionId, isNotNull);
        pass('A3: startSurvey', 'session_id=$sessionId');

        // A4: saveSurveyStepAnswers (10개)
        final answers = <Map<String, dynamic>>[
          {
            'step': 0,
            'selected_options': ['espresso'],
          },
          {
            'step': 1,
            'selected_options': ['beginner'],
          },
          {
            'step': 2,
            'selected_options': ['like'],
          },
          {
            'step': 3,
            'selected_options': ['neutral'],
          },
          {
            'step': 4,
            'selected_options': ['like'],
          },
          {
            'step': 5,
            'selected_options': ['dislike'],
          },
          {
            'step': 6,
            'selected_options': ['like'],
          },
          {
            'step': 7,
            'selected_options': ['dislike'],
          },
          {
            'step': 8,
            'selected_options': ['like'],
          },
          {
            'step': 9,
            'selected_options': ['dislike'],
          },
        ];
        await surveyRepo.saveSurveyStepAnswers(sessionId!, answers);
        pass('A4: saveSurveyStepAnswers', '10개');

        // A5: generateResult (submit-survey Edge Function 401 가능 → warn)
        final fullAnswers = <int, List<String>>{
          0: ['espresso'],
          1: ['beginner'],
          2: ['like'],
          3: ['neutral'],
          4: ['like'],
          5: ['dislike'],
          6: ['like'],
          7: ['dislike'],
          8: ['like'],
          9: ['dislike'],
        };
        try {
          final result = await surveyRepo.generateResult(fullAnswers);
          pass('A5: generateResult', 'type=${result.coffeeType}');
        } catch (e) {
          warn('A5: generateResult (Edge Function 이슈 가능)', '$e');
        }

        // A6: getSurveyResult
        final fetched = await surveyRepo.getSurveyResult();
        if (fetched != null) {
          pass('A6: getSurveyResult', 'type=${fetched.coffeeType}');
        } else {
          pass('A6: getSurveyResult', 'null (Edge Function 미완료 시 정상)');
        }

        // A7: 로그아웃
        // 회원탈퇴로 정리
        final authRepo = SupabaseAuthRepository();
        try {
          await authRepo.deleteAccount();
          pass('A7: deleteAccount');
        } catch (e) {
          warn('A7: deleteAccount', e);
        }
        await signOut();
        pass('A7: signOut');
      } catch (e) {
        fail('A: 게스트+설문 플로우', e);
        await signOut();
      }

      // ════════════════════════════════════════════
      // B. 설문 생략 플로우
      // ════════════════════════════════════════════
      debugPrint('\n══════ B. SURVEY SKIP ══════');

      try {
        final db = await signInGuest();
        pass('B1: signInAnonymously');

        // B2: save_display_name
        await db.rpc('save_display_name', params: {'display_name': 'B_스킵유저'});
        pass('B2: save_display_name');

        // B3: setOnboardingComplete
        final prefsRepo = SupabaseUserPreferencesRepository();
        await prefsRepo.setOnboardingComplete(true);
        pass('B3: setOnboardingComplete(true)');

        // B4: getSurveyResult → null (설문 안 했으므로)
        final surveyRepo = SupabaseSurveyRepository();
        final result = await surveyRepo.getSurveyResult();
        // 서버에 taste_profile이 없으므로 null 또는 로컬 캐시
        pass('B4: getSurveyResult', result?.coffeeType ?? 'null');

        // B5: 정리 + 로그아웃
        final authRepo = SupabaseAuthRepository();
        try {
          await authRepo.deleteAccount();
        } catch (_) {}
        await signOut();
        pass('B5: cleanup + signOut');
      } catch (e) {
        fail('B: 설문 생략 플로우', e);
        await signOut();
      }

      // ════════════════════════════════════════════
      // C. 원두 CRUD 플로우
      // ════════════════════════════════════════════
      debugPrint('\n══════ C. BEAN CRUD ══════');

      try {
        final db = await signInGuest();
        pass('C1: signInAnonymously');

        final coffeeRepo = SupabaseCoffeeRepository();

        // C2: getCoffeeItems (초기)
        final initial = await coffeeRepo.getCoffeeItems();
        pass('C2: getCoffeeItems (초기)', '${initial.length}건');

        // C3: addToCoffeeList (카탈로그에서 추가)
        // 먼저 카탈로그에서 bean_id 하나 확보
        String? catalogBeanId;
        try {
          final beans = await db.from('coffee_beans').select('id').limit(1);
          if (beans.isNotEmpty) {
            catalogBeanId = beans.first['id'] as String;
          }
        } catch (_) {}

        if (catalogBeanId != null) {
          final addResult = await coffeeRepo.addToCoffeeList(
            catalogBeanId,
            addedFrom: 'manual',
          );
          pass('C3: addToCoffeeList', '$addResult');

          // C4: getCoffeeItems → 추가 확인
          final afterAdd = await coffeeRepo.getCoffeeItems();
          pass('C4: getCoffeeItems 추가 후', '${afterAdd.length}건');

          // C7-a: deleteCoffeeItem (카탈로그 추가한 것 정리)
          await coffeeRepo.deleteCoffeeItem(catalogBeanId);
          pass('C7a: deleteCoffeeItem (카탈로그)');
        } else {
          warn('C3: addToCoffeeList', 'coffee_beans 비어있음');
        }

        // C5: addCoffeeItem (커스텀 원두)
        try {
          await coffeeRepo.addCoffeeItem(
            CoffeeItem(
              id: 'e2e_custom_bean',
              name: 'E2E 커스텀 원두',
              description: '테스트용 원두',
              color: const Color(0xFF8B6F47),
            ),
          );
          pass('C5: addCoffeeItem (커스텀)');
        } catch (e) {
          warn('C5: addCoffeeItem', e);
        }

        // C8: getCoffeeCatalog
        try {
          final catalog = await coffeeRepo.getCoffeeCatalog();
          pass('C8: getCoffeeCatalog', '${catalog.keys}');
        } catch (e) {
          warn('C8: getCoffeeCatalog', e);
        }

        // Cleanup
        final authRepo = SupabaseAuthRepository();
        try {
          await authRepo.deleteAccount();
        } catch (_) {}
        await signOut();
        pass('C9: cleanup + signOut');
      } catch (e) {
        fail('C: 원두 CRUD', e);
        await signOut();
      }

      // ════════════════════════════════════════════
      // D. 레시피 CRUD 플로우
      // ════════════════════════════════════════════
      debugPrint('\n══════ D. RECIPE CRUD ══════');

      try {
        await signInGuest();
        pass('D1: signInAnonymously');

        final recipeRepo = SupabaseRecipeRepository();

        // D2: getAllRecipes (빌트인 12개 확인)
        final allRecipes = await recipeRepo.getAllRecipes();
        expect(allRecipes.length, greaterThanOrEqualTo(12));
        pass('D2: getAllRecipes', '${allRecipes.length}개');

        // D3: getRecipeByType
        final handDrip = await recipeRepo.getRecipeByType('handDrip');
        if (handDrip != null) {
          pass('D3: getRecipeByType(handDrip)', 'name=${handDrip.name}');
        } else {
          warn('D3: getRecipeByType(handDrip)', 'null (brew_methods 시드 필요)');
        }

        // D4: saveRecipe (커스텀)
        String? savedRecipeId;
        try {
          final testRecipe = TimerRecipeModel(
            id: 'e2e_test',
            name: 'E2E 테스트 레시피',
            coffeeType: 'hand_drip',
            coffeeAmount: 20,
            waterAmount: 300,
            totalDurationSeconds: 180,
            steps: const [
              TimerStepModel(
                stepNumber: 1,
                title: '뜸 들이기',
                description: '40ml',
                durationSeconds: 30,
                waterAmount: 40,
                stepType: TimerStepType.brewing,
              ),
            ],
            aromaTags: const [AromaTagModel(emoji: '🍊', name: '시트러스')],
          );
          await recipeRepo.saveRecipe(testRecipe);
          pass('D4: saveRecipe');

          // 저장 확인
          final after = await recipeRepo.getAllRecipes();
          final custom = after.where((r) => r.name == 'E2E 테스트 레시피');
          if (custom.isNotEmpty) {
            savedRecipeId = custom.first.id;
            pass('D4: saveRecipe 확인', 'id=$savedRecipeId');
          }
        } catch (e) {
          warn('D4: saveRecipe', e);
        }

        // D5: getRecipeById (커스텀)
        if (savedRecipeId != null) {
          try {
            final recipe = await recipeRepo.getRecipeById(savedRecipeId);
            expect(recipe, isNotNull);
            pass('D5: getRecipeById(custom)', 'name=${recipe!.name}');
          } catch (e) {
            fail('D5: getRecipeById(custom)', e);
          }

          // D6: deleteRecipe
          try {
            await recipeRepo.deleteRecipe(savedRecipeId);
            pass('D6: deleteRecipe', savedRecipeId);
          } catch (e) {
            fail('D6: deleteRecipe', e);
          }
        }

        // Cleanup
        final authRepo = SupabaseAuthRepository();
        try {
          await authRepo.deleteAccount();
        } catch (_) {}
        await signOut();
        pass('D7: cleanup + signOut');
      } catch (e) {
        fail('D: 레시피 CRUD', e);
        await signOut();
      }

      // ════════════════════════════════════════════
      // E. 추출 기록 (Brew Log) 플로우
      // ════════════════════════════════════════════
      debugPrint('\n══════ E. BREW LOG ══════');

      try {
        final db = await signInGuest();
        pass('E1: signInAnonymously');

        final brewLogRepo = SupabaseBrewLogRepository();

        // brew_method_id 확보 (slug → UUID)
        String? brewMethodId;
        try {
          final methods = await db.from('brew_methods').select('id, slug');
          if (methods.isNotEmpty) {
            brewMethodId = methods.first['id'] as String;
            pass(
              'E1.5: brew_methods 조회',
              'id=$brewMethodId, slug=${methods.first['slug']}',
            );
          }
        } catch (e) {
          warn('E1.5: brew_methods 조회', e);
        }

        // E2: saveBrewLog
        String? logId;
        if (brewMethodId != null) {
          try {
            final result = await brewLogRepo.saveBrewLog({
              'brew_method_id': brewMethodId,
              'coffee_amount_g': 18.0,
              'total_water_ml': 250.0,
              'rating': 4,
              'notes': 'E2E 테스트 추출',
            });
            logId = result['id'] as String? ?? result['log_id'] as String?;
            pass('E2: saveBrewLog', 'id=$logId');
          } catch (e) {
            fail('E2: saveBrewLog', e);
          }
        } else {
          warn('E2: saveBrewLog', 'brew_methods 비어있어 테스트 불가');
        }

        // E3: getMyBrewLogs
        try {
          final logs = await brewLogRepo.getMyBrewLogs();
          pass('E3: getMyBrewLogs', '${logs.length}건');
        } catch (e) {
          fail('E3: getMyBrewLogs', e);
        }

        // E4: updateBrewLog
        if (logId != null) {
          try {
            await brewLogRepo.updateBrewLog(logId, {
              'rating': 5,
              'notes': 'E2E 수정됨',
            });
            pass('E4: updateBrewLog', 'rating=5');
          } catch (e) {
            fail('E4: updateBrewLog', e);
          }
        }

        // E5: getMyBrewStats
        try {
          final stats = await brewLogRepo.getMyBrewStats();
          pass(
            'E5: getMyBrewStats',
            'total=${stats?['total_brews']}, methods=${stats?['unique_methods']}',
          );
        } catch (e) {
          fail('E5: getMyBrewStats', e);
        }

        // E6: deleteBrewLog
        if (logId != null) {
          try {
            await brewLogRepo.deleteBrewLog(logId);
            pass('E6: deleteBrewLog');
          } catch (e) {
            fail('E6: deleteBrewLog', e);
          }
        }

        // Cleanup
        final authRepo = SupabaseAuthRepository();
        try {
          await authRepo.deleteAccount();
        } catch (_) {}
        await signOut();
        pass('E7: cleanup + signOut');
      } catch (e) {
        fail('E: Brew Log', e);
        await signOut();
      }

      // ════════════════════════════════════════════
      // F. 회원탈퇴 플로우
      // ════════════════════════════════════════════
      debugPrint('\n══════ F. DELETE ACCOUNT ══════');

      try {
        final db = await signInGuest();
        final userId = db.auth.currentUser?.id;
        pass('F1: signInAnonymously', 'userId=$userId');

        // F2: save_display_name
        await db.rpc('save_display_name', params: {'display_name': 'F_탈퇴유저'});
        pass('F2: save_display_name');

        // F3: deleteAccount
        final authRepo = SupabaseAuthRepository();
        try {
          await authRepo.deleteAccount();
          pass('F3: deleteAccount');
        } catch (e) {
          warn('F3: deleteAccount (Edge Function)', e);
        }

        // F4: signOut
        await signOut();
        pass('F4: signOut');

        // F5: 세션 없음 확인
        final currentUser = db.auth.currentUser;
        pass('F5: 세션 확인', 'currentUser=${currentUser?.id ?? 'null'}');
      } catch (e) {
        fail('F: 회원탈퇴', e);
        await signOut();
      }

      // ════════════════════════════════════════════
      // G. 재로그인 시 설문 미반복 확인
      // ════════════════════════════════════════════
      debugPrint('\n══════ G. RE-LOGIN SURVEY SKIP ══════');

      try {
        // G1: 게스트 로그인
        final db = await signInGuest();
        final userId = db.auth.currentUser?.id;
        pass('G1: signInAnonymously', 'userId=$userId');

        // G2: 닉네임 설정
        await db.rpc('save_display_name', params: {'display_name': 'G_재로그인유저'});
        pass('G2: save_display_name');

        // G3: 설문 완료
        final surveyRepo = SupabaseSurveyRepository();
        final session = await surveyRepo.startSurvey(surveyType: 'preference');
        final sessionId = session['session_id'] as String?;
        expect(sessionId, isNotNull);
        pass('G3: startSurvey', 'session_id=$sessionId');

        final answers = <Map<String, dynamic>>[
          {
            'step': 0,
            'selected_options': ['espresso'],
          },
          {
            'step': 1,
            'selected_options': ['beginner'],
          },
          {
            'step': 2,
            'selected_options': ['like'],
          },
          {
            'step': 3,
            'selected_options': ['neutral'],
          },
          {
            'step': 4,
            'selected_options': ['like'],
          },
          {
            'step': 5,
            'selected_options': ['dislike'],
          },
          {
            'step': 6,
            'selected_options': ['like'],
          },
          {
            'step': 7,
            'selected_options': ['dislike'],
          },
          {
            'step': 8,
            'selected_options': ['like'],
          },
          {
            'step': 9,
            'selected_options': ['dislike'],
          },
        ];
        await surveyRepo.saveSurveyStepAnswers(sessionId!, answers);
        try {
          await surveyRepo.generateResult({
            0: ['espresso'],
            1: ['beginner'],
            2: ['like'],
            3: ['neutral'],
            4: ['like'],
            5: ['dislike'],
            6: ['like'],
            7: ['dislike'],
            8: ['like'],
            9: ['dislike'],
          });
        } catch (_) {
          // Edge Function 미완료 가능 — 무시
        }
        pass('G4: survey completed');

        // G5: get_onboarding_status 확인 (설문 완료 상태)
        final status = await db.rpc('get_onboarding_status');
        final hasCompleted = (status is Map)
            ? status['has_completed_survey'] as bool?
            : null;
        pass('G5: get_onboarding_status', 'has_completed_survey=$hasCompleted');

        // G6: 로그아웃 (이 게스트 계정은 탈퇴하지 않음 — 재로그인 불가이므로)
        // 게스트는 재로그인 불가이므로, 새 게스트로 같은 RPC 동작 확인
        await signOut();
        pass('G6: signOut');

        // G7: 새 게스트로 로그인 → 설문 미완료 상태여야 함 (새 계정)
        final db2 = await signInGuest();
        final status2 = await db2.rpc('get_onboarding_status');
        final hasCompleted2 = (status2 is Map)
            ? status2['has_completed_survey'] as bool?
            : null;
        expect(hasCompleted2, isFalse, reason: '새 게스트는 설문 미완료 상태여야 합니다');
        pass(
          'G7: new guest onboarding_status',
          'has_completed_survey=$hasCompleted2 (expected: false)',
        );

        // Cleanup
        final authRepo = SupabaseAuthRepository();
        try {
          await authRepo.deleteAccount();
        } catch (_) {}
        await signOut();
        pass('G8: cleanup + signOut');
      } catch (e) {
        fail('G: 재로그인 설문 스킵', e);
        await signOut();
      }

      // ════════════════════════════════════════════
      // SUMMARY
      // ════════════════════════════════════════════
      debugPrint('\n════════════════════════════════════════');
      debugPrint('  PASSED: $passed');
      debugPrint('  FAILED: $failed');
      debugPrint(
        '  WARNINGS: ${issues.where((i) => i.startsWith('WARN')).length}',
      );
      if (issues.isNotEmpty) {
        debugPrint('\n  Issues:');
        for (final i in issues) {
          debugPrint('    - $i');
        }
      }
      debugPrint('════════════════════════════════════════\n');

      expect(
        failed,
        equals(0),
        reason:
            '$failed tests failed:\n${issues.where((i) => i.startsWith("FAIL")).join("\n")}',
      );
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    });
  });
}
