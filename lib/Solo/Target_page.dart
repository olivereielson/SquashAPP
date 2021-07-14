import 'dart:math';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:squash/Solo/New%20Target.dart';
import 'package:squash/Solo/solo_defs.dart';

class target extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  List<int> sides;

  target({@required this.analytics, @required this.observer, @required this.sides});

  @override
  target_state createState() => new target_state(sides);
}

class target_state extends State<target> {
  target_state(this.sides);

  List<int> sides;

  Color court_color = Color.fromRGBO(4, 12, 128, 1);

  Point location = Point(250, 250);
  double box_size = 100;
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  Widget draw_court() {
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
                          color: court_color,
                          // set border color
                          width: 30.0), // set border width
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // set rounded corner radius
                    ),
                  ),
                  RotatedBox(
                      quarterTurns: 1,
                      child: Center(
                          child: Text(
                        "Target",
                        style: TextStyle(fontSize: 200, color: Colors.white, fontWeight: FontWeight.bold),
                      )))
                ],
              ),
            );
          },
        ));
  }

  Widget fixed_target() {
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

  Widget shot(Map data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Center(
        child: Container(
          height: 175,
          width: 110,
          decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              border: Border.all(color: !sides.contains(data["id"]) ? Colors.white.withOpacity(0.7) : Colors.white, width: 4),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data["name"],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorLight),
                ),
              ),
              Spacer(),
              Container(
                height: 80,
                width: 130,
                child: Stack(
                  children: [
                    Positioned(left: 50.0, top: 20, child: Container(width: 5, height: 95, color: !sides.contains(data["id"]) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(left: 25.0, top: 20, child: Container(width: 5, height: 25, color: !sides.contains(data["id"]) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(left: 0.0, top: 40, child: Container(width: 25, height: 5, color: !sides.contains(data["id"]) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(right: 25.0, top: 20, child: Container(width: 5, height: 25, color: !sides.contains(data["id"]) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(right: 0.0, top: 40, child: Container(width: 25, height: 5, color: !sides.contains(data["id"]) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(left: 0, top: 15, child: Container(width: 130, height: 5, color: !sides.contains(data["id"]) ? Colors.white.withOpacity(0.7) : Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).splashColor,
        appBar: AppBar(
          title: Text(
            "Currently Selected",
            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, sides);
            },
          ),
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: ImplicitlyAnimatedReorderableList<int>(
                // The current items in the list.
                scrollDirection: Axis.horizontal,
                items: sides,
                insertDuration: Duration(milliseconds: 200),
                removeDuration: Duration(milliseconds: 200),
                areItemsTheSame: (a, b) => a == b,

                itemBuilder: (context, itemAnimation, item, index) {
                  return Reorderable(
                    key: ValueKey(  SoloDefs().get().getAt(index)),
                    builder: (context, dragAnimation, inDrag) {
                      final t = dragAnimation.value;
                      final elevation = lerpDouble(0, 8, t);
                      final color = Color.lerp(Colors.white, Colors.white.withOpacity(0.8), t);

                      return AnimatedBuilder(
                        animation: dragAnimation,
                        builder: (BuildContext context, Widget child) {
                          return Handle(
                            delay: const Duration(milliseconds: 500),
                            key: ValueKey(SoloDefs().get().getAt(index)),
                            child: SizeFadeTransition(
                              sizeFraction: 0.7,
                              curve: Curves.easeInOut,
                              animation: itemAnimation,
                              child: Material(color: color, elevation: elevation, type: MaterialType.transparency, child: shot(SoloDefs().Exersise[item])),
                            ),
                          );
                        },
                      );
                    },
                  );
                },

                onReorderFinished: (item, from, to, newItems) {
                  // Remember to update the underlying data when the list has been
                  // reordered.
                  setState(() {
                    sides
                      ..clear()
                      ..addAll(newItems);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Solo Exercises", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 25.0,
                    mainAxisSpacing: 25.0,
                  ),
                  itemCount: SoloDefs().get().length+1,
                  itemBuilder: (BuildContext context, int index) {

                    if(index==SoloDefs().get().length){

                      return GestureDetector(
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => create_target(analytics: widget.analytics, observer: widget.observer)),
                          );

                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white.withOpacity(0.5), width: 4),
                              borderRadius:
                              BorderRadius
                                  .all(Radius.circular(20.0))),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Create New",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                          ),
                        ),
                      );

                    }

                    var data = SoloDefs().get().get(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (sides.contains(index)) {
                            sides.remove(index);
                          } else {
                            sides.add(index);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: !sides.contains(SoloDefs().get().getAt(index).id) ? Colors.white.withOpacity(0.5) : Colors.white, width: !sides.contains(SoloDefs().get().getAt(index).id)?4:7),
                            borderRadius:
                        BorderRadius
                            .all(Radius.circular(20.0))),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorLight),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}

/*
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: ReorderableListView.builder(

                scrollDirection: Axis.horizontal,



                proxyDecorator: (s,i,a){

                  return s;

                },



                clipBehavior: Clip.antiAliasWithSaveLayer,

                onReorder: (int oldIndex, int newIndex) {

                  setState(() {
                    if(newIndex>oldIndex){
                      newIndex-=1;
                    }
                    int items =sides.removeAt(oldIndex);
                    sides.insert(newIndex, items);
                  });


                },
                itemCount: sides.length,
                itemBuilder: (BuildContext context, int index) {

                  return shot(SoloDefs().Exersise[sides[index]]);


              },
              ),
            ),

 */
