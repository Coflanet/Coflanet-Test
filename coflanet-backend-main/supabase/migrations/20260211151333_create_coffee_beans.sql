-- 커피 원두 카탈로그 테이블
CREATE TABLE IF NOT EXISTS public.coffee_beans (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  origin TEXT[] DEFAULT '{}',
  roast_point SMALLINT CHECK (roast_point BETWEEN 1 AND 10),
  roast_level TEXT CHECK (roast_level IN ('light', 'medium', 'medium_dark', 'dark')),
  description TEXT,
  image_url TEXT,
  original_price INTEGER,
  discount_price INTEGER,
  discount_percent SMALLINT CHECK (discount_percent BETWEEN 0 AND 100),
  weight TEXT,
  purchase_url TEXT,
  acidity SMALLINT DEFAULT 0 CHECK (acidity BETWEEN 0 AND 100),
  sweetness SMALLINT DEFAULT 0 CHECK (sweetness BETWEEN 0 AND 100),
  bitterness SMALLINT DEFAULT 0 CHECK (bitterness BETWEEN 0 AND 100),
  body SMALLINT DEFAULT 0 CHECK (body BETWEEN 0 AND 100),
  aroma SMALLINT DEFAULT 0 CHECK (aroma BETWEEN 0 AND 100),
  is_available BOOLEAN DEFAULT true NOT NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE TRIGGER coffee_beans_update_updated_at
  BEFORE UPDATE ON public.coffee_beans
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.coffee_beans ENABLE ROW LEVEL SECURITY;

-- 모든 사용자 조회 가능
CREATE POLICY coffee_beans_select_all ON public.coffee_beans
  FOR SELECT USING (true);
