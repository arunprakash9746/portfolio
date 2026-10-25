import 'package:flutter/material.dart';

class Pointer extends CustomPainter {
  final double radius;
  final Color color;
  Pointer(this.radius, {this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      const Offset(0, 0),
      radius,
      Paint()
        ..color = color
        ..blendMode = BlendMode.difference,
    );
  }

  @override
  bool shouldRepaint(covariant Pointer oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}

class HoverPointer extends CustomPainter {
  final double radius;
  HoverPointer(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        const Offset(0, 0),
        radius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
