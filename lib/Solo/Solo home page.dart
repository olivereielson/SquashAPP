import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';
import 'package:animated_icon_button/animated_icon_button.dart';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scidart/numdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash/Solo/bndboxsolo.dart';
import 'package:squash/extra/headers.dart';
import 'package:squash/maginfine/magnifier.dart';
import 'package:tflite/tflite.dart';
import 'package:wakelock/wakelock.dart';

import '../Ghosting/Selection Screen.dart';
import '../Ghosting/bndbox.dart';
import '../Ghosting/camera.dart';
import '../maginfine/touchBubble.dart';
import 'counter_widget.dart';
import 'court_functions.dart';
import 'court_painter.dart';
import '../extra/hive_classes.dart';
import 'finish_solo.dart';
import 'package:flutter/foundation.dart';

class SoloHome extends StatefulWidget {
  final List<CameraDescription> cameras;
  final int start_camera;
  final int shot_count;
  final int type;
  final List<int> sides;
  final Duration time;

  SoloHome({this.cameras, this.start_camera, this.shot_count, this.time, this.type, this.sides});

  @override
  SoloHomeState createState() => new SoloHomeState(cameras, start_camera);
}

class SoloHomeState extends State<SoloHome> {
  SoloHomeState(this.cameras, this.camera);

  List<dynamic> _recognitions;

  List<Point> bounces = [];
  List<Bounce> total_bounces = [];

  Point location = Point(200, 200);

  bool show_stuff = true;
  bool front_Camera = true;

  bool is_working = false;

  String ball_conf = "";

  DateTime detection;

  CameraController controller;
  bool isDetecting = false;
  Color main = Color.fromRGBO(4, 12, 128, 1);

  List<Point> points = [Point(324.0, 489.0), Point(157.0, 498.0), Point(349.0, 535.0), Point(133.0, 543.0)];

  static const double touchBubbleSize = 50;

  Offset position = Offset(200, 500);
  double currentBubbleSize = 10.0;
  bool magnifierVisible = false;

  bool back_hand = false;

  bool pause = false;

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

  List<dynamic> scr_points_corners = [
    [1080.0, 12.0],
    [10.0, 15.0],
    [1080.0, 1645.0],
    [10.0, 1645.00],

    [540.0, 930.0],
    [540.5, 1645.0],

  ];

  List<Point> dst_point = [];

  double box_size = 90;
  DateTime start_time;

  double box_size2 = 90;

  List<Widget> ball = [];

  bool on_ground = false;

  int current_side = 0;

  var H;

  int page = 0;

  bool below = false;
  List<Point> last_bounce = [];
  List<dynamic> get_data = [];

  var solo_storage_box;

  int up_count = 0;

  PageController pc = PageController(
    initialPage: 0,
  );

  //Camera varavibles

  double threshold = 0.4;
  int numResultsPerClass = 1;
  ResolutionPreset res = ResolutionPreset.high;
  int camera;

  int dets = 0;

  final List<CameraDescription> cameras;

  //bouce

  List<Point> last_seen = [];
  bool up_down = false;
  int blew_count = 0;

  @override
  void initState() {
    currentBubbleSize = touchBubbleSize;
    current_side = widget.sides[0];
    if (current_side < 2) {
      back_hand = false;
    } else {
      back_hand = true;
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      //DeviceOrientation.landscapeLeft,
    ]);
    Wakelock.toggle(enable: true);

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    setupcamera();
    start_time = DateTime.now();
    generate_cout_point();
    saved_points();
    super.initState();
  }

  Future<void> saved_points() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("herer");
    print(back_hand);


    if (!back_hand) {
      if (!prefs.containsKey("p2.y")) {
        prefs.setDouble("p0.x", 324.0);
        prefs.setDouble("p0.y", 489.0);

        prefs.setDouble("p1.x", 157.0);
        prefs.setDouble("p1.y", 498.0);

        prefs.setDouble("p2.x", 349.0);
        prefs.setDouble("p2.y", 535.0);

        prefs.setDouble("p3.x", 133.0);
        prefs.setDouble("p3.y", 543.0);
      } else {
        points[0] = Point(prefs.getDouble("p0.x"), prefs.getDouble("p0.y"));
        points[1] = Point(prefs.getDouble("p1.x"), prefs.getDouble("p1.y"));
        points[2] = Point(prefs.getDouble("p2.x"), prefs.getDouble("p2.y"));
        points[3] = Point(prefs.getDouble("p3.x"), prefs.getDouble("p3.y"));

        generate_cout_point();

        setState(() {});
      }
    } else {
      if (!prefs.containsKey("p2b.y")) {
        prefs.setDouble("p0b.x", 324.0);
        prefs.setDouble("p0b.y", 489.0);

        prefs.setDouble("p1b.x", 157.0);
        prefs.setDouble("p1b.y", 498.0);

        prefs.setDouble("p2b.x", 349.0);
        prefs.setDouble("p2b.y", 535.0);

        prefs.setDouble("p3b.x", 133.0);
        prefs.setDouble("p3b.y", 543.0);
      } else {
        points[0] = Point(prefs.getDouble("p0b.x"), prefs.getDouble("p0b.y"));
        points[1] = Point(prefs.getDouble("p1b.x"), prefs.getDouble("p1b.y"));
        points[2] = Point(prefs.getDouble("p2b.x"), prefs.getDouble("p2b.y"));
        points[3] = Point(prefs.getDouble("p3b.x"), prefs.getDouble("p3b.y"));

        generate_cout_point();

        setState(() {});
      }
    }
  }

  void generate_cout_point() {
    List<dynamic> dst = [
      [points[2].x, points[2].y],
      [points[3].x, points[3].y],
      [points[1].x, points[1].y],
      [points[0].x, points[0].y],
    ];


    dst_point.clear();
    var H = find_homography3(back_hand ? scr_backhand : scr_forehand, dst);

    for (int i = 0; i < scr_points_corners.length; i++) {
      Point p = hom_trans(scr_points_corners[i][0], scr_points_corners[i][1], H);

      dst_point.add(p);
    }


  }

  setRecognitions2(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;

      _recognitions.forEach((re) {
        if (re["detectedClass"] == "ball") {
          double x = (re["rect"]["x"] * MediaQuery.of(context).size.width);
          double y = re["rect"]["y"] * MediaQuery.of(context).size.height;
           ball_conf = ((re["confidenceInClass"] * 100).toString());
          y = y + (re["rect"]["h"] * MediaQuery.of(context).size.height);
          if (is_working && !pause) {
            if (current_side == 1 || current_side == 3) {
              smartbounce_service_box(x, y, re["rect"]["h"] * MediaQuery.of(context).size.height);
            } else {
              smartbounce(x, y, re["rect"]["h"] * MediaQuery.of(context).size.height);
            }
          }
        }
      });
    });
  }

  void setupcamera() {
    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[camera],
        ResolutionPreset.high,
      );

      controller.initialize().then((_) async {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) async {
          if (!isDetecting) {
            detection = DateTime.now();

            isDetecting = true;
            Tflite.detectObjectOnFrame(
                    bytesList: img.planes.map((plane) {
                      return plane.bytes;
                    }).toList(),
                    imageHeight: img.height,
                    imageWidth: img.width,
                    model: "SSDMobileNet",
                    threshold: threshold,
                    numResultsPerClass: numResultsPerClass)
                .then((recognitions) {
              //print(DateTime.now().difference(detection));

              setRecognitions2(recognitions, img.height, img.width);
              isDetecting = false;
            });
          }
        });
      });
    }
  }

  void smartbounce2(x, y, h) {
    if (y < dst_point[0].y - 30 && x > dst_point[0].x) {
      below = false;
    }

    if (last_bounce.length > 7) {
      int len = last_bounce.length;

      double mid_om = last_bounce[last_bounce.length - 3].y;

      if (last_bounce[len - 6].y < mid_om &&
          last_bounce[len - 4].y < mid_om &&
          last_bounce[len - 2].y < mid_om &&
          last_bounce[len - 1].y < mid_om &&
          dst_point[0].y - 30 < mid_om &&
          mid_om - last_bounce[len - 5].y > 15 &&
          !below) {
        double slope = (dst_point[0].y - dst_point[2].y) / (dst_point[0].x - dst_point[2].x);

        double line_x = ((mid_om - dst_point[0].y) / slope) + dst_point[0].x;

        List<dynamic> dst = [
          [points[2].x, points[2].y],
          [points[3].x, points[3].y],
          [points[1].x, points[1].y],
          [points[0].x, points[0].y],
        ];

        //print(back_hand);

        var H = find_homography3(dst, back_hand ? scr_backhand : scr_forehand);

        Point temp;

        if (last_bounce[last_bounce.length - 3].x < line_x) {
          ball.add(Positioned(
              left: line_x,
              top: last_bounce[last_bounce.length - 3].y - h,
              child: Icon(
                Icons.circle,
                size: 15,
                color: line_x - last_bounce[last_bounce.length - 3].x > 40 ? Colors.pink : Colors.yellow,
              )));
          ball.add(Positioned(
              left: last_bounce[last_bounce.length - 3].x,
              top: last_bounce[last_bounce.length - 3].y - h,
              child: Icon(
                Icons.circle,
                size: 15,
                color: Colors.deepPurple,
              )));
          temp = hom_trans(line_x, last_bounce[last_bounce.length - 3].y - h, H);
        } else {
          ball.add(Positioned(
              left: last_bounce[last_bounce.length - 3].x,
              top: last_bounce[last_bounce.length - 3].y - h,
              child: Icon(
                Icons.circle,
                size: 15,
                color: Colors.black,
              )));

          temp = hom_trans(last_bounce[last_bounce.length - 3].x, last_bounce[last_bounce.length - 3].y, H);
        }

        setState(() {
          bounces.add(temp);
        });
        total_bounces.add(new Bounce(temp.x, temp.y, current_side.toDouble(), DateTime.now()));

        //total_bounces.add(temp);

        last_bounce.clear();
        below = true;
      } else {
        last_bounce.removeAt(len - 7);
      }
    }

    last_bounce.add(Point(x, y));
  }


  void smartbounce(x, y, h) {

    int max = 7;

    if (y < dst_point[0].y - 15 && x > dst_point[0].x-30) {
        setState(() {
          below = false;
          blew_count++;
        });

    }

    if (last_bounce.length > max) {
      int len = last_bounce.length;

      double mid_om = last_bounce[last_bounce.length - 3].y;

      if (last_bounce[len - 6].y < mid_om &&
          last_bounce[len - 4].y < mid_om &&
          last_bounce[len - 2].y < mid_om &&
          last_bounce[len - 1].y < mid_om &&
          points[1].y < mid_om &&
          mid_om - last_bounce[len - 5].y > 5 &&
          !below &&
          blew_count >= 5) {
        double lineX;
        double lineY;

        List<dynamic> dst = [
          [points[2].x, points[2].y],
          [points[3].x, points[3].y],
          [points[1].x, points[1].y],
          [points[0].x, points[0].y],
        ];
        print(dst);



        var H = find_homography3(dst, back_hand ? scr_backhand : scr_forehand);
        Point temp;

        //finds the best point if ball bounces off court
        ball.clear();

        if (!back_hand) {
          double slope = (dst_point[0].y - dst_point[2].y) / (dst_point[0].x - dst_point[2].x);

          lineX = ((mid_om - dst_point[0].y) / slope) + dst_point[0].x;
          lineY = (slope * (last_bounce[last_bounce.length - 3].x - dst_point[0].x)) + dst_point[0].y;

          if (last_bounce[last_bounce.length - 3].x < lineX) {
            temp = hom_trans(lineX, lineY - h, H);

            ball.add(Positioned(
                left: lineX,
                top: lineY - h,
                child: Icon(
                  Icons.circle,
                  size: 15,
                  color: Colors.pink,
                )));
          } else {
            temp = hom_trans(last_bounce[last_bounce.length - 3].x, last_bounce[last_bounce.length - 3].y, H);

            ball.add(Positioned(
                left: last_bounce[last_bounce.length - 3].x,
                top: last_bounce[last_bounce.length - 3].y - h,
                child: Icon(
                  Icons.circle,
                  size: 15,
                  color: Colors.black,
                )));
          }
        } else {
          double slope = (dst_point[1].y - dst_point[3].y) / (dst_point[1].x - dst_point[3].x);

          lineX = ((mid_om - dst_point[1].y) / slope) + dst_point[1].x;
          lineY = (slope * (last_bounce[last_bounce.length - 3].x - dst_point[1].x)) + dst_point[1].y;

          if (last_bounce[last_bounce.length - 3].x > lineX) {
            temp = hom_trans(lineX, lineY - h, H);

            ball.add(Positioned(
                left: lineX,
                top: lineY - h,
                child: Icon(
                  Icons.circle,
                  size: 15,
                  color: Colors.pink,
                )));
          } else {
            temp = hom_trans(last_bounce[last_bounce.length - 3].x, last_bounce[last_bounce.length - 3].y, H);

            ball.add(Positioned(
                left: last_bounce[last_bounce.length - 3].x,
                top: last_bounce[last_bounce.length - 3].y - h,
                child: Icon(
                  Icons.circle,
                  size: 15,
                  color: Colors.black,
                )));
          }
        }

        setState(() {
          bounces.add(temp);
        });
        total_bounces.add(new Bounce(temp.x, temp.y, current_side.toDouble(), DateTime.now()));

        //last_bounce.clear();
        setState(() {
          blew_count = 0;

          below = true;
        });

        //print(get_data);

      } else {

        last_bounce.removeAt(len - max);
        ball.add(Positioned(
            left: x,
            top: y-h,
            child: Icon(
              Icons.circle,
              size: 15,
              color: Colors.green,
            )));
      }
    }

    last_bounce.add(Point(x, y));

  }

  void smartbounce_service_box(x, y, h) {
    if (y < dst_point[0].y - 30 && x > dst_point[0].x) {
      setState(() {
        below = false;
        blew_count++;
      });
    }

    if (last_bounce.length > 7) {
      int len = last_bounce.length;

      double mid_om = last_bounce[last_bounce.length - 3].y;

      if (last_bounce[len - 6].y < mid_om &&
          last_bounce[len - 4].y < mid_om &&
          last_bounce[len - 2].y < mid_om &&
          last_bounce[len - 1].y < mid_om &&
          dst_point[0].y < mid_om &&
          mid_om - last_bounce[len - 5].y > 5 &&
          !below &&
          blew_count >= 2) {





        List<dynamic> dst = [
          [points[2].x, points[2].y],
          [points[3].x, points[3].y],
          [points[1].x, points[1].y],
          [points[0].x, points[0].y],
        ];

        //print(back_hand);

        var H = find_homography3(dst, back_hand ? scr_backhand : scr_forehand);

        Point temp;

        temp = hom_trans(last_bounce[last_bounce.length - 3].x, last_bounce[last_bounce.length - 3].y, H);

        List<int> c = back_hand ? [0, 280, 930, 1200] : [810, 1080, 930, 1200];

        if (temp.x > c[0] && temp.x < c[1] && temp.y > c[2] && temp.y < c[3]) {
          ball.add(Positioned(
              left: last_bounce[last_bounce.length - 3].x,
              top: last_bounce[last_bounce.length - 3].y - h,
              child: Icon(
                Icons.circle,
                size: 15,
                color: Colors.black,
              )));

          bounces.add(temp);
          total_bounces.add(new Bounce(temp.x, temp.y, current_side.toDouble(), DateTime.now()));
        } else {
          ball.add(Positioned(
              left: last_bounce[last_bounce.length - 3].x,
              top: last_bounce[last_bounce.length - 3].y - h,
              child: Icon(
                Icons.cancel,
                size: 15,
                color: Colors.redAccent,
              )));
        }
        last_bounce.clear();
        below = true;
      } else {
        last_bounce.removeAt(len - 7);
      }
    }

    last_bounce.add(Point(x, y));
  }

  Point hom_trans(x, y, H) {
    var nums = Array2d([
      Array([x]),
      Array([y]),
      Array([1])
    ]);
    var points = matrixDot(H, nums);
    double scale = points[2][0];
    double x1 = (points[0][0] / scale);
    double y1 = (points[1][0] / scale);

    return Point(x1, y1);
  }

  Widget extra() {
    return Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          painter: MyPainter(points, dst_point,back_hand,current_side),
        ),
        TouchBubble(
          index: 1,
          position: Offset(points[1].x, points[1].y),
          bubbleSize: currentBubbleSize,
          onStartDragging: _startDragging,
          onDrag: _drag,
          onEndDragging: _endDragging,
        ),
        TouchBubble(
          index: 0,
          position: Offset(points[0].x, points[0].y),
          bubbleSize: currentBubbleSize,
          onStartDragging: _startDragging,
          onDrag: _drag,
          onEndDragging: _endDragging,
        ),
        TouchBubble(
          index: 2,
          position: Offset(points[2].x, points[2].y),
          bubbleSize: currentBubbleSize,
          onStartDragging: _startDragging,
          onDrag: _drag,
          onEndDragging: _endDragging,
        ),
        TouchBubble(
          index: 3,
          position: Offset(points[3].x, points[3].y),
          bubbleSize: currentBubbleSize,
          onStartDragging: _startDragging,
          onDrag: _drag,
          onEndDragging: _endDragging,
        ),
        //t_box(0, "TR"),
        //t_box(1, "TL"),
        //t_box(2, "BR"),
        //t_box(3, "BL"),
      ],
    );
  }

  Widget Settings_tap(bool top) {
    return Positioned(
      right: (MediaQuery.of(context).size.width - 250) / 2,
      bottom: !top ? 20 : MediaQuery.of(context).size.height - 130,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.9), borderRadius: BorderRadius.all(Radius.circular(20))),
          height: 50,
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Wakelock.toggle(enable: false);
                    Navigator.pop(context);
                  }),
              IconButton(
                  icon: Icon(pause ? Icons.play_arrow : Icons.pause, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      ball.clear();
                      total_bounces.clear();
                      bounces.clear();
                      // pause = !pause;
                    });
                  }),
              IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: () {
                    if (camera == 0) {
                      camera = 1;
                    } else {
                      camera = 0;
                    }

                    onNewCameraSelected(cameras[camera]);
                  }),
              IconButton(
                  icon: page == 0 ? Icon(Icons.arrow_forward_rounded, color: Colors.white) : Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () {
                    if (page == 0) {
                      pc.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                      page = 1;
                    } else {
                      pc.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                      page = 0;
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      res,
    );

// If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {}
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {}

    if (mounted) {
      setState(() {});
    }

    controller.startImageStream((CameraImage img) async {
      if (!isDetecting) {
        isDetecting = true;

        Tflite.detectObjectOnFrame(
                bytesList: img.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                model: "SSDMobileNet",
                threshold: threshold,
                numResultsPerClass: numResultsPerClass)
            .then((recognitions) {
          //print(recognitions);

          setRecognitions2(recognitions, img.height, img.width);
          isDetecting = false;
        });
      }
    });
  }

  Widget draw_court() {
    Color court_color = Theme.of(context).primaryColor;

    double h = (MediaQuery.of(context).size.width * 1645) / 1080;

    double offset = MediaQuery.of(context).size.height - h;

    return Stack(
      children: [
        Positioned(
            top: 0,
            child: Container(
              height: offset,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {
                                if (page == 0) {
                                  pc.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                                  page = 1;
                                } else {
                                  pc.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                                  page = 0;
                                }
                              }),
                          IconButton(
                              icon: Icon(
                                pause ? Icons.play_arrow : Icons.pause,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {
                                setState(() {
                                  pause = !pause;
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {
                                Wakelock.toggle(enable: false);
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
        Positioned(
            bottom: h,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: court_color,
            )),
        Positioned(
            top: h * 0.56 + offset,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: court_color,
            )),
        Positioned(
            top: h * 0.56 + offset,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.56,
              width: 15,
              color: court_color,
            )),
        Positioned(
          top: h * 0.56 + offset,
          left: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4 + 15,
            height: MediaQuery.of(context).size.width / 4 + 15,
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
          top: h * 0.56 + offset,
          right: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4 + 15,
            height: MediaQuery.of(context).size.width / 4 + 15,
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

  Widget camera_preview() {
    return AspectRatio(
      aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,

      // Use the VideoPlayer widget to display the video.

      child: CameraPreview(controller),
    );
  }

  Widget flat_bounce() {
    List<Widget> bounce = [];
    double h = (MediaQuery.of(context).size.width * 1645) / 1080;

    double offset = MediaQuery.of(context).size.height - h;

    for (int i = 0; i < bounces.length; i++) {
      //(bounces[i]);

      double x1 = (bounces[i].x * MediaQuery.of(context).size.width) / 1080;
      double y1 = ((bounces[i].y * h) / 1645) + offset;

      bounce.add(Positioned(
        top: y1,
        left: x1,
        child: Icon(
          Icons.circle,
          size: 20,
          color: Colors.black,
        ),
      ));
    }

    return Stack(
      children: bounce,
    );
  }

  Widget fixed_target() {
    return Positioned(
        left: location.x.toDouble() - (box_size2 / 2),
        top: location.y.toDouble() - (box_size2 / 2),
        child: Draggable(
          child: Container(
            width: box_size2,
            height: box_size2,
            decoration: BoxDecoration(
              border: Border.all(
                  color: main,
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
              location = Point(offset.dx.toInt() + (box_size2 / 2), offset.dy.toInt() + (box_size2 / 2));
            });
          },
          feedback: Container(
            width: box_size2,
            height: box_size2,
            decoration: BoxDecoration(
              border: Border.all(
                  color: main,
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

  Future<void> save2() async {
    Wakelock.toggle(enable: false);

    String box = "Solo1";

    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(Solo_stroage_Adapter());
    }

    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(BounceAdapter());
    }

    var solo;

    if (Hive.isBoxOpen(box)) {
      solo = Hive.box<Solo_stroage>(box);
    } else {
      solo = await Hive.openBox<Solo_stroage>(box);
    }

    var s = Solo_stroage()
      ..start = start_time
      ..end = DateTime.now()
      ..bounces = total_bounces;

    if (total_bounces.length > 1) {
      solo.add(s);
    }
  }

  void _startDragging(Offset newPosition) {
    setState(() {
      magnifierVisible = true;
      position = newPosition;
      currentBubbleSize = touchBubbleSize * 1.5;
    });
  }

  void _drag(Offset newPosition, int index) {
    setState(() {
      position = newPosition;
      points[index] = Point(newPosition.dx, newPosition.dy);
      points[index] = Point(newPosition.dx, newPosition.dy);
      generate_cout_point();
    });
  }

  Future<void> _endDragging() async {
    setState(() {
      currentBubbleSize = touchBubbleSize;
      magnifierVisible = false;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (back_hand) {
      prefs.setDouble('p0b.x', points[0].x);
      prefs.setDouble('p0b.y', points[0].y);

      prefs.setDouble('p1b.x', points[1].x);
      prefs.setDouble('p1b.y', points[1].y);

      prefs.setDouble('p2b.x', points[2].x);
      prefs.setDouble('p2b.y', points[2].y);

      prefs.setDouble('p3b.x', points[3].x);
      prefs.setDouble('p3b.y', points[3].y);
    } else {
      prefs.setDouble('p0.x', points[0].x);
      prefs.setDouble('p0.y', points[0].y);

      prefs.setDouble('p1.x', points[1].x);
      prefs.setDouble('p1.y', points[1].y);

      prefs.setDouble('p2.x', points[2].x);
      prefs.setDouble('p2.y', points[2].y);

      prefs.setDouble('p3.x', points[3].x);
      prefs.setDouble('p3.y', points[3].y);
    }

  }

  @override
  Widget build(BuildContext context) {

    //print(back_hand);

    return PageView(
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      controller: pc,
      children: [
        Stack(
          children: [
            Scaffold(
              body: Stack(children: [
                //, Image(image: AssetImage('assets/test.jpg')

                Magnifier(
                  scale: 2.0,
                  screen_width: MediaQuery.of(context).size.width,
                  position: position,
                  visible: magnifierVisible,
                  child: camera_preview(),
                ),

                show_stuff ? extra() : Text(""),

                Settings_tap(false),

               Positioned(
                  top: magnifierVisible
                      ?  -1000:0,
                  left: (MediaQuery.of(context).size.width - 320) / 2,
                      child: counter_widget(
                          type: widget.type,
                          main: main,
                          time: widget.time,
                          counter_value: bounces.length,
                          counter_goal: widget.shot_count,
                          activities: widget.sides,
                          pause: pause,
                          is_working: (bool) {
                            is_working = bool;
                            if (!is_working) {
                              bounces.clear();
                            }
                          },
                          done: (bool) async {
                            await save2();
                            await Navigator.push(context,
                                PageTransition(type: PageTransitionType.bottomToTop, child: Finish_Screen_Solo(total_bounces.length, DateTime.now().difference(start_time).toString().substring(0, 7),
                                    total_bounces)));

                            Navigator.pop(context);
                          },
                          current_side: (vals) {

                            current_side=vals;

                            print("int=$vals");

                            if (vals < 2) {
                              back_hand = false;
                              saved_points();

                              //   generate_cout_point();
                            } else {
                              setState(() {
                                back_hand = true;
                                saved_points();
                                //   generate_cout_point();
                              });
                            }
                            setState(() {
                              bounces.clear();
                              ball.clear();
                            });
                          },
                        ),
                    ),

                Positioned(top: 400, right: 40, child: Text(ball_conf)),

                Positioned(
                    top: 400,
                    right: 40,
                    child: Container(
                      height: 50,
                      width: 50,
                      color: blew_count >= 4 ? Colors.pink : Colors.orange,
                      child: Center(
                        child: Column(
                          children: [
                            Text(blew_count.toString()),
                            Text(below.toString()),
                          ],
                        ),
                      ),
                    )),

                Stack(
                  children: ball,
                ),

                BndBoxSolo(_recognitions == null ? [] : _recognitions),
              ]),
            ),
          ],
        ),
        Scaffold(
            body: Stack(
          children: [
            draw_court(),
            //fixed_target(),
            //Settings_tap(true),
            flat_bounce(),
          ],
        )),
      ],
    );
  }

  @override
  void dispose() {
    //Tflite.close();
    controller?.dispose();
    Wakelock.toggle(enable: false);

    super.dispose();
  }
}
