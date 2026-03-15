BEGIN;

CREATE OR REPLACE FUNCTION public.delete_user_data(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_auth_uid uuid := (SELECT auth.uid());
  v_role text := COALESCE(current_setting('request.jwt.claim.role', true), '');
  v_target_user uuid := p_user_id;
  v_deleted_recommendations integer := 0;
  v_deleted_result_flavors integer := 0;
  v_deleted_results integer := 0;
  v_deleted_answers integer := 0;
  v_deleted_sessions integer := 0;
  v_deleted_bean_list integer := 0;
  v_deleted_recipe_steps integer := 0;
  v_deleted_recipe_aroma_tags integer := 0;
  v_deleted_recipes integer := 0;
  v_deleted_brew_logs integer := 0;
  v_deleted_profile integer := 0;
BEGIN
  IF v_target_user IS NULL THEN
    RAISE EXCEPTION 'TARGET_USER_REQUIRED';
  END IF;

  IF v_role <> 'service_role' THEN
    IF v_auth_uid IS NULL THEN
      RAISE EXCEPTION 'UNAUTHORIZED';
    END IF;
    IF v_auth_uid <> v_target_user THEN
      RAISE EXCEPTION 'FORBIDDEN';
    END IF;
  END IF;

  DELETE FROM public.recommendations r
  USING public.survey_results sr
  WHERE r.result_id = sr.id
    AND sr.user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_recommendations = ROW_COUNT;

  DELETE FROM public.survey_result_flavors srf
  USING public.survey_results sr
  WHERE srf.result_id = sr.id
    AND sr.user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_result_flavors = ROW_COUNT;

  DELETE FROM public.survey_results
  WHERE user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_results = ROW_COUNT;

  DELETE FROM public.survey_answers sa
  USING public.survey_sessions ss
  WHERE sa.session_id = ss.id
    AND ss.user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_answers = ROW_COUNT;

  DELETE FROM public.survey_sessions
  WHERE user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_sessions = ROW_COUNT;

  DELETE FROM public.user_bean_lists
  WHERE user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_bean_list = ROW_COUNT;

  DELETE FROM public.recipe_steps rs
  USING public.recipes r
  WHERE rs.recipe_id = r.id
    AND r.user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_recipe_steps = ROW_COUNT;

  DELETE FROM public.recipe_aroma_tags rat
  USING public.recipes r
  WHERE rat.recipe_id = r.id
    AND r.user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_recipe_aroma_tags = ROW_COUNT;

  DELETE FROM public.recipes
  WHERE user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_recipes = ROW_COUNT;

  DELETE FROM public.brew_logs
  WHERE user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_brew_logs = ROW_COUNT;

  DELETE FROM public.profiles
  WHERE user_id = v_target_user;
  GET DIAGNOSTICS v_deleted_profile = ROW_COUNT;

  RETURN jsonb_build_object(
    'user_id', v_target_user,
    'recommendations', v_deleted_recommendations,
    'survey_result_flavors', v_deleted_result_flavors,
    'survey_results', v_deleted_results,
    'survey_answers', v_deleted_answers,
    'survey_sessions', v_deleted_sessions,
    'user_bean_lists', v_deleted_bean_list,
    'recipe_steps', v_deleted_recipe_steps,
    'recipe_aroma_tags', v_deleted_recipe_aroma_tags,
    'recipes', v_deleted_recipes,
    'brew_logs', v_deleted_brew_logs,
    'profiles', v_deleted_profile
  );
END;
$$;

REVOKE ALL ON FUNCTION public.delete_user_data(uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.delete_user_data(uuid) TO authenticated, service_role;

COMMIT;
