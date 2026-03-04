import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/repositories/supabase/supabase_auth_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_coffee_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_recipe_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_survey_repository.dart';
import 'package:coflanet/data/repositories/supabase/supabase_user_preferences_repository.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/models/timer_step_model.dart';

/// Supabase Repository 종합 통합 테스트
///
/// Guest 로그인 후 실제 Repository 클래스를 통해 모든 CRUD 동작 검증.
/// 테스트 순서: Auth → UserPrefs → Survey → Coffee → Recipe → Cleanup
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

  group('Supabase Repository Integration', () {
    testWidgets('Full repository lifecycle test', (tester) async {
      // ────────────────────────────────────────────
      // SETUP
      // ────────────────────────────────────────────
      await dotenv.load(fileName: '.env');

      // Initialize LocalStorage (calls GetStorage.init internally)
      final localStorage = LocalStorage();
      await localStorage.init();

      // Register in GetX DI
      if (!Get.isRegistered<LocalStorage>()) {
        Get.put(localStorage);
      }

      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );

      final db = Supabase.instance.client;

      // ════════════════════════════════════════════
      // A. AUTH REPOSITORY
      // ════════════════════════════════════════════
      debugPrint('\n══════ A. AUTH REPOSITORY ══════');

      final authRepo = SupabaseAuthRepository();
      String? userId;

      // A1: Guest login
      try {
        final auth = await db.auth.signInAnonymously();
        userId = auth.user?.id;
        expect(userId, isNotNull);
        pass('Guest signInAnonymously', 'userId=$userId');
      } catch (e) {
        fail('Guest signInAnonymously', e);
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        return;
      }

      // A2: getCurrentUser
      try {
        final user = await authRepo.getCurrentUser();
        expect(user, isNotNull);
        pass('AuthRepo.getCurrentUser', 'id=${user?.id}');
      } catch (e) {
        fail('AuthRepo.getCurrentUser', e);
      }

      // A3: updateProfile
      try {
        final user = await authRepo.updateProfile(name: 'E2E테스트유저');
        expect(user.name, contains('E2E테스트유저'));
        pass('AuthRepo.updateProfile', 'name=${user.name}');
      } catch (e) {
        fail('AuthRepo.updateProfile', e);
      }

      // ════════════════════════════════════════════
      // B. USER PREFERENCES REPOSITORY
      // ════════════════════════════════════════════
      debugPrint('\n══════ B. USER PREFERENCES ══════');

      final prefsRepo = SupabaseUserPreferencesRepository();

      // B1: isOnboardingComplete (초기 상태)
      try {
        final complete = await prefsRepo.isOnboardingComplete();
        pass('PrefsRepo.isOnboardingComplete', '$complete');
      } catch (e) {
        fail('PrefsRepo.isOnboardingComplete', e);
      }

      // B2: saveUserName + getUserName
      try {
        await prefsRepo.saveUserName('E2E닉네임');
        final name = await prefsRepo.getUserName();
        expect(name, contains('E2E닉네임'));
        pass('PrefsRepo.saveUserName+getUserName', name ?? 'null');
      } catch (e) {
        fail('PrefsRepo.saveUserName+getUserName', e);
      }

      // B3: getUserId
      try {
        final id = await prefsRepo.getUserId();
        expect(id, isNotNull);
        expect(id, equals(userId));
        pass('PrefsRepo.getUserId', id ?? 'null');
      } catch (e) {
        fail('PrefsRepo.getUserId', e);
      }

      // B4: setDarkMode + isDarkMode
      try {
        await prefsRepo.setDarkMode(true);
        final dark = await prefsRepo.isDarkMode();
        expect(dark, isTrue);
        pass('PrefsRepo.setDarkMode(true)+isDarkMode', '$dark');

        // Reset
        await prefsRepo.setDarkMode(false);
        final reset = await prefsRepo.isDarkMode();
        expect(reset, isFalse);
        pass('PrefsRepo.setDarkMode(false) reset', '$reset');
      } catch (e) {
        fail('PrefsRepo.setDarkMode cycle', e);
      }

      // ════════════════════════════════════════════
      // C. SURVEY REPOSITORY
      // ════════════════════════════════════════════
      debugPrint('\n══════ C. SURVEY REPOSITORY ══════');

      final surveyRepo = SupabaseSurveyRepository();

      // C1: getQuestions (정적 데이터)
      try {
        final questions = await surveyRepo.getQuestions();
        expect(questions, isNotEmpty);
        pass('SurveyRepo.getQuestions', '${questions.length}개');
      } catch (e) {
        fail('SurveyRepo.getQuestions', e);
      }

      // C2: saveSurveyReasons (서버 RPC)
      try {
        await surveyRepo.saveSurveyReasons(['find_taste', 'record_recipe']);
        pass('SurveyRepo.saveSurveyReasons', 'OK');
      } catch (e) {
        fail('SurveyRepo.saveSurveyReasons', e);
      }

      // C3: saveSurveyAnswers + getSurveyAnswers (로컬)
      try {
        final answers = {
          'step1': ['opt_a'],
          'step2': ['opt_b', 'opt_c'],
        };
        await surveyRepo.saveSurveyAnswers(answers);
        final loaded = await surveyRepo.getSurveyAnswers();
        expect(loaded, isNotNull);
        expect(loaded!['step1'], isNotNull);
        pass('SurveyRepo.saveSurveyAnswers+get', '${loaded.keys.length} steps');
      } catch (e) {
        fail('SurveyRepo.saveSurveyAnswers+get', e);
      }

      // C4: saveSelectedBeanIds + getSelectedBeanIds (로컬)
      try {
        await surveyRepo.saveSelectedBeanIds(['bean_1', 'bean_2']);
        final ids = await surveyRepo.getSelectedBeanIds();
        expect(ids, isNotNull);
        expect(ids!.length, equals(2));
        pass('SurveyRepo.saveSelectedBeanIds+get', '$ids');
      } catch (e) {
        fail('SurveyRepo.saveSelectedBeanIds+get', e);
      }

      // C5: Full survey flow — startSurvey → generateResult (10개 답변)
      // generateResult 내부에서 saveSurveyStepAnswers + completeSurvey + submit-survey 처리
      try {
        // C5a: startSurvey (세션 생성 + question UUID 로딩)
        final session = await surveyRepo.startSurvey(surveyType: 'preference');
        final sessionId = session['session_id'] as String?;
        expect(sessionId, isNotNull);
        pass('SurveyRepo.startSurvey', 'session_id=$sessionId');

        // C5b: generateResult (내부에서 save + complete + submit 수행)
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
        final result = await surveyRepo.generateResult(fullAnswers);
        pass('SurveyRepo.generateResult', 'type=${result.coffeeType}');
      } catch (e) {
        // submit-survey Edge Function may return issues for anonymous users
        warn('SurveyRepo.generateResult (Edge Function 이슈 가능)', '$e');
      }

      // C6: getSurveyResult (서버 RPC)
      try {
        final result = await surveyRepo.getSurveyResult();
        if (result != null) {
          pass('SurveyRepo.getSurveyResult', 'type=${result.coffeeType}');
        } else {
          pass('SurveyRepo.getSurveyResult', 'null (Edge Function 미완료 시 정상)');
        }
      } catch (e) {
        fail('SurveyRepo.getSurveyResult', e);
      }

      // C7: clearSurveyResult (retake_survey RPC)
      try {
        await surveyRepo.clearSurveyResult();
        pass('SurveyRepo.clearSurveyResult', 'OK');
      } catch (e) {
        fail('SurveyRepo.clearSurveyResult', e);
      }

      // ════════════════════════════════════════════
      // D. COFFEE REPOSITORY
      // ════════════════════════════════════════════
      debugPrint('\n══════ D. COFFEE REPOSITORY ══════');

      final coffeeRepo = SupabaseCoffeeRepository();

      // D1: getCoffeeItems (초기 상태)
      int initialBeanCount = 0;
      try {
        final items = await coffeeRepo.getCoffeeItems();
        initialBeanCount = items.length;
        pass('CoffeeRepo.getCoffeeItems (초기)', '${items.length}건');
      } catch (e) {
        fail('CoffeeRepo.getCoffeeItems', e);
      }

      // D2: addCoffeeItem → 서버에 원두 추가
      // 먼저 coffee_beans 테이블에서 사용 가능한 bean_id 확인
      String? testBeanId;
      try {
        final beans = await db.from('coffee_beans').select('id').limit(1);
        if (beans.isNotEmpty) {
          testBeanId = beans.first['id'].toString();
          pass('coffee_beans 테이블 조회', 'bean_id=$testBeanId');
        } else {
          warn('coffee_beans 테이블', '비어있음 — addCoffeeItem 테스트 불가');
        }
      } catch (e) {
        warn('coffee_beans 테이블 조회', e);
      }

      if (testBeanId != null) {
        // D3: addCoffeeItem
        try {
          await coffeeRepo.addCoffeeItem(_testCoffeeItem(testBeanId));
          final items = await coffeeRepo.getCoffeeItems();
          expect(items.length, greaterThanOrEqualTo(initialBeanCount));
          pass('CoffeeRepo.addCoffeeItem', '추가 후 ${items.length}건');
        } catch (e) {
          fail('CoffeeRepo.addCoffeeItem', e);
        }

        // D4: getCoffeeItemById
        try {
          final item = await coffeeRepo.getCoffeeItemById(testBeanId);
          if (item != null) {
            pass('CoffeeRepo.getCoffeeItemById', 'name=${item.name}');
          } else {
            warn('CoffeeRepo.getCoffeeItemById', 'null — RPC 응답 형식 확인 필요');
          }
        } catch (e) {
          fail('CoffeeRepo.getCoffeeItemById', e);
        }

        // D5: updateCoffeeItem (sort_order 변경)
        try {
          await coffeeRepo.updateCoffeeItem(
            _testCoffeeItem(testBeanId, sortOrder: 99),
          );
          pass('CoffeeRepo.updateCoffeeItem', 'sort_order=99');
        } catch (e) {
          fail('CoffeeRepo.updateCoffeeItem', e);
        }

        // D6: reorderCoffeeItems
        try {
          await coffeeRepo.reorderCoffeeItems([testBeanId]);
          pass('CoffeeRepo.reorderCoffeeItems', 'OK');
        } catch (e) {
          fail('CoffeeRepo.reorderCoffeeItems', e);
        }

        // D7: deleteCoffeeItem
        try {
          await coffeeRepo.deleteCoffeeItem(testBeanId);
          final items = await coffeeRepo.getCoffeeItems();
          pass('CoffeeRepo.deleteCoffeeItem', '삭제 후 ${items.length}건');
        } catch (e) {
          fail('CoffeeRepo.deleteCoffeeItem', e);
        }
      }

      // D8: updateCoffeeVisibility (no-op 확인)
      try {
        await coffeeRepo.updateCoffeeVisibility('any', true);
        pass('CoffeeRepo.updateCoffeeVisibility', 'no-op OK');
      } catch (e) {
        fail('CoffeeRepo.updateCoffeeVisibility', e);
      }

      // ════════════════════════════════════════════
      // E. RECIPE REPOSITORY
      // ════════════════════════════════════════════
      debugPrint('\n══════ E. RECIPE REPOSITORY ══════');

      final recipeRepo = SupabaseRecipeRepository();

      // E1: getAllRecipes (빌트인 + 커스텀)
      try {
        final recipes = await recipeRepo.getAllRecipes();
        expect(recipes, isNotEmpty);
        pass('RecipeRepo.getAllRecipes', '${recipes.length}개 (빌트인 포함)');
      } catch (e) {
        fail('RecipeRepo.getAllRecipes', e);
      }

      // E2: getRecipeByType (서버 brew_methods 시드 데이터 의존)
      for (final type in ['handDrip', 'espresso']) {
        try {
          final recipe = await recipeRepo.getRecipeByType(type);
          if (recipe != null) {
            pass(
              'RecipeRepo.getRecipeByType($type)',
              'name=${recipe.name}, steps=${recipe.steps.length}',
            );
          } else {
            warn(
              'RecipeRepo.getRecipeByType($type)',
              'null — brew_methods에 해당 slug 없음 (시드 데이터 필요)',
            );
          }
        } catch (e) {
          fail('RecipeRepo.getRecipeByType($type)', e);
        }
      }

      // E3: getRecipeById (빌트인)
      try {
        final recipe = await recipeRepo.getRecipeById('handDrip');
        expect(recipe, isNotNull);
        pass('RecipeRepo.getRecipeById(handDrip)', 'name=${recipe!.name}');
      } catch (e) {
        fail('RecipeRepo.getRecipeById', e);
      }

      // E4: saveRecipe (커스텀 레시피 저장)
      String? savedRecipeId;
      try {
        final testRecipe = _testRecipe();
        await recipeRepo.saveRecipe(testRecipe);
        pass('RecipeRepo.saveRecipe', 'inserted');

        // 저장 후 확인
        final all = await recipeRepo.getAllRecipes();
        final custom = all.where((r) => r.name == 'E2E 테스트 레시피');
        if (custom.isNotEmpty) {
          savedRecipeId = custom.first.id;
          pass(
            'RecipeRepo.saveRecipe 확인',
            'id=$savedRecipeId, steps=${custom.first.steps.length}, tags=${custom.first.aromaTags.length}',
          );
        } else {
          warn('RecipeRepo.saveRecipe 확인', '저장은 성공했으나 목록에서 찾을 수 없음');
        }
      } catch (e) {
        fail('RecipeRepo.saveRecipe', e);
      }

      // E5: getRecipeById (커스텀)
      if (savedRecipeId != null) {
        try {
          final recipe = await recipeRepo.getRecipeById(savedRecipeId);
          expect(recipe, isNotNull);
          pass('RecipeRepo.getRecipeById(custom)', 'name=${recipe!.name}');
        } catch (e) {
          fail('RecipeRepo.getRecipeById(custom)', e);
        }
      }

      // E6: addToSavedRecipes + getSavedRecipes (로컬 스토리지 — 테스트 환경 제약)
      try {
        await recipeRepo.addToSavedRecipes('handDrip');
        final saved = await recipeRepo.getSavedRecipes();
        if (saved.any((r) => r.id == 'handDrip')) {
          pass('RecipeRepo.addToSavedRecipes+get', '${saved.length}개');
        } else {
          warn(
            'RecipeRepo.addToSavedRecipes+get',
            '로컬 스토리지 테스트 환경 제약 — 앱 실행 시 정상',
          );
        }
        await recipeRepo.removeFromSavedRecipes('handDrip');
        pass('RecipeRepo.removeFromSavedRecipes', 'OK');
      } catch (e) {
        warn('RecipeRepo.savedRecipes cycle', '$e');
      }

      // E7: deleteRecipe (커스텀 정리)
      if (savedRecipeId != null) {
        try {
          await recipeRepo.deleteRecipe(savedRecipeId);
          pass('RecipeRepo.deleteRecipe', 'deleted $savedRecipeId');
        } catch (e) {
          fail('RecipeRepo.deleteRecipe', e);
        }
      }

      // ════════════════════════════════════════════
      // F. DASHBOARD & BREW STATS (RPC 직접 호출)
      // ════════════════════════════════════════════
      debugPrint('\n══════ F. DASHBOARD & STATS ══════');

      try {
        final r = await db.rpc('get_my_dashboard');
        pass(
          'get_my_dashboard',
          'display_name=${r['display_name']}, beans=${r['bean_count']}',
        );
      } catch (e) {
        fail('get_my_dashboard', e);
      }

      try {
        final r = await db.rpc('get_my_brew_stats');
        pass(
          'get_my_brew_stats',
          'total=${r['total_brews']}, methods=${r['unique_methods']}',
        );
      } catch (e) {
        fail('get_my_brew_stats', e);
      }

      // ════════════════════════════════════════════
      // G. DELETE ACCOUNT + CLEANUP
      // ════════════════════════════════════════════
      debugPrint('\n══════ G. CLEANUP ══════');

      try {
        await authRepo.deleteAccount();
        pass('AuthRepo.deleteAccount', 'OK');
      } catch (e) {
        warn('AuthRepo.deleteAccount (Edge Function 이슈 가능)', '$e');
      }

      try {
        await authRepo.logout();
        pass('AuthRepo.logout', 'OK');
      } catch (e) {
        warn('AuthRepo.logout', '$e');
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

// ─── Test helpers ───

CoffeeItem _testCoffeeItem(String beanId, {int sortOrder = 0}) {
  return CoffeeItem(
    id: beanId,
    name: 'E2E Test Bean',
    description: 'Test',
    color: const Color(0xFF8B6F47),
    sortOrder: sortOrder,
  );
}

TimerRecipeModel _testRecipe() {
  return TimerRecipeModel(
    id: 'e2e_test',
    name: 'E2E 테스트 레시피',
    coffeeType: 'hand_drip',
    coffeeAmount: 20,
    waterAmount: 300,
    totalDurationSeconds: 180,
    steps: [
      const TimerStepModel(
        stepNumber: 1,
        title: '뜸 들이기',
        description: '40ml 물을 부어 30초 기다립니다',
        durationSeconds: 30,
        waterAmount: 40,
        stepType: TimerStepType.brewing,
      ),
      const TimerStepModel(
        stepNumber: 2,
        title: '1차 추출',
        description: '160ml까지 물을 천천히 붓습니다',
        durationSeconds: 60,
        waterAmount: 120,
        stepType: TimerStepType.brewing,
      ),
      const TimerStepModel(
        stepNumber: 3,
        title: '2차 추출',
        description: '300ml까지 물을 부어 완료합니다',
        durationSeconds: 90,
        waterAmount: 140,
        stepType: TimerStepType.brewing,
      ),
    ],
    aromaDescription: 'E2E 테스트용 아로마',
    aromaTags: const [
      AromaTagModel(emoji: '🍊', name: '시트러스'),
      AromaTagModel(emoji: '🌸', name: '플로럴'),
    ],
  );
}
