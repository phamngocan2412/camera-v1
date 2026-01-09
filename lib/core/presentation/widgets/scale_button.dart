import 'package:flutter/material.dart';

class ScaleButton extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double scale;

  const ScaleButton({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
    this.scale = 0.95,
  });

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _controller.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    _controller.reverse();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
