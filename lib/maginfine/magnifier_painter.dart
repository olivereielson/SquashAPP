import 'package:flutter/material.dart';

class MagnifierPainter extends CustomPainter {
  const MagnifierPainter({@required this.color, this.strokeWidth = 5});

  final double strokeWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    _drawCircle(canvas, size);
    _drawCrosshair(canvas, size);
  }

  void _drawCircle(Canvas canvas, Size size) {
    Paint paintObject = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color;
    canvas.drawCircle(size.center(Offset(0, 0)), 5, paintObject);

    canvas.drawCircle(size.center(Offset(0, 0)), size.longestSide / 2, paintObject);
  }

  void _drawCrosshair(Canvas canvas, Size size) {
    Paint crossPaint = Paint()
      ..strokeWidth = 2
      ..color = color;

    double crossSize = (size.longestSide - 20) / 2;

    //canvas.drawCircle(size.center(Offset(0, 0)), 100, crossPaint);

    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, (size.height - 10) / 2), crossPaint);

    canvas.drawLine(Offset(size.width / 2, (size.height + 10) / 2), Offset(size.width / 2, size.height), crossPaint);

    canvas.drawLine(Offset(0, size.height / 2), Offset((size.height - 10) / 2, (size.height) / 2), crossPaint);

    canvas.drawLine(Offset((size.height + 10) / 2, size.height / 2), Offset((size.height), (size.height) / 2), crossPaint);

    //canvas.drawLine(size.center(Offset(-crossSize, -crossSize)), size.center(Offset(crossSize, crossSize)), crossPaint);

    //canvas.drawLine(size.center(Offset(crossSize, -crossSize)), size.center(Offset(-crossSize, crossSize)), crossPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
