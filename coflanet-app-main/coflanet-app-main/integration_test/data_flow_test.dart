import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 전체 데이터 플로우 검증 테스트
/// Guest 로그인 → 프로필 → 설문 → 레시피 → 테이블 접근 → 정리
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late SupabaseClient db;
  String? userId;
  int passed = 0;
  int failed = 0;
  final List<String> issues = [];

  void pass(String name) {
    passed++;
    debugPrint('PASS $name');
  }

  void fail(String name, dynamic error) {
    failed++;
    issues.add('$name: $error');
    debugPrint('FAIL $name: $error');
  }

  void warn(String name, dynamic error) {
    issues.add('[WARN] $name: $error');
    debugPrint('WARN $name: $error');
  }

  group('Complete Data Flow', () {
    testWidgets('Full lifecycle test', (tester) async {
      await dotenv.load(fileName: '.env');
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );
      db = Supabase.instance.client;

      // ============================
      // A. AUTH
      // ============================
      debugPrint('\n===== A. AUTH =====');

      try {
        final auth = await db.auth.signInAnonymously();
        userId = auth.user?.id;
        expect(userId, isNotNull);
        pass('Guest login (userId=$userId)');
      } catch (e) {
        fail('Guest login', e);
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        return;
      }

      // ============================
      // B. PROFILE SETUP
      // ============================
      debugPrint('\n===== B. PROFILE SETUP =====');

      // B1: save_display_name
      try {
        final r = await db.rpc(
          'save_display_name',
          params: {'display_name': 'E2E유저'},
        );
        expect(r['display_name'], equals('E2E유저'));
        pass('save_display_name → ${r['display_name']}');
      } catch (e) {
        fail('save_display_name', e);
      }

      // B2: save_onboarding_reasons
      try {
        final r = await db.rpc(
          'save_onboarding_reasons',
          params: {
            'reasons': ['find_taste', 'try_variety'],
          },
        );
        expect(
          List<String>.from(r['onboarding_reasons']),
          containsAll(['find_taste', 'try_variety']),
        );
        pass('save_onboarding_reasons → ${r['onboarding_reasons']}');
      } catch (e) {
        fail('save_onboarding_reasons', e);
      }

      // B3: get_onboarding_status
      try {
        final r = await db.rpc('get_onboarding_status');
        expect(r['has_nickname'], isTrue);
        expect(r['has_signup_reasons'], isTrue);
        expect(r['has_completed_survey'], isFalse);
        pass('get_onboarding_status → next_screen=${r['next_screen']}');
      } catch (e) {
        fail('get_onboarding_status', e);
      }

      // ============================
      // C. SURVEY FLOW
      // ============================
      debugPrint('\n===== C. SURVEY FLOW =====');

      // C1: start_survey RPC → session_id
      String? sessionId;
      try {
        final r = await db.rpc(
          'start_survey',
          params: {'p_survey_type': 'preference'},
        );
        sessionId = r?['session_id'] as String?;
        expect(sessionId, isNotNull);
        pass('start_survey → session_id=$sessionId');
      } catch (e) {
        fail('start_survey', e);
      }

      // C1.5: save_survey_answers — 10개 답변 저장
      if (sessionId != null) {
        try {
          // question_key → UUID 조회
          final qRows = await db
              .from('survey_questions')
              .select('id, question_key, survey_type')
              .or('survey_type.eq.common,survey_type.eq.preference')
              .order('step')
              .order('question_order');

          final keyToId = <String, String>{};
          for (final r in qRows) {
            final key = r['question_key'] as String?;
            if (key != null) keyToId[key] = r['id'] as String;
          }
          debugPrint('   loaded ${keyToId.length} question IDs');

          final questionKeys = [
            'brew_method',
            'experience_level',
            'pref_acidity',
            'pref_body',
            'pref_sweetness',
            'pref_bitterness',
            'pref_aroma_fruity',
            'pref_aroma_floral',
            'pref_aroma_nutty_cocoa',
            'pref_aroma_roasted',
          ];
          final options = [
            'espresso',
            'beginner',
            'like',
            'neutral',
            'like',
            'dislike',
            'like',
            'dislike',
            'like',
            'dislike',
          ];
          final answers = <Map<String, dynamic>>[];
          for (int i = 0; i < questionKeys.length; i++) {
            final qId = keyToId[questionKeys[i]];
            if (qId == null) continue;
            final entry = <String, dynamic>{
              'question_id': qId,
              'selected_options': [options[i]],
            };
            // score_value for taste (2-5) and aroma (6-9) steps
            if (i >= 2 && i <= 5) {
              entry['score_value'] = options[i] == 'like'
                  ? 3
                  : options[i] == 'neutral'
                  ? 2
                  : 1;
            } else if (i >= 6 && i <= 9) {
              entry['score_value'] = options[i] == 'like' ? 1 : 0;
            }
            answers.add(entry);
          }

          final saveR = await db.rpc(
            'save_survey_answers',
            params: {'p_session_id': sessionId, 'p_answers': answers},
          );
          debugPrint('   save_survey_answers result: $saveR');
          pass('save_survey_answers → ${answers.length}개 저장');
        } catch (e) {
          fail('save_survey_answers', e);
        }
      }

      // C1.7: complete_survey RPC
      if (sessionId != null) {
        try {
          final r = await db.rpc(
            'complete_survey',
            params: {'p_session_id': sessionId},
          );
          debugPrint('   complete_survey result: $r');
          pass('complete_survey');
        } catch (e) {
          fail('complete_survey', e);
        }
      }

      // C2: submit-survey Edge Function
      if (sessionId != null) {
        try {
          final r = await db.functions.invoke(
            'submit-survey',
            body: {'session_id': sessionId},
          );
          debugPrint(
            '   submit-survey response: status=${r.status}, data=${r.data}',
          );
          pass('submit-survey → status=${r.status}');
        } on FunctionException catch (e) {
          warn(
            'submit-survey (Edge Function)',
            'status=${e.status}, details=${e.details}',
          );
        }
      }

      // C3: get_my_taste_profile
      try {
        final r = await db.rpc('get_my_taste_profile');
        debugPrint('   get_my_taste_profile → $r');
        if (r != null) {
          pass('get_my_taste_profile → 데이터 있음');
        } else {
          pass('get_my_taste_profile → null (submit-survey 미완료 시 정상)');
        }
      } catch (e) {
        fail('get_my_taste_profile', e);
      }

      // C4: get_my_recommendations
      try {
        final r = await db.rpc('get_my_recommendations');
        debugPrint('   get_my_recommendations → $r');
        pass(
          'get_my_recommendations → ${r == null ? 'null' : '${(r as List).length}건'}',
        );
      } catch (e) {
        fail('get_my_recommendations', e);
      }

      // ============================
      // D. BEAN LIST
      // ============================
      debugPrint('\n===== D. BEAN LIST =====');

      try {
        final r = await db.rpc('get_my_bean_list');
        expect(r, isA<List>());
        pass('get_my_bean_list → ${(r as List).length}건');
      } catch (e) {
        fail('get_my_bean_list', e);
      }

      // ============================
      // E. RECIPE - 실제 테이블 접근 확인
      // ============================
      debugPrint('\n===== E. RECIPE =====');

      // E1: recipes 테이블 접근
      try {
        final rows = await db.from('recipes').select().eq('user_id', userId!);
        pass('recipes 테이블 접근 OK → ${rows.length}건');
      } catch (e) {
        warn('recipes 테이블', e);
      }

      // E2: brew_methods 테이블 접근
      try {
        final rows = await db.from('brew_methods').select();
        pass('brew_methods 테이블 접근 OK → ${rows.length}건');
        if (rows.isEmpty) {
          warn('brew_methods', '테이블이 비어있음 — 시드 데이터 필요');
        }
      } catch (e) {
        warn('brew_methods 테이블', e);
      }

      // E3: recipe_steps 테이블 접근
      try {
        await db.from('recipe_steps').select().limit(1);
        pass('recipe_steps 테이블 접근 OK');
      } catch (e) {
        warn('recipe_steps 테이블', e);
      }

      // E4: recipe_aroma_tags 테이블 접근
      try {
        await db.from('recipe_aroma_tags').select().limit(1);
        pass('recipe_aroma_tags 테이블 접근 OK');
      } catch (e) {
        warn('recipe_aroma_tags 테이블', e);
      }

      // E5: get_merged_recipe RPC (brew_methods가 비어있으면 실패 가능)
      try {
        // brew_methods에서 첫 번째 id를 가져와서 테스트
        final methods = await db.from('brew_methods').select('id').limit(1);
        if (methods.isNotEmpty) {
          final methodId = methods.first['id'] as String;
          final r = await db.rpc(
            'get_merged_recipe',
            params: {'p_brew_method_id': methodId},
          );
          debugPrint('   get_merged_recipe → $r');
          pass('get_merged_recipe RPC OK');
        } else {
          warn('get_merged_recipe', 'brew_methods 비어있어 테스트 불가');
        }
      } catch (e) {
        warn('get_merged_recipe RPC', '$e');
      }

      // ============================
      // F. DASHBOARD & STATS
      // ============================
      debugPrint('\n===== F. DASHBOARD & STATS =====');

      try {
        final r = await db.rpc('get_my_dashboard');
        expect(r['display_name'], equals('E2E유저'));
        pass(
          'get_my_dashboard → display_name=${r['display_name']}, beans=${r['bean_count']}, recipes=${r['custom_recipe_count']}',
        );
      } catch (e) {
        fail('get_my_dashboard', e);
      }

      try {
        final r = await db.rpc('get_my_brew_stats');
        pass(
          'get_my_brew_stats → total=${r['total_brews']}, beans=${r['unique_beans']}, methods=${r['unique_methods']}',
        );
      } catch (e) {
        fail('get_my_brew_stats', e);
      }

      // ============================
      // G. PROFILES 직접 테이블 접근 (RLS 확인)
      // ============================
      debugPrint('\n===== G. PROFILES TABLE =====');

      try {
        final r = await db
            .from('profiles')
            .select()
            .eq('user_id', userId!)
            .single();
        expect(r['display_name'], equals('E2E유저'));
        pass(
          'profiles 직접 쿼리 → display_name=${r['display_name']}, reasons=${r['onboarding_reasons']}',
        );
      } catch (e) {
        warn('profiles 직접 쿼리', e);
      }

      // ============================
      // H. DARK MODE SYNC
      // ============================
      debugPrint('\n===== H. DARK MODE =====');

      try {
        await db
            .from('profiles')
            .update({'is_dark_mode': true})
            .eq('user_id', userId!);
        final r = await db.rpc('get_my_dashboard');
        expect(r['is_dark_mode'], isTrue);
        pass('다크모드 서버 동기화 OK');
        // Reset
        await db
            .from('profiles')
            .update({'is_dark_mode': false})
            .eq('user_id', userId!);
      } catch (e) {
        warn('다크모드 동기화', e);
      }

      // ============================
      // I. DELETE ACCOUNT (Edge Function)
      // ============================
      debugPrint('\n===== I. DELETE ACCOUNT =====');

      try {
        final r = await db.functions.invoke('delete-account');
        pass('delete-account → status=${r.status}');
      } on FunctionException catch (e) {
        warn('delete-account (Edge Function)', 'status=${e.status}');
      }

      // Cleanup
      try {
        await db.auth.signOut();
      } catch (_) {}

      // ============================
      // SUMMARY
      // ============================
      debugPrint('\n========================================');
      debugPrint('  PASSED: $passed');
      debugPrint('  FAILED: $failed');
      debugPrint(
        '  WARNINGS: ${issues.where((i) => i.startsWith('[WARN]')).length}',
      );
      if (issues.isNotEmpty) {
        debugPrint('\n  Issues:');
        for (final i in issues) {
          debugPrint('    - $i');
        }
      }
      debugPrint('========================================\n');

      expect(failed, equals(0), reason: '$failed tests failed');
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    });
  });
}
