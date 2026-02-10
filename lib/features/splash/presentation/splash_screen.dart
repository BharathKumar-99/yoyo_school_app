import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/features/splash/presentation/splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashViewModel>(
      create: (context) => SplashViewModel(),
      child: Consumer<SplashViewModel>(
        builder: (context, spl, w) {
          return Container(color: Colors.white);
        },
      ),
    );
  }
}
