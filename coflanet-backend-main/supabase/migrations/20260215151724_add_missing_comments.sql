-- brew_logs 테이블 및 컬럼 설명
COMMENT ON TABLE public.brew_logs IS '추출 기록 — 사용자의 커피 추출 이력';
COMMENT ON COLUMN public.brew_logs.id IS '기록 고유 ID';
COMMENT ON COLUMN public.brew_logs.user_id IS '사용자 ID';
COMMENT ON COLUMN public.brew_logs.bean_id IS '사용 원두 ID';
COMMENT ON COLUMN public.brew_logs.brew_method_id IS '사용 추출 기구 ID';
COMMENT ON COLUMN public.brew_logs.recipe_id IS '사용 레시피 ID';
COMMENT ON COLUMN public.brew_logs.coffee_amount_g IS '커피 투입량 (g)';
COMMENT ON COLUMN public.brew_logs.water_temp_c IS '물 온도 (°C)';
COMMENT ON COLUMN public.brew_logs.grind_size_um IS '분쇄 입도 (μm)';
COMMENT ON COLUMN public.brew_logs.total_water_ml IS '총 물 사용량 (ml)';
COMMENT ON COLUMN public.brew_logs.total_yield_g IS '총 추출량 (g)';
COMMENT ON COLUMN public.brew_logs.total_duration_seconds IS '총 추출 시간 (초)';
COMMENT ON COLUMN public.brew_logs.cups IS '추출 잔 수 (1-4)';
COMMENT ON COLUMN public.brew_logs.strength IS '추출 강도';
COMMENT ON COLUMN public.brew_logs.rating IS '평점 (1-5)';
COMMENT ON COLUMN public.brew_logs.notes IS '메모';
COMMENT ON COLUMN public.brew_logs.brewed_at IS '추출 일시';
COMMENT ON COLUMN public.brew_logs.created_at IS '생성 일시';
COMMENT ON COLUMN public.brew_logs.updated_at IS '수정 일시';

-- coffee_beans 후속 추가 컬럼
COMMENT ON COLUMN public.coffee_beans.variety IS '품종 (예: SL28, Gesha)';
COMMENT ON COLUMN public.coffee_beans.processing IS '가공 방식 (예: washed, natural)';
COMMENT ON COLUMN public.coffee_beans.external_review_count IS '외부 리뷰 수';

-- profiles 후속 추가 컬럼
COMMENT ON COLUMN public.profiles.avatar_url IS '프로필 이미지 URL';
COMMENT ON COLUMN public.profiles.coffee_level IS '커피 레벨: beginner, enthusiast, home_barista, professional';
COMMENT ON COLUMN public.profiles.survey_completed IS '설문 완료 여부';

-- recipes 후속 추가 컬럼
COMMENT ON COLUMN public.recipes.yield_g IS '추출량 (g)';
COMMENT ON COLUMN public.recipes.extraction_time_seconds IS '추출 시간 (초)';

-- brew_methods 후속 추가 컬럼
COMMENT ON COLUMN public.brew_methods.equipment IS '필요 장비 목록';

-- bean_flavor_tags 후속 추가 컬럼
COMMENT ON COLUMN public.bean_flavor_tags.descriptor_ko IS '세부 풍미 설명자 (한국어)';
