import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Bubble> _bubbles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize bubbles
    for (int i = 0; i < 15; i++) {
      _bubbles.add(Bubble(_random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              ],
            ),
          ),
        ),
        // Animated Bubbles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: BubblePainter(
                bubbles: _bubbles,
                controllerValue: _controller.value,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              ),
              child: Container(),
            );
          },
        ),
        // Child Content
        widget.child,
      ],
    );
  }
}

class Bubble {
  late double x;
  late double y;
  late double size;
  late double speed;

  Bubble(Random random) {
    x = random.nextDouble();
    y = random.nextDouble();
    size = random.nextDouble() * 50 + 20;
    speed = random.nextDouble() * 0.2 + 0.05;
  }

  void update() {
    y -= speed * 0.01;
    if (y < -0.1) {
      y = 1.1;
      x = Random().nextDouble();
    }
  }
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double controllerValue;
  final Color color;

  BubblePainter({
    required this.bubbles,
    required this.controllerValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var bubble in bubbles) {
      bubble.update();
      canvas.drawCircle(
        Offset(bubble.x * size.width, bubble.y * size.height),
        bubble.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
