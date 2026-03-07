-- 설문 질문 마스터 테이블
CREATE TABLE IF NOT EXISTS public.survey_questions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  survey_type TEXT NOT NULL CHECK (survey_type IN ('common', 'preference', 'lifestyle')),
  step SMALLINT NOT NULL,
  question_order SMALLINT NOT NULL,
  question_key TEXT NOT NULL UNIQUE,
  question_text TEXT NOT NULL,
  description TEXT,
  category TEXT CHECK (category IN ('coffee_experience', 'taste_basic', 'taste_aroma', 'lifestyle', 'sensory')),
  allow_multiple BOOLEAN DEFAULT false NOT NULL,
  answer_type TEXT NOT NULL CHECK (answer_type IN ('single_select', 'multi_select', 'scale_3', 'scale_5', 'binary')),
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE TRIGGER survey_questions_update_updated_at
  BEFORE UPDATE ON public.survey_questions
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.survey_questions ENABLE ROW LEVEL SECURITY;

-- 모든 사용자 조회 가능 (참조 데이터)
CREATE POLICY survey_questions_select_all ON public.survey_questions
  FOR SELECT USING (true);
