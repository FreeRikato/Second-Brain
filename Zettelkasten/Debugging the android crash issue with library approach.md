The android crash issue happens in the play pixo app but when trying to recreate the same procedure of integration in a new react native project with expo the integration seems to work fine. This means the issue is in the codebase of play pixo and not in the integration or unity. 

799 and 825

New React Native project that works with latest android unity build => Working integration
Pixo codebase that crashes on integrating the latest android unity build => Failing integration
## Plan of action
1. List out the difference in android configuration between the working and failing integration
2. Create a new React native project with RN 0.74.5 and ndk 25 then try the integration
3. Try different combinations of the android configuration between the working and failing integration in case Pixo works with latest android unity build.

| Configuration                       | Failing Integration | Working Integration |
| ----------------------------------- | ------------------- | ------------------- |
| React Native                        | 0.74.5              | 0.79.2              |
| NDK                                 | 25.1.8937393        | 27.1.12297006       |
| NDK version for android unity build | 23.1.7779620        | 23.1.7779620        |
|                                     |                     |                     |
|                                     |                     |                     |
|                                     |                     |                     |
|                                     |                     |                     |
|                                     |                     |                     |
|                                     |                     |                     |


# React native project 1 =>

## android/build.gradle:
```
// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
  repositories {
    google()
    mavenCentral()
  }
  dependencies {
    classpath('com.android.tools.build:gradle')
    classpath('com.facebook.react:react-native-gradle-plugin')
    classpath('org.jetbrains.kotlin:kotlin-gradle-plugin')
  }
}

def reactNativeAndroidDir = new File(
  providers.exec {
    workingDir(rootDir)
    commandLine("node", "--print", "require.resolve('react-native/package.json')")
  }.standardOutput.asText.get().trim(),
  "../android"
)

allprojects {
  repositories {
    maven {
      // All of React Native (JS, Obj-C sources, Android binaries) is installed from npm
      flatDir {
        dirs "${project(':unityLibrary').projectDir}/libs"
      }
      url(reactNativeAndroidDir)
    }

    google()
    mavenCentral()
    maven { url 'https://www.jitpack.io' }
  }
}

apply plugin: "expo-root-project"
apply plugin: "com.facebook.react.rootproject"
```

## android/app/build.gradle:

```
apply plugin: "com.android.application"
apply plugin: "org.jetbrains.kotlin.android"
apply plugin: "com.facebook.react"

def projectRoot = rootDir.getAbsoluteFile().getParentFile().getAbsolutePath()

/**
 * This is the configuration block to customize your React Native Android app.
 * By default you don't need to apply any configuration, just uncomment the lines you need.
 */
react {
    entryFile = file(["node", "-e", "require('expo/scripts/resolveAppEntry')", projectRoot, "android", "absolute"].execute(null, rootDir).text.trim())
    reactNativeDir = new File(["node", "--print", "require.resolve('react-native/package.json')"].execute(null, rootDir).text.trim()).getParentFile().getAbsoluteFile()
    hermesCommand = new File(["node", "--print", "require.resolve('react-native/package.json')"].execute(null, rootDir).text.trim()).getParentFile().getAbsolutePath() + "/sdks/hermesc/%OS-BIN%/hermesc"
    codegenDir = new File(["node", "--print", "require.resolve('@react-native/codegen/package.json', { paths: [require.resolve('react-native/package.json')] })"].execute(null, rootDir).text.trim()).getParentFile().getAbsoluteFile()

    enableBundleCompression = (findProperty('android.enableBundleCompression') ?: false).toBoolean()
    // Use Expo CLI to bundle the app, this ensures the Metro config
    // works correctly with Expo projects.
    cliFile = new File(["node", "--print", "require.resolve('@expo/cli', { paths: [require.resolve('expo/package.json')] })"].execute(null, rootDir).text.trim())
    bundleCommand = "export:embed"

    /* Folders */
     //   The root of your project, i.e. where "package.json" lives. Default is '../..'
    // root = file("../../")
    //   The folder where the react-native NPM package is. Default is ../../node_modules/react-native
    // reactNativeDir = file("../../node_modules/react-native")
    //   The folder where the react-native Codegen package is. Default is ../../node_modules/@react-native/codegen
    // codegenDir = file("../../node_modules/@react-native/codegen")

    /* Variants */
    //   The list of variants to that are debuggable. For those we're going to
    //   skip the bundling of the JS bundle and the assets. By default is just 'debug'.
    //   If you add flavors like lite, prod, etc. you'll have to list your debuggableVariants.
    // debuggableVariants = ["liteDebug", "prodDebug"]

    /* Bundling */
    //   A list containing the node command and its flags. Default is just 'node'.
    // nodeExecutableAndArgs = ["node"]

    //
    //   The path to the CLI configuration file. Default is empty.
    // bundleConfig = file(../rn-cli.config.js)
    //
    //   The name of the generated asset file containing your JS bundle
    // bundleAssetName = "MyApplication.android.bundle"
    //
    //   The entry file for bundle generation. Default is 'index.android.js' or 'index.js'
    // entryFile = file("../js/MyApplication.android.js")
    //
    //   A list of extra flags to pass to the 'bundle' commands.
    //   See https://github.com/react-native-community/cli/blob/main/docs/commands.md#bundle
    // extraPackagerArgs = []

    /* Hermes Commands */
    //   The hermes compiler command to run. By default it is 'hermesc'
    // hermesCommand = "$rootDir/my-custom-hermesc/bin/hermesc"
    //
    //   The list of flags to pass to the Hermes compiler. By default is "-O", "-output-source-map"
    // hermesFlags = ["-O", "-output-source-map"]

    /* Autolinking */
    autolinkLibrariesWithApp()
}

/**
 * Set this to true to Run Proguard on Release builds to minify the Java bytecode.
 */
def enableProguardInReleaseBuilds = (findProperty('android.enableProguardInReleaseBuilds') ?: false).toBoolean()

/**
 * The preferred build flavor of JavaScriptCore (JSC)
 *
 * For example, to use the international variant, you can use:
 * `def jscFlavor = 'org.webkit:android-jsc-intl:+'`
 *
 * The international variant includes ICU i18n library and necessary data
 * allowing to use e.g. `Date.toLocaleString` and `String.localeCompare` that
 * give correct results when using with locales other than en-US. Note that
 * this variant is about 6MiB larger per architecture than default.
 */
def jscFlavor = 'io.github.react-native-community:jsc-android:2026004.+'

android {
    ndkVersion rootProject.ext.ndkVersion

    buildToolsVersion rootProject.ext.buildToolsVersion
    compileSdk rootProject.ext.compileSdkVersion

    namespace 'com.rikato.unityintegration'
    defaultConfig {
        applicationId 'com.rikato.unityintegration'
        minSdkVersion rootProject.ext.minSdkVersion
        targetSdkVersion rootProject.ext.targetSdkVersion
        versionCode 1
        versionName "1.0.0"
    }
    signingConfigs {
        debug {
            storeFile file('debug.keystore')
            storePassword 'android'
            keyAlias 'androiddebugkey'
            keyPassword 'android'
        }
    }
    buildTypes {
        debug {
            signingConfig signingConfigs.debug
        }
        release {
            // Caution! In production, you need to generate your own keystore file.
            // see https://reactnative.dev/docs/signed-apk-android.
            signingConfig signingConfigs.debug
            shrinkResources (findProperty('android.enableShrinkResourcesInReleaseBuilds')?.toBoolean() ?: false)
            minifyEnabled enableProguardInReleaseBuilds
            proguardFiles getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro"
            crunchPngs (findProperty('android.enablePngCrunchInReleaseBuilds')?.toBoolean() ?: true)
        }
    }
    packagingOptions {
        jniLibs {
            useLegacyPackaging (findProperty('expo.useLegacyPackaging')?.toBoolean() ?: false)
        }
    }
    androidResources {
        ignoreAssetsPattern '!.svn:!.git:!.ds_store:!*.scc:!CVS:!thumbs.db:!picasa.ini:!*~'
    }
}

// Apply static values from `gradle.properties` to the `android.packagingOptions`
// Accepts values in comma delimited lists, example:
// android.packagingOptions.pickFirsts=/LICENSE,**/picasa.ini
["pickFirsts", "excludes", "merges", "doNotStrip"].each { prop ->
    // Split option: 'foo,bar' -> ['foo', 'bar']
    def options = (findProperty("android.packagingOptions.$prop") ?: "").split(",");
    // Trim all elements in place.
    for (i in 0..<options.size()) options[i] = options[i].trim();
    // `[] - ""` is essentially `[""].filter(Boolean)` removing all empty strings.
    options -= ""

    if (options.length > 0) {
        println "android.packagingOptions.$prop += $options ($options.length)"
        // Ex: android.packagingOptions.pickFirsts += '**/SCCS/**'
        options.each {
            android.packagingOptions[prop] += it
        }
    }
}

dependencies {
    // The version of react-native is set by the React Native Gradle Plugin
    implementation("com.facebook.react:react-android")

    def isGifEnabled = (findProperty('expo.gif.enabled') ?: "") == "true";
    def isWebpEnabled = (findProperty('expo.webp.enabled') ?: "") == "true";
    def isWebpAnimatedEnabled = (findProperty('expo.webp.animated') ?: "") == "true";

    if (isGifEnabled) {
        // For animated gif support
        implementation("com.facebook.fresco:animated-gif:${expoLibs.versions.fresco.get()}")
    }

    if (isWebpEnabled) {
        // For webp support
        implementation("com.facebook.fresco:webpsupport:${expoLibs.versions.fresco.get()}")
        if (isWebpAnimatedEnabled) {
            // Animated webp support
            implementation("com.facebook.fresco:animated-webp:${expoLibs.versions.fresco.get()}")
        }
    }

    if (hermesEnabled.toBoolean()) {
        implementation("com.facebook.react:hermes-android")
    } else {
        implementation jscFlavor
    }
}
```

## android/gradle.properties:

```
# Project-wide Gradle settings.

# IDE (e.g. Android Studio) users:
# Gradle settings configured through the IDE *will override*
# any settings specified in this file.

# For more details on how to configure your build environment visit
# http://www.gradle.org/docs/current/userguide/build_environment.html

# Specifies the JVM arguments used for the daemon process.
# The setting is particularly useful for tweaking memory settings.
# Default value: -Xmx512m -XX:MaxMetaspaceSize=256m
org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m

# When configured, Gradle will run in incubating parallel mode.
# This option should only be used with decoupled projects. More details, visit
# http://www.gradle.org/docs/current/userguide/multi_project_builds.html#sec:decoupled_projects
# org.gradle.parallel=true

# AndroidX package structure to make it clearer which packages are bundled with the
# Android operating system, and which are packaged with your app's APK
# https://developer.android.com/topic/libraries/support-library/androidx-rn
android.useAndroidX=true

# Enable AAPT2 PNG crunching
android.enablePngCrunchInReleaseBuilds=true

# Use this property to specify which architecture you want to build.
# You can also override it from the CLI using
# ./gradlew <task> -PreactNativeArchitectures=x86_64
reactNativeArchitectures=armeabi-v7a,arm64-v8a,x86,x86_64

# Use this property to enable support to the new architecture.
# This will allow you to use TurboModules and the Fabric render in
# your application. You should enable this flag either if you want
# to write custom TurboModules/Fabric components OR use libraries that
# are providing them.
newArchEnabled=true

# Use this property to enable or disable the Hermes JS engine.
# If set to false, you will be using JSC instead.
hermesEnabled=true

# Enable GIF support in React Native images (~200 B increase)
expo.gif.enabled=true
# Enable webp support in React Native images (~85 KB increase)
expo.webp.enabled=true
# Enable animated webp support (~3.4 MB increase)
# Disabled by default because iOS doesn't support animated webp
expo.webp.animated=false

# Enable network inspector
EX_DEV_CLIENT_NETWORK_INSPECTOR=true

# Use legacy packaging to compress native libraries in the resulting APK.
expo.useLegacyPackaging=false


unityStreamingAssets=.unity3d

# Whether the app is configured to use edge-to-edge via the app config or `react-native-edge-to-edge` plugin
expo.edgeToEdgeEnabled=true

```

## android/settings.gradle:

```
pluginManagement {
  def reactNativeGradlePlugin = new File(
    providers.exec {
      workingDir(rootDir)
      commandLine("node", "--print", "require.resolve('@react-native/gradle-plugin/package.json', { paths: [require.resolve('react-native/package.json')] })")
    }.standardOutput.asText.get().trim()
  ).getParentFile().absolutePath
  includeBuild(reactNativeGradlePlugin)
  
  def expoPluginsPath = new File(
    providers.exec {
      workingDir(rootDir)
      commandLine("node", "--print", "require.resolve('expo-modules-autolinking/package.json', { paths: [require.resolve('expo/package.json')] })")
    }.standardOutput.asText.get().trim(),
    "../android/expo-gradle-plugin"
  ).absolutePath
  includeBuild(expoPluginsPath)
}

plugins {
  id("com.facebook.react.settings")
  id("expo-autolinking-settings")
}

extensions.configure(com.facebook.react.ReactSettingsExtension) { ex ->
  if (System.getenv('EXPO_USE_COMMUNITY_AUTOLINKING') == '1') {
    ex.autolinkLibrariesFromCommand()
  } else {
    ex.autolinkLibrariesFromCommand(expoAutolinking.rnConfigCommand)
  }
}
expoAutolinking.useExpoModules()

rootProject.name = 'react_native_unity_integration'

expoAutolinking.useExpoVersionCatalog()

include ':app'
includeBuild(expoAutolinking.reactNativeGradlePlugin)

include ':unityLibrary'
project(':unityLibrary').projectDir = new File('../unity/builds/android/unityLibrary')
```

## android/gradle/wrapper/gradle-wrapper.properties:

```
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.13-bin.zip
networkTimeout=10000
validateDistributionUrl=true
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
```

## android/app/src/main/AndroidManifest.xml:

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
  <uses-permission android:name="android.permission.VIBRATE"/>
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
  <queries>
    <intent>
      <action android:name="android.intent.action.VIEW"/>
      <category android:name="android.intent.category.BROWSABLE"/>
      <data android:scheme="https"/>
    </intent>
  </queries>
  <application android:name=".MainApplication" android:label="@string/app_name" android:icon="@mipmap/ic_launcher" android:roundIcon="@mipmap/ic_launcher_round" android:allowBackup="true" android:theme="@style/AppTheme" android:supportsRtl="true">
    <meta-data android:name="expo.modules.updates.ENABLED" android:value="false"/>
    <meta-data android:name="expo.modules.updates.EXPO_UPDATES_CHECK_ON_LAUNCH" android:value="ALWAYS"/>
    <meta-data android:name="expo.modules.updates.EXPO_UPDATES_LAUNCH_WAIT_MS" android:value="0"/>
    <activity android:name=".MainActivity" android:configChanges="keyboard|keyboardHidden|orientation|screenSize|screenLayout|uiMode" android:launchMode="singleTask" android:windowSoftInputMode="adjustResize" android:theme="@style/Theme.App.SplashScreen" android:exported="true" android:screenOrientation="portrait">
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>
      <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="reactnativeunityintegration"/>
      </intent-filter>
    </activity>
  </application>
</manifest>
```

## MainApplication.kt:

```
package com.rikato.unityintegration

import android.app.Application
import android.content.res.Configuration

import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.react.ReactHost
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.load
import com.facebook.react.defaults.DefaultReactNativeHost
import com.facebook.react.soloader.OpenSourceMergedSoMapping
import com.facebook.soloader.SoLoader

import expo.modules.ApplicationLifecycleDispatcher
import expo.modules.ReactNativeHostWrapper

class MainApplication : Application(), ReactApplication {

  override val reactNativeHost: ReactNativeHost = ReactNativeHostWrapper(
        this,
        object : DefaultReactNativeHost(this) {
          override fun getPackages(): List<ReactPackage> {
            val packages = PackageList(this).packages
            // Packages that cannot be autolinked yet can be added manually here, for example:
            // packages.add(new MyReactNativePackage());
            return packages
          }

          override fun getJSMainModuleName(): String = ".expo/.virtual-metro-entry"

          override fun getUseDeveloperSupport(): Boolean = BuildConfig.DEBUG

          override val isNewArchEnabled: Boolean = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
          override val isHermesEnabled: Boolean = BuildConfig.IS_HERMES_ENABLED
      }
  )

  override val reactHost: ReactHost
    get() = ReactNativeHostWrapper.createReactHost(applicationContext, reactNativeHost)

  override fun onCreate() {
    super.onCreate()
    SoLoader.init(this, OpenSourceMergedSoMapping)
    if (BuildConfig.IS_NEW_ARCHITECTURE_ENABLED) {
      // If you opted-in for the New Architecture, we load the native entry point for this app.
      load()
    }
    ApplicationLifecycleDispatcher.onApplicationCreate(this)
  }

  override fun onConfigurationChanged(newConfig: Configuration) {
    super.onConfigurationChanged(newConfig)
    ApplicationLifecycleDispatcher.onConfigurationChanged(this, newConfig)
  }
}
```

## MainActivity.kt:

```
package com.rikato.unityintegration
import expo.modules.splashscreen.SplashScreenManager

import android.os.Build
import android.os.Bundle

import com.facebook.react.ReactActivity
import com.facebook.react.ReactActivityDelegate
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.fabricEnabled
import com.facebook.react.defaults.DefaultReactActivityDelegate

import expo.modules.ReactActivityDelegateWrapper

class MainActivity : ReactActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    // Set the theme to AppTheme BEFORE onCreate to support
    // coloring the background, status bar, and navigation bar.
    // This is required for expo-splash-screen.
    // setTheme(R.style.AppTheme);
    // @generated begin expo-splashscreen - expo prebuild (DO NOT MODIFY) sync-f3ff59a738c56c9a6119210cb55f0b613eb8b6af
    SplashScreenManager.registerOnActivity(this)
    // @generated end expo-splashscreen
    super.onCreate(null)
  }

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  override fun getMainComponentName(): String = "main"

  /**
   * Returns the instance of the [ReactActivityDelegate]. We use [DefaultReactActivityDelegate]
   * which allows you to enable New Architecture with a single boolean flags [fabricEnabled]
   */
  override fun createReactActivityDelegate(): ReactActivityDelegate {
    return ReactActivityDelegateWrapper(
          this,
          BuildConfig.IS_NEW_ARCHITECTURE_ENABLED,
          object : DefaultReactActivityDelegate(
              this,
              mainComponentName,
              fabricEnabled
          ){})
  }

  /**
    * Align the back button behavior with Android S
    * where moving root activities to background instead of finishing activities.
    * @see <a href="https://developer.android.com/reference/android/app/Activity#onBackPressed()">onBackPressed</a>
    */
  override fun invokeDefaultOnBackPressed() {
      if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.R) {
          if (!moveTaskToBack(false)) {
              // For non-root activities, use the default implementation to finish them.
              super.invokeDefaultOnBackPressed()
          }
          return
      }

      // Use the default back button implementation on Android S
      // because it's doing more than [Activity.moveTaskToBack] in fact.
      super.invokeDefaultOnBackPressed()
  }
}
```

## unity/builds/android/build.gradle:
```
plugins {
    // If you are changing the Android Gradle Plugin version, make sure it is compatible with the Gradle version preinstalled with Unity
    // See which Gradle version is preinstalled with Unity here https://docs.unity3d.com/Manual/android-gradle-overview.html
    // See official Gradle and Android Gradle Plugin compatibility table here https://developer.android.com/studio/releases/gradle-plugin#updating-gradle
    // To specify a custom Gradle version in Unity, go do "Preferences > External Tools", uncheck "Gradle Installed with Unity (recommended)" and specify a path to a custom Gradle version
    id 'com.android.application' version '8.3.0' apply false
    id 'com.android.library' version '8.3.0' apply false
}

tasks.register('clean', Delete) {
    delete rootProject.layout.buildDirectory
}

unity/builds/android/unityLibrary/build.gradle:

apply plugin: 'com.android.library'
apply from: '../shared/keepUnitySymbols.gradle'

dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'androidx.core:core:1.9.0'
    implementation 'androidx.games:games-activity:3.0.5'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    implementation 'androidx.games:games-frame-pacing:1.10.0'
}

android {
    namespace "com.unity3d.player"
    ndkPath "/Users/aravinthan/Library/Android/sdk/ndk/23.1.7779620"
    ndkVersion "23.1.7779620"
    compileSdk 35
    buildToolsVersion = "34.0.0"

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    defaultConfig {
        consumerProguardFiles "proguard-unity.txt"
        versionName "1.0.0"
        minSdk 23
        targetSdk 35
        versionCode 4

        ndk {
            abiFilters "armeabi-v7a", "arm64-v8a"
            debugSymbolLevel "none"
        }

        externalNativeBuild {
            cmake {
                arguments "-DANDROID_STL=c++_shared"
            }
        }
    }

    lint {
        abortOnError false
    }

    androidResources {
        ignoreAssetsPattern = "!.svn:!.git:!.ds_store:!*.scc:!CVS:!thumbs.db:!picasa.ini:!*~"
        noCompress = ['.unity3d', '.ress', '.resource', '.obb', '.bundle', '.unityexp'] + unityStreamingAssets.tokenize(', ')
    }

    packaging {
        jniLibs {
            useLegacyPackaging true
        }
    }
}


def getSdkDir() {
    Properties local = new Properties()
    local.load(new FileInputStream("${rootDir}/local.properties"))
    return local.getProperty('sdk.dir')
}

def GetIl2CppOutputPath(String workingDir, String abi) {
    return "${workingDir}/src/main/jniLibs/${abi}/libil2cpp.so";
}

def GetIl2CppSymbolPath(String workingDir, String abi) {
    return "${workingDir}/symbols/${abi}/libil2cpp.so";
}

def BuildIl2CppImpl(String workingDir, String configuration, String architecture, String abi, String[] staticLibraries) {
    def commandLineArgs = []
    commandLineArgs.add("--compile-cpp")
    commandLineArgs.add("--platform=Android")
    commandLineArgs.add("--architecture=${architecture}")
    commandLineArgs.add("--outputpath=${workingDir}/src/main/jniLibs/${abi}/libil2cpp.so")
    commandLineArgs.add("--baselib-directory=${workingDir}/src/main/jniStaticLibs/${abi}")
    commandLineArgs.add("--incremental-g-c-time-slice=3")
    commandLineArgs.add("--configuration=${configuration}")
    commandLineArgs.add("--dotnetprofile=unityaot-linux")
    commandLineArgs.add("--usymtool-path=${workingDir}/src/main/Il2CppOutputProject/usymtool")
    commandLineArgs.add("--profiler-report")
    commandLineArgs.add("--profiler-output-file=${workingDir}/build/il2cpp_${abi}_${configuration}/il2cpp_conv.traceevents")
    commandLineArgs.add("--print-command-line")
    commandLineArgs.add("--static-lib-il2-cpp")
    commandLineArgs.add("--data-folder=${workingDir}/src/main/Il2CppOutputProject/Source/il2cppOutput/data")
    commandLineArgs.add("--generatedcppdir=${workingDir}/src/main/Il2CppOutputProject/Source/il2cppOutput")
    commandLineArgs.add("--cachedirectory=${workingDir}/build/il2cpp_${abi}_${configuration}/il2cpp_cache")
    commandLineArgs.add("--tool-chain-path=${android.ndkDirectory}")

    staticLibraries.eachWithIndex {fileName, i->
        commandLineArgs.add("--additional-libraries=${workingDir}/src/main/jniStaticLibs/${abi}/${fileName}")
    }

    def executableExtension = ""
    if (org.gradle.internal.os.OperatingSystem.current().isWindows()) {
        executableExtension = ".exe"
        commandLineArgs = commandLineArgs*.replace('\"', '\\\"')
    }
    exec {
        executable "${workingDir}/src/main/Il2CppOutputProject/IL2CPP/build/deploy/il2cpp${executableExtension}"
        args commandLineArgs
        environment "ANDROID_SDK_ROOT", getSdkDir()
    }

    def dbgLevel =  project.android.defaultConfig.ndk.debugSymbolLevel;
    def usePublicSymbols = dbgLevel == null || !dbgLevel.toString().toLowerCase().equals("full")
    def extensionToRemove = usePublicSymbols ? ".dbg.so" : ".sym.so"
    def extensionToKeep = usePublicSymbols ? ".sym.so" : ".dbg.so"

    delete "${workingDir}/src/main/jniLibs/${abi}/libil2cpp${extensionToRemove}"
    ant.move(file: "${workingDir}/src/main/jniLibs/${abi}/libil2cpp${extensionToKeep}", tofile: "${workingDir}/symbols/${abi}/libil2cpp.so")

}

android {
    tasks.register('buildIl2Cpp') {
        def workingDir = projectDir.toString().replaceAll('\\\\', '/');
        def archs = [
            'armv7' : 'armeabi-v7a',
            'arm64' : 'arm64-v8a'
        ]
        def staticLibs = [
            'armv7' : [  ],
            'arm64' : [  ]
        ]
        inputs.files fileTree(dir: 'src/main/Il2CppOutputProject', include: ['**/*'])
        inputs.files fileTree(dir: 'src/main/jniStaticLibs', include: ['**/*'])
        archs.each { arch, abi ->
            outputs.file GetIl2CppOutputPath(workingDir, abi)
            outputs.file GetIl2CppSymbolPath(workingDir, abi)
        }
        doLast {
            archs.each { arch, abi ->
                BuildIl2CppImpl(workingDir, 'Release', arch, abi, staticLibs[arch] as String[]);
            }
        }
    }

    afterEvaluate {
        if (project(':unityLibrary').tasks.findByName('mergeDebugJniLibFolders'))
            project(':unityLibrary').mergeDebugJniLibFolders.dependsOn buildIl2Cpp
        if (project(':unityLibrary').tasks.findByName('mergeReleaseJniLibFolders'))
            project(':unityLibrary').mergeReleaseJniLibFolders.dependsOn buildIl2Cpp
    }
    sourceSets {
        main {
            jni.srcDirs = ["src/main/Il2CppOutputProject"]
        }
    }
}

android.externalNativeBuild {
    cmake {
        version "3.22.1"
        path "src/main/cpp/CMakeLists.txt"
    }
}
android.buildFeatures {
    prefab true
}
```

## unity/builds/android/gradle.properties:

```
org.gradle.jvmargs=-Xmx4096M
org.gradle.parallel=true
unityStreamingAssets=
unityTemplateVersion=18
unityProjectPath=/Users/user/Unity/projects/Rootquotient work/cp-unity
unity.projectPath=/Users/user/Unity/projects/Rootquotient work/cp-unity
unity.debugSymbolLevel=none
unity.buildToolsVersion=34.0.0
unity.minSdkVersion=23
unity.targetSdkVersion=35
unity.compileSdkVersion=35
unity.applicationId=com.colorpencil.pixounity
unity.abiFilters=armeabi-v7a,arm64-v8a
unity.versionCode=4
unity.versionName=1.0.0
unity.namespace=com.colorpencil.pixounity
unity.androidSdkPath=/Users/aravinthan/Library/Android/sdk
unity.androidNdkPath=/Users/aravinthan/Library/Android/sdk/ndk/23.1.7779620
unity.androidNdkVersion=23.1.7779620
unity.jdkPath=/Applications/Unity/Hub/Editor/6000.0.37f1/PlaybackEngines/AndroidPlayer/OpenJDK
unity.javaCompatabilityVersion=VERSION_17
android.useAndroidX=true
android.enableJetifier=true
android.bundle.includeNativeDebugMetadata=false
org.gradle.welcome=never

unity/builds/android/settings.gradle:

pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}

include ':launcher'
include ':unityLibrary'

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)

    repositories {
        google()
        mavenCentral()

        flatDir {
            dirs "${project(':unityLibrary').projectDir}/libs"
        }
    }
}
```

## unity/builds/android/unityLibrary/src/main/AndroidManifest.xml:

```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" xmlns:tools="http://schemas.android.com/tools">
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-feature android:glEsVersion="0x00030000" />
  <uses-feature android:name="android.hardware.vulkan.version" android:required="false" />
  <uses-feature android:name="android.hardware.touchscreen" android:required="false" />
  <uses-feature android:name="android.hardware.touchscreen.multitouch" android:required="false" />
  <uses-feature android:name="android.hardware.touchscreen.multitouch.distinct" android:required="false" />
  <application android:enableOnBackInvokedCallback="false" android:extractNativeLibs="true">
    <meta-data android:name="unity.splash-mode" android:value="0" />
    <meta-data android:name="unity.splash-enable" android:value="True" />
    <meta-data android:name="unity.launch-fullscreen" android:value="True" />
    <meta-data android:name="unity.render-outside-safearea" android:value="True" />
    <meta-data android:name="notch.config" android:value="portrait|landscape" />
    <meta-data android:name="unity.auto-report-fully-drawn" android:value="true" />
    <meta-data android:name="unity.auto-set-game-state" android:value="true" />
    <meta-data android:name="unity.strip-engine-code" android:value="false" />
    <activity android:configChanges="mcc|mnc|locale|touchscreen|keyboard|keyboardHidden|navigation|orientation|screenLayout|uiMode|screenSize|smallestScreenSize|fontScale|layoutDirection|density" android:enabled="true" android:exported="true" android:hardwareAccelerated="false" android:launchMode="singleTask" android:name="com.unity3d.player.UnityPlayerGameActivity" android:resizeableActivity="true" android:screenOrientation="fullUser" android:theme="@style/BaseUnityGameActivityTheme">
      <meta-data android:name="unityplayer.UnityActivity" android:value="true" />
      <meta-data android:name="android.app.lib_name" android:value="game" />
      <meta-data android:name="WindowManagerPreference:FreeformWindowSize" android:value="@string/FreeformWindowSize_tablet" />
      <meta-data android:name="WindowManagerPreference:FreeformWindowOrientation" android:value="@string/FreeformWindowOrientation_landscape" />
      <meta-data android:name="notch_support" android:value="true" />
      <layout android:defaultHeight="1080px" android:defaultWidth="1920px" android:minHeight="300px" android:minWidth="400px" />
    </activity>
  </application>
</manifest>
```

# React native project 2 =>
## android/build.gradle:
```
gradle.startParameter.excludedTaskNames.addAll(
        gradle.startParameter.taskNames.findAll { it.contains("testClasses") }
)

buildscript {
    ext {
        buildToolsVersion = "34.0.0"
        minSdkVersion = 23
        compileSdkVersion = 34
        targetSdkVersion = 34
        ndkVersion = "23.1.7779620"
        kotlinVersion = "1.9.22"
        supportLibVersion = "28.0.0"
    }
    repositories {
        google()
        flatDir {
            dirs "${project(':unityLibrary').projectDir}/libs"
        }
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle")
        classpath("com.facebook.react:react-native-gradle-plugin")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin")
        classpath 'com.google.gms:google-services:4.4.1'
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.1' // Firebase Crashlytics plugin
    }
}

apply plugin: "com.facebook.react.rootproject"
```
## android/app/build.gradle:
```
apply plugin: "com.android.application"
apply plugin: "org.jetbrains.kotlin.android"
apply plugin: "com.facebook.react"
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.google.firebase.crashlytics'

/**
 * This is the configuration block to customize your React Native Android app.
 * By default you don't need to apply any configuration, just uncomment the lines you need.
 */
react {
    /* Folders */
    //   The root of your project, i.e. where "package.json" lives. Default is '..'
    // root = file("../")
    //   The folder where the react-native NPM package is. Default is ../node_modules/react-native
    reactNativeDir = file("../../../../node_modules/react-native")
      //The folder where the react-native Codegen package is. Default is ../../../..ode_modules/@react-native/codegen
    codegenDir = file("../../../../node_modules/@react-native/codegen")
      //The cli.js file which is the React Native CLI entrypoint. Default is ../node_modules/react-native/cli.js
    cliFile = file("../../../../node_modules/react-native/cli.js")

    /* Variants */
    //   The list of variants to that are debuggable. For those we're going to
    //   skip the bundling of the JS bundle and the assets. By default is just 'debug'.
    //   If you add flavors like lite, prod, etc. you'll have to list your debuggableVariants.
    // debuggableVariants = ["liteDebug", "prodDebug"]

    /* Bundling */
    //   A list containing the node command and its flags. Default is just 'node'.
    // nodeExecutableAndArgs = ["node"]
    //
    //   The command to run when bundling. By default is 'bundle'
    // bundleCommand = "ram-bundle"
    //
    //   The path to the CLI configuration file. Default is empty.
    // bundleConfig = file(../rn-cli.config.js)
    //
    //   The name of the generated asset file containing your JS bundle
    // bundleAssetName = "MyApplication.android.bundle"
    //
    //   The entry file for bundle generation. Default is 'index.android.js' or 'index.js'
    // entryFile = file("../js/MyApplication.android.js")
    //
    //   A list of extra flags to pass to the 'bundle' commands.
    //   See https://github.com/react-native-community/cli/blob/main/docs/commands.md#bundle
    // extraPackagerArgs = []

    /* Hermes Commands */
    //   The hermes compiler command to run. By default it is 'hermesc'
    // For linux
    // hermesCommand = "../../node_modules/react-native/sdks/hermesc/linux64-bin/hermesc"
     // For Mac
     hermesCommand = "../../node_modules/react-native/sdks/hermesc/osx-bin/hermesc"
    //  For windows
    //  hermesCommand = "../../node_modules/react-native/sdks/hermesc/win64-bin/hermesc"
    //
    //   The list of flags to pass to the Hermes compiler. By default is "-O", "-output-source-map"
    // hermesFlags = ["-O", "-output-source-map"]
}

/**
 * Set this to true to Run Proguard on Release builds to minify the Java bytecode.
 */
def enableProguardInReleaseBuilds = false

/**
 * The preferred build flavor of JavaScriptCore (JSC)
 *
 * For example, to use the international variant, you can use:
 * `def jscFlavor = 'org.webkit:android-jsc-intl:+'`
 *
 * The international variant includes ICU i18n library and necessary data
 * allowing to use e.g. `Date.toLocaleString` and `String.localeCompare` that
 * give correct results when using with locales other than en-US. Note that
 * this variant is about 6MiB larger per architecture than default.
 */
def jscFlavor = 'org.webkit:android-jsc:+'

android {
    ndkVersion rootProject.ext.ndkVersion
    buildToolsVersion rootProject.ext.buildToolsVersion
    compileSdk rootProject.ext.compileSdkVersion

    namespace "com.color_pencil"
    defaultConfig {
        // applicationId "com.color_pencil"
        minSdkVersion rootProject.ext.minSdkVersion
        targetSdkVersion rootProject.ext.targetSdkVersion
        // versionCode 63
        // versionName "1.0.10"
        missingDimensionStrategy "store", "play"
    }
    signingConfigs {
        debug {
            storeFile file('debug.keystore')
            storePassword 'android'
            keyAlias 'androiddebugkey'
            keyPassword 'android'
        }
         release {
            if (project.hasProperty('MYAPP_UPLOAD_STORE_FILE')) {
                storeFile file(MYAPP_UPLOAD_STORE_FILE)
                storePassword MYAPP_UPLOAD_STORE_PASSWORD
                keyAlias MYAPP_UPLOAD_KEY_ALIAS
                keyPassword MYAPP_UPLOAD_KEY_PASSWORD
            }
        }
         releasezeta {
            if (project.hasProperty('ZETA_APP_UPLOAD_STORE_FILE')) {
                storeFile file(ZETA_APP_UPLOAD_STORE_FILE)
                storePassword ZETA_APP_UPLOAD_STORE_PASSWORD
                keyAlias ZETA_APP_UPLOAD_KEY_ALIAS
                keyPassword ZETA_APP_UPLOAD_KEY_PASSWORD
            }
        }
         releasewhiz {
            if (project.hasProperty('WHIZ_APP_UPLOAD_STORE_FILE')) {
                storeFile file(WHIZ_APP_UPLOAD_STORE_FILE)
                storePassword WHIZ_APP_UPLOAD_STORE_PASSWORD
                keyAlias WHIZ_APP_UPLOAD_KEY_ALIAS
                keyPassword WHIZ_APP_UPLOAD_KEY_PASSWORD
            }
        }
    }
    buildTypes {
        debug {
            signingConfig signingConfigs.debug
        }
        release {
            // Caution! In production, you need to generate your own keystore file.
            // see https://reactnative.dev/docs/signed-apk-android.
            // signingConfig signingConfigs.release
            minifyEnabled enableProguardInReleaseBuilds
            proguardFiles getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro"
        }
    }

     flavorDimensions "appFlavor"

      productFlavors {
        pixo {
            dimension "appFlavor"
            applicationId "com.color_pencil"
            versionCode 91
            versionName "1.0.21"

            signingConfig signingConfigs.release
        }
        zeta {
            dimension "appFlavor"
            applicationId "com.app.zeta"
            versionCode 8
            versionName "1.0.2"
            signingConfig signingConfigs.releasezeta
        }
        whiz {
            dimension "appFlavor"
            applicationId "com.whiz"
            versionCode 10
            versionName "1.0.3"
            signingConfig signingConfigs.releasewhiz
        }
    }
    // flavorDimensions "appstore"

    // productFlavors {
    //     googlePlay {
    //         dimension "appstore"
    //         missingDimensionStrategy "store", "play"
    //     }

    //     // amazon {
    //     //     dimension "appstore"
    //     //     missingDimensionStrategy "store", "amazon"
    //     // }
    // }
}

dependencies {
    // The version of react-native is set by the React Native Gradle Plugin
    implementation platform('org.jetbrains.kotlin:kotlin-bom:1.8.0')
    implementation("com.facebook.react:react-android")
    implementation project(':react-native-safe-area-context')
    implementation platform('com.google.firebase:firebase-bom:29.0.3')
    implementation 'com.google.firebase:firebase-messaging'
    implementation 'com.google.firebase:firebase-crashlytics'
    implementation 'com.android.billingclient:billing:6.0.1'
    // implementation 'androidx.activity:activity-ktx:1.9.1'
    if (hermesEnabled.toBoolean()) {
        implementation("com.facebook.react:hermes-android")
    } else {
        implementation jscFlavor
    }
}

apply from: file("../../../../node_modules/@react-native-community/cli-platform-android/native_modules.gradle"); applyNativeModulesAppBuildGradle(project)
```
## android/gradle.properties:
```
# Project-wide Gradle settings.

# IDE (e.g. Android Studio) users:
# Gradle settings configured through the IDE *will override*
# any settings specified in this file.

# For more details on how to configure your build environment visit
# http://www.gradle.org/docs/current/userguide/build_environment.html

# Specifies the JVM arguments used for the daemon process.
# The setting is particularly useful for tweaking memory settings.
# Default value: -Xmx512m -XX:MaxMetaspaceSize=256m
org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m
android.ndkVersion=23.1.7779620

# When configured, Gradle will run in incubating parallel mode.
# This option should only be used with decoupled projects. More details, visit
# http://www.gradle.org/docs/current/userguide/multi_project_builds.html#sec:decoupled_projects
# org.gradle.parallel=true

# AndroidX package structure to make it clearer which packages are bundled with the
# Android operating system, and which are packaged with your app's APK
# https://developer.android.com/topic/libraries/support-library/androidx-rn
android.useAndroidX=true
# Automatically convert third-party libraries to use AndroidX
android.enableJetifier=true

# Use this property to specify which architecture you want to build.
# You can also override it from the CLI using
# ./gradlew <task> -PreactNativeArchitectures=x86_64
reactNativeArchitectures=armeabi-v7a,arm64-v8a,x86,x86_64

# Use this property to enable support to the new architecture.
# This will allow you to use TurboModules and the Fabric render in
# your application. You should enable this flag either if you want
# to write custom TurboModules/Fabric components OR use libraries that
# are providing them.
newArchEnabled=false

# Use this property to enable or disable the Hermes JS engine.
# If set to false, you will be using JSC instead.
hermesEnabled=true
unityStreamingAssets=.unity3d

MYAPP_UPLOAD_STORE_FILE=my-upload-key.keystore
MYAPP_UPLOAD_KEY_ALIAS=my-key-alias
MYAPP_UPLOAD_STORE_PASSWORD=Crayond@12345
MYAPP_UPLOAD_KEY_PASSWORD=Crayond@12345

# ZETA
ZETA_APP_UPLOAD_STORE_FILE=zeta-upload-key.keystore
ZETA_APP_UPLOAD_KEY_ALIAS=zeta-key-alias
ZETA_APP_UPLOAD_STORE_PASSWORD=Crayond@12345
ZETA_APP_UPLOAD_KEY_PASSWORD=Crayond@12345

# WHIZ
WHIZ_APP_UPLOAD_STORE_FILE=whiz-upload-key.keystore
WHIZ_APP_UPLOAD_KEY_ALIAS=whiz-key-alias
WHIZ_APP_UPLOAD_STORE_PASSWORD=Crayond@12345
WHIZ_APP_UPLOAD_KEY_PASSWORD=Crayond@12345
```
## android/settings.gradle:
```
rootProject.name = 'color_pencil'
apply from: file("../../../node_modules/@react-native-community/cli-platform-android/native_modules.gradle"); applyNativeModulesSettingsGradle(settings)
include ':app'
includeBuild('../../../node_modules/@react-native/gradle-plugin')
include ':unityLibrary'
project(':unityLibrary').projectDir=new File('..\\unity\\builds\\android\\unityLibrary')
```
## android/gradle/wrapper/gradle-wrapper.properties:
```
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-bin.zip
networkTimeout=10000
validateDistributionUrl=true
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
```
## android/app/src/main/AndroidManifest.xml:
```
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.color_pencil">
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
  <uses-permission android:name="com.android.vending.BILLING" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  <application android:name=".MainApplication" android:label="@string/app_name" android:icon="@mipmap/ic_launcher" android:roundIcon="@mipmap/ic_launcher" android:allowBackup="false" android:theme="@style/AppTheme">
    <meta-data android:name="com.google.firebase.messaging.default_notification_icon" android:resource="@mipmap/ic_launcher"/>
    <meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>
    <meta-data android:name="com.facebook.sdk.ClientToken" android:value="@string/facebook_client_token"/>
    <activity android:name=".MainActivity" android:label="@string/app_name" android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|screenSize|smallestScreenSize|uiMode" android:launchMode="singleTask" android:windowSoftInputMode="adjustResize" android:exported="true" android:resizeableActivity="true"
     >
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>
      <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="colorpencil"/>
      </intent-filter>
    </activity>
  </application>
</manifest>
```
## MainApplication.kt:
```
package com.color_pencil

import android.app.Application
import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactHost
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.load
import com.facebook.react.defaults.DefaultReactHost.getDefaultReactHost
import com.facebook.react.defaults.DefaultReactNativeHost
import com.facebook.soloader.SoLoader

class MainApplication : Application(), ReactApplication {

  override val reactNativeHost: ReactNativeHost =
      object : DefaultReactNativeHost(this) {
        override fun getPackages(): List<ReactPackage> =
            PackageList(this).packages.apply {
            }

        override fun getJSMainModuleName(): String = "index"

        override fun getUseDeveloperSupport(): Boolean = BuildConfig.DEBUG

        override val isNewArchEnabled: Boolean = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
        override val isHermesEnabled: Boolean = BuildConfig.IS_HERMES_ENABLED
      }

  override val reactHost: ReactHost
    get() = getDefaultReactHost(applicationContext, reactNativeHost)

  override fun onCreate() {
    super.onCreate()
    SoLoader.init(this, false)
    if (BuildConfig.IS_NEW_ARCHITECTURE_ENABLED) {
      // If you opted-in for the New Architecture, we load the native entry point for this app.
      load()
    }
  }
}
```
## MainActivity.kt:
```
package com.color_pencil
import android.os.Bundle
//import android.view.View
//import androidx.activity.enableEdgeToEdge
import com.facebook.react.ReactActivity
import com.facebook.react.ReactActivityDelegate
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.fabricEnabled
import com.facebook.react.defaults.DefaultReactActivityDelegate
import org.devio.rn.splashscreen.SplashScreen

class MainActivity : ReactActivity() {

 override fun onCreate(savedInstanceState: Bundle?) {
//    enableEdgeToEdge()
    SplashScreen.show(this, R.style.SplashScreen_SplashTheme, R.id.lottie)
    SplashScreen.setAnimationFinished(true)
   // super.onCreate(savedInstanceState)
    super.onCreate(null)

//    window.decorView.systemUiVisibility = (
//        View.SYSTEM_UI_FLAG_LAYOUT_STABLE
//        or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
//        or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
//        or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION // Hides the navigation bar
//        or View.SYSTEM_UI_FLAG_FULLSCREEN // Hides the status bar
//        or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY // Keeps the bars hidden in immersive mode
//    )
  }

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  override fun getMainComponentName(): String = "color_pencil"

    
  /**
   * Returns the instance of the [ReactActivityDelegate]. We use [DefaultReactActivityDelegate]
   * which allows you to enable New Architecture with a single boolean flags [fabricEnabled]
   */
  override fun createReactActivityDelegate(): ReactActivityDelegate =
      DefaultReactActivityDelegate(this, mainComponentName, fabricEnabled)
}
```
## unity/builds/android/build.gradle:
```
plugins {
    // If you are changing the Android Gradle Plugin version, make sure it is compatible with the Gradle version preinstalled with Unity
    // See which Gradle version is preinstalled with Unity here https://docs.unity3d.com/Manual/android-gradle-overview.html
    // See official Gradle and Android Gradle Plugin compatibility table here https://developer.android.com/studio/releases/gradle-plugin#updating-gradle
    // To specify a custom Gradle version in Unity, go do "Preferences > External Tools", uncheck "Gradle Installed with Unity (recommended)" and specify a path to a custom Gradle version
    id 'com.android.application' version '8.3.0' apply false
    id 'com.android.library' version '8.3.0' apply false
}

tasks.register('clean', Delete) {
    delete rootProject.layout.buildDirectory
}
```
## unity/builds/android/gradle.properties:
```
org.gradle.jvmargs=-Xmx4096M
org.gradle.parallel=true
unityStreamingAssets=
unityTemplateVersion=18
unityProjectPath=/Users/user/Unity/projects/Rootquotient work/cp-unity
unity.projectPath=/Users/user/Unity/projects/Rootquotient work/cp-unity
unity.debugSymbolLevel=none
unity.buildToolsVersion=34.0.0
unity.minSdkVersion=23
unity.targetSdkVersion=35
unity.compileSdkVersion=35
unity.applicationId=com.colorpencil.pixounity
unity.abiFilters=armeabi-v7a,arm64-v8a
unity.versionCode=4
unity.versionName=1.0.0
unity.namespace=com.colorpencil.pixounity
unity.androidSdkPath=/Users/aravinthan/Library/Android/sdk
unity.androidNdkPath=/Users/aravinthan/Library/Android/sdk/ndk/23.1.7779620
unity.androidNdkVersion=23.1.7779620
unity.jdkPath=/Applications/Unity/Hub/Editor/6000.0.37f1/PlaybackEngines/AndroidPlayer/OpenJDK
unity.javaCompatabilityVersion=VERSION_17
android.useAndroidX=true
android.enableJetifier=true
android.bundle.includeNativeDebugMetadata=false
org.gradle.welcome=never
```
## unity/builds/android/unityLibrary/src/main/AndroidManifest.xml:
```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
  xmlns:tools="http://schemas.android.com/tools">
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-feature android:glEsVersion="0x00030000" />
  <uses-feature android:name="android.hardware.vulkan.version" android:required="false" />
  <uses-feature android:name="android.hardware.touchscreen" android:required="false" />
  <uses-feature android:name="android.hardware.touchscreen.multitouch" android:required="false" />
  <uses-feature android:name="android.hardware.touchscreen.multitouch.distinct"
    android:required="false" />
  <application android:enableOnBackInvokedCallback="false" android:extractNativeLibs="true">
    <meta-data android:name="unity.splash-mode" android:value="0" />
    <meta-data android:name="unity.splash-enable" android:value="True" />
    <meta-data android:name="unity.launch-fullscreen" android:value="True" />
    <meta-data android:name="unity.render-outside-safearea" android:value="True" />
    <meta-data android:name="notch.config" android:value="portrait|landscape" />
    <meta-data android:name="unity.auto-report-fully-drawn" android:value="true" />
    <meta-data android:name="unity.auto-set-game-state" android:value="true" />
    <meta-data android:name="unity.strip-engine-code" android:value="false" />
    <activity
      android:configChanges="mcc|mnc|locale|touchscreen|keyboard|keyboardHidden|navigation|orientation|screenLayout|uiMode|screenSize|smallestScreenSize|fontScale|layoutDirection|density"
      android:enabled="true" android:exported="true" android:hardwareAccelerated="false"
      android:launchMode="singleTask" android:name="com.unity3d.player.UnityPlayerGameActivity"
      android:resizeableActivity="true" android:screenOrientation="fullUser"
      android:theme="@style/BaseUnityGameActivityTheme">
      <meta-data android:name="unityplayer.UnityActivity" android:value="true" />
      <meta-data android:name="android.app.lib_name" android:value="game" />
      <meta-data android:name="WindowManagerPreference:FreeformWindowSize"
        android:value="@string/FreeformWindowSize_tablet" />
      <meta-data android:name="WindowManagerPreference:FreeformWindowOrientation"
        android:value="@string/FreeformWindowOrientation_landscape" />
      <meta-data android:name="notch_support" android:value="true" />
      <layout android:defaultHeight="1080px" android:defaultWidth="1920px" android:minHeight="300px"
        android:minWidth="400px" />
    </activity>
  </application>
</manifest>
```