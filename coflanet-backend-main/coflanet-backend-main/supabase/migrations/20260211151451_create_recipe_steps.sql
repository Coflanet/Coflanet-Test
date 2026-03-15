-- 레시피 추출 단계 테이블
CREATE TABLE IF NOT EXISTS public.recipe_steps (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  recipe_id UUID NOT NULL REFERENCES public.recipes(id) ON DELETE CASCADE,
  step_number SMALLINT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  step_type TEXT CHECK (step_type IN ('preparation', 'brewing', 'waiting')),
  water_amount_ml NUMERIC(6,1),
  yield_amount_g NUMERIC(6,1),
  duration_seconds INTEGER,
  action_text TEXT,
  illustration_emoji TEXT,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_recipe_steps_recipe_id ON public.recipe_steps(recipe_id);

CREATE TRIGGER recipe_steps_update_updated_at
  BEFORE UPDATE ON public.recipe_steps
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.recipe_steps ENABLE ROW LEVEL SECURITY;

-- 본인 레시피 단계 + 시스템 기본 레시피 단계 조회
CREATE POLICY recipe_steps_select_own_and_system ON public.recipe_steps
  FOR SELECT USING (
    recipe_id IN (SELECT id FROM public.recipes WHERE user_id IS NULL OR user_id = (SELECT auth.uid()))
  );

CREATE POLICY recipe_steps_insert_authenticated ON public.recipe_steps
  FOR INSERT WITH CHECK (
    recipe_id IN (SELECT id FROM public.recipes WHERE user_id = (SELECT auth.uid()))
  );

CREATE POLICY recipe_steps_update_own ON public.recipe_steps
  FOR UPDATE USING (
    recipe_id IN (SELECT id FROM public.recipes WHERE user_id = (SELECT auth.uid()))
  );

CREATE POLICY recipe_steps_delete_own ON public.recipe_steps
  FOR DELETE USING (
    recipe_id IN (SELECT id FROM public.recipes WHERE user_id = (SELECT auth.uid()))
  );
