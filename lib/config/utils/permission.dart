import 'package:permission_handler/permission_handler.dart';

Future<void> checkMicPermission() async {
  final status = await Permission.microphone.status;

  // Already granted → do nothing
  if (status.isGranted) {
    return;
  }

  // Permanently denied → open settings
  if (status.isPermanentlyDenied) {
    await openAppSettings();
    return;
  }

  // Only request if NOT already requested
  if (status.isDenied) {
    await Permission.microphone.request();
  }
}
