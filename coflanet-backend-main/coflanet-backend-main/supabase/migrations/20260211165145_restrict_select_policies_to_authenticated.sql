
-- 사용자 소유 데이터 SELECT 정책을 authenticated role로 강화 (defense-in-depth)

-- 1. profiles
DROP POLICY profiles_select_own ON profiles;
CREATE POLICY profiles_select_own ON profiles
  FOR SELECT TO authenticated
  USING (user_id = (select auth.uid()));

-- 2. survey_sessions
DROP POLICY survey_sessions_select_own ON survey_sessions;
CREATE POLICY survey_sessions_select_own ON survey_sessions
  FOR SELECT TO authenticated
  USING (user_id = (select auth.uid()));

-- 3. survey_answers
DROP POLICY survey_answers_select_own ON survey_answers;
CREATE POLICY survey_answers_select_own ON survey_answers
  FOR SELECT TO authenticated
  USING (session_id IN (
    SELECT id FROM survey_sessions
    WHERE user_id = (select auth.uid())
  ));

-- 4. survey_results
DROP POLICY survey_results_select_own ON survey_results;
CREATE POLICY survey_results_select_own ON survey_results
  FOR SELECT TO authenticated
  USING (user_id = (select auth.uid()));

-- 5. survey_result_flavors
DROP POLICY survey_result_flavors_select_own ON survey_result_flavors;
CREATE POLICY survey_result_flavors_select_own ON survey_result_flavors
  FOR SELECT TO authenticated
  USING (result_id IN (
    SELECT id FROM survey_results
    WHERE user_id = (select auth.uid())
  ));

-- 6. recommendations
DROP POLICY recommendations_select_own ON recommendations;
CREATE POLICY recommendations_select_own ON recommendations
  FOR SELECT TO authenticated
  USING (result_id IN (
    SELECT id FROM survey_results
    WHERE user_id = (select auth.uid())
  ));

-- 7. user_bean_lists
DROP POLICY user_bean_lists_select_own ON user_bean_lists;
CREATE POLICY user_bean_lists_select_own ON user_bean_lists
  FOR SELECT TO authenticated
  USING (user_id = (select auth.uid()));

-- 8. recipes
DROP POLICY recipes_select_own_and_system ON recipes;
CREATE POLICY recipes_select_own_and_system ON recipes
  FOR SELECT TO authenticated
  USING ((user_id IS NULL) OR (user_id = (select auth.uid())));

-- 9. recipe_steps
DROP POLICY recipe_steps_select_own_and_system ON recipe_steps;
CREATE POLICY recipe_steps_select_own_and_system ON recipe_steps
  FOR SELECT TO authenticated
  USING (recipe_id IN (
    SELECT id FROM recipes
    WHERE (user_id IS NULL) OR (user_id = (select auth.uid()))
  ));

-- 10. recipe_aroma_tags
DROP POLICY recipe_aroma_tags_select_own_and_system ON recipe_aroma_tags;
CREATE POLICY recipe_aroma_tags_select_own_and_system ON recipe_aroma_tags
  FOR SELECT TO authenticated
  USING (recipe_id IN (
    SELECT id FROM recipes
    WHERE (user_id IS NULL) OR (user_id = (select auth.uid()))
  ));
