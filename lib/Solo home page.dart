import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scidart/numdart.dart';
import 'package:squash/bndboxsolo.dart';
import 'package:tflite/tflite.dart';

import 'bndbox.dart';
import 'camera.dart';
import 'counter_widget.dart';
import 'court_functions.dart';
import 'court_painter.dart';

class SoloHome extends StatefulWidget {
  final List<CameraDescription> cameras;
  final int start_camera;
  final int target_count;
  final int shot_count;
  final int type;
  final int side_count;
  final Duration time;

  final Point taget;

  SoloHome(this.cameras, this.start_camera, this.taget, this.shot_count, this.target_count, this.time, this.type, this.side_count);

  @override
  SoloHomeState createState() => new SoloHomeState(cameras);
}

class SoloHomeState extends State<SoloHome> {
  SoloHomeState(this.cameras);

  List<dynamic> _recognitions;

  List<Point> bounces = [];
  List<Point> target_bounces = [];

  Point location = Point(200, 200);

  bool show_stuff = true;
  bool front_Camera = true;

  String ball_conf = "";

  CameraController controller;
  bool isDetecting = false;
  Color main = Color.fromRGBO(4, 12, 128, 1);

  List<Point> points = [Point(324.0, 489.0), Point(157.0, 498.0), Point(349.0, 535.0), Point(133.0, 543.0)];

  List<dynamic> scr = [
    [485, 1080],
    [240, 1080],
    [240, 825],
    [485, 825]
  ];

  List<Point> dst_point = [];

  double box_size = 90;
  DateTime start_time;

  double box_size2 = 90;

  List<Widget> ball = [];

  final List<CameraDescription> cameras;

  bool on_ground = false;

  var H;

  bool below = false;
  List<Point> last_bounce = [];

  int up_count = 0;

  //Camera varavibles

  double threshold = 0.2;
  int numResultsPerClass = 1;
  ResolutionPreset res = ResolutionPreset.high;
  int camera = 0;

  //bouce

  int upcount = 0;

  List<dynamic> last_seen = [];
  List<bool> direction = [];

  bool up_down = false;

  @override
  void initState() {
    super.initState();
    setupcamera();
    start_time = DateTime.now();
    generate_cout_point();
  }

  void generate_cout_point() {
    List<dynamic> dst = [
      [points[2].x, points[2].y],
      [points[3].x, points[3].y],
      [points[1].x, points[1].y],
      [points[0].x, points[0].y],
    ];
    List<dynamic> scr_points = [
      [485.0, 0.0],
      [0.0, 0.0],
      [485.0, 1465.0],
      [0.0, 1465.00],
    ];

    dst_point.clear();

    var H = find_homography3(scr, dst);

    for (int i = 0; i < scr_points.length; i++) {
      Point p = hom_trans(scr_points[i][0], scr_points[i][1], H);

      dst_point.add(p);
    }
  }

  setRecognitions2(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;

      _recognitions.forEach((re) {
        if (re["detectedClass"] == "ball") {
          double x = re["rect"]["x"] * MediaQuery.of(context).size.width;
          double y = re["rect"]["y"] * MediaQuery.of(context).size.height;
          //ball_conf = ((re["confidenceInClass"] * 100).toString());
          y = y + (re["rect"]["h"] * MediaQuery.of(context).size.height + 10);
          //smartbounce(x, y, re["rect"]["h"] * MediaQuery.of(context).size.height);
          ground(x, y, re["rect"]["h"] * MediaQuery.of(context).size.height);
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
        res,
      );

      controller.initialize().then((_) async {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) async {
          if (!isDetecting) {
            isDetecting = false;

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
      });
    }
  }

  void ground2(x, y) {
    //rectangle

    if (y > points[0].y && y > points[1].y && y < points[2].y && y < points[3].y) {
      double slope_R = (points[2].y - points[0].y) / (points[2].x - points[0].x);
      double slope_L = (points[3].y - points[1].y) / (points[3].x - points[1].x);
      double y_line = ((y - points[1].y) / slope_L) + points[1].x;
      double x_line = ((y - points[0].y) / slope_R) + points[0].x;

      if (x < x_line && x > y_line && !on_ground && DateTime.now().difference(start_time).inSeconds > 0.5) {
        on_ground = true;

        start_time = DateTime.now();

        List<dynamic> dst = [
          [points[0].x, points[0].y],
          [points[1].x, points[1].y],
          [points[2].x, points[2].y],
          [points[3].x, points[3].y]
        ];
        List<dynamic> scr = [
          [300, 217],
          [229, 214],
          [229, 167],
          [300, 167]
        ];
        H = find_homography3(dst, scr);

        bounces.add(hom_trans(x, y, H));
        ball.add(Positioned(
            left: x,
            top: y,
            child: Icon(
              Icons.adjust,
              size: 30,
            )));
      }
    } else {
      on_ground = false;
    }
  }

  void ground(x, y, h) {
    //rectangle

    if (y > dst_point[0].y && y > dst_point[1].y && y < dst_point[2].y && y < dst_point[3].y) {
      double slope_R = (dst_point[2].y - dst_point[0].y) / (dst_point[2].x - dst_point[0].x);
      double slope_L = (dst_point[3].y - dst_point[1].y) / (dst_point[3].x - dst_point[1].x);
      double y_line = ((y - dst_point[1].y) / slope_L) + dst_point[1].x;
      double x_line = ((y - dst_point[0].y) / slope_R) + dst_point[0].x;

      // print("x=$x    xline=$x_line     yline=$y_line");

      if (x < x_line && x > y_line && !on_ground && DateTime.now().difference(start_time).inSeconds > 0.5) {
        on_ground = true;

        start_time = DateTime.now();

        List<dynamic> dst = [
          [points[2].x, points[2].y],
          [points[3].x, points[3].y],
          [points[1].x, points[1].y],
          [points[0].x, points[0].y],
        ];

        H = find_homography3(dst, scr);

        bounces.add(hom_trans(x, y, H));

        if (x > location.x && x < location.x + box_size2 && y > location.y && y < location.y + box_size2) {
          target_bounces.add(hom_trans(x, y, h));
        }

        ball.add(Positioned(
            left: x,
            top: y - h,
            child: Icon(
              Icons.adjust,
              size: 30,
            )));
      }
    } else {
      on_ground = false;
    }
  }

  void smartbounce(x, y, h) {
    if (y > dst_point[0].y - 30) {
      below = true;
      last_bounce.add(Point(x, y));
    } else {
      if (upcount > 3) {
        if (below && last_bounce.length > 1) {
          up_count = 0;

          last_bounce.sort((a, b) => a.y.compareTo(b.y));

          Point p = last_bounce[last_bounce.length - 1];

          ball.add(Positioned(
              left: p.x + 5,
              top: p.y - (h / 2),
              child: Icon(
                Icons.circle,
                size: 15,
                color: Colors.blue,
              )));

          List<dynamic> dst = [
            [points[2].x, points[2].y],
            [points[3].x, points[3].y],
            [points[1].x, points[1].y],
            [points[0].x, points[0].y],
          ];

          H = find_homography3(dst, scr);

          bounces.add(hom_trans(p.x + 5, p.y - (h / 2), H));
          upcount = 0;
        }
      } else {
        upcount++;
      }

      last_bounce.clear();
      below = false;
    }
  }

  void smartbounce2(x, y, h) {
    if (last_seen.length > 5) {
      //print(last_seen[last_seen.length-1][1]-y);

      if (last_seen[last_seen.length - 1][1] - y > 10) {
        up_down = true;
      } else {
        up_down = false;
      }

      direction.add(up_down);
      ball_conf = up_down.toString();

      //print(direction[direction.length - 1]);


      //print(" fff     ");

      if ( dst_point[0].y<last_seen[last_seen.length - 4][1]&&direction[direction.length - 4] != up_down && direction[direction.length - 3] != up_down && direction[direction.length - 2] == up_down
          && up_down) {
        ball.add(Positioned(
            left: last_seen[last_seen.length - 4][0] + 5,
            top: last_seen[last_seen.length - 4][1] - (h / 2),
            child: Icon(
              Icons.circle,
              size: 15,
              color: Colors.black,
            )));
      }
    }

    last_seen.add([x, y]);
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

  Widget t_box(double num, String pos) {
    return Positioned(
        left: points[num.toInt()].x.toDouble() - (box_size / 2),
        top: points[num.toInt()].y.toDouble() - (box_size / 2),
        child: Draggable(
          ignoringFeedbackSemantics: true,
          child: Container(
            width: box_size,
            height: box_size,
            decoration: BoxDecoration(
              border: Border.all(
                  color: main,
                  // set border color
                  width: 4.0), // set border width
              borderRadius: BorderRadius.all(Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Center(
              child: Icon(Icons.radio_button_off),
            ),
          ),
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              points[num.toInt()] = Point(offset.dx.toInt() + (100 / 2), offset.dy.toInt() + (100 / 2));
              generate_cout_point();
            });
          },
          childWhenDragging: Text(""),
          feedback: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                  color: main,
                  // set border color
                  width: 6.0), // set border width
              borderRadius: BorderRadius.all(Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Center(
              child: Icon(Icons.radio_button_off),
            ),
          ),
        ));
  }

  Widget painting() {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
      painter: MyPainter(points, dst_point, widget.taget),
    );
  }

  Widget extra() {
    return Stack(
      children: [
        painting(),
        t_box(0, "TR"),
        t_box(1, "TL"),
        t_box(2, "BR"),
        t_box(3, "BL"),
      ],
    );
  }

  Widget Settings_tap(bool top) {
    return Positioned(
      right: (MediaQuery.of(context).size.width - 200) / 2,
      bottom: !top ? 20 : MediaQuery.of(context).size.height - 130,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: main.withOpacity(0.8), borderRadius: BorderRadius.all(Radius.circular(20))),
          height: 50,
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              IconButton(
                  icon: Icon(Icons.pause, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      show_stuff = !show_stuff;
                    });
                  }),
              IconButton(
                  icon: Icon(Icons.rotate_right, color: Colors.white),
                  onPressed: () {
                    ball.clear();
                    bounces.clear();
                  }),
              IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: () {
                    front_Camera = !front_Camera;

                    onNewCameraSelected(cameras[front_Camera ? 0 : 1]);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget counter() {
    return Positioned(
      left: (MediaQuery.of(context).size.width - 180) / 2,
      top: 10,
      child: SafeArea(
        child: CircularPercentIndicator(
          progressColor: main,
          arcBackgroundColor: Colors.white,
          arcType: ArcType.FULL,
          lineWidth: 20,
          backgroundColor: Colors.white,
          percent: 0.2,
          radius: 180,
          animation: true,
          animateFromLastPercent: true,
          animationDuration: 1,
          backgroundWidth: 20,
          center: Text(
            bounces.length.toString(),
            style: TextStyle(fontSize: 49, fontWeight: FontWeight.bold, color: Colors.white),
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
        isDetecting = false;

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
    return Stack(
      children: [
        Positioned(
            top: MediaQuery.of(context).size.height * 0.57,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: main,
            )),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.57,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.57,
              width: 15,
              color: main,
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
                  color: main,
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

  Widget camera_preview() {
    return AspectRatio(
      aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,

      // Use the VideoPlayer widget to display the video.

      child: CameraPreview(controller),
    );
  }

  Widget flat_bounce() {
    List<Widget> bounce = [];

    for (int i = 0; i < bounces.length; i++) {
      double x1 = (bounces[i].x * (MediaQuery.of(context).size.width) / 2) / 485;
      double y1 = (bounces[i].y * MediaQuery.of(context).size.height) / 1465;

      bounce.add(Positioned(
        top: y1,
        left: x1 + (MediaQuery.of(context).size.width) / 2,
        child: Icon(Icons.circle),
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

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      children: [
        Stack(
          children: [
            Scaffold(
              body: Stack(children: [
                //Image(image: AssetImage('assets/test.jpg')),
                camera_preview(),

                BndBoxSolo(_recognitions == null ? [] : _recognitions),

                show_stuff ? extra() : Text(""),
                Settings_tap(false),
                //counter(),
                //counter_widget(widget.type,widget.side_count,main,time:widget.time,counter_value: bounces.length,counter_goal: widget.type==1?widget.target_count:widget.shot_count, done: (bool)
                //{Navigator.pop(context);},),

                Positioned(top: 400, right: 40, child: Text(ball_conf)),

                Positioned(
                    top: dst_point[0].y - 30,
                    child: Container(
                      color: Colors.blue,
                      width: MediaQuery.of(context).size.width,
                      height: 10,
                    )),
                show_stuff
                    ? Stack(
                        children: ball,
                      )
                    : Text(""),
              ]),
            ),
          ],
        ),
        Scaffold(
            body: Stack(
          children: [
            draw_court(),
            fixed_target(),
            Settings_tap(true),
            flat_bounce(),
          ],
        )),
      ],
    );
  }
}