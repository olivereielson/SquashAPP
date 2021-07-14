import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:page_transition/page_transition.dart';
import 'package:squash/extra/hive_classes.dart';

class create_target extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  create_target({@required this.analytics, @required this.observer});

  @override
  _create_targetState createState() => _create_targetState();
}

class _create_targetState extends State<create_target> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  double box_size = 50;
  Point location = Point(250, 250);
  double locationB = 400;

  int _side = 0;
  Color line_color = Colors.grey;

  String box = "Solo_Defs1";


  @override
  void initState() {

    _testSetCurrentScreen();
    super.initState();
  }

  Widget draw_court() {
    Color court_color = Colors.white;
    return Stack(
      children: [
        Positioned(
            top: MediaQuery.of(context).size.height * 0.57,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: court_color,
            )),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.57,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.57,
              width: 15,
              color: court_color,
            )),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.57,
          left: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 4,
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
          top: MediaQuery.of(context).size.height * 0.57,
          right: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 4,
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

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Create_Solo_Court_Page',
      screenClassOverride: 'Create_Solo_Court_Page',
    );
  }


  Widget fixed_target() {
    return Positioned(
        left: location.x.toDouble() - (box_size / 2),
        top: location.y.toDouble() - (box_size / 2),
        child: Draggable(
          child: Container(
            width: box_size,
            height: box_size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          ),
          rootOverlay: true,
          dragAnchorStrategy: (t, off, context) {
            return Offset(off.size.width / 2, off.size.height / 2);
          },
          onDragUpdate: (detatils) {
            setState(() {
              location = Point(detatils.localPosition.dx.toInt(), detatils.localPosition.dy.toInt());
            });
          },
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              //location = Point(offset.dx.toInt() - (box_size / 2), offset.dy.toInt() - (box_size / 2));
              //location = Point(offset.dx.toInt(), offset.dy.toInt());
            });
          },
          childWhenDragging: Icon(
            Icons.circle,
            color: Colors.transparent,
          ),
          feedback: Container(
            width: box_size,
            height: box_size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          ),
        ));
  }

  Widget fixed_targetB() {
    return Positioned(
        left: location.x.toDouble() - (box_size / 2),
        top: locationB - (box_size / 2),
        child: Draggable(
          child: Container(
            width: box_size,
            height: box_size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(1)),
          ),
          childWhenDragging: Icon(
            Icons.circle,
            color: Colors.transparent,
          ),
          dragAnchorStrategy: (t, off, context) {
            return Offset(off.size.width / 2, off.size.height / 2);
          },
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              // location = Point(offset.dx.toInt() + (box_size / 2), offset.dy.toInt() + (box_size / 2));
              //location = Point(offset.dx.toInt(), location.y);
              //locationB=offset.dy;
            });
          },
          onDragUpdate: (detatils) {
            setState(() {
              location = Point(detatils.globalPosition.dx.toInt(), location.y);
              locationB = detatils.globalPosition.dy;
              //location = Point(detatils.globalPosition.dx.toInt(), detatils.globalPosition.dy.toInt());
            });
          },
          feedback: Container(
            width: box_size,
            height: box_size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(1)),
          ),
        ));
  }

  Widget lines() {
    return Positioned(
      top: location.y.toDouble(),
      left: location.x.toDouble(),
      child: Container(
        height: locationB - location.y.toDouble(),
        color: line_color,
        width: 5,
      ),
    );
  }

  Widget lines2() {
    return Positioned(
      top: location.y.toDouble(),
      left: _side == 1 ? location.x.toDouble() : 0,
      child: Container(
        height: 5,
        color: line_color,
        width: _side == 1 ? MediaQuery.of(context).size.width - location.x.toDouble() : MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width - location.x.toDouble()),
      ),
    );
  }

  Widget lines3() {
    return Positioned(
      top: locationB,
      left: _side == 1 ? location.x.toDouble() : 0,
      child: Container(
        height: 5,
        color: line_color,
        width: _side == 1 ? MediaQuery.of(context).size.width - location.x.toDouble() : MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width - location.x.toDouble()),
      ),
    );
  }

  Future<String> text_dialog() async {
    String n = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.topToBottom,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "Enter Custom Workout Name",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Eg 6 corners",
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.white60),
                      labelStyle: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold)),
                  onSubmitted: (name) {
                    if (name.substring(name.length - 1) == "") {
                      name = name.substring(0, name.length - 1);
                    }

                    Navigator.pop(context, name);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );

    if (n.replaceAll(" ", "") == "") {
      return "NO NAME";
    }
    return n.toString().toUpperCase();
  }

  int Xcorrection(int val) {
    return (1080 * val) ~/ MediaQuery.of(context).size.width;
  }

  int Ycorrection(int val) {
    return (1645 * val) ~/ MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Positioned(
              child: SafeArea(
            right: false,
            left: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                    Text(
                      "Create Target",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    IconButton(
                        onPressed: () async {
                          String name = await text_dialog();
                          Box<Solo_Defs> Exersise2;

                          if (Hive.isBoxOpen(box)) {
                            Exersise2 = Hive.box<Solo_Defs>(box);
                          } else {
                            Exersise2 = await Hive.openBox<Solo_Defs>(box);
                          }

                          var temp = Solo_Defs()
                            ..name = name
                            ..id = Exersise2.length
                            ..xmin = _side == 0 ? 10 : Xcorrection(location.x)
                            ..ymin = Ycorrection(location.y)
                            ..xmax = _side == 0 ? Xcorrection(location.x) : 1080
                            ..ymax = Ycorrection(locationB.toInt())
                            ..right_side = _side == 0 ? false : true;

                          Exersise2.add(temp);

                          //print(Exersise2.length);
                          //print(Exersise2.getAt(index));

                          widget.analytics.logEvent(
                            name: "Custom_Solo_Court_Saved",
                            parameters: <String, dynamic>{
                              'type': _side == 0 ? 'Left' : 'Right',
                              'name': name,
                              'xmin': _side == 0 ? 10 : Xcorrection(location.x),
                              'ymin': Ycorrection(location.y),
                              'xmax': _side == 0 ? Xcorrection(location.x) : 1080,
                              'ymax': Ycorrection(locationB.toInt())
                            },
                          );

                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          )),
          Positioned(
              top: 80,
              left: (MediaQuery.of(context).size.width - 300) / 2,
              child: SafeArea(
                child: Container(
                  width: 300,
                  child: CupertinoSlidingSegmentedControl(
                    children: <int, Widget>{
                      0: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Left",
                          style: TextStyle(color: _side == 1 ? Colors.white : Theme.of(context).splashColor, fontSize: 15),
                        ),
                      ),
                      1: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Right",
                          style: TextStyle(color: _side == 0 ? Colors.white : Theme.of(context).splashColor, fontSize: 15),
                        ),
                      )
                    },
                    onValueChanged: (val) {
                      setState(() {
                        _side = val;
                      });
                    },
                    groupValue: _side,
                    thumbColor: Colors.white,
                  ),
                ),
              )),
          draw_court(),
          lines(),
          lines2(),
          lines3(),
          fixed_target(),
          fixed_targetB(),
        ],
      ),
    );
  }
}
