
-- ============================================================
-- 테이블 및 컬럼 설명 (Korean descriptions)
-- ============================================================

-- ────────────────────────────────────────
-- 1. profiles (사용자 프로필)
-- ────────────────────────────────────────
COMMENT ON TABLE profiles IS '사용자 프로필 — 회원가입 시 자동 생성';
COMMENT ON COLUMN profiles.id IS '프로필 고유 ID';
COMMENT ON COLUMN profiles.user_id IS 'auth.users 참조 — 인증 사용자 ID';
COMMENT ON COLUMN profiles.display_name IS '표시 이름 (닉네임)';
COMMENT ON COLUMN profiles.is_onboarding_complete IS '온보딩 완료 여부';
COMMENT ON COLUMN profiles.onboarding_reasons IS '온보딩 시 선택한 앱 사용 목적 (복수 선택)';
COMMENT ON COLUMN profiles.is_dark_mode IS '다크 모드 활성화 여부';
COMMENT ON COLUMN profiles.created_at IS '생성 일시';
COMMENT ON COLUMN profiles.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 2. survey_questions (설문 질문)
-- ────────────────────────────────────────
COMMENT ON TABLE survey_questions IS '설문 질문 — 취향/라이프스타일 설문의 질문 정의';
COMMENT ON COLUMN survey_questions.id IS '질문 고유 ID';
COMMENT ON COLUMN survey_questions.survey_type IS '설문 유형: common(공통), preference(취향), lifestyle(라이프스타일)';
COMMENT ON COLUMN survey_questions.step IS '설문 단계 번호';
COMMENT ON COLUMN survey_questions.question_order IS '단계 내 질문 순서';
COMMENT ON COLUMN survey_questions.question_key IS '질문 고유 키 (프로그래밍용)';
COMMENT ON COLUMN survey_questions.question_text IS '질문 텍스트 (사용자에게 표시)';
COMMENT ON COLUMN survey_questions.description IS '질문 보충 설명';
COMMENT ON COLUMN survey_questions.category IS '질문 카테고리: coffee_experience, taste_basic, taste_aroma, lifestyle, sensory';
COMMENT ON COLUMN survey_questions.allow_multiple IS '복수 선택 허용 여부';
COMMENT ON COLUMN survey_questions.answer_type IS '응답 형식: single_select, multi_select, scale_3, scale_5, binary';
COMMENT ON COLUMN survey_questions.created_at IS '생성 일시';
COMMENT ON COLUMN survey_questions.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 3. survey_options (설문 선택지)
-- ────────────────────────────────────────
COMMENT ON TABLE survey_options IS '설문 선택지 — 각 질문에 대한 응답 선택지';
COMMENT ON COLUMN survey_options.id IS '선택지 고유 ID';
COMMENT ON COLUMN survey_options.question_id IS '소속 질문 ID';
COMMENT ON COLUMN survey_options.option_key IS '선택지 고유 키 (프로그래밍용)';
COMMENT ON COLUMN survey_options.label IS '선택지 텍스트 (사용자에게 표시)';
COMMENT ON COLUMN survey_options.description IS '선택지 보충 설명';
COMMENT ON COLUMN survey_options.icon IS '선택지 아이콘 (이모지 또는 아이콘명)';
COMMENT ON COLUMN survey_options.display_order IS '표시 순서';
COMMENT ON COLUMN survey_options.score_value IS '점수 값 (scale 타입 질문에서 사용)';
COMMENT ON COLUMN survey_options.created_at IS '생성 일시';
COMMENT ON COLUMN survey_options.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 4. survey_sessions (설문 세션)
-- ────────────────────────────────────────
COMMENT ON TABLE survey_sessions IS '설문 세션 — 사용자의 설문 진행 상태 추적';
COMMENT ON COLUMN survey_sessions.id IS '세션 고유 ID';
COMMENT ON COLUMN survey_sessions.user_id IS '설문 진행 사용자 ID';
COMMENT ON COLUMN survey_sessions.survey_type IS '설문 유형: preference(취향), lifestyle(라이프스타일)';
COMMENT ON COLUMN survey_sessions.status IS '진행 상태: in_progress, completed, analyzing, analyzed';
COMMENT ON COLUMN survey_sessions.current_step IS '현재 진행 중인 단계 번호';
COMMENT ON COLUMN survey_sessions.started_at IS '설문 시작 일시';
COMMENT ON COLUMN survey_sessions.completed_at IS '설문 완료 일시';
COMMENT ON COLUMN survey_sessions.created_at IS '생성 일시';
COMMENT ON COLUMN survey_sessions.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 5. survey_answers (설문 답변)
-- ────────────────────────────────────────
COMMENT ON TABLE survey_answers IS '설문 답변 — 각 질문에 대한 사용자 응답';
COMMENT ON COLUMN survey_answers.id IS '답변 고유 ID';
COMMENT ON COLUMN survey_answers.session_id IS '소속 설문 세션 ID';
COMMENT ON COLUMN survey_answers.question_id IS '응답 대상 질문 ID';
COMMENT ON COLUMN survey_answers.selected_options IS '선택한 옵션 키 배열 (복수 선택 가능)';
COMMENT ON COLUMN survey_answers.score_value IS '점수 값 (scale 타입 질문의 직접 점수)';
COMMENT ON COLUMN survey_answers.created_at IS '생성 일시';
COMMENT ON COLUMN survey_answers.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 6. survey_results (설문 결과)
-- ────────────────────────────────────────
COMMENT ON TABLE survey_results IS '설문 결과 — 설문 분석으로 산출된 맛 프로필과 커피 타입';
COMMENT ON COLUMN survey_results.id IS '결과 고유 ID';
COMMENT ON COLUMN survey_results.session_id IS '소속 설문 세션 ID (1:1 관계)';
COMMENT ON COLUMN survey_results.user_id IS '사용자 ID';
COMMENT ON COLUMN survey_results.coffee_type IS '커피 타입: acidity(산미형), strong(강렬형), sweet(달콤형), balance(균형형)';
COMMENT ON COLUMN survey_results.coffee_type_label IS '커피 타입 한글 레이블';
COMMENT ON COLUMN survey_results.coffee_type_description IS '커피 타입 설명 문구';
COMMENT ON COLUMN survey_results.acidity IS '산미 점수 (0-100)';
COMMENT ON COLUMN survey_results.sweetness IS '단맛 점수 (0-100)';
COMMENT ON COLUMN survey_results.bitterness IS '쓴맛 점수 (0-100)';
COMMENT ON COLUMN survey_results.body IS '바디감 점수 (0-100)';
COMMENT ON COLUMN survey_results.aroma IS '향미 점수 (0-100)';
COMMENT ON COLUMN survey_results.created_at IS '생성 일시';
COMMENT ON COLUMN survey_results.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 7. survey_result_flavors (설문 결과 플레이버)
-- ────────────────────────────────────────
COMMENT ON TABLE survey_result_flavors IS '설문 결과 플레이버 — 사용자 맛 프로필에 매칭된 플레이버 태그';
COMMENT ON COLUMN survey_result_flavors.id IS '플레이버 고유 ID';
COMMENT ON COLUMN survey_result_flavors.result_id IS '소속 설문 결과 ID';
COMMENT ON COLUMN survey_result_flavors.name IS '플레이버 이름 (예: 초콜릿, 베리)';
COMMENT ON COLUMN survey_result_flavors.emoji IS '플레이버 이모지';
COMMENT ON COLUMN survey_result_flavors.description IS '플레이버 설명';
COMMENT ON COLUMN survey_result_flavors.display_order IS '표시 순서';
COMMENT ON COLUMN survey_result_flavors.created_at IS '생성 일시';
COMMENT ON COLUMN survey_result_flavors.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 8. coffee_beans (커피 원두)
-- ────────────────────────────────────────
COMMENT ON TABLE coffee_beans IS '커피 원두 — 추천 대상 원두 카탈로그';
COMMENT ON COLUMN coffee_beans.id IS '원두 고유 ID';
COMMENT ON COLUMN coffee_beans.name IS '원두 이름';
COMMENT ON COLUMN coffee_beans.origin IS '원산지 배열 (복수 블렌딩 가능)';
COMMENT ON COLUMN coffee_beans.roast_point IS '로스팅 포인트 (1-10)';
COMMENT ON COLUMN coffee_beans.roast_level IS '로스팅 레벨: light, medium, medium_dark, dark';
COMMENT ON COLUMN coffee_beans.description IS '원두 소개 문구';
COMMENT ON COLUMN coffee_beans.image_url IS '원두 이미지 URL';
COMMENT ON COLUMN coffee_beans.original_price IS '정가 (원)';
COMMENT ON COLUMN coffee_beans.discount_price IS '할인가 (원)';
COMMENT ON COLUMN coffee_beans.discount_percent IS '할인율 (0-100%)';
COMMENT ON COLUMN coffee_beans.weight IS '용량 (예: 200g)';
COMMENT ON COLUMN coffee_beans.purchase_url IS '구매 링크';
COMMENT ON COLUMN coffee_beans.acidity IS '산미 점수 (0-100)';
COMMENT ON COLUMN coffee_beans.sweetness IS '단맛 점수 (0-100)';
COMMENT ON COLUMN coffee_beans.bitterness IS '쓴맛 점수 (0-100)';
COMMENT ON COLUMN coffee_beans.body IS '바디감 점수 (0-100)';
COMMENT ON COLUMN coffee_beans.aroma IS '향미 점수 (0-100)';
COMMENT ON COLUMN coffee_beans.is_available IS '판매 가능 여부';
COMMENT ON COLUMN coffee_beans.stock IS '재고 수량';
COMMENT ON COLUMN coffee_beans.created_at IS '생성 일시';
COMMENT ON COLUMN coffee_beans.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 9. bean_flavor_tags (원두 플레이버 태그)
-- ────────────────────────────────────────
COMMENT ON TABLE bean_flavor_tags IS '원두 플레이버 태그 — 원두별 풍미 분류 (SCA 플레이버 휠 기반)';
COMMENT ON COLUMN bean_flavor_tags.id IS '태그 고유 ID';
COMMENT ON COLUMN bean_flavor_tags.bean_id IS '소속 원두 ID';
COMMENT ON COLUMN bean_flavor_tags.category IS '플레이버 대분류: Fruity, Floral, Nutty_Cocoa, Roasted';
COMMENT ON COLUMN bean_flavor_tags.sub_category IS '플레이버 중분류 (예: Berry, Citrus)';
COMMENT ON COLUMN bean_flavor_tags.descriptor IS '세부 풍미 설명자 (예: Blueberry, Lemon)';
COMMENT ON COLUMN bean_flavor_tags.display_order IS '표시 순서';
COMMENT ON COLUMN bean_flavor_tags.created_at IS '생성 일시';
COMMENT ON COLUMN bean_flavor_tags.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 10. recommendations (추천 결과)
-- ────────────────────────────────────────
COMMENT ON TABLE recommendations IS '추천 결과 — 설문 기반 사용자-원두 매칭 결과 (상위 5개)';
COMMENT ON COLUMN recommendations.id IS '추천 고유 ID';
COMMENT ON COLUMN recommendations.result_id IS '소속 설문 결과 ID';
COMMENT ON COLUMN recommendations.bean_id IS '추천 원두 ID';
COMMENT ON COLUMN recommendations.match_score IS '매칭 점수 (0.0-1.0, 높을수록 적합)';
COMMENT ON COLUMN recommendations.display_order IS '추천 순위 (1이 최우선)';
COMMENT ON COLUMN recommendations.recommendation_reason IS '추천 사유 텍스트';
COMMENT ON COLUMN recommendations.created_at IS '생성 일시';
COMMENT ON COLUMN recommendations.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 11. user_bean_lists (사용자 원두 리스트)
-- ────────────────────────────────────────
COMMENT ON TABLE user_bean_lists IS '사용자 원두 리스트 — 찜한 원두 목록 (마이페이지)';
COMMENT ON COLUMN user_bean_lists.id IS '리스트 항목 고유 ID';
COMMENT ON COLUMN user_bean_lists.user_id IS '사용자 ID';
COMMENT ON COLUMN user_bean_lists.bean_id IS '찜한 원두 ID';
COMMENT ON COLUMN user_bean_lists.added_from IS '추가 경로: recommendation(추천), search(검색), manual(직접)';
COMMENT ON COLUMN user_bean_lists.sort_order IS '사용자 정렬 순서';
COMMENT ON COLUMN user_bean_lists.created_at IS '생성 일시';
COMMENT ON COLUMN user_bean_lists.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 12. brew_methods (추출 기구)
-- ────────────────────────────────────────
COMMENT ON TABLE brew_methods IS '추출 기구 — 핸드드립, 머신 등 커피 추출 도구 목록';
COMMENT ON COLUMN brew_methods.id IS '기구 고유 ID';
COMMENT ON COLUMN brew_methods.name IS '기구 이름 (예: 하리오 V60)';
COMMENT ON COLUMN brew_methods.slug IS 'URL 슬러그 (고유)';
COMMENT ON COLUMN brew_methods.category IS '기구 분류: machine, handdrip, capsule, etc';
COMMENT ON COLUMN brew_methods.image_url IS '기구 이미지 URL';
COMMENT ON COLUMN brew_methods.created_at IS '생성 일시';
COMMENT ON COLUMN brew_methods.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 13. recipes (레시피)
-- ────────────────────────────────────────
COMMENT ON TABLE recipes IS '레시피 — 추출 기구별 커피 레시피 (시스템 기본 + 사용자 커스텀)';
COMMENT ON COLUMN recipes.id IS '레시피 고유 ID';
COMMENT ON COLUMN recipes.user_id IS '작성자 ID (NULL이면 시스템 기본 레시피)';
COMMENT ON COLUMN recipes.bean_id IS '연결된 원두 ID (선택)';
COMMENT ON COLUMN recipes.brew_method_id IS '사용 추출 기구 ID';
COMMENT ON COLUMN recipes.name IS '레시피 이름';
COMMENT ON COLUMN recipes.cups IS '추출 잔 수 (1-4)';
COMMENT ON COLUMN recipes.strength IS '추출 강도: light, balanced, strong, lungo, espresso, ristretto';
COMMENT ON COLUMN recipes.coffee_amount_g IS '커피 투입량 (g)';
COMMENT ON COLUMN recipes.water_temp_c IS '물 온도 (°C)';
COMMENT ON COLUMN recipes.grind_size_um IS '분쇄 입도 (μm)';
COMMENT ON COLUMN recipes.total_water_ml IS '총 물 사용량 (ml)';
COMMENT ON COLUMN recipes.total_yield_g IS '총 추출량 (g)';
COMMENT ON COLUMN recipes.total_duration_seconds IS '총 추출 시간 (초)';
COMMENT ON COLUMN recipes.aroma_description IS '향미 설명 텍스트';
COMMENT ON COLUMN recipes.is_default IS '시스템 기본 레시피 여부';
COMMENT ON COLUMN recipes.created_at IS '생성 일시';
COMMENT ON COLUMN recipes.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 14. recipe_steps (레시피 단계)
-- ────────────────────────────────────────
COMMENT ON TABLE recipe_steps IS '레시피 단계 — 추출 과정의 개별 스텝';
COMMENT ON COLUMN recipe_steps.id IS '단계 고유 ID';
COMMENT ON COLUMN recipe_steps.recipe_id IS '소속 레시피 ID';
COMMENT ON COLUMN recipe_steps.step_number IS '단계 번호 (순서)';
COMMENT ON COLUMN recipe_steps.title IS '단계 제목 (예: 뜸 들이기)';
COMMENT ON COLUMN recipe_steps.description IS '단계 상세 설명';
COMMENT ON COLUMN recipe_steps.step_type IS '단계 유형: preparation(준비), brewing(추출), waiting(대기)';
COMMENT ON COLUMN recipe_steps.water_amount_ml IS '이 단계 물 투입량 (ml)';
COMMENT ON COLUMN recipe_steps.yield_amount_g IS '이 단계 추출량 (g)';
COMMENT ON COLUMN recipe_steps.duration_seconds IS '이 단계 소요 시간 (초)';
COMMENT ON COLUMN recipe_steps.action_text IS '타이머 화면에 표시할 동작 텍스트';
COMMENT ON COLUMN recipe_steps.illustration_emoji IS '단계 일러스트 이모지';
COMMENT ON COLUMN recipe_steps.created_at IS '생성 일시';
COMMENT ON COLUMN recipe_steps.updated_at IS '수정 일시 (트리거 자동 갱신)';

-- ────────────────────────────────────────
-- 15. recipe_aroma_tags (레시피 아로마 태그)
-- ────────────────────────────────────────
COMMENT ON TABLE recipe_aroma_tags IS '레시피 아로마 태그 — 레시피에 연결된 향미 키워드';
COMMENT ON COLUMN recipe_aroma_tags.id IS '태그 고유 ID';
COMMENT ON COLUMN recipe_aroma_tags.recipe_id IS '소속 레시피 ID';
COMMENT ON COLUMN recipe_aroma_tags.emoji IS '아로마 이모지';
COMMENT ON COLUMN recipe_aroma_tags.name IS '아로마 이름 (예: 견과류, 꽃향)';
COMMENT ON COLUMN recipe_aroma_tags.display_order IS '표시 순서';
COMMENT ON COLUMN recipe_aroma_tags.created_at IS '생성 일시';
COMMENT ON COLUMN recipe_aroma_tags.updated_at IS '수정 일시 (트리거 자동 갱신)';
