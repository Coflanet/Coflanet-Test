-- ============================================================
-- 스키마 리뷰 수정: 중복 인덱스 제거 + 누락 FK 인덱스 추가
-- ============================================================

-- 1. 중복 인덱스 제거 (UNIQUE 제약조건의 자동 인덱스와 중복)
DROP INDEX IF EXISTS public.uniq_profiles_user_id;
DROP INDEX IF EXISTS public.uniq_survey_results_session_id;

-- 2. 누락 FK 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_recipes_brew_method_id
  ON public.recipes (brew_method_id);

CREATE INDEX IF NOT EXISTS idx_recommendations_bean_id
  ON public.recommendations (bean_id);

CREATE INDEX IF NOT EXISTS idx_survey_answers_question_id
  ON public.survey_answers (question_id);

CREATE INDEX IF NOT EXISTS idx_user_bean_lists_bean_id
  ON public.user_bean_lists (bean_id);
