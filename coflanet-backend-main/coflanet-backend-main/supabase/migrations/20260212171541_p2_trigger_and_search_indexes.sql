BEGIN;

CREATE OR REPLACE FUNCTION public.reorder_bean_list_after_delete()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  WITH reordered AS (
    SELECT
      id,
      row_number() OVER (ORDER BY sort_order, created_at, id) AS rn
    FROM public.user_bean_lists
    WHERE user_id = OLD.user_id
  )
  UPDATE public.user_bean_lists u
  SET sort_order = reordered.rn
  FROM reordered
  WHERE u.id = reordered.id;

  RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS on_bean_list_deleted ON public.user_bean_lists;
CREATE TRIGGER on_bean_list_deleted
AFTER DELETE ON public.user_bean_lists
FOR EACH ROW
EXECUTE FUNCTION public.reorder_bean_list_after_delete();

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS idx_coffee_beans_name_trgm
  ON public.coffee_beans
  USING gin(name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_coffee_beans_is_available
  ON public.coffee_beans(is_available)
  WHERE is_available = true;

COMMIT;
