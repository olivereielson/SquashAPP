import 'dart:ffi';
import 'dart:ui';

import 'package:scidart/numdart.dart';
import 'package:squash/Solo/court_functions.dart';

class SoloDefs {

  List<dynamic> scr_forehand = [
    [810, 1200],
    [1080, 1200],
    [1080, 930],
    [810, 930]
  ];

  List<dynamic> scr_backhand = [
    [10.0, 1200],
    [280, 1200],
    [280, 930],
    [10, 930]
  ];


  List Exersise = [
    {"name": "Forehand Drives", "id": 0, "xmin": 540, "ymin": 930, "xmax": 1080, "ymax": 1645, "BackHand": false},
    {"name": "Backhand Drives", "id": 1, "xmin": 10, "ymin": 930, "xmax": 540, "ymax": 1645, "BackHand": true},
    {"name": "Forehand Channel", "id": 2, "xmin": 810, "ymin": 930, "xmax": 1080, "ymax": 1645, "BackHand": false},
    {"name": "Backhand Channel", "id": 3, "xmin": 10, "ymin": 930, "xmax": 280, "ymax": 1645, "BackHand": true},
    {"name": "Forehand Half Channel", "id": 4, "xmin": 945, "ymin": 930, "xmax": 1080, "ymax": 1645, "BackHand": false},
    {"name": "Backhand Half Channel", "id": 5, "xmin": 10, "ymin": 930, "xmax": 145, "ymax": 1645, "BackHand": true},
    {"name": "Forehand Service Box", "id": 6, "xmin": 810, "ymin": 930, "xmax": 1080, "ymax": 1200, "BackHand": false},
    {"name": "BackHand Service Box", "id": 7, "xmin": 10, "ymin": 930, "xmax": 280, "ymax": 1200, "BackHand": true},
  ];


  Map convert_points(int index,points){

    var H;
    if(Exersise[index]["BackHand"]) {
       H= find_homography3(scr_backhand, points);
    }else{
       H = find_homography3(scr_forehand, points);

    }

    Offset p1=hom_trans(Exersise[index]["xmin"].toDouble(), Exersise[index]["ymin"].toDouble(), H);
    Offset p2=hom_trans(Exersise[index]["xmax"].toDouble(), Exersise[index]["ymin"].toDouble(), H);
    Offset p3=hom_trans(Exersise[index]["xmax"].toDouble(), Exersise[index]["ymax"].toDouble(), H);
    Offset p4=hom_trans(Exersise[index]["xmin"].toDouble(), Exersise[index]["ymax"].toDouble(), H);


    return <String,Offset> {"p1":p1,"p2":p2,"p3":p3,"p4":p4};





  }

  Offset hom_trans(x,y,H){
    var nums =Array2d([Array([x]),Array([y]),Array([1])]);
    var points= matrixDot(H,nums);
    double scale=points[2][0];
    double x1=(points[0][0]/scale);
    double y1=(points[1][0]/scale);

    return Offset(x1, y1);



  }

}




//Map ForeHandDrives = {"name": "Forehand Drives", "id": 0, "xmin": 540, "ymin": 930, "xmax": 1080, "ymax": 1645, "BackHand": false};

//Map BackHandDrives = {"name": "Backhand Drives", "id": 1, "xmin": 10, "ymin": 930, "xmax": 540, "ymax": 1645, "BackHand": true};

//Map ForeHandServiceBox = {"name": "Forehand Service Box", "id": 2, "xmin": 810, "ymin": 930, "xmax": 1080, "ymax": 1200, "BackHand": false};

//Map BackHandServiceBox = {"name": "BackHand Service Box", "id": 3, "xmin": 10, "ymin": 930, "xmax": 280, "ymax": 1200, "BackHand": true};