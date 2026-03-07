-- 추천 결과 테이블
CREATE TABLE IF NOT EXISTS public.recommendations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  result_id UUID NOT NULL REFERENCES public.survey_results(id) ON DELETE CASCADE,
  bean_id UUID NOT NULL REFERENCES public.coffee_beans(id) ON DELETE CASCADE,
  match_score NUMERIC(5,4) CHECK (match_score BETWEEN 0 AND 1),
  display_order SMALLINT NOT NULL DEFAULT 0,
  recommendation_reason TEXT,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_recommendations_result_id ON public.recommendations(result_id);

CREATE TRIGGER recommendations_update_updated_at
  BEFORE UPDATE ON public.recommendations
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.recommendations ENABLE ROW LEVEL SECURITY;

CREATE POLICY recommendations_select_own ON public.recommendations
  FOR SELECT USING (
    result_id IN (SELECT id FROM public.survey_results WHERE user_id = (SELECT auth.uid()))
  );
