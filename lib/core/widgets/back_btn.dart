import 'package:flutter/material.dart';

import '../../config/router/navigation_helper.dart';

Widget backBtn({bool streak = false, BuildContext? context}) {
  return IconButton(
    onPressed: () async {
      if (streak && context != null) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Leave Streak?'),
            content: const Text(
              'Are you sure you want to go back? Your streak progress might be lost.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Yes, Leave'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          NavigationHelper.pop(false);
        }
      } else {
        NavigationHelper.pop();
      }
    },
    icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
      fixedSize: WidgetStateProperty.all(const Size(40, 40)),
    ),
  );
}
