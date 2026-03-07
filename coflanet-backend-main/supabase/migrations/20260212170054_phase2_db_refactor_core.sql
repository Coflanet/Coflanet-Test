BEGIN;

-- 1) RLS WITH CHECK gap fixes
DROP POLICY IF EXISTS survey_answers_update_own ON public.survey_answers;
CREATE POLICY survey_answers_update_own ON public.survey_answers
  FOR UPDATE TO authenticated
  USING (
    session_id IN (
      SELECT id
      FROM public.survey_sessions
      WHERE user_id = (SELECT auth.uid())
    )
  )
  WITH CHECK (
    session_id IN (
      SELECT id
      FROM public.survey_sessions
      WHERE user_id = (SELECT auth.uid())
    )
  );

DROP POLICY IF EXISTS recipe_steps_update_own ON public.recipe_steps;
CREATE POLICY recipe_steps_update_own ON public.recipe_steps
  FOR UPDATE TO authenticated
  USING (
    recipe_id IN (
      SELECT id
      FROM public.recipes
      WHERE user_id = (SELECT auth.uid())
    )
  )
  WITH CHECK (
    recipe_id IN (
      SELECT id
      FROM public.recipes
      WHERE user_id = (SELECT auth.uid())
    )
  );

DROP POLICY IF EXISTS recipe_aroma_tags_update_own ON public.recipe_aroma_tags;
CREATE POLICY recipe_aroma_tags_update_own ON public.recipe_aroma_tags
  FOR UPDATE TO authenticated
  USING (
    recipe_id IN (
      SELECT id
      FROM public.recipes
      WHERE user_id = (SELECT auth.uid())
    )
  )
  WITH CHECK (
    recipe_id IN (
      SELECT id
      FROM public.recipes
      WHERE user_id = (SELECT auth.uid())
    )
  );

-- 2) Composite indexes for common access paths
CREATE INDEX IF NOT EXISTS idx_user_bean_lists_user_sort
  ON public.user_bean_lists(user_id, sort_order);

CREATE INDEX IF NOT EXISTS idx_survey_sessions_user_status
  ON public.survey_sessions(user_id, status);

-- 3) brew_logs table (core missing domain table)
CREATE TABLE IF NOT EXISTS public.brew_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  bean_id UUID REFERENCES public.coffee_beans(id) ON DELETE SET NULL,
  brew_method_id UUID REFERENCES public.brew_methods(id) ON DELETE SET NULL,
  recipe_id UUID REFERENCES public.recipes(id) ON DELETE SET NULL,
  coffee_amount_g NUMERIC(5,1),
  water_temp_c NUMERIC(4,1),
  grind_size_um NUMERIC(6,0),
  total_water_ml NUMERIC(6,1),
  total_yield_g NUMERIC(6,1),
  total_duration_seconds INTEGER,
  cups SMALLINT DEFAULT 1,
  strength TEXT,
  rating SMALLINT,
  notes TEXT,
  brewed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT brew_logs_cups_check CHECK (cups >= 1 AND cups <= 4),
  CONSTRAINT brew_logs_strength_check CHECK (
    strength IN ('light', 'balanced', 'strong', 'lungo', 'espresso', 'ristretto')
  ),
  CONSTRAINT brew_logs_rating_check CHECK (rating >= 1 AND rating <= 5)
);

ALTER TABLE public.brew_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS brew_logs_select_own ON public.brew_logs;
CREATE POLICY brew_logs_select_own ON public.brew_logs
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS brew_logs_insert_authenticated ON public.brew_logs;
CREATE POLICY brew_logs_insert_authenticated ON public.brew_logs
  FOR INSERT TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS brew_logs_update_own ON public.brew_logs;
CREATE POLICY brew_logs_update_own ON public.brew_logs
  FOR UPDATE TO authenticated
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS brew_logs_delete_own ON public.brew_logs;
CREATE POLICY brew_logs_delete_own ON public.brew_logs
  FOR DELETE TO authenticated
  USING (user_id = (SELECT auth.uid()));

CREATE INDEX IF NOT EXISTS idx_brew_logs_user_id ON public.brew_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_brew_logs_bean_id ON public.brew_logs(bean_id);
CREATE INDEX IF NOT EXISTS idx_brew_logs_brew_method_id ON public.brew_logs(brew_method_id);
CREATE INDEX IF NOT EXISTS idx_brew_logs_user_brewed ON public.brew_logs(user_id, brewed_at DESC);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_trigger
    WHERE tgname = 'brew_logs_update_updated_at'
      AND tgrelid = 'public.brew_logs'::regclass
  ) THEN
    CREATE TRIGGER brew_logs_update_updated_at
      BEFORE UPDATE ON public.brew_logs
      FOR EACH ROW
      EXECUTE FUNCTION public.update_updated_at();
  END IF;
END
$$;

-- 4) profiles extension
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS avatar_url TEXT,
  ADD COLUMN IF NOT EXISTS coffee_level TEXT,
  ADD COLUMN IF NOT EXISTS survey_completed BOOLEAN NOT NULL DEFAULT false;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'profiles_coffee_level_check'
      AND conrelid = 'public.profiles'::regclass
  ) THEN
    ALTER TABLE public.profiles
      ADD CONSTRAINT profiles_coffee_level_check
      CHECK (coffee_level IN ('beginner', 'enthusiast', 'home_barista', 'professional'));
  END IF;
END
$$;

-- 5) coffee_beans extension
ALTER TABLE public.coffee_beans
  ADD COLUMN IF NOT EXISTS variety TEXT,
  ADD COLUMN IF NOT EXISTS processing TEXT,
  ADD COLUMN IF NOT EXISTS external_review_count INTEGER NOT NULL DEFAULT 0;

-- 6) bean_flavor_tags extension
ALTER TABLE public.bean_flavor_tags
  ADD COLUMN IF NOT EXISTS descriptor_ko TEXT;

-- 7) brew_methods extension
ALTER TABLE public.brew_methods
  ADD COLUMN IF NOT EXISTS equipment TEXT[] NOT NULL DEFAULT '{}'::TEXT[];

-- 8) recipes extension + numeric validation checks
ALTER TABLE public.recipes
  ADD COLUMN IF NOT EXISTS yield_g NUMERIC(5,1),
  ADD COLUMN IF NOT EXISTS extraction_time_seconds INTEGER;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'recipes_coffee_amount_g_range_check'
      AND conrelid = 'public.recipes'::regclass
  ) THEN
    ALTER TABLE public.recipes
      ADD CONSTRAINT recipes_coffee_amount_g_range_check
      CHECK (coffee_amount_g IS NULL OR (coffee_amount_g >= 1 AND coffee_amount_g <= 100));
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'recipes_water_temp_c_range_check'
      AND conrelid = 'public.recipes'::regclass
  ) THEN
    ALTER TABLE public.recipes
      ADD CONSTRAINT recipes_water_temp_c_range_check
      CHECK (water_temp_c IS NULL OR (water_temp_c >= 50 AND water_temp_c <= 100));
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'recipes_grind_size_um_range_check'
      AND conrelid = 'public.recipes'::regclass
  ) THEN
    ALTER TABLE public.recipes
      ADD CONSTRAINT recipes_grind_size_um_range_check
      CHECK (grind_size_um IS NULL OR (grind_size_um >= 50 AND grind_size_um <= 3000));
  END IF;
END
$$;

COMMIT;
