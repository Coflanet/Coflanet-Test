import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:coflanet/core/services/auth_error.dart';

/// 모든 Supabase repository 의 공통 베이스.
///
/// 모든 SDK 호출(`db.rpc`, `db.functions.invoke`, `db.from(...)` 등)을 [guard] 로
/// 감싸면, 인증 만료(UNAUTHORIZED/42501) 에러를 **호출 지점에서 단 한 번** 전역
/// 처리([onAuthExpired])한 뒤 재throw 한다. repository 가 에러를 삼켜 기본값을
/// 반환하든, 호출 컨트롤러가 `executeWithLoading` 을 쓰든 안 쓰든 무관하게 동작한다.
///
/// `AuthService` 를 직접 import 하지 않고 정적 콜백을 주입받아 import 순환을 피한다.
abstract class SupabaseRepositoryBase {
  /// Supabase 클라이언트. 각 repository 는 별도 게터를 정의하지 말고 이걸 사용한다.
  SupabaseClient get db => Supabase.instance.client;

  /// 인증 만료 시 호출되는 콜백. `main.dart` 에서 1회 주입한다.
  /// (예: `() => Get.find<AuthService>().handleSessionExpired()`)
  static Future<void> Function()? onAuthExpired;

  /// 모든 Supabase 호출을 감싸는 가드.
  ///
  /// 인증 만료 에러면 전역 처리([onAuthExpired])를 호출한 뒤 rethrow,
  /// 그 외 에러는 그대로 전파한다. 중복 호출은 핸들러 내부 가드가 담당한다.
  @protected
  Future<T> guard<T>(Future<T> Function() op) async {
    try {
      return await op();
    } catch (e) {
      if (isAuthExpiredError(e)) {
        final handler = onAuthExpired;
        if (handler != null) await handler();
      }
      rethrow;
    }
  }
}
