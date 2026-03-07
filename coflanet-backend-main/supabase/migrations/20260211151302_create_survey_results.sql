-- 설문 결과 (맛 프로필) 테이블
CREATE TABLE IF NOT EXISTS public.survey_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id UUID NOT NULL UNIQUE REFERENCES public.survey_sessions(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  coffee_type TEXT CHECK (coffee_type IN ('acidity', 'strong', 'sweet', 'balance')),
  coffee_type_label TEXT,
  coffee_type_description TEXT,
  acidity SMALLINT DEFAULT 0 CHECK (acidity BETWEEN 0 AND 100),
  sweetness SMALLINT DEFAULT 0 CHECK (sweetness BETWEEN 0 AND 100),
  bitterness SMALLINT DEFAULT 0 CHECK (bitterness BETWEEN 0 AND 100),
  body SMALLINT DEFAULT 0 CHECK (body BETWEEN 0 AND 100),
  aroma SMALLINT DEFAULT 0 CHECK (aroma BETWEEN 0 AND 100),
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS uniq_survey_results_session_id ON public.survey_results(session_id);
CREATE INDEX IF NOT EXISTS idx_survey_results_user_id ON public.survey_results(user_id);

CREATE TRIGGER survey_results_update_updated_at
  BEFORE UPDATE ON public.survey_results
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.survey_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY survey_results_select_own ON public.survey_results
  FOR SELECT USING (user_id = (SELECT auth.uid()));

CREATE POLICY survey_results_update_own ON public.survey_results
  FOR UPDATE USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));
