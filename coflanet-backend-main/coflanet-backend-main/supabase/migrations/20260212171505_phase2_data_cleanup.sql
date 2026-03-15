BEGIN;

UPDATE public.coffee_beans
SET name = replace(name, '%%', '%')
WHERE position('%%' in name) > 0;

UPDATE public.bean_flavor_tags
SET descriptor_ko = descriptor
WHERE descriptor_ko IS NULL
  AND descriptor IS NOT NULL;

WITH tag_counts AS (
  SELECT
    bean_id,
    COUNT(*)::integer AS flavor_count
  FROM public.bean_flavor_tags
  GROUP BY bean_id
)
UPDATE public.coffee_beans cb
SET aroma = LEAST(100, GREATEST(0, 20 + (tc.flavor_count * 4)))
FROM tag_counts tc
WHERE cb.id = tc.bean_id;

UPDATE public.coffee_beans
SET description = CONCAT(
  name,
  ' is a specialty coffee bean profile in Coflanet catalog.'
)
WHERE description IS NULL OR btrim(description) = '';

COMMIT;
