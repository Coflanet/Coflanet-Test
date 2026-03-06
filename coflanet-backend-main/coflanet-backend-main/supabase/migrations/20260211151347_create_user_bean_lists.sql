-- 사용자 원두 목록 테이블
CREATE TABLE IF NOT EXISTS public.user_bean_lists (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  bean_id UUID NOT NULL REFERENCES public.coffee_beans(id) ON DELETE CASCADE,
  added_from TEXT CHECK (added_from IN ('recommendation', 'search', 'manual')),
  sort_order SMALLINT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS uniq_user_bean_lists_user_bean
  ON public.user_bean_lists(user_id, bean_id);

CREATE TRIGGER user_bean_lists_update_updated_at
  BEFORE UPDATE ON public.user_bean_lists
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.user_bean_lists ENABLE ROW LEVEL SECURITY;

CREATE POLICY user_bean_lists_select_own ON public.user_bean_lists
  FOR SELECT USING (user_id = (SELECT auth.uid()));

CREATE POLICY user_bean_lists_insert_authenticated ON public.user_bean_lists
  FOR INSERT WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY user_bean_lists_update_own ON public.user_bean_lists
  FOR UPDATE USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY user_bean_lists_delete_own ON public.user_bean_lists
  FOR DELETE USING (user_id = (SELECT auth.uid()));
