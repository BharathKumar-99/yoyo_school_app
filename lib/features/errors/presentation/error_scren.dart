import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorScreen extends StatefulWidget {
  final String? message;
  final StackTrace? error;
  final VoidCallback? onRetry;

  const ErrorScreen({super.key, this.message, this.error, this.onRetry});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Something went wrong",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.message ?? "An unexpected error occurred.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.error.toString(),
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: "monospace",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (widget.onRetry != null)
                    ElevatedButton.icon(
                      onPressed: widget.onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: widget.error.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error details copied"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text("Copy Error Logs"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
