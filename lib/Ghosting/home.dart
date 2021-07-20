import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:squash/Ghosting/finish%20screen.dart';
import 'package:squash/extra/data_collection.dart';
import 'package:squash/extra/hive_classes.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'camera.dart';
import 'bndbox.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  double number_set = 0;
  double round_num = 0;
  Duration rest_time;
  Duration round_time;
  List<double> corners;
  int start_time;
  int type;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  HomePage(this.cameras, this.number_set, this.round_num, this.rest_time, this.corners, this.start_time, this.round_time, this.type, {this.analytics, this.observer});

  @override
  _HomePageState createState() => new _HomePageState(number_set, round_num, rest_time, corners, start_time);
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<dynamic> _recognitions;

  _HomePageState(this.number_set, this.round_num, this.rest_time, this.corners, this.start_countdown);

  Color main = Color.fromRGBO(40, 45, 81, 1);

  List<double> corners;
  int start_countdown;

  bool is_exersising = false;
  bool showcam = true;
  int t_size = 80;
  double number_set;
  double round_num;

  int part = 16;

  Duration rest_time;
  bool resting = false;

  bool onT = false;
  AnimationController controller;

  int corner = 10;

  int ghostcast = 0;
  String ghosttime = "";

  Point p1 = new Point(200, 500);

  DateTime start_time, end_time, application_start;
  List<double> time_array = [];
  List<double> time_array2 = [];

  List<double> corner_array = [];
  double precent_effort = 0;
  double xpoint;
  double maxsize = 200;
  List<TargetFocus> targets = [];
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();

  Timer _timer;
  int _start;

  bool countdown = false;

  int center_state = 0;

  void showTutorial() {
    TutorialCoachMark(
      context,
      targets: targets,
      // List<TargetFocus>
      colorShadow: Theme.of(context).primaryColor,
      // DEFAULT Colors.black
      // alignSkip: Alignment.bottomRight,
      // textSkip: "SKIP",
      // paddingFocus: 10,
      // opacityShadow: 0.8,
      onClickTarget: (target) {
        print(target);
      },
      onClickOverlay: (target) {
        print(target);
      },
      hideSkip: true,

      onSkip: () {
        print("Finish");
      },
      onFinish: () {
        print("finish");
      },
    )..show();
  }

  @override
  void initState() {
    make_targets();
    _testSetCurrentScreen();
    Data_Sender().testSetCurrentScreen(widget.analytics, "Ghosting Page", "Ghosting_Page");

    super.initState();

    application_start = DateTime.now();
    _start = widget.start_time;

    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void make_targets() {
    targets.add(TargetFocus(identify: "Target 1", keyTarget: keyButton, contents: [
      TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Ghosting Setup",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Lean your phone against the center of the Tin and drag this box over the T",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ))
    ]));
  }

  Future<void> kill() async {
    String test = DateTime.now().difference(application_start).toString();
    await save_data();

    widget.analytics.logEvent(
      name: 'Ghost_Finished',
    );

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Finish_Screen(ghostcast, test.substring(0, test.length - 7), time_array2, widget.analytics, widget.observer)),
    );

    Navigator.pop(context);
  }

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Solo_Workout_Page',
      screenClassOverride: 'Solo_Workout_Page',
    );
  }

  Widget CountDown() {
    return GestureDetector(
      onTap: () {
        countdown=true;
        const oneSec = const Duration(seconds: 1);
        _timer = new Timer.periodic(oneSec, (Timer timer) {
          if (_start < 1) {
            timer.cancel();
            center_state = 1;
          } else {
            setState(() {
              _start = _start - 1;
            });
          }
        });
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor,
          border: Border.all(
              color: Theme.of(context).splashColor,
              // set border color
              width: 6.0), // set border width
          borderRadius: BorderRadius.all(Radius.circular(25.0)), // set rounded corner radius
        ),
        child: countdown
            ? Center(
                child: Text(
                _start.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.white),
              ))
            : Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 60,
              ),
      ),
    );
  }

  Widget corner_box(int number) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 2.0).animate(controller),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: corner == number ? Theme.of(context).primaryColor : Colors.transparent,
          border: Border.all(
              color: corner == number ? Theme.of(context).primaryColor : Colors.transparent,
              // set border color
              width: 6.0), // set border width
          borderRadius: BorderRadius.all(Radius.circular(25.0)), // set rounded corner radius
        ),
        width: corner == number ? 100 : 40,
        height: corner == number ? 100 : 40,
      ),
    );
  }

  Widget Corner_tree() {
    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                corner_box(0),
                corner_box(1),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                corner_box(2),
                corner_box(3),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                corner_box(4),
                corner_box(5),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                corner_box(6),
                corner_box(7),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                corner_box(8),
                corner_box(9),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget t_box() {
    return Positioned(
        left: p1.x.toDouble(),
        top: p1.y.toDouble(),
        child: Draggable(
          child: Container(
            key: keyButton,
            width: t_size.toDouble(),
            height: t_size.toDouble(),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Theme.of(context).splashColor,
                  // set border color
                  width: 6.0), // set border width
              borderRadius: BorderRadius.all(Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Center(
              child: Text(
                "T",
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              p1 = Point(offset.dx.toInt(), offset.dy.toInt());
            });
          },
          feedback: Container(
            width: t_size.toDouble(),
            height: t_size.toDouble(),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Theme.of(context).splashColor,
                  // set border color
                  width: 6.0), // set border width
              borderRadius: BorderRadius.all(Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Center(
              child: Text(
                "T",
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ));
  }

  Widget rest_timer() {
    return Container(
      key: Key("time"),
      width: 300,
      height: 300,
      child: Center(
        child: CircularCountDownTimer(
          height: 250,
          width: 250,
          isTimerTextShown: center_state==2,
          duration: rest_time.inSeconds,
          fillColor: Theme.of(context).splashColor,
          strokeWidth: center_state==2?30:100,
          initialDuration: 0,
          textFormat:           CountdownTextFormat.S,
          isReverse: true,
         textStyle: TextStyle(color: resting ? Theme.of(context).highlightColor : Colors.transparent, fontWeight: FontWeight.bold, fontSize: 70),
           //textStyle: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 70),

          onComplete: () {
            setState(() {
              resting = !resting;

              center_state = 1;

              corner = corners[new Random().nextInt(corners.length)].toInt();
            });
          },
          ringColor: center_state==2?Colors.white:Colors.pinkAccent,
        ),
      ),
    );
  }

  Widget work_timer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
          width: 200,
          height: 200,
          child: Center(
            child: CircularCountDownTimer(
              height: 200,
              width: 200,
              isTimerTextShown: center_state==1,
              duration: widget.round_time.inSeconds,
              fillColor: Theme.of(context).splashColor,
              strokeWidth: 20,
              isReverse: true,
              textFormat:           CountdownTextFormat.S,

              textStyle: TextStyle(color: Theme.of(context).highlightColor, fontWeight: FontWeight.bold, fontSize: 70),
              onComplete: () {
                setState(() {
                  resting = true;
                  time_array.clear();
                  round_num--;
                  corner = 10;
                  center_state = 2;
                });
                if (round_num <= 0) {
                  kill();

                  Navigator.pop(context);
                }
              },
              ringColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget precent_complete_indicator(double precent) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        child: CircularPercentIndicator(
          progressColor: Theme.of(context).primaryColor,
          lineWidth: 20,
          backgroundColor: Colors.white,
          percent: precent,
          radius: 180,
          animation: true,
          animateFromLastPercent: true,
          animationDuration: 1,
          backgroundWidth: 20,
          center: Text(
            (time_array.length).toInt().toString(),
            style: TextStyle(fontSize: 49, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> save_data() async {
    String box = "Ghosting1";

    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(GhostingAdapter());
    }

    Box<Ghosting> ghost;

    if (Hive.isBoxOpen(box)) {
      ghost = Hive.box<Ghosting>(box);
    } else {
      ghost = await Hive.openBox<Ghosting>(box);
    }

    print(time_array2);

    Ghosting s = Ghosting()
      ..start = application_start
      ..end = DateTime.now()
      ..rest_time = rest_time.inSeconds
      ..rounds = round_num.toInt()
      ..time_array = time_array2
      ..corner_array = corner_array;

    print(s.time_array);

    ghost.add(s);
  }

  Widget draw_court() {
    return Stack(
      children: [
        Positioned(
            top: MediaQuery.of(context).size.height / 2,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
            )),
        Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: 15,
              color: Theme.of(context).primaryColor,
            )),
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          left: -15,
          child: Container(
            width: 125.0,
            height: 125.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Theme.of(context).primaryColor,
                  // set border color
                  width: 15.0), // set border width
              // set rounded corner radius
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          right: -15,
          child: Container(
            width: 125.0,
            height: 125.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Theme.of(context).primaryColor,
                  // set border color
                  width: 15.0), // set border width
              // set rounded corner radius
            ),
          ),
        ),
      ],
    );
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      //print(recognitions);

      try {
        var x = (recognitions[0]["rect"]["x"] * MediaQuery.of(context).size.width);
        var w = recognitions[0]["rect"]["w"] * MediaQuery.of(context).size.width;
        var y = recognitions[0]["rect"]["y"] * MediaQuery.of(context).size.height;
        var h = recognitions[0]["rect"]["h"] * MediaQuery.of(context).size.height;

        double xpos = x + (w ~/ 2);
        double ypos = y + h;

        if (is_exersising) {
          if (p1.x < xpos && xpos < p1.x + t_size && p1.y < ypos && ypos < p1.y + t_size) {
            if (onT == false && DateTime.now().difference(start_time).inMilliseconds > 2500 && !resting) {
              int rng = corners[new Random().nextInt(corners.length)].toInt();

              if (corner == rng) {
                controller.reset();
                controller.forward();
              }

              corner = rng;
              ghostcast++;
              corner_array.add(rng.toDouble());

              if (start_time == null) {
                start_time = DateTime.now();
              } else {
                double dif = (DateTime.now().difference(start_time).inMilliseconds / 1000).toDouble();

                ghosttime = dif.toStringAsFixed(1);

                start_time = DateTime.now();

                time_array.add(dif.toDouble());
                time_array2.add(dif.toDouble());
                //time_array.sort();

                //
                //time_array
                print(time_array);

                if (time_array.length == number_set && widget.type == 1) {
                  resting = true;
                  time_array.clear();
                  round_num--;
                  corner = 10;
                  center_state = 2;
                }

                //(round_num);

                if (round_num <= 0) {
                  kill();

                  Navigator.pop(context);
                }
              }
            }

            onT = true;
          } else {
            onT = false;
          }
        }
      } catch (e) {}
    });
  }

  Widget center_tile() {
    if (center_state == 0) {
      return CountDown();
    }

    if (center_state == 1 && widget.type == 0) {
      return work_timer();
    }

    if (center_state == 1 && widget.type == 0) {
      return precent_complete_indicator(time_array.length / number_set);
    }
    if (center_state == 2) {
      return rest_timer();
    }
  }

  @override
  Widget build(BuildContext context) {
    // p1 = Point((MediaQuery.of(context).size.width - t_size) / 2, (MediaQuery.of(context).size.height - t_size) / 2);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Stack(
        children: [
          Camera(widget.cameras, setRecognitions, center_state==0, false, 1),
          center_state == 0 ? BndBox(_recognitions == null ? [] : _recognitions) : Text(""),
          center_state == 0 ? t_box() : draw_court(),
          Positioned(
              top: 0,
              right: 20,
              child: SafeArea(
                child: center_state == 0
                    ? IconButton(
                        icon: Icon(
                          Icons.help,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          widget.analytics.logEvent(name: "Ghost_Tutorial_Shown");
                          showTutorial();
                        },
                      )
                    : Text(""),
              )),
          Corner_tree(),
          Positioned(
              top: -20,
              left: (MediaQuery.of(context).size.width - 170) / 2,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    widget.analytics.logEvent(name: "Ghosted_Ended_Early");
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: 170,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).splashColor,
                          border: Border.all(
                            color: Theme.of(context).splashColor,
                          ),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                      child: Center(
                          child: Text(
                        "Close",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ))),
                ),
              )),
          Positioned(
            top: 100,
            child: SafeArea(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.pink,

                    child: AnimatedSwitcher(
                      key: keyButton4,
                      duration: Duration(milliseconds: 400),
                      child: center_tile(),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                    ))),
          ),
        ],
      )),
    );
  }

  @override
  dispose() {

    controller.dispose();
    super.dispose();
  }
}

/*
AnimatedSwitcher(
                      key: keyButton4,
                      duration: Duration(milliseconds: 400),
                      child: center,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
 */
