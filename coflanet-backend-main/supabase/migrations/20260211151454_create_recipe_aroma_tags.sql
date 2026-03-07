-- 레시피 향 태그 테이블
CREATE TABLE IF NOT EXISTS public.recipe_aroma_tags (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  recipe_id UUID NOT NULL REFERENCES public.recipes(id) ON DELETE CASCADE,
  emoji TEXT,
  name TEXT NOT NULL,
  display_order SMALLINT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_recipe_aroma_tags_recipe_id ON public.recipe_aroma_tags(recipe_id);

CREATE TRIGGER recipe_aroma_tags_update_updated_at
  BEFORE UPDATE ON public.recipe_aroma_tags
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.recipe_aroma_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY recipe_aroma_tags_select_own_and_system ON public.recipe_aroma_tags
  FOR SELECT USING (
    recipe_id IN (SELECT id FROM public.recipes WHERE user_id IS NULL OR user_id = (SELECT auth.uid()))
  );

CREATE POLICY recipe_aroma_tags_insert_authenticated ON public.recipe_aroma_tags
  FOR INSERT WITH CHECK (
    recipe_id IN (SELECT id FROM public.recipes WHERE user_id = (SELECT auth.uid()))
  );

CREATE POLICY recipe_aroma_tags_update_own ON public.recipe_aroma_tags
  FOR UPDATE USING (
    recipe_id IN (SELECT id FROM public.recipes WHERE user_id = (SELECT auth.uid()))
  );

CREATE POLICY recipe_aroma_tags_delete_own ON public.recipe_aroma_tags
  FOR DELETE USING (
    recipe_id IN (SELECT id FROM public.recipes WHERE user_id = (SELECT auth.uid()))
  );
