import 'dart:ffi';
import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:scidart/numdart.dart';
import 'package:squash/Solo/court_functions.dart';
import 'package:squash/extra/hive_classes.dart';

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
    {"name": "Forehand Drives", "id": 0, "xmin": 540, "ymin": 930, "xmax": 1080, "ymax": 1645, "right_side": true},
    {"name": "Backhand Drives", "id": 1, "xmin": 10, "ymin": 930, "xmax": 540, "ymax": 1645, "right_side": false},
    {"name": "Forehand Channel", "id": 2, "xmin": 810, "ymin": 930, "xmax": 1080, "ymax": 1645, "right_side": true},
    {"name": "Backhand Channel", "id": 3, "xmin": 10, "ymin": 930, "xmax": 280, "ymax": 1645, "right_side": false},
    {"name": "Forehand Half Channel", "id": 4, "xmin": 945, "ymin": 930, "xmax": 1080, "ymax": 1645, "right_side": true},
    {"name": "Backhand Half Channel", "id": 5, "xmin": 10, "ymin": 930, "xmax": 145, "ymax": 1645, "right_side": false},
    {"name": "Forehand Service Box", "id": 6, "xmin": 810, "ymin": 930, "xmax": 1080, "ymax": 1200, "right_side": true},
    {"name": "BackHand Service Box", "id": 7, "xmin": 10, "ymin": 930, "xmax": 280, "ymax": 1200, "right_side": false},
  ];
  List Exersise_Lefty = [
    {"name": "Backhand Drives", "id": 0, "xmin": 540, "ymin": 930, "xmax": 1080, "ymax": 1645, "right_side": true},
    {"name": "Forehand Drives", "id": 1, "xmin": 10, "ymin": 930, "xmax": 540, "ymax": 1645, "right_side": false},
    {"name": "Backhand Channel", "id": 2, "xmin": 810, "ymin": 930, "xmax": 1080, "ymax": 1645, "right_side": true},
    {"name": "Forehand Channel", "id": 3, "xmin": 10, "ymin": 930, "xmax": 280, "ymax": 1645, "right_side": false},
    {"name": "Backhand Half Channel", "id": 4, "xmin": 945, "ymin": 930, "xmax": 1080, "ymax": 1645, "right_side": true},
    {"name": "Forehand Half Channel", "id": 5, "xmin": 10, "ymin": 930, "xmax": 145, "ymax": 1645, "right_side": false},
    {"name": "BackHand Service Box", "id": 6, "xmin": 810, "ymin": 930, "xmax": 1080, "ymax": 1200, "right_side": true},
    {"name": "Forehand Service Box", "id": 7, "xmin": 10, "ymin": 930, "xmax": 280, "ymax": 1200, "right_side": false},
  ];

  Box<Solo_Defs> Exersise2;
  String box="Solo_Defs1";


  Map convert_points(Solo_Defs def,points){

    var H;


    if(!def.right_side) {
       H= find_homography3(scr_backhand, points);
    }else{
       H = find_homography3(scr_forehand, points);
    }

    Offset p1=hom_trans(def.xmin.toDouble(), def.ymin.toDouble(), H);
    Offset p2=hom_trans(def.xmax.toDouble(), def.ymin.toDouble(), H);
    Offset p3=hom_trans(def.xmax.toDouble(), def.ymax.toDouble(), H);
    Offset p4=hom_trans(def.xmin.toDouble(), def.ymax.toDouble(), H);


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

  setup() async {

    if (!Hive.isAdapterRegistered(78)) {
      Hive.registerAdapter(Solo_Defs_Adapter());
    }

    if (Hive.isBoxOpen(box)) {
      Exersise2 = Hive.box<Solo_Defs>(box);
    } else {
      Exersise2 = await Hive.openBox<Solo_Defs>(box);
    }
    var hand_boox = await Hive.openBox('solo_def');
    String hand=hand_boox.get("hand");

    if(Exersise2.length==0){

      for(int i=0; i<Exersise.length;i++){

        Solo_Defs temp;
        if(hand=="Right"){

           temp = Solo_Defs()
            ..name=Exersise[i]["name"]
            ..id=i
            ..xmin=Exersise[i]["xmin"]
            ..ymin=Exersise[i]["ymin"]
            ..xmax=Exersise[i]["xmax"]
            ..ymax=Exersise[i]["ymax"]
            ..right_side=Exersise[i]["right_side"];

        }
        else{

           temp = Solo_Defs()
            ..name=Exersise_Lefty[i]["name"]
            ..id=i
            ..xmin=Exersise_Lefty[i]["xmin"]
            ..ymin=Exersise_Lefty[i]["ymin"]
            ..xmax=Exersise_Lefty[i]["xmax"]
            ..ymax=Exersise_Lefty[i]["ymax"]
            ..right_side=Exersise_Lefty[i]["right_side"];


        }

        Exersise2.add(temp);

      }


    }





  }

  delete(int index){
    Exersise2 = Hive.box<Solo_Defs>(box);
    Exersise2.deleteAt(index);

  }

   Box<Solo_Defs> get(){
    Exersise2 = Hive.box<Solo_Defs>(box);
    return Exersise2;

  }

}
