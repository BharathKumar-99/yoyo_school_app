# Keep JNI entry points for FFmpeg Kit
-keep class com.arthenica.ffmpegkit.** { *; }
-keep class com.arthenica.ffmpegkit.flutter.** { *; }
-keepclassmembers class * {
    native <methods>;
}