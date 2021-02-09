import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class target extends StatefulWidget {
  target();

  @override
  target_state createState() => new target_state();
}

class target_state extends State<target> {
  Color court_color = Color.fromRGBO(4, 12, 128, 1);

  Point location = Point(250, 250);
  double box_size =100;
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  Widget draw_court() {
    return Stack(
      children: [
        Positioned(
            top: MediaQuery.of(context).size.height *0.57,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: court_color,
            )),
        Positioned(
            top: MediaQuery.of(context).size.height *0.57,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height *0.57,
              width: 15,
              color: court_color,
            )),
        Positioned(
          top: MediaQuery.of(context).size.height *0.57,
          left: -15,
          child: Container(
            width: MediaQuery.of(context).size.width /4,
            height: MediaQuery.of(context).size.width /4,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: court_color,
                  // set border color
                  width: 15.0), // set border width
              // set rounded corner radius
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height *0.57,
          right: -15,
          child: Container(
            width: MediaQuery.of(context).size.width /4,
            height:MediaQuery.of(context).size.width /4,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: court_color,
                  // set border color
                  width: 15.0), // set border width
              // set rounded corner radius
            ),
          ),
        ),
      ],
    );
  }

  Widget Target() {
    return MatrixGestureDetector(

        onMatrixUpdate: (m, tm, sm, rm) {
          notifier.value = m;


        },

        shouldRotate: false,
        child: AnimatedBuilder(
          animation: notifier,
          builder: (ctx, child) {
            return Transform(
              transform: notifier.value,
              child: Stack(
                children: [
                  Container(



                    decoration: BoxDecoration(
                      color: court_color,
                      border: Border.all(
                          color:court_color,
                          // set border color
                          width: 30.0), // set border width
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // set rounded corner radius
                    ),
                  ),
                  RotatedBox(
                      quarterTurns: 1,
                      child: Center(child: Text("Target",style: TextStyle(fontSize: 200,color: Colors.white,fontWeight: FontWeight.bold),)))
                ],
              ),
            );
          },
        ));
  }

  Widget fixed_target(){

    return Positioned(
        left: location.x.toDouble() - (box_size / 2),
        top: location.y.toDouble() - (box_size / 2),
        child: Draggable(
          child: Container(
            width: box_size,
            height: box_size,
            decoration: BoxDecoration(

              border: Border.all(
                  color: court_color,
                  // set border color
                  width: 6.0), // set border width
              borderRadius: BorderRadius.all(Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Center(
              child: Text(
                "Target",
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              location = Point(offset.dx.toInt() + (box_size / 2), offset.dy.toInt() + (box_size / 2));



            });
          },
          feedback: Container(
            width: box_size,
            height: box_size,
            decoration: BoxDecoration(

              border: Border.all(
                  color: court_color,
                  // set border color
                  width: 6.0), // set border width
              borderRadius: BorderRadius.all(Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Center(
              child: Text(
                "Target",
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ));




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.black,fontSize: 20),
                    ),
                  ),
                  color: Colors.white,


                  onPressed: () {

                    //double x1=(300*location.x)/MediaQuery.of(context).size.width;
                    //double y1=(300*location.y)/MediaQuery.of(context).size.height;

                    Navigator.of(context).pop(location);


                  }
              )
            ],
          ),
        ),
        draw_court(),
        fixed_target(),
      ]),
    );
  }
}
