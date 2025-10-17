import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';

class RiveManager {
  static final RiveManager _instance = RiveManager._internal();
  factory RiveManager() => _instance;
  RiveManager._internal();

  late RiveAnimationController _controller;
  final bool _isInitialized = false;

  RiveAnimationController? get controller =>
      _isInitialized ? _controller : null;

  void play() {
    showDialog(
      context: ctx!,
      barrierDismissible: false,
      builder: (context) => const PlayPauseAnimation(),
    );

    Future.delayed(const Duration(seconds: 4), () {
      if (Navigator.canPop(ctx!)) {
        Navigator.pop(ctx!);
      }
    });
  }
}

class PlayPauseAnimation extends StatefulWidget {
  const PlayPauseAnimation({super.key});

  @override
  _PlayPauseAnimationState createState() => _PlayPauseAnimationState();
}

class _PlayPauseAnimationState extends State<PlayPauseAnimation> {
  late RiveAnimationController _controller;

  bool get isPlaying => _controller.isActive;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('Animation 1', autoplay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'assets/animation/confetti.riv',
          controllers: [_controller],
          onInit: (_) => setState(() {}),
        ),
      ),
    );
  }
}
