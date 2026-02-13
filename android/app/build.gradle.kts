import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val envFile = rootProject.file("../.env")
val envProps = Properties()
if (envFile.exists()) {
    envFile.inputStream().use { envProps.load(it) }
}

android {
    namespace = "com.coflanet.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.coflanet.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["KAKAO_NATIVE_APP_KEY"] =
            envProps.getProperty("KAKAO_NATIVE_APP_KEY", "")
        manifestPlaceholders["nidOAuthRedirectScheme"] =
            "naver" + envProps.getProperty("NAVER_CLIENT_ID", "")
        resValue("string", "naver_client_id",
            envProps.getProperty("NAVER_CLIENT_ID", ""))
        resValue("string", "naver_client_secret",
            envProps.getProperty("NAVER_CLIENT_SECRET", ""))
        resValue("string", "naver_client_name", "Coflanet")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
