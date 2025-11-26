import 'package:flutter/material.dart';

typedef GestureCallback = void Function();

class AudioControlWidget extends StatelessWidget {
  final GestureCallback onStartHold;
  final GestureCallback onReleaseHold;
  final GestureCallback onSwipeLeft;
  final GestureCallback onSwipeRight;
  final GestureCallback onLeftDeleteTap;
  final GestureCallback onRightDeleteTap;
  final Color color;
  final bool isRecording;
  final Color border;
  final Color bgColor;

  const AudioControlWidget({
    super.key,
    required this.onStartHold,
    required this.onReleaseHold,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onLeftDeleteTap,
    required this.onRightDeleteTap,
    this.isRecording = false,
    required this.color,
    required this.border,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isRecording)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 20),
              _buildDeleteButton(
                onTap: onLeftDeleteTap,
                icon: Icon(Icons.close, color: border),
              ),
              _PulsatingSwipeIndicatorStateful('<<', border: border),
              const SizedBox(width: 84),
              _PulsatingSwipeIndicatorStateful('>>', border: border),
              _buildDeleteButton(
                onTap: onRightDeleteTap,
                icon: Icon(Icons.close, color: border),
              ),
              const SizedBox(width: 20),
            ],
          ),
        _DraggableMicrophoneControl(
          isRecording: isRecording,
          onStartHold: onStartHold,
          onReleaseHold: onReleaseHold,
          onSwipeLeft: onSwipeLeft,
          onSwipeRight: onSwipeRight,
          color: color,
          bgColor: bgColor,
        ),
      ],
    );
  }

  Widget _buildDeleteButton({
    required GestureCallback onTap,
    required Icon icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: border),
        ),
        child: icon,
      ),
    );
  }
}

class _PulsatingSwipeIndicatorStateful extends StatefulWidget {
  final String text;
  final Color border;

  const _PulsatingSwipeIndicatorStateful(this.text, {required this.border});

  @override
  State<_PulsatingSwipeIndicatorStateful> createState() =>
      _PulsatingSwipeIndicatorStatefulState();
}

class _PulsatingSwipeIndicatorStatefulState
    extends State<_PulsatingSwipeIndicatorStateful>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.border,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DraggableMicrophoneControl extends StatefulWidget {
  final GestureCallback onStartHold;
  final GestureCallback onReleaseHold;
  final GestureCallback onSwipeLeft;
  final GestureCallback onSwipeRight;
  final bool isRecording;
  final Color color;
  final Color bgColor;
  const _DraggableMicrophoneControl({
    required this.isRecording,
    required this.onStartHold,
    required this.onReleaseHold,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.color,
    required this.bgColor,
  });

  @override
  State<_DraggableMicrophoneControl> createState() =>
      __DraggableMicrophoneControlState();
}

class __DraggableMicrophoneControlState
    extends State<_DraggableMicrophoneControl> {
  Offset _dragOffset = Offset.zero;
  static const double _swipeThreshold = 40.0;

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    setState(() {
      _dragOffset = details.localOffsetFromOrigin;

      final clampedX = _dragOffset.dx.clamp(-110.0, 110.0);
      _dragOffset = Offset(clampedX, 0);
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    final finalDragX = _dragOffset.dx;
    bool isSwipe = false;

    if (finalDragX < -_swipeThreshold) {
      widget.onSwipeLeft();
      isSwipe = true;
    } else if (finalDragX > _swipeThreshold) {
      widget.onSwipeRight();
      isSwipe = true;
    }

    if (!isSwipe) {
      widget.onReleaseHold();
    }

    setState(() {
      _dragOffset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        _dragOffset = Offset.zero;
        widget.onStartHold();
      },
      onLongPressMoveUpdate: _onLongPressMoveUpdate,
      onLongPressEnd: _onLongPressEnd,

      child: Transform.translate(
        offset: _dragOffset,
        child: CircleAvatar(
          radius: 42,
          backgroundColor: widget.bgColor,
          child: CircleAvatar(
            backgroundColor: widget.isRecording ? widget.color : Colors.white,
            radius: 40,
            child: Icon(
              widget.isRecording ? Icons.mic : Icons.mic_none_rounded,
              size: 45,
              color: widget.isRecording ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
