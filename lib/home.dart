import 'dart:io';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:squash/finish%20screen.dart';
import 'camera.dart';
import 'bndbox.dart';
import 'countdown.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  double number_set = 0;
  double round_num = 0;
  Duration rest_time;
  List<double> corners;
  int start_time;
  HomePage(this.cameras, this.number_set, this.round_num, this.rest_time, this.corners, this.start_time);

  @override
  _HomePageState createState() => new _HomePageState(number_set, round_num, rest_time, corners, start_time);
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<dynamic> _recognitions;

  _HomePageState(this.number_set, this.round_num, this.rest_time, this.corners, this.start_countdown);
  Color main=Color.fromRGBO(4, 12, 128, 1);

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

  DateTime application_start;

  bool onT = false;
  AnimationController controller;

  int corner = 10;

  int ghostcast = 0;
  String ghosttime = "";

  Point p1 = new Point(200, 500);

  DateTime start_time, end_time;
  List<double> time_array = [];
  double precent_effort = 0;
  double xpoint;
  double maxsize = 200;

  Widget center;

  @override
  void initState() {
    super.initState();

    center = count_down_timer();

    application_start = DateTime.now();
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> kill() async {
    String test = DateTime.now().difference(application_start).toString();

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Finish_Screen(ghostcast, test.substring(0, test.length - 7), time_array)),
    );

    Navigator.pop(context);
  }

  Widget corner_box(int number) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 2.0).animate(controller),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: corner == number ? main : Colors.transparent,
          border: Border.all(
              color: corner == number ? main : Colors.transparent,
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
            width: t_size.toDouble(),
            height: t_size.toDouble(),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: main,
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
                  color: main,
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

  Widget count_down_timer() {
    return Container(
      width: 200,
      child: Center(
        child: CountDown(
          start_countdown,
          done: (t) {
            setState(() {
              is_exersising = true;
              center = precent_complete_indicator(time_array.length / number_set);
              corner = corners[new Random().nextInt(corners.length)].toInt();
              start_time = DateTime.now();
              showcam = false;
            });
          },
        ),
      ),
    );
  }

  Widget rest_timer() {
    return Container(
      key: Key("time"),
      width: 350,
      height: 350,
      child: Center(
        child: CircularCountDownTimer(
          height: 320,
          width: 320,
          duration: rest_time.inSeconds,
          color: Colors.white,
          fillColor: main,
          strokeWidth: 10,
          isReverse: true,
          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 70),
          onComplete: () {
            setState(() {
              resting = !resting;
              center = precent_complete_indicator(time_array.length / number_set);
              corner = corners[new Random().nextInt(corners.length)].toInt();
            });
          },
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
          progressColor: main,
          arcBackgroundColor: Colors.white,
          arcType: ArcType.FULL,
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

  Widget draw_court() {
    return Stack(
      children: [
        Positioned(
            top: MediaQuery.of(context).size.height / 2,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: main,
            )),
        Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: 15,
              color: main,
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
                  color: main,
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
                  color: main,
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
      print(recognitions);

      try {
        double xpos;
        if (Platform.isIOS) {
          xpos = _recognitions.asMap()[0]["keypoints"][part]["x"] * MediaQuery.of(context).size.width;
        } else {
          xpos = MediaQuery.of(context).size.width - (_recognitions.asMap()[0]["keypoints"][part]["x"] * MediaQuery.of(context).size.width);
        }

        double ypos = _recognitions.asMap()[0]["keypoints"][part]["y"] * MediaQuery.of(context).size.height;

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
              if (start_time == null) {
                start_time = DateTime.now();
              } else {
                double dif = (DateTime.now().difference(start_time).inMilliseconds / 1000).toDouble();

                ghosttime = dif.toStringAsFixed(1);

                start_time = DateTime.now();

                time_array.add(dif.toDouble());
                //time_array.sort();

                center = precent_complete_indicator(time_array.length / number_set);

                print(time_array);

                if (time_array.length == number_set) {
                  resting = true;
                  time_array.clear();
                  round_num--;
                  corner = 10;
                  center = rest_timer();
                }

                print(round_num);

                if (round_num <= 0) {
                  kill();

                  // Navigator.pop(context);

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

  @override
  Widget build(BuildContext context) {
    // p1 = Point((MediaQuery.of(context).size.width - t_size) / 2, (MediaQuery.of(context).size.height - t_size) / 2);

    return Scaffold(
        body: Stack(
      children: [
        Camera(widget.cameras, setRecognitions, showcam, false, 1),
        showcam ? t_box() : draw_court(),
        Corner_tree(),
        !showcam
            ? Positioned(
                top: -20,
                left: (MediaQuery.of(context).size.width - 170) / 2,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        width: 170,
                        height: 50,
                        decoration: BoxDecoration(
                            color: main,
                            border: Border.all(
                              color: main,
                            ),
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                        child: Center(
                            child: Text(
                          "Close",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                        ))),
                  ),
                ))
            : Text(""),
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              showcam = !showcam;
            });
          },
          onLongPress: () {
            Navigator.pop(context);
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 400),
                        child: center,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        showcam ? BndBox(_recognitions == null ? [] : _recognitions) : Text(""),
      ],
    ));
  }
}
