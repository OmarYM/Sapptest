import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  Color color;
  CurvePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.0167);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.075,
        size.width * 0.5, size.height * 0.0167);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.0584,
        size.width * 1.0, size.height * 0.0167);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}