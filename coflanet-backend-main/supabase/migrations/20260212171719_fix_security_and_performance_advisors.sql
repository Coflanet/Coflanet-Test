alter view public.v_user_brew_stats set (security_invoker = true);

create index if not exists idx_brew_logs_recipe_id
  on public.brew_logs(recipe_id);

create schema if not exists extensions;
alter extension pg_trgm set schema extensions;
