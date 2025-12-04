import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';

class MaintenanceModeScreen extends StatelessWidget {
  const MaintenanceModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.build_circle_outlined,
                size: 100,
                color: Colors.orange.shade700,
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                text.scheduled_maintenance,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                text.service_unavailable,
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Time estimate
              Text(
                text.back_online,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Retry Button
              const SizedBox(height: 16),

              // Optional: Link to a status page
            ],
          ),
        ),
      ),
    );
  }
}
