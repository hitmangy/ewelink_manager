import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:ewelink/theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(_controller.value),
          child: Container(),
          size: Size.infinite,
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppTheme.darkBackground;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw gradient blobs
    final gradientPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          AppTheme.accentColor.withOpacity(0.3),
          AppTheme.accentColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.2, size.height * 0.2),
        radius: size.width * 0.4,
      ));

    // Animated blob 1
    final blob1Center = Offset(
      size.width * (0.2 + 0.1 * math.sin(animationValue * 2 * math.pi)),
      size.height * (0.2 + 0.1 * math.cos(animationValue * 2 * math.pi)),
    );
    canvas.drawCircle(blob1Center, size.width * 0.4, gradientPaint);

    // Animated blob 2
    final gradientPaint2 = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          AppTheme.accentColorLight.withOpacity(0.3),
          AppTheme.accentColorLight.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.8, size.height * 0.8),
        radius: size.width * 0.5,
      ));

    final blob2Center = Offset(
      size.width * (0.8 + 0.1 * math.cos(animationValue * 2 * math.pi + 1)),
      size.height * (0.8 + 0.1 * math.sin(animationValue * 2 * math.pi + 1)),
    );
    canvas.drawCircle(blob2Center, size.width * 0.5, gradientPaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
