-- RPC Function 4개: 사용자별 복합 읽기 함수
-- 공통: LANGUAGE sql, STABLE, SECURITY INVOKER, search_path = ''

-- =============================================
-- 1. get_my_taste_profile()
-- 최신 설문 결과 + 플레이버 목록
-- =============================================
CREATE OR REPLACE FUNCTION public.get_my_taste_profile()
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
  SELECT
    CASE WHEN sr.id IS NULL THEN NULL
    ELSE jsonb_build_object(
      'id', sr.id,
      'coffee_type', sr.coffee_type,
      'coffee_type_label', sr.coffee_type_label,
      'coffee_type_description', sr.coffee_type_description,
      'acidity', sr.acidity,
      'sweetness', sr.sweetness,
      'bitterness', sr.bitterness,
      'body', sr.body,
      'aroma', sr.aroma,
      'created_at', sr.created_at,
      'flavors', (
        SELECT COALESCE(
          jsonb_agg(
            jsonb_build_object(
              'name', srf.name,
              'emoji', srf.emoji,
              'description', srf.description,
              'display_order', srf.display_order
            )
            ORDER BY srf.display_order
          ) FILTER (WHERE srf.id IS NOT NULL),
          '[]'::jsonb
        )
        FROM public.survey_result_flavors srf
        WHERE srf.result_id = sr.id
      )
    )
    END
  FROM public.survey_results sr
  WHERE sr.user_id = (SELECT auth.uid())
  ORDER BY sr.created_at DESC
  LIMIT 1;
$$;

COMMENT ON FUNCTION public.get_my_taste_profile() IS '최신 맛 프로필 + 플레이버 조회 (미완료 시 null)';

-- =============================================
-- 2. get_my_recommendations()
-- 최신 추천 5개 + 원두 상세 + 플레이버 태그
-- =============================================
CREATE OR REPLACE FUNCTION public.get_my_recommendations()
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
  WITH latest_result AS (
    SELECT sr.id
    FROM public.survey_results sr
    WHERE sr.user_id = (SELECT auth.uid())
    ORDER BY sr.created_at DESC
    LIMIT 1
  )
  SELECT
    CASE WHEN lr.id IS NULL THEN NULL
    ELSE jsonb_build_object(
      'result_id', lr.id,
      'recommendations', (
        SELECT COALESCE(
          jsonb_agg(
            jsonb_build_object(
              'id', rec.id,
              'match_score', rec.match_score,
              'display_order', rec.display_order,
              'recommendation_reason', rec.recommendation_reason,
              'bean', jsonb_build_object(
                'id', cb.id,
                'name', cb.name,
                'origin', cb.origin,
                'roast_point', cb.roast_point,
                'roast_level', cb.roast_level,
                'description', cb.description,
                'image_url', cb.image_url,
                'original_price', cb.original_price,
                'discount_price', cb.discount_price,
                'discount_percent', cb.discount_percent,
                'weight', cb.weight,
                'purchase_url', cb.purchase_url,
                'acidity', cb.acidity,
                'sweetness', cb.sweetness,
                'bitterness', cb.bitterness,
                'body', cb.body,
                'aroma', cb.aroma,
                'flavor_tags', (
                  SELECT COALESCE(
                    jsonb_agg(
                      jsonb_build_object(
                        'category', bft.category,
                        'sub_category', bft.sub_category,
                        'descriptor', bft.descriptor
                      )
                      ORDER BY bft.display_order
                    ) FILTER (WHERE bft.id IS NOT NULL),
                    '[]'::jsonb
                  )
                  FROM public.bean_flavor_tags bft
                  WHERE bft.bean_id = cb.id
                )
              )
            )
            ORDER BY rec.display_order
          ),
          '[]'::jsonb
        )
        FROM public.recommendations rec
        JOIN public.coffee_beans cb ON cb.id = rec.bean_id
        WHERE rec.result_id = lr.id
      )
    )
    END
  FROM latest_result lr;
$$;

COMMENT ON FUNCTION public.get_my_recommendations() IS '최신 추천 목록 + 원두 상세 + 플레이버 (미완료 시 null)';

-- =============================================
-- 3. get_my_bean_list()
-- 내 원두 리스트 + 원두 상세 + 플레이버 태그
-- =============================================
CREATE OR REPLACE FUNCTION public.get_my_bean_list()
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'id', ubl.id,
        'added_from', ubl.added_from,
        'sort_order', ubl.sort_order,
        'created_at', ubl.created_at,
        'bean', jsonb_build_object(
          'id', cb.id,
          'name', cb.name,
          'origin', cb.origin,
          'roast_point', cb.roast_point,
          'roast_level', cb.roast_level,
          'description', cb.description,
          'image_url', cb.image_url,
          'original_price', cb.original_price,
          'discount_price', cb.discount_price,
          'discount_percent', cb.discount_percent,
          'weight', cb.weight,
          'acidity', cb.acidity,
          'sweetness', cb.sweetness,
          'bitterness', cb.bitterness,
          'body', cb.body,
          'aroma', cb.aroma,
          'flavor_tags', (
            SELECT COALESCE(
              jsonb_agg(
                jsonb_build_object(
                  'category', bft.category,
                  'sub_category', bft.sub_category,
                  'descriptor', bft.descriptor
                )
                ORDER BY bft.display_order
              ) FILTER (WHERE bft.id IS NOT NULL),
              '[]'::jsonb
            )
            FROM public.bean_flavor_tags bft
            WHERE bft.bean_id = cb.id
          )
        )
      )
      ORDER BY ubl.sort_order NULLS LAST, ubl.created_at DESC
    ),
    '[]'::jsonb
  )
  FROM public.user_bean_lists ubl
  JOIN public.coffee_beans cb ON cb.id = ubl.bean_id
  WHERE ubl.user_id = (SELECT auth.uid());
$$;

COMMENT ON FUNCTION public.get_my_bean_list() IS '내 원두 리스트 + 원두 상세 (빈 리스트 시 [])';

-- =============================================
-- 4. get_my_dashboard()
-- 프로필 + 커피타입 + 원두수 + 레시피수
-- =============================================
CREATE OR REPLACE FUNCTION public.get_my_dashboard()
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
  SELECT jsonb_build_object(
    'display_name', p.display_name,
    'is_onboarding_complete', p.is_onboarding_complete,
    'is_dark_mode', p.is_dark_mode,
    'created_at', p.created_at,
    'latest_coffee_type', (
      SELECT sr.coffee_type
      FROM public.survey_results sr
      WHERE sr.user_id = (SELECT auth.uid())
      ORDER BY sr.created_at DESC
      LIMIT 1
    ),
    'latest_coffee_type_label', (
      SELECT sr.coffee_type_label
      FROM public.survey_results sr
      WHERE sr.user_id = (SELECT auth.uid())
      ORDER BY sr.created_at DESC
      LIMIT 1
    ),
    'bean_count', (
      SELECT COUNT(*)::int
      FROM public.user_bean_lists ubl
      WHERE ubl.user_id = (SELECT auth.uid())
    ),
    'custom_recipe_count', (
      SELECT COUNT(*)::int
      FROM public.recipes r
      WHERE r.user_id = (SELECT auth.uid())
    )
  )
  FROM public.profiles p
  WHERE p.user_id = (SELECT auth.uid());
$$;

COMMENT ON FUNCTION public.get_my_dashboard() IS '마이페이지 대시보드 (프로필 + 집계)';

-- =============================================
-- 권한 설정: PUBLIC 제거 + authenticated만 허용
-- =============================================
REVOKE EXECUTE ON FUNCTION public.get_my_taste_profile() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.get_my_recommendations() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.get_my_bean_list() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.get_my_dashboard() FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.get_my_taste_profile() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_my_recommendations() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_my_bean_list() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_my_dashboard() TO authenticated;
