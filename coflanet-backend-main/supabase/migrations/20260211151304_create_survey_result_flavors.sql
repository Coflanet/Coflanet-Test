-- 설문 결과 플레이버 설명 테이블
CREATE TABLE IF NOT EXISTS public.survey_result_flavors (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  result_id UUID NOT NULL REFERENCES public.survey_results(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  emoji TEXT,
  description TEXT,
  display_order SMALLINT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_survey_result_flavors_result_id ON public.survey_result_flavors(result_id);

CREATE TRIGGER survey_result_flavors_update_updated_at
  BEFORE UPDATE ON public.survey_result_flavors
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.survey_result_flavors ENABLE ROW LEVEL SECURITY;

CREATE POLICY survey_result_flavors_select_own ON public.survey_result_flavors
  FOR SELECT USING (
    result_id IN (SELECT id FROM public.survey_results WHERE user_id = (SELECT auth.uid()))
  );
