
-- ================================================================
-- RLS 쓰기 정책 role 범위 제한: public → authenticated
-- 클라이언트가 쓰는 18개 INSERT/UPDATE/DELETE 정책 대상
-- EF(service_role) 전용 테이블은 변경 없음
-- ================================================================

-- 1. profiles (UPDATE만 — INSERT는 트리거 처리)
DROP POLICY IF EXISTS profiles_update_own ON public.profiles;
CREATE POLICY profiles_update_own ON public.profiles
  FOR UPDATE TO authenticated
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

-- 2. survey_sessions (INSERT + UPDATE — EF status 변경은 service_role)
DROP POLICY IF EXISTS survey_sessions_insert_authenticated ON public.survey_sessions;
CREATE POLICY survey_sessions_insert_authenticated ON public.survey_sessions
  FOR INSERT TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS survey_sessions_update_own ON public.survey_sessions;
CREATE POLICY survey_sessions_update_own ON public.survey_sessions
  FOR UPDATE TO authenticated
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

-- 3. survey_answers (INSERT + UPDATE)
DROP POLICY IF EXISTS survey_answers_insert_authenticated ON public.survey_answers;
CREATE POLICY survey_answers_insert_authenticated ON public.survey_answers
  FOR INSERT TO authenticated
  WITH CHECK (session_id IN (
    SELECT id FROM public.survey_sessions
    WHERE user_id = (SELECT auth.uid())
  ));

DROP POLICY IF EXISTS survey_answers_update_own ON public.survey_answers;
CREATE POLICY survey_answers_update_own ON public.survey_answers
  FOR UPDATE TO authenticated
  USING (session_id IN (
    SELECT id FROM public.survey_sessions
    WHERE user_id = (SELECT auth.uid())
  ));

-- 4. survey_results (UPDATE만 — INSERT는 EF 처리)
DROP POLICY IF EXISTS survey_results_update_own ON public.survey_results;
CREATE POLICY survey_results_update_own ON public.survey_results
  FOR UPDATE TO authenticated
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

-- 5. user_bean_lists (INSERT + UPDATE + DELETE)
DROP POLICY IF EXISTS user_bean_lists_insert_authenticated ON public.user_bean_lists;
CREATE POLICY user_bean_lists_insert_authenticated ON public.user_bean_lists
  FOR INSERT TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS user_bean_lists_update_own ON public.user_bean_lists;
CREATE POLICY user_bean_lists_update_own ON public.user_bean_lists
  FOR UPDATE TO authenticated
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS user_bean_lists_delete_own ON public.user_bean_lists;
CREATE POLICY user_bean_lists_delete_own ON public.user_bean_lists
  FOR DELETE TO authenticated
  USING (user_id = (SELECT auth.uid()));

-- 6. recipes (INSERT + UPDATE + DELETE)
DROP POLICY IF EXISTS recipes_insert_authenticated ON public.recipes;
CREATE POLICY recipes_insert_authenticated ON public.recipes
  FOR INSERT TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS recipes_update_own ON public.recipes;
CREATE POLICY recipes_update_own ON public.recipes
  FOR UPDATE TO authenticated
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS recipes_delete_own ON public.recipes;
CREATE POLICY recipes_delete_own ON public.recipes
  FOR DELETE TO authenticated
  USING (user_id = (SELECT auth.uid()));

-- 7. recipe_steps (INSERT + UPDATE + DELETE)
DROP POLICY IF EXISTS recipe_steps_insert_authenticated ON public.recipe_steps;
CREATE POLICY recipe_steps_insert_authenticated ON public.recipe_steps
  FOR INSERT TO authenticated
  WITH CHECK (recipe_id IN (
    SELECT id FROM public.recipes
    WHERE user_id = (SELECT auth.uid())
  ));

DROP POLICY IF EXISTS recipe_steps_update_own ON public.recipe_steps;
CREATE POLICY recipe_steps_update_own ON public.recipe_steps
  FOR UPDATE TO authenticated
  USING (recipe_id IN (
    SELECT id FROM public.recipes
    WHERE user_id = (SELECT auth.uid())
  ));

DROP POLICY IF EXISTS recipe_steps_delete_own ON public.recipe_steps;
CREATE POLICY recipe_steps_delete_own ON public.recipe_steps
  FOR DELETE TO authenticated
  USING (recipe_id IN (
    SELECT id FROM public.recipes
    WHERE user_id = (SELECT auth.uid())
  ));

-- 8. recipe_aroma_tags (INSERT + UPDATE + DELETE)
DROP POLICY IF EXISTS recipe_aroma_tags_insert_authenticated ON public.recipe_aroma_tags;
CREATE POLICY recipe_aroma_tags_insert_authenticated ON public.recipe_aroma_tags
  FOR INSERT TO authenticated
  WITH CHECK (recipe_id IN (
    SELECT id FROM public.recipes
    WHERE user_id = (SELECT auth.uid())
  ));

DROP POLICY IF EXISTS recipe_aroma_tags_update_own ON public.recipe_aroma_tags;
CREATE POLICY recipe_aroma_tags_update_own ON public.recipe_aroma_tags
  FOR UPDATE TO authenticated
  USING (recipe_id IN (
    SELECT id FROM public.recipes
    WHERE user_id = (SELECT auth.uid())
  ));

DROP POLICY IF EXISTS recipe_aroma_tags_delete_own ON public.recipe_aroma_tags;
CREATE POLICY recipe_aroma_tags_delete_own ON public.recipe_aroma_tags
  FOR DELETE TO authenticated
  USING (recipe_id IN (
    SELECT id FROM public.recipes
    WHERE user_id = (SELECT auth.uid())
  ));
