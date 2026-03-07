# Coflanet Backend

Coflanet의 Supabase 기반 백엔드 저장소입니다.

## 프로젝트 구조
- `supabase/migrations`: DB 스키마/정책/함수 마이그레이션
- `supabase/functions`: Supabase Edge Functions
- `supabase/seed_coffee_beans.sql`: 원두 초기 데이터 시드
- `docs/`: 설계/분석 문서
- `refs/`: 기획/앱 레퍼런스 데이터

## 사전 준비
1. Supabase CLI 설치
```bash
npx -y supabase --version
```
2. Supabase 로그인
```bash
npx -y supabase login
```

## Supabase 로컬 실행
프로젝트 루트에서:
```bash
npx -y supabase start
```

중지:
```bash
npx -y supabase stop
```

## 원격 프로젝트 연결
```bash
npx -y supabase link --project-ref <PROJECT_REF>
```

## 마이그레이션 반영
원격 DB에 반영:
```bash
npx -y supabase db push
```

로컬 리셋 + 전체 재적용:
```bash
npx -y supabase db reset
```

## 시드 데이터 적용
원두 시드는 SQL 파일로 관리합니다.
```bash
npx -y supabase db query < supabase/seed_coffee_beans.sql
```

## Edge Function
현재 함수:
- `submit-survey`
- `match-coffee`
- `delete-account`

배포 예시:
```bash
npx -y supabase functions deploy submit-survey --project-ref <PROJECT_REF>
npx -y supabase functions deploy match-coffee --project-ref <PROJECT_REF>
npx -y supabase functions deploy delete-account --project-ref <PROJECT_REF>
```

로컬 실행 예시:
```bash
npx -y supabase functions serve submit-survey --env-file .env
```

## 필수 환경 변수
Edge Function에서 다음 값을 사용합니다.
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

주의:
- `.env` 파일 값은 커밋하지 않습니다.
- 서비스 키는 서버 환경에서만 사용합니다.

## 권장 작업 순서
1. 마이그레이션 작성
2. `supabase db push`로 스키마 반영
3. 필요 시 시드 적용
4. Edge Function 배포
5. 앱에서 API/함수 동작 검증
