import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

// Added WidgetsBindingObserver to detect when user returns from Settings
class _PermissionsScreenState extends State<PermissionsScreen> with WidgetsBindingObserver {
  bool micGranted = false;
  bool notifGranted = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPermissionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This triggers when the user comes back to the app from iOS Settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadPermissionStatus();
    }
  }

  Future<void> _loadPermissionStatus() async {
    final mic = await Permission.microphone.status;
    final notif = await Permission.notification.status;

    setState(() {
      micGranted = mic.isGranted;
      notifGranted = notif.isGranted;
    });
  }

  Future<void> _handlePermissionRequest(Permission permission) async {
    setState(() => loading = true);

    // 1. Check current status
    var status = await permission.status;

    // 2. If it's the first time or previously denied (but not permanently), show POPUP
    if (status.isDenied) {
      status = await permission.request();
    } 
    // 3. If user already said "Don't Allow" twice or disabled it in settings
    else if (status.isPermanentlyDenied || status.isRestricted) {
      await openAppSettings();
    }

    await _loadPermissionStatus();
    setState(() => loading = false);
  }

  bool get allGranted => micGranted && notifGranted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                "To continue, please allow the following permissions so the app can function correctly.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              _PermissionTile(
                icon: Icons.mic,
                title: "Microphone",
                description: "Used for recording phrases",
                granted: micGranted,
                onTap: () => _handlePermissionRequest(Permission.microphone),
              ),

              const SizedBox(height: 20),

              _PermissionTile(
                icon: Icons.notifications,
                title: "Notifications",
                description: "Receive reminders and updates",
                granted: notifGranted,
                onTap: () => _handlePermissionRequest(Permission.notification),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allGranted ? Colors.blue : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: allGranted
                      ? () => context.go(RouteNames.splash)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: loading
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                          )
                        : const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: granted ? Colors.green.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: granted ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: granted ? Colors.green : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: granted ? Colors.white : Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(description, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            Icon(
              granted ? Icons.check_circle : Icons.arrow_forward_ios,
              color: granted ? Colors.green : Colors.grey,
              size: granted ? 28 : 18,
            ),
          ],
        ),
      ),
    );
  }
}