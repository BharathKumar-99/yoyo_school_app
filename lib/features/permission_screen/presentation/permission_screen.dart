import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool micGranted = false;
  bool notifGranted = false;

  Future<void> _requestMic() async {
    PermissionStatus status = await Permission.microphone.status;

    if (status.isDenied) {
      status = await Permission.microphone.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    setState(() => micGranted = status.isGranted);
  }

  Future<void> _requestNotifications() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    setState(() => notifGranted = status.isGranted);
  }

  bool get allGranted => micGranted && notifGranted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              const Text(
                "Permissions Required",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              const Text(
                "We need a couple of permissions to give you the best experience.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),
              
              _PermissionTile(
                icon: Icons.mic,
                title: "Microphone",
                description: "Used for recording phrases",
                granted: micGranted,
                onTap: _requestMic,
              ),

              const SizedBox(height: 20),

              _PermissionTile(
                icon: Icons.notifications,
                title: "Notifications",
                description: "Stay updated with alerts and reminders",
                granted: notifGranted,
                onTap: _requestNotifications,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: allGranted
                      ? () {
                          // Navigate to app
                          context.go(RouteNames.permission);
                        }
                      : null,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text("Continue"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool granted;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.granted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: granted ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: granted ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            Icon(
              granted ? Icons.check_circle : Icons.arrow_forward_ios,
              color: granted ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
