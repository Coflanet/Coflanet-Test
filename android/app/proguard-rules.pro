# Supabase / Tink / OkHttp - R8 missing class suppression
-dontwarn com.google.errorprone.annotations.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
-dontwarn com.google.crypto.tink.**

# Keep Google Tink classes (used by Supabase auth)
-keep class com.google.crypto.tink.** { *; }

# Keep OkHttp platform classes
-keep class okhttp3.internal.platform.** { *; }

# Suppress all R8 missing class errors for third-party libraries
-ignorewarnings
