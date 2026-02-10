import 'package:permission_handler/permission_handler.dart';

Future<void> requestMicrophonePermission() async {
  final status = await Permission.microphone.request();
  if (status.isGranted) {
    print("Microphone permission granted");
    // Proceed with microphone-related functionality
  } else if (status.isDenied) {
    print("Microphone permission denied");
    // Show a rationale or gracefully handle the denial
  } else if (status.isPermanentlyDenied) {
    print("Microphone permission permanently denied");
    // Guide the user to app settings
    openAppSettings();
  }
}
