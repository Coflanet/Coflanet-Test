# Supabase / Tink / OkHttp - R8 missing class suppression
-dontwarn com.google.errorprone.annotations.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
-dontwarn com.google.crypto.tink.**

# Keep Google Tink classes (used by Supabase auth)
-keep class com.google.crypto.tink.** { *; }

# Keep OkHttp platform classes
-keep class okhttp3.internal.platform.** { *; }

# ── 네이버 로그인 SDK + Gson (release R8 난독화 시 제네릭 시그니처 유실 방지) ──
# ClassCastException: Class cannot be cast to ParameterizedType 해결
# (Signature 속성이 제거되면 네이버 SDK 의 Gson TypeToken 역직렬화가 실패)
-keepattributes Signature, *Annotation*, EnclosingMethod, InnerClasses

# 네이버 로그인 SDK
-keep class com.navercorp.nid.** { *; }
-dontwarn com.navercorp.nid.**

# Gson (네이버 SDK 내부 사용)
-keep class com.google.gson.** { *; }
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# ── Retrofit / 코루틴 (R8 full mode 제네릭 시그니처 보존) ──
# 네이버 SDK 의 NidOAuthLoginService(Retrofit 인터페이스)가 suspend 응답 타입을
# 분석할 때 Call/Response/Continuation 의 제네릭이 유실되면
# ClassCastException(Class → ParameterizedType) 발생. Retrofit 공식 R8 규칙 적용.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>
-keepclassmembers,allowshrinking,allowobfuscation interface * {
  @retrofit2.http.* <methods>;
}
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**
-dontwarn javax.annotation.**

# Suppress all R8 missing class errors for third-party libraries
-ignorewarnings
