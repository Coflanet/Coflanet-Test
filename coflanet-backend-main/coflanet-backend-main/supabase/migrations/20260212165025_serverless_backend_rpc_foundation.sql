BEGIN;

-- 온보딩 분기 상태 조회
CREATE OR REPLACE FUNCTION public.get_onboarding_status()
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_profile RECORD;
  v_latest_session RECORD;
  v_has_recommendations boolean := false;
  v_next_screen text := 'onboarding';
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  SELECT
    p.user_id,
    p.display_name,
    p.onboarding_reasons
  INTO v_profile
  FROM public.profiles p
  WHERE p.user_id = v_uid;

  SELECT
    s.id,
    s.survey_type
  INTO v_latest_session
  FROM public.survey_sessions s
  WHERE s.user_id = v_uid
    AND s.status = 'analyzed'
  ORDER BY s.created_at DESC
  LIMIT 1;

  IF v_latest_session.id IS NOT NULL THEN
    SELECT EXISTS (
      SELECT 1
      FROM public.survey_results r
      JOIN public.recommendations rec
        ON rec.result_id = r.id
      WHERE r.session_id = v_latest_session.id
      LIMIT 1
    ) INTO v_has_recommendations;
  END IF;

  IF v_profile.user_id IS NULL THEN
    v_next_screen := 'onboarding';
  ELSIF v_profile.display_name IS NULL OR btrim(v_profile.display_name) = '' THEN
    v_next_screen := 'onboarding';
  ELSIF COALESCE(array_length(v_profile.onboarding_reasons, 1), 0) = 0 THEN
    v_next_screen := 'onboarding';
  ELSIF v_latest_session.id IS NULL THEN
    v_next_screen := 'survey';
  ELSIF NOT v_has_recommendations THEN
    v_next_screen := 'survey_result';
  ELSE
    v_next_screen := 'main';
  END IF;

  RETURN jsonb_build_object(
    'has_profile', v_profile.user_id IS NOT NULL,
    'has_nickname', v_profile.display_name IS NOT NULL AND btrim(v_profile.display_name) <> '',
    'has_signup_reasons', COALESCE(array_length(v_profile.onboarding_reasons, 1), 0) > 0,
    'has_completed_survey', v_latest_session.id IS NOT NULL,
    'has_recommendations', v_has_recommendations,
    'latest_survey_type', v_latest_session.survey_type,
    'next_screen', v_next_screen
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_onboarding_status() TO authenticated;

-- 설문 재시작용 세션 생성
CREATE OR REPLACE FUNCTION public.retake_survey()
RETURNS jsonb
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_new_session_id uuid;
  v_latest_type text;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  SELECT s.survey_type
  INTO v_latest_type
  FROM public.survey_sessions s
  WHERE s.user_id = v_uid
  ORDER BY s.created_at DESC
  LIMIT 1;

  IF v_latest_type IS NULL THEN
    v_latest_type := 'preference';
  END IF;

  UPDATE public.survey_sessions
  SET
    status = 'completed',
    completed_at = COALESCE(completed_at, now()),
    updated_at = now()
  WHERE user_id = v_uid
    AND status IN ('in_progress', 'analyzing');

  INSERT INTO public.survey_sessions (
    user_id,
    survey_type,
    status,
    current_step,
    started_at
  )
  VALUES (
    v_uid,
    v_latest_type,
    'in_progress',
    1,
    now()
  )
  RETURNING id INTO v_new_session_id;

  RETURN jsonb_build_object(
    'new_session_id', v_new_session_id,
    'ready_for_new_survey', true
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.retake_survey() TO authenticated;

-- 사용자 원두 리스트에서 단건 제거 + 정렬 재계산
CREATE OR REPLACE FUNCTION public.remove_from_coffee_list(p_bean_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_deleted_count integer := 0;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  DELETE FROM public.user_bean_lists ubl
  WHERE ubl.user_id = v_uid
    AND ubl.bean_id = p_bean_id;

  GET DIAGNOSTICS v_deleted_count = ROW_COUNT;

  WITH reordered AS (
    SELECT
      id,
      row_number() OVER (ORDER BY sort_order, created_at, id) AS rn
    FROM public.user_bean_lists
    WHERE user_id = v_uid
  )
  UPDATE public.user_bean_lists u
  SET sort_order = reordered.rn
  FROM reordered
  WHERE u.id = reordered.id;

  RETURN jsonb_build_object(
    'removed', v_deleted_count > 0,
    'deleted_count', v_deleted_count
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.remove_from_coffee_list(uuid) TO authenticated;

-- 사용자 원두 리스트 수동 정렬
CREATE OR REPLACE FUNCTION public.reorder_coffee_list(p_bean_ids uuid[])
RETURNS jsonb
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_updated_count integer := 0;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  IF p_bean_ids IS NULL OR COALESCE(array_length(p_bean_ids, 1), 0) = 0 THEN
    RETURN jsonb_build_object(
      'updated_count', 0,
      'message', 'no_op'
    );
  END IF;

  WITH ordered_ids AS (
    SELECT
      bean_id,
      ord::smallint AS new_sort_order
    FROM unnest(p_bean_ids) WITH ORDINALITY AS t(bean_id, ord)
  )
  UPDATE public.user_bean_lists u
  SET sort_order = o.new_sort_order
  FROM ordered_ids o
  WHERE u.user_id = v_uid
    AND u.bean_id = o.bean_id;

  GET DIAGNOSTICS v_updated_count = ROW_COUNT;

  RETURN jsonb_build_object(
    'updated_count', v_updated_count
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.reorder_coffee_list(uuid[]) TO authenticated;

COMMIT;
