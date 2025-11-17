# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Keep FFmpeg (plugin itself provides rules, but safe)
-keep class com.arthenica.ffmpegkit.** { *; }
-dontwarn com.arthenica.ffmpegkit.**

# Keep Kotlin (optional but safe)
-keep class kotlin.** { *; }
-keepclassmembers class kotlin.** { *; }

# Keep Supabase (uses pure Dart → safe, but keep for reflection safety)
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# Prevent removing annotations
-keepattributes *Annotation*

# Remove logs
-assumenosideeffects class android.util.Log {
    public static *** i(...);
    public static *** d(...);
    public static *** v(...);
    public static *** w(...);
    public static *** e(...);
}
