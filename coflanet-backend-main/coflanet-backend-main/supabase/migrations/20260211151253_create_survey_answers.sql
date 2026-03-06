-- 설문 응답 테이블
CREATE TABLE IF NOT EXISTS public.survey_answers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id UUID NOT NULL REFERENCES public.survey_sessions(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES public.survey_questions(id) ON DELETE CASCADE,
  selected_options TEXT[] DEFAULT '{}',
  score_value SMALLINT,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS uniq_survey_answers_session_question
  ON public.survey_answers(session_id, question_id);

CREATE TRIGGER survey_answers_update_updated_at
  BEFORE UPDATE ON public.survey_answers
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.survey_answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY survey_answers_select_own ON public.survey_answers
  FOR SELECT USING (
    session_id IN (SELECT id FROM public.survey_sessions WHERE user_id = (SELECT auth.uid()))
  );

CREATE POLICY survey_answers_insert_authenticated ON public.survey_answers
  FOR INSERT WITH CHECK (
    session_id IN (SELECT id FROM public.survey_sessions WHERE user_id = (SELECT auth.uid()))
  );

CREATE POLICY survey_answers_update_own ON public.survey_answers
  FOR UPDATE USING (
    session_id IN (SELECT id FROM public.survey_sessions WHERE user_id = (SELECT auth.uid()))
  );
