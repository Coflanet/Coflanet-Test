import 'package:supabase_flutter/supabase_flutter.dart';

/// 서버 RPC/함수의 인증 만료성 에러인지 판별한다.
///
/// 의존성 없는 순수 함수로 분리해 두어, repository 레이어(`SupabaseRepositoryBase`)와
/// `AuthService` 양쪽이 import 순환 없이 공유한다.
///
/// - PostgrestException P0001 + 메시지에 'UNAUTHORIZED' (RPC 내부 RAISE)
/// - PostgrestException 42501 (permission denied — 미인증 role 로 함수 호출)
bool isAuthExpiredError(Object error) {
  if (error is PostgrestException) {
    final code = error.code;
    if (code == '42501') return true;
    if (code == 'P0001' &&
        error.message.toUpperCase().contains('UNAUTHORIZED')) {
      return true;
    }
  }
  return false;
}
