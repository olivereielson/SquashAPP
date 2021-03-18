import 'dart:math';
import 'dart:ui';

import '../extra/hive_classes.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';

import 'court_functions.dart';



class MyPainter extends CustomPainter {

  List<Point> serve_box;
  List<Point> dst_point;



  MyPainter(this.serve_box,this.dst_point);





  Offset hom_trans(x,y,H){
    var nums =Array2d([Array([x]),Array([y]),Array([1])]);
    var points= matrixDot(H,nums);
    double scale=points[2][0];
    double x1=(points[0][0]/scale);
    double y1=(points[1][0]/scale);


    return Offset(x1, y1);



  }

  Offset point_to_offset(Point p){

    return Offset(p.x.toDouble(), p.y.toDouble());


  }



  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color =Color.fromRGBO(40, 45, 81, 1)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    final paint2 = Paint()
      ..color =Color.fromRGBO(4, 255, 255, 1)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;



//2



    canvas.drawLine(point_to_offset(serve_box[0]), point_to_offset(serve_box[1]), paint);
    canvas.drawLine(point_to_offset(serve_box[0]), point_to_offset(serve_box[2]), paint);
    canvas.drawLine(point_to_offset(serve_box[3]), point_to_offset(serve_box[2]), paint);
    canvas.drawLine(point_to_offset(serve_box[3]), point_to_offset(serve_box[1]), paint);



    //canvas.drawLine(point_to_offset(dst_point[0]), point_to_offset(serve_box[1]), paint2);

    //anvas.drawLine(point_to_offset(dst_point[2]), point_to_offset(dst_point[3]), paint2);




    canvas.drawLine(point_to_offset(dst_point[3]), point_to_offset(dst_point[1]), paint);
    //canvas.drawLine(point_to_offset(dst_point[4]), point_to_offset(serve_box[1]), paint);
    canvas.drawLine(point_to_offset(dst_point[3]), point_to_offset(dst_point[2]), paint);
    canvas.drawLine(point_to_offset(dst_point[0]), point_to_offset(dst_point[2]), paint);
    canvas.drawLine(point_to_offset(dst_point[1]), point_to_offset(dst_point[0]), paint);
    //canvas.drawLine(point_to_offset(dst_point[0]), Offset(dst_point[0].x,0.0), paint2);
    //sscanvas.drawLine(point_to_offset(dst_point[0]), Offset(dst_point[0].x,1000), paint2);





//3
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
