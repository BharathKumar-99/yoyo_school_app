import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/utils/restarter.dart';
import 'app.dart';
import 'bootstrap/app_initializer.dart';

Future<void> main() async {
  await AppInitializer.initialize();
  runApp(RestartWidget(child: const MyApp()));
}
