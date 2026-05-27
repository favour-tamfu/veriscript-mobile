plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

}

android {
    namespace = "com.makeji.veriscript.veriscript_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true   // ✅ Kotlin DSL uses "isCoreLibraryDesugaringEnabled"
    }

    kotlinOptions {
        jvmTarget = "17"   // ✅ use plain string, avoids compilerOptions error
    }

    defaultConfig {
        applicationId = "com.makeji.veriscript.veriscript_mobile"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Desugaring library required for flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")

    // Keep your other dependencies here
    implementation("androidx.core:core-ktx:1.12.0")
}
