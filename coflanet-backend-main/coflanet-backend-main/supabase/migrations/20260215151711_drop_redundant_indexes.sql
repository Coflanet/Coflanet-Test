-- 중복 인덱스 제거
-- idx_brew_logs_user_id는 idx_brew_logs_user_brewed(user_id, brewed_at DESC)가 커버
DROP INDEX IF EXISTS public.idx_brew_logs_user_id;

-- idx_survey_sessions_user_id는 idx_survey_sessions_user_status(user_id, status)가 커버
DROP INDEX IF EXISTS public.idx_survey_sessions_user_id;
