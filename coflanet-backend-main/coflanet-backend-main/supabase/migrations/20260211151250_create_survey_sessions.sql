-- 설문 세션 테이블
CREATE TABLE IF NOT EXISTS public.survey_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  survey_type TEXT NOT NULL CHECK (survey_type IN ('preference', 'lifestyle')),
  status TEXT NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed', 'analyzing', 'analyzed')),
  current_step SMALLINT NOT NULL DEFAULT 1,
  started_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_survey_sessions_user_id ON public.survey_sessions(user_id);

CREATE TRIGGER survey_sessions_update_updated_at
  BEFORE UPDATE ON public.survey_sessions
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.survey_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY survey_sessions_select_own ON public.survey_sessions
  FOR SELECT USING (user_id = (SELECT auth.uid()));

CREATE POLICY survey_sessions_insert_authenticated ON public.survey_sessions
  FOR INSERT WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY survey_sessions_update_own ON public.survey_sessions
  FOR UPDATE USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));
