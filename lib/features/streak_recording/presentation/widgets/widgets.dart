import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';

class BouncingText extends StatefulWidget {
  const BouncingText({super.key});

  @override
  State<BouncingText> createState() => _BouncingTextState();
}

class _BouncingTextState extends State<BouncingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  late Animation<double> _animation4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation1 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.25, curve: Curves.easeInOut),
      ),
    );
    _animation2 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.5, curve: Curves.easeInOut),
      ),
    );
    _animation3 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.75, curve: Curves.easeInOut),
      ),
    );
    _animation4 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedLetter(String letter, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnimatedLetter('Y', _animation1),
            const SizedBox(width: 4),
            _buildAnimatedLetter('o', _animation2),
            const SizedBox(width: 8),
            _buildAnimatedLetter('Y', _animation3),
            const SizedBox(width: 4),
            _buildAnimatedLetter('o', _animation4),
          ],
        ),
      ),
    );
  }
}

class CheckingDots extends StatefulWidget {
  const CheckingDots({super.key});

  @override
  State<CheckingDots> createState() => _CheckingDotsState();
}

class _CheckingDotsState extends State<CheckingDots> {
  int dotCount = 1;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      setState(() {
        dotCount = (dotCount % 4) + 1; // cycles 1 → 4 → 1 → 4...
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * dotCount;
    return Text(
      '${text.checking}$dots',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}
