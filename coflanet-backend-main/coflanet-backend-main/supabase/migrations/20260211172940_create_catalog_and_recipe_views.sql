-- View 2개 생성: v_coffee_bean_catalog, v_recipe_overview
-- 앱에서 원두 카탈로그와 레시피 목록을 단일 호출로 조회

-- =============================================
-- 1. v_coffee_bean_catalog
-- 원두 + 플레이버 태그를 JSONB 배열로 집계
-- =============================================
CREATE OR REPLACE VIEW public.v_coffee_bean_catalog
WITH (security_invoker = true)
AS
SELECT
  cb.id,
  cb.name,
  cb.origin,
  cb.roast_point,
  cb.roast_level,
  cb.description,
  cb.image_url,
  cb.original_price,
  cb.discount_price,
  cb.discount_percent,
  cb.weight,
  cb.purchase_url,
  cb.acidity,
  cb.sweetness,
  cb.bitterness,
  cb.body,
  cb.aroma,
  cb.is_available,
  cb.stock,
  cb.created_at,
  cb.updated_at,
  COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'category', bft.category,
        'sub_category', bft.sub_category,
        'descriptor', bft.descriptor,
        'display_order', bft.display_order
      )
      ORDER BY bft.display_order
    ) FILTER (WHERE bft.id IS NOT NULL),
    '[]'::jsonb
  ) AS flavor_tags
FROM public.coffee_beans cb
LEFT JOIN public.bean_flavor_tags bft ON bft.bean_id = cb.id
GROUP BY cb.id;

COMMENT ON VIEW public.v_coffee_bean_catalog IS '원두 카탈로그 + 플레이버 태그 JSONB 집계 뷰';

-- =============================================
-- 2. v_recipe_overview
-- 레시피 + 기구 + 스텝수 + 아로마 태그
-- =============================================
CREATE OR REPLACE VIEW public.v_recipe_overview
WITH (security_invoker = true)
AS
SELECT
  r.id,
  r.user_id,
  r.bean_id,
  r.brew_method_id,
  r.name,
  r.cups,
  r.strength,
  r.coffee_amount_g,
  r.water_temp_c,
  r.grind_size_um,
  r.total_water_ml,
  r.total_yield_g,
  r.total_duration_seconds,
  r.aroma_description,
  r.is_default,
  r.created_at,
  r.updated_at,
  -- 기구 정보
  jsonb_build_object(
    'name', bm.name,
    'slug', bm.slug,
    'category', bm.category,
    'image_url', bm.image_url
  ) AS brew_method,
  -- 스텝 수 (서브쿼리)
  (
    SELECT COUNT(*)::int
    FROM public.recipe_steps rs
    WHERE rs.recipe_id = r.id
  ) AS step_count,
  -- 아로마 태그 JSONB 배열 (서브쿼리)
  (
    SELECT COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'emoji', rat.emoji,
          'name', rat.name
        )
        ORDER BY rat.display_order
      ) FILTER (WHERE rat.id IS NOT NULL),
      '[]'::jsonb
    )
    FROM public.recipe_aroma_tags rat
    WHERE rat.recipe_id = r.id
  ) AS aroma_tags
FROM public.recipes r
JOIN public.brew_methods bm ON bm.id = r.brew_method_id;

COMMENT ON VIEW public.v_recipe_overview IS '레시피 + 기구 + 스텝수 + 아로마 태그 뷰';

-- =============================================
-- 권한 설정
-- =============================================
GRANT SELECT ON public.v_coffee_bean_catalog TO anon, authenticated;
GRANT SELECT ON public.v_recipe_overview TO authenticated;
