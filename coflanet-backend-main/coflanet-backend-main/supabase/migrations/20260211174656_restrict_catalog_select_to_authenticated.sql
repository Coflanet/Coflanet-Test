-- 카탈로그 테이블 SELECT 정책을 authenticated 역할로 제한
-- 비인증 사용자의 카탈로그 데이터 접근을 차단하여 공격 표면 축소

-- 1. coffee_beans
DROP POLICY IF EXISTS coffee_beans_select_all ON coffee_beans;
CREATE POLICY coffee_beans_select_all ON coffee_beans
  FOR SELECT TO authenticated USING (true);

-- 2. brew_methods
DROP POLICY IF EXISTS brew_methods_select_all ON brew_methods;
CREATE POLICY brew_methods_select_all ON brew_methods
  FOR SELECT TO authenticated USING (true);

-- 3. survey_questions
DROP POLICY IF EXISTS survey_questions_select_all ON survey_questions;
CREATE POLICY survey_questions_select_all ON survey_questions
  FOR SELECT TO authenticated USING (true);

-- 4. survey_options
DROP POLICY IF EXISTS survey_options_select_all ON survey_options;
CREATE POLICY survey_options_select_all ON survey_options
  FOR SELECT TO authenticated USING (true);

-- 5. bean_flavor_tags
DROP POLICY IF EXISTS bean_flavor_tags_select_all ON bean_flavor_tags;
CREATE POLICY bean_flavor_tags_select_all ON bean_flavor_tags
  FOR SELECT TO authenticated USING (true);
