import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import '../../config/router/navigation_helper.dart';
import '../../features/home/model/level_model.dart';
import '../../features/home/model/school_launguage.dart' show SchoolLanguage;
import '../../features/home/model/student_model.dart';

Widget backBtn({
  bool streak = false,
  BuildContext? context,
  SchoolLanguage? slanguage,
  String? className,
  List<Level>? levels,
  Student? student,
}) {
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
                onPressed: () => NavigationHelper.go(
                  RouteNames.phrasesDetails,
                  extra: {
                    'language': slanguage,
                    "className": className ?? "",
                    "level": levels ?? [],
                    'student': student,
                  },
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => NavigationHelper.go(
                  RouteNames.phrasesDetails,
                  extra: {
                    'language': slanguage,
                    "className": className ?? "",
                    "level": levels ?? [],
                    'student': student,
                  },
                ),
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
