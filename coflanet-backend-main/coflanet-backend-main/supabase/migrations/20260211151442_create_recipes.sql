-- 레시피 테이블 (시스템 기본 + 사용자 커스텀)
CREATE TABLE IF NOT EXISTS public.recipes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  bean_id UUID REFERENCES public.coffee_beans(id) ON DELETE SET NULL,
  brew_method_id UUID NOT NULL REFERENCES public.brew_methods(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  cups SMALLINT DEFAULT 1 CHECK (cups BETWEEN 1 AND 4),
  strength TEXT CHECK (strength IN ('light', 'balanced', 'strong', 'lungo', 'espresso', 'ristretto')),
  coffee_amount_g NUMERIC(5,1),
  water_temp_c NUMERIC(4,1),
  grind_size_um NUMERIC(6,0),
  total_water_ml NUMERIC(6,1),
  total_yield_g NUMERIC(6,1),
  total_duration_seconds INTEGER,
  aroma_description TEXT,
  is_default BOOLEAN DEFAULT false NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_recipes_user_id ON public.recipes(user_id);
CREATE INDEX IF NOT EXISTS idx_recipes_bean_id ON public.recipes(bean_id);

CREATE TRIGGER recipes_update_updated_at
  BEFORE UPDATE ON public.recipes
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.recipes ENABLE ROW LEVEL SECURITY;

-- 본인 레시피 + 시스템 기본 레시피(user_id IS NULL) 조회
CREATE POLICY recipes_select_own_and_system ON public.recipes
  FOR SELECT USING (user_id IS NULL OR user_id = (SELECT auth.uid()));

CREATE POLICY recipes_insert_authenticated ON public.recipes
  FOR INSERT WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY recipes_update_own ON public.recipes
  FOR UPDATE USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY recipes_delete_own ON public.recipes
  FOR DELETE USING (user_id = (SELECT auth.uid()));
