import 'dart:math';
import 'package:flutter/material.dart';

class AttributePainter extends CustomPainter {
  final double progressPercent;
  final double strokeWidth;
  final double filledStrokeWidth;

  AttributePainter({
    required this.progressPercent,
    this.strokeWidth = 4.0,
    this.filledStrokeWidth = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()..color = Colors.white.withOpacity(0.25);
    final strokeBgPaint = Paint()..color = Color.fromARGB(255, 255, 0, 0);
    final strokeFilledPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = filledStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawCircle(center, radius - strokeWidth, strokeBgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
      -pi / 2,
      (progressPercent / 100) * pi * 2,
      false,
      strokeFilledPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AttributeWidget extends StatelessWidget {
  final double progress;
  final Widget? child;
  final double size;

  const AttributeWidget({
    super.key,
    required this.progress,
    this.child,
    this.size = 82.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AttributePainter(progressPercent: progress),
      size: Size(size, size),
      child: Container(
        padding: EdgeInsets.all(size / 3.8),
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}