-- 원두 플레이버 태그 테이블
CREATE TABLE IF NOT EXISTS public.bean_flavor_tags (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  bean_id UUID NOT NULL REFERENCES public.coffee_beans(id) ON DELETE CASCADE,
  category TEXT NOT NULL CHECK (category IN ('Fruity', 'Floral', 'Nutty_Cocoa', 'Roasted')),
  sub_category TEXT,
  descriptor TEXT,
  display_order SMALLINT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_bean_flavor_tags_bean_id ON public.bean_flavor_tags(bean_id);

CREATE TRIGGER bean_flavor_tags_update_updated_at
  BEFORE UPDATE ON public.bean_flavor_tags
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.bean_flavor_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY bean_flavor_tags_select_all ON public.bean_flavor_tags
  FOR SELECT USING (true);
