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
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadPermissionStatus();
  }

  Future<void> _loadPermissionStatus() async {
    final mic = await Permission.microphone.status;
    final notif = await Permission.notification.status;

    setState(() {
      micGranted = mic.isGranted;
      notifGranted = notif.isGranted;
    });
  }

  Future<void> _requestMic() async {
    setState(() => loading = true);

    final status = await Permission.microphone.request();

    if (status.isGranted) {
      micGranted = true;
    } else {
      await openAppSettings();
    }

    setState(() => loading = false);
  }

  Future<void> _requestNotifications() async {
    setState(() => loading = true);

    final status = await Permission.notification.request();

    if (status.isGranted) {
      notifGranted = true;
    } else {
      await openAppSettings();
    }

    setState(() => loading = false);
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
                "To continue, please allow the following permissions.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              _PermissionTile(
                icon: Icons.mic,
                title: "Microphone",
                description: "Used for recording phrases",
                granted: micGranted,
                onTap: loading ? null : _requestMic,
              ),

              const SizedBox(height: 20),

              _PermissionTile(
                icon: Icons.notifications,
                title: "Notifications",
                description: "Receive reminders and updates",
                granted: notifGranted,
                onTap: loading ? null : _requestNotifications,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: allGranted
                      ? () {
                          context.go(RouteNames.splash);
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("Continue"),
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
  final VoidCallback? onTap;

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
