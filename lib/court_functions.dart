import 'dart:math';

import 'package:flutter/services.dart';
import 'package:scidart/numdart.dart';
import 'dart:math' as math;

import 'package:scidart/src/numdart/arrays_base/array.dart';
import 'package:scidart/src/numdart/arrays_base/array2d.dart';
import 'package:scidart/src/numdart/geometric/hypotenuse.dart';
import 'package:scidart/src/numdart/linalg/matrix_operations/matrix_sub.dart';
import 'package:scidart/src/numdart/numdart.dart';






Array2d find_homography3(List<dynamic> p1, List<dynamic> p2) {

  Array2d A = Array2d.empty();
  Array2d B = Array2d.empty();


  //print(p2);







  for (int i = 0; i <4; i++) {

    double x = p1[i][0].toDouble();
    double y = p1[i][1].toDouble();

    double u = p2[i][0].toDouble();
    double v = p2[i][1].toDouble();

    A.add(Array([x, y,1, 0, 0, 0, -u*x,- u*y ]));
    A.add(Array([0, 0, 0, x, y, 1, -v*x, -v*y]));

    B.add(Array([u]));
    B.add(Array([v]));










  }

  Array2d hom_matrix = Array2d.empty();
  Array2d hom = Array2d.empty();


  A=matrixInverse(A);

  hom=matrixDot(A, B);












    hom_matrix.add(Array([hom[0][0],hom[1][0],hom[2][0]]));
    hom_matrix.add(Array([hom[3][0],hom[4][0],hom[5][0]]));
    hom_matrix.add(Array([hom[6][0],hom[7][0],1]));




//  print(hom_matrix);



  return hom_matrix;



}

