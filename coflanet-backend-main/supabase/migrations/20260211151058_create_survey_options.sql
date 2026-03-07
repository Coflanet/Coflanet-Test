-- 설문 선택지 마스터 테이블
CREATE TABLE IF NOT EXISTS public.survey_options (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  question_id UUID NOT NULL REFERENCES public.survey_questions(id) ON DELETE CASCADE,
  option_key TEXT NOT NULL,
  label TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  display_order SMALLINT NOT NULL DEFAULT 0,
  score_value SMALLINT,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_survey_options_question_id ON public.survey_options(question_id);

CREATE TRIGGER survey_options_update_updated_at
  BEFORE UPDATE ON public.survey_options
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.survey_options ENABLE ROW LEVEL SECURITY;

-- 모든 사용자 조회 가능 (참조 데이터)
CREATE POLICY survey_options_select_all ON public.survey_options
  FOR SELECT USING (true);
