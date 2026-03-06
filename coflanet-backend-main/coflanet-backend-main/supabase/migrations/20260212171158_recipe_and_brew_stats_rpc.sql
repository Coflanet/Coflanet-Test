BEGIN;

CREATE OR REPLACE FUNCTION public.get_merged_recipe(
  p_brew_method_id uuid,
  p_bean_id uuid DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_base_recipe public.recipes%ROWTYPE;
  v_bean_recipe public.recipes%ROWTYPE;
  v_user_recipe public.recipes%ROWTYPE;
  v_source_level text := 'none';
  v_selected_recipe_id uuid;
  v_steps jsonb := '[]'::jsonb;
  v_aroma_tags jsonb := '[]'::jsonb;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  SELECT *
  INTO v_base_recipe
  FROM public.recipes
  WHERE brew_method_id = p_brew_method_id
    AND bean_id IS NULL
    AND user_id IS NULL
    AND is_default = true
  ORDER BY updated_at DESC, created_at DESC
  LIMIT 1;

  IF p_bean_id IS NOT NULL THEN
    SELECT *
    INTO v_bean_recipe
    FROM public.recipes
    WHERE brew_method_id = p_brew_method_id
      AND bean_id = p_bean_id
      AND user_id IS NULL
    ORDER BY updated_at DESC, created_at DESC
    LIMIT 1;
  END IF;

  SELECT *
  INTO v_user_recipe
  FROM public.recipes
  WHERE brew_method_id = p_brew_method_id
    AND user_id = v_uid
    AND bean_id IS NOT DISTINCT FROM p_bean_id
  ORDER BY updated_at DESC, created_at DESC
  LIMIT 1;

  IF v_user_recipe.id IS NOT NULL THEN
    v_source_level := 'user_custom';
    v_selected_recipe_id := v_user_recipe.id;
  ELSIF v_bean_recipe.id IS NOT NULL THEN
    v_source_level := 'bean_default';
    v_selected_recipe_id := v_bean_recipe.id;
  ELSIF v_base_recipe.id IS NOT NULL THEN
    v_source_level := 'base';
    v_selected_recipe_id := v_base_recipe.id;
  END IF;

  IF v_selected_recipe_id IS NOT NULL THEN
    SELECT COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'id', rs.id,
          'step_number', rs.step_number,
          'title', rs.title,
          'description', rs.description,
          'step_type', rs.step_type,
          'water_amount_ml', rs.water_amount_ml,
          'yield_amount_g', rs.yield_amount_g,
          'duration_seconds', rs.duration_seconds,
          'action_text', rs.action_text,
          'illustration_emoji', rs.illustration_emoji
        ) ORDER BY rs.step_number
      ),
      '[]'::jsonb
    )
    INTO v_steps
    FROM public.recipe_steps rs
    WHERE rs.recipe_id = v_selected_recipe_id;

    SELECT COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'id', rat.id,
          'emoji', rat.emoji,
          'name', rat.name,
          'display_order', rat.display_order
        ) ORDER BY rat.display_order
      ),
      '[]'::jsonb
    )
    INTO v_aroma_tags
    FROM public.recipe_aroma_tags rat
    WHERE rat.recipe_id = v_selected_recipe_id;
  END IF;

  RETURN jsonb_build_object(
    'source_level', v_source_level,
    'recipe_id', COALESCE(v_user_recipe.id, v_bean_recipe.id, v_base_recipe.id),
    'brew_method_id', p_brew_method_id,
    'bean_id', p_bean_id,
    'name', COALESCE(v_user_recipe.name, v_bean_recipe.name, v_base_recipe.name),
    'cups', COALESCE(v_user_recipe.cups, v_bean_recipe.cups, v_base_recipe.cups),
    'strength', COALESCE(v_user_recipe.strength, v_bean_recipe.strength, v_base_recipe.strength),
    'coffee_amount_g', COALESCE(v_user_recipe.coffee_amount_g, v_bean_recipe.coffee_amount_g, v_base_recipe.coffee_amount_g),
    'water_temp_c', COALESCE(v_user_recipe.water_temp_c, v_bean_recipe.water_temp_c, v_base_recipe.water_temp_c),
    'grind_size_um', COALESCE(v_user_recipe.grind_size_um, v_bean_recipe.grind_size_um, v_base_recipe.grind_size_um),
    'total_water_ml', COALESCE(v_user_recipe.total_water_ml, v_bean_recipe.total_water_ml, v_base_recipe.total_water_ml),
    'total_yield_g', COALESCE(v_user_recipe.total_yield_g, v_bean_recipe.total_yield_g, v_base_recipe.total_yield_g),
    'total_duration_seconds', COALESCE(v_user_recipe.total_duration_seconds, v_bean_recipe.total_duration_seconds, v_base_recipe.total_duration_seconds),
    'yield_g', COALESCE(v_user_recipe.yield_g, v_bean_recipe.yield_g, v_base_recipe.yield_g),
    'extraction_time_seconds', COALESCE(v_user_recipe.extraction_time_seconds, v_bean_recipe.extraction_time_seconds, v_base_recipe.extraction_time_seconds),
    'aroma_description', COALESCE(v_user_recipe.aroma_description, v_bean_recipe.aroma_description, v_base_recipe.aroma_description),
    'steps', v_steps,
    'aroma_tags', v_aroma_tags
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_merged_recipe(uuid, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_merged_recipe(uuid, uuid) TO authenticated;

CREATE OR REPLACE FUNCTION public.save_custom_recipe(
  p_brew_method_id uuid,
  p_bean_id uuid,
  p_name text,
  p_values jsonb DEFAULT '{}'::jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_uid uuid := (SELECT auth.uid());
  v_recipe_id uuid;
  v_is_new boolean := false;
  v_step jsonb;
  v_tag jsonb;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED';
  END IF;

  SELECT r.id
  INTO v_recipe_id
  FROM public.recipes r
  WHERE r.user_id = v_uid
    AND r.brew_method_id = p_brew_method_id
    AND r.bean_id IS NOT DISTINCT FROM p_bean_id
  ORDER BY r.updated_at DESC, r.created_at DESC
  LIMIT 1;

  IF v_recipe_id IS NULL THEN
    v_is_new := true;
    INSERT INTO public.recipes (
      user_id,
      bean_id,
      brew_method_id,
      name,
      cups,
      strength,
      coffee_amount_g,
      water_temp_c,
      grind_size_um,
      total_water_ml,
      total_yield_g,
      total_duration_seconds,
      aroma_description,
      yield_g,
      extraction_time_seconds,
      is_default
    )
    VALUES (
      v_uid,
      p_bean_id,
      p_brew_method_id,
      COALESCE(p_name, 'Custom Recipe'),
      NULLIF(p_values->>'cups', '')::smallint,
      p_values->>'strength',
      NULLIF(p_values->>'coffee_amount_g', '')::numeric,
      NULLIF(p_values->>'water_temp_c', '')::numeric,
      NULLIF(p_values->>'grind_size_um', '')::numeric,
      NULLIF(p_values->>'total_water_ml', '')::numeric,
      NULLIF(p_values->>'total_yield_g', '')::numeric,
      NULLIF(p_values->>'total_duration_seconds', '')::integer,
      p_values->>'aroma_description',
      NULLIF(p_values->>'yield_g', '')::numeric,
      NULLIF(p_values->>'extraction_time_seconds', '')::integer,
      false
    )
    RETURNING id INTO v_recipe_id;
  ELSE
    UPDATE public.recipes
    SET
      name = COALESCE(p_name, name),
      cups = COALESCE(NULLIF(p_values->>'cups', '')::smallint, cups),
      strength = COALESCE(p_values->>'strength', strength),
      coffee_amount_g = COALESCE(NULLIF(p_values->>'coffee_amount_g', '')::numeric, coffee_amount_g),
      water_temp_c = COALESCE(NULLIF(p_values->>'water_temp_c', '')::numeric, water_temp_c),
      grind_size_um = COALESCE(NULLIF(p_values->>'grind_size_um', '')::numeric, grind_size_um),
      total_water_ml = COALESCE(NULLIF(p_values->>'total_water_ml', '')::numeric, total_water_ml),
      total_yield_g = COALESCE(NULLIF(p_values->>'total_yield_g', '')::numeric, total_yield_g),
      total_duration_seconds = COALESCE(NULLIF(p_values->>'total_duration_seconds', '')::integer, total_duration_seconds),
      aroma_description = COALESCE(p_values->>'aroma_description', aroma_description),
      yield_g = COALESCE(NULLIF(p_values->>'yield_g', '')::numeric, yield_g),
      extraction_time_seconds = COALESCE(NULLIF(p_values->>'extraction_time_seconds', '')::integer, extraction_time_seconds),
      updated_at = now()
    WHERE id = v_recipe_id;
  END IF;

  DELETE FROM public.recipe_steps WHERE recipe_id = v_recipe_id;
  DELETE FROM public.recipe_aroma_tags WHERE recipe_id = v_recipe_id;

  IF jsonb_typeof(p_values->'steps') = 'array' THEN
    FOR v_step IN SELECT * FROM jsonb_array_elements(p_values->'steps')
    LOOP
      INSERT INTO public.recipe_steps (
        recipe_id,
        step_number,
        title,
        description,
        step_type,
        water_amount_ml,
        yield_amount_g,
        duration_seconds,
        action_text,
        illustration_emoji
      )
      VALUES (
        v_recipe_id,
        COALESCE(NULLIF(v_step->>'step_number', '')::smallint, 1),
        COALESCE(v_step->>'title', 'Step'),
        v_step->>'description',
        v_step->>'step_type',
        NULLIF(v_step->>'water_amount_ml', '')::numeric,
        NULLIF(v_step->>'yield_amount_g', '')::numeric,
        NULLIF(v_step->>'duration_seconds', '')::integer,
        v_step->>'action_text',
        v_step->>'illustration_emoji'
      );
    END LOOP;
  END IF;

  IF jsonb_typeof(p_values->'aroma_tags') = 'array' THEN
    FOR v_tag IN SELECT * FROM jsonb_array_elements(p_values->'aroma_tags')
    LOOP
      INSERT INTO public.recipe_aroma_tags (
        recipe_id,
        emoji,
        name,
        display_order
      )
      VALUES (
        v_recipe_id,
        v_tag->>'emoji',
        COALESCE(v_tag->>'name', 'Aroma'),
        COALESCE(NULLIF(v_tag->>'display_order', '')::smallint, 0)
      );
    END LOOP;
  END IF;

  RETURN jsonb_build_object(
    'recipe_id', v_recipe_id,
    'is_new', v_is_new
  );
END;
$$;

REVOKE ALL ON FUNCTION public.save_custom_recipe(uuid, uuid, text, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.save_custom_recipe(uuid, uuid, text, jsonb) TO authenticated;

CREATE OR REPLACE VIEW public.v_user_brew_stats AS
SELECT
  bl.user_id,
  COUNT(*)::bigint AS total_brews,
  COUNT(DISTINCT bl.bean_id)::bigint AS unique_beans,
  COUNT(DISTINCT bl.brew_method_id)::bigint AS unique_methods,
  ROUND(AVG(bl.rating)::numeric, 2) AS avg_rating,
  MAX(bl.brewed_at) AS last_brewed_at
FROM public.brew_logs bl
GROUP BY bl.user_id;

CREATE OR REPLACE FUNCTION public.get_my_brew_stats()
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
  SELECT COALESCE(
    (
      SELECT jsonb_build_object(
        'total_brews', s.total_brews,
        'unique_beans', s.unique_beans,
        'unique_methods', s.unique_methods,
        'avg_rating', s.avg_rating,
        'last_brewed_at', s.last_brewed_at
      )
      FROM public.v_user_brew_stats s
      WHERE s.user_id = (SELECT auth.uid())
    ),
    jsonb_build_object(
      'total_brews', 0,
      'unique_beans', 0,
      'unique_methods', 0,
      'avg_rating', NULL,
      'last_brewed_at', NULL
    )
  );
$$;

REVOKE ALL ON FUNCTION public.get_my_brew_stats() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_my_brew_stats() TO authenticated;

COMMIT;
