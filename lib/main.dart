import 'package:flutter/material.dart';
import 'app.dart';
import 'bootstrap/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const MyApp());
}
