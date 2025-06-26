import 'package:flutter/material.dart';

class MovingWatermark extends StatefulWidget {
  final Widget child;
  const MovingWatermark({required this.child});

  @override
  State<MovingWatermark> createState() => MovingWatermarkState();
}

class MovingWatermarkState extends State<MovingWatermark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<Offset>(
      begin: const Offset(0.05, 0.05),
      end: const Offset(0.7, 0.7),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SlideTransition(
        position: _animation,
        child: Align(
          alignment: Alignment.topLeft,
          child: Opacity(
            opacity: 0.5,
            child: IgnorePointer(child: widget.child),
          ),
        ),
      ),
    );
  }
}
