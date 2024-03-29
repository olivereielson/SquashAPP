import 'dart:math';
import 'dart:ui';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:squash/Solo/New%20Target.dart';
import 'package:squash/Solo/solo%20screen.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/extra/hive_classes.dart';

class target extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  List<Solo_Defs> sides;

  target({@required this.analytics, @required this.observer, @required this.sides});

  @override
  target_state createState() => new target_state(sides);
}

class target_state extends State<target> {
  target_state(this.sides2);

  List<Solo_Defs> sides2;
  List<Solo_Defs> sides=[];

  Color court_color = Color.fromRGBO(4, 12, 128, 1);

  Point location = Point(250, 250);
  double box_size = 100;
  bool is_shaking=false;
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  @override
  void initState() {


    sides=sides2.toList();

    _testSetCurrentScreen();
    super.initState();
  }

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Choose_Solo_Court_Page',
      screenClassOverride: 'Choose_Solo_Court_Page',
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

  Widget shot(Solo_Defs data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Center(
        child: Container(
          height: 175,
          width: 110,
          decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              border: Border.all(color: !sides.contains(data.id) ? Colors.white.withOpacity(0.7) : Colors.white, width: 4),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data.name,
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
                    Positioned(left: 50.0, top: 20, child: Container(width: 5, height: 95, color: !sides.contains(data.id) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(left: 25.0, top: 20, child: Container(width: 5, height: 25, color: !sides.contains(data.id) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(left: 0.0, top: 40, child: Container(width: 25, height: 5, color: !sides.contains(data.id) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(right: 25.0, top: 20, child: Container(width: 5, height: 25, color: !sides.contains(data.id) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(right: 0.0, top: 40, child: Container(width: 25, height: 5, color: !sides.contains(data.id) ? Colors.white.withOpacity(0.7) : Colors.white)),
                    Positioned(left: 0, top: 15, child: Container(width: 130, height: 5, color: !sides.contains(data.id) ? Colors.white.withOpacity(0.7) : Colors.white)),
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



    return GestureDetector(
      onTap: (){

        if(is_shaking){
          setState(() {
            is_shaking=false;
          });

        }

      },
      child: Scaffold(
          backgroundColor: Theme.of(context).splashColor,
          appBar: AppBar(
            title: Text(
              "Currently Selected",
              style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context,sides);
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
                child: ImplicitlyAnimatedReorderableList<Solo_Defs>(
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
                                child: Material(color: color, elevation: elevation, type: MaterialType.transparency, child: shot(item)),
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
                    widget.analytics.logEvent(name: "Solo_Custom_Court_Reordered");

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
                              MaterialPageRoute(builder: (context) => create_target(analytics: widget.analytics, observer: widget.observer,screenH: MediaQuery.of(context).size.height,),fullscreenDialog:
                              true),
                            );

                          },
                          child: ShakeAnimatedWidget(
                            enabled: false,
                            duration: Duration(milliseconds: 500),
                            shakeAngle: Rotation.deg(z: 1),
                            curve: Curves.linear,

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
                          ),
                        );

                      }

                      return  ShakeAnimatedWidget(
                        enabled: is_shaking,

                        duration: Duration(milliseconds: 500),
                        shakeAngle: Rotation.deg(z: 2),
                        curve: Curves.linear,
                        child: GestureDetector(
                          onTap: () {
                            if(!is_shaking){
                              setState(() {
                                if (sides.contains(SoloDefs().get().getAt(index))) {
                                  sides.remove(SoloDefs().get().getAt(index));
                                } else {
                                  sides.add(SoloDefs().get().getAt(index));
                                }
                              });
                              widget.analytics.logEvent(name: "Solo_Custom_Court_Toggled");

                            }

                          },
                          onLongPress: (){

                            setState(() {
                              is_shaking=true;
                            });


                          },

                          child: Container(
                            child: Stack(
                              children: [

                                Center(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: !sides.contains(SoloDefs().get().getAt(index)) ? Colors.white.withOpacity(0.5) : Colors.white, width: !sides.contains(SoloDefs().get().getAt(index))?4:7),
                                        borderRadius:
                                    BorderRadius
                                        .all(Radius.circular(20.0))),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AutoSizeText(
                                          SoloDefs().get().getAt(index).name.toString(),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Theme.of(context).primaryColorLight),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                    left: 0,

                                    child: AnimatedOpacity(
                                      opacity: is_shaking?1:0,
                                      duration: Duration(milliseconds: 300),
                                      child: Container(
                                        decoration: BoxDecoration(

                                          shape: BoxShape.circle,
                                          color: Colors.grey


                                        ),

                                          child: GestureDetector(
                                              onTap: () async {

                                                if(is_shaking){
                                                  widget.analytics.logEvent(name: "Solo_Custom_Court_Removed");
                                                  setState(() {
                                                    if(sides.contains(SoloDefs().get().getAt(index))){
                                                      sides.remove(SoloDefs().get().getAt(index));
                                                    }
                                                    SoloDefs().delete(index);

                                                  });
                                                }


                                              },

                                              child: Icon(Icons.close))),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }
}

