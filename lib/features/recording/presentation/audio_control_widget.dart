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
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDeleteButton(
              onTap: onLeftDeleteTap,
              icon: const Icon(Icons.close, color: Colors.grey),
            ),
            const SizedBox(width: 10),

            _buildSwipeIndicator('<<'),

            const SizedBox(width: 80),

            _buildSwipeIndicator('>>'),
            const SizedBox(width: 10),

            _buildDeleteButton(
              onTap: onRightDeleteTap,
              icon: const Icon(Icons.close, color: Colors.grey),
            ),
          ],
        ),

        _DraggableMicrophoneControl(
          isRecording: isRecording,
          onStartHold: onStartHold,
          onReleaseHold: onReleaseHold,
          onSwipeLeft: onSwipeLeft,
          onSwipeRight: onSwipeRight,
          color: color,
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
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: icon,
      ),
    );
  }

  Widget _buildSwipeIndicator(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
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
  const _DraggableMicrophoneControl({
    required this.isRecording,
    required this.onStartHold,
    required this.onReleaseHold,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.color,
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

      final clampedX = _dragOffset.dx.clamp(-80.0, 80.0);
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
          backgroundColor: widget.color,
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
