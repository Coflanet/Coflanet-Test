#!/bin/bash
# Coflanet APK 빌드 스크립트 (Linux/Mac)
# 사전 요구사항: Flutter SDK, Android SDK, Java 17+

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================"
echo "Coflanet APK 빌드 시작"
echo "========================================"

# .env 파일 확인
if [ ! -f .env ]; then
    echo "[경고] .env 파일이 없습니다. 빈 파일을 생성합니다."
    cat > .env << 'EOF'
SUPABASE_URL=
SUPABASE_ANON_KEY=
KAKAO_NATIVE_APP_KEY=
NAVER_CLIENT_ID=
NAVER_CLIENT_SECRET=
EOF
fi

echo ">> flutter pub get"
flutter pub get

echo ">> flutter build apk --release (UI 테스트 모드: 로그인 없이 더미 데이터 사용)"
flutter build apk --release --dart-define=CI_TEST=true

echo "========================================"
echo "빌드 완료!"
echo "APK 위치: build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "안드로이드 폰에 설치하려면:"
echo "  1. USB로 폰을 연결하고: adb install build/app/outputs/flutter-apk/app-release.apk"
echo "  2. 또는 APK 파일을 폰으로 전송 후 직접 설치"
echo "========================================"
