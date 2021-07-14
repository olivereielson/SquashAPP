import 'dart:math';
import 'dart:ui';

import 'package:squash/Solo/solo_defs.dart';

import '../extra/hive_classes.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';

import 'court_functions.dart';

class MyPainter extends CustomPainter {
  List<Point> serve_box;
  List<Point> dst_point;
  bool showGreen;
  int currentSide;
  Color line_color;

  MyPainter(this.serve_box, this.dst_point, this.currentSide, this.showGreen,this.line_color);

  Offset hom_trans(x, y, H) {
    var nums = Array2d([
      Array([x]),
      Array([y]),
      Array([1])
    ]);
    var points = matrixDot(H, nums);
    double scale = points[2][0];
    double x1 = (points[0][0] / scale);
    double y1 = (points[1][0] / scale);

    return Offset(x1, y1);
  }

  Offset point_to_offset(Point p) {
    return Offset(p.x.toDouble(), p.y.toDouble());
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = line_color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;


    final colorPaint = Paint()
      ..color = Colors.lightGreen.withOpacity(0.3)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

//2

    canvas.drawLine(point_to_offset(serve_box[0]), point_to_offset(serve_box[1]), paint);
    canvas.drawLine(point_to_offset(serve_box[0]), point_to_offset(serve_box[2]), paint);
    canvas.drawLine(point_to_offset(serve_box[3]), point_to_offset(serve_box[2]), paint);
    canvas.drawLine(point_to_offset(serve_box[3]), point_to_offset(serve_box[1]), paint);

    List<dynamic> dst = [
      [serve_box[2].x, serve_box[2].y],
      [serve_box[3].x, serve_box[3].y],
      [serve_box[1].x, serve_box[1].y],
      [serve_box[0].x, serve_box[0].y],
    ];

    Map<String, Offset> targets = SoloDefs().convert_points(currentSide, dst);


    var drive2 = Path();

    drive2.moveTo(targets["p1"].dx, targets["p1"].dy);
    drive2.lineTo(targets["p2"].dx, targets["p2"].dy);
    drive2.lineTo(targets["p3"].dx, targets["p3"].dy);
    drive2.lineTo(targets["p4"].dx, targets["p4"].dy);

    if (showGreen) {
      canvas.drawPath(drive2, colorPaint);
    }

    canvas.drawLine(point_to_offset(dst_point[3]), point_to_offset(dst_point[1]), paint);
    canvas.drawLine(point_to_offset(dst_point[3]), point_to_offset(dst_point[2]), paint);
    canvas.drawLine(point_to_offset(dst_point[0]), point_to_offset(dst_point[2]), paint);
    canvas.drawLine(point_to_offset(dst_point[1]), point_to_offset(dst_point[0]), paint);

//3
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
