import 'dart:math';

import 'package:flutter/material.dart';

class FakeWaveform extends StatefulWidget {
  final bool isPlaying;
  final int barCount;
  final double height;
  final Color color;

  const FakeWaveform({
    super.key,
    required this.isPlaying,
    this.barCount = 30,
    this.height = 30,
    this.color = Colors.black,
  });

  @override
  State<FakeWaveform> createState() => _FakeWaveformState();
}

class _FakeWaveformState extends State<FakeWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _bars;

  @override
  void initState() {
    super.initState();

    _bars = List.generate(widget.barCount, (i) => _baseHeight(i));

    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 900),
        )..addListener(() {
          if (!widget.isPlaying) return;

          setState(() {
            _bars = _bars
                .map((e) => (e + _randomDelta()).clamp(4.0, widget.height))
                .toList();
          });
        });

    if (widget.isPlaying) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant FakeWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _bars = List.generate(widget.barCount, (i) => _baseHeight(i));
    }
  }

  double _baseHeight(int index) {
    final center = widget.barCount / 2;
    final distance = (index - center).abs();
    return (widget.height * (1 - distance / center)).clamp(6.0, widget.height);
  }

  double _randomDelta() => (Random().nextDouble() - 0.5) * 6;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _bars.map((h) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 3,
            height: h,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
