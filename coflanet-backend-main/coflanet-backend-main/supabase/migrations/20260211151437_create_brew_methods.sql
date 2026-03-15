-- 추출 기구 마스터 테이블
CREATE TABLE IF NOT EXISTS public.brew_methods (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  category TEXT NOT NULL CHECK (category IN ('machine', 'handdrip', 'capsule', 'etc')),
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE TRIGGER brew_methods_update_updated_at
  BEFORE UPDATE ON public.brew_methods
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.brew_methods ENABLE ROW LEVEL SECURITY;

CREATE POLICY brew_methods_select_all ON public.brew_methods
  FOR SELECT USING (true);
