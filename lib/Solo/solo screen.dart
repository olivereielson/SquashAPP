import 'dart:math';

import 'package:camera/camera.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:squash/Solo/Solo%20home%20page.dart';
import 'package:squash/Target_page.dart';
import 'package:tflite/tflite.dart';

class SoloScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  SoloScreen(this.cameras);

  @override
  SoloScreenState createState() => new SoloScreenState(cameras);
}

class SoloScreenState extends State<SoloScreen> {
  SoloScreenState(this.cameras);

  bool delete_mode = false;

  final _solokey = GlobalKey<AnimatedListState>();

  final List<CameraDescription> cameras;

  bool use_round = false;
  bool use_time = false;
  bool use_target = false;

  String name;



  int extra_num;
  int shot_number = 100;
  int start_camera = 0;
  int segmentedControlGroupValue = 0;
  Point location = Point(250.0, 250.0);
  bool target_locked = false;
  String box = "solo3";
  var Exersises;

  Duration total_time = Duration(seconds: 500);

  Duration rest_time = Duration(seconds: 30);



  Color main = Color.fromRGBO(40, 70, 130, 1);

  DateTime time;

  List<int> sides = [0,1,2,3];

  List<Widget> settings;
  int side_count = 2;
  int taraget_count = 50;

  List<String> type_list = ["Timed Solo", "Target Practice", "Shot Count"];

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/converted_model.tflite",
      labels: "assets/ball.txt",
      useGpuDelegate: true,
    );
  }

  Widget input(String title, String value, Icon icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(20),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: icon,
              ),

              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(value),
                  ],
                ),
              ),
              Spacer(),
              Icon(Icons.navigate_next, color: Colors.black) // This Icon
            ],
          ),
        ),
      ),
    );
  }

  show_shot_picker() {
    List<Widget> nums = [];

    nums.add(Text(
      "1 Shot",
    ));

    for (int x = 2; x < 50; x++) {
      nums.add(Text(
        x.toString() + " Shots",
      ));
    }

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            child: CupertinoPicker(
                looping: true,
                backgroundColor: Colors.transparent,
                onSelectedItemChanged: (value) {
                  setState(() {
                    shot_number = value + 1;
                    extra_num = value + 1;
                  });
                },
                itemExtent: 50,
                children: nums),
          );
        });
  }


  show_target_picker() {
    List<Widget> nums = [];

    nums.add(Text(
      "1 Target",
    ));

    for (int x = 2; x < 20; x++) {
      nums.add(Text(
        x.toString() + " Targets",
      ));
    }

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            child: CupertinoPicker(
                looping: true,
                backgroundColor: Colors.transparent,
                onSelectedItemChanged: (value) {
                  setState(() {
                    taraget_count = value + 1;
                    extra_num = value + 1;
                  });
                },
                itemExtent: 50,
                children: nums),
          );
        });
  }

  show_time_picker() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: total_time,
              onTimerDurationChanged: (data) {
                setState(() {
                  total_time = data;
                  extra_num = data.inSeconds;
                });
              },
            ),
          );
        });
  }

  show_rest_picker() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: rest_time,
              onTimerDurationChanged: (data) {
                setState(() {
                  rest_time = data;
                  extra_num = data.inSeconds;
                });
              },
            ),
          );
        });
  }


  text_dialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Name Custom Exersie"),
          content: new TextField(
            autofocus: true,
            decoration: new InputDecoration(labelText: 'Custom Name', fillColor: main),
            onSubmitted: (value) {
              name = value;

              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  Widget round() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Divider(
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {
                show_shot_picker();
              },
              child: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shot_number.toString(),
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: main),
                        ),
                        Text("Number of Shots"),
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {
                show_rest_picker();
              },
              child: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rest_time.toString().split('.').first.padLeft(8, "0").substring(3),
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: main),
                        ),
                        Text("Rest Time"),
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ));
  }

  Widget Target_input() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Divider(
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {
                show_target_picker();
              },
              child: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          taraget_count.toString(),
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: main),
                        ),
                        Text("Number of Targets"),
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {
                show_rest_picker();
              },
              child: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rest_time.toString().split('.').first.padLeft(8, "0").substring(3),
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: main),
                        ),
                        Text("Rest Time"),
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ));
  }

  Widget Time_Input() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Divider(
            thickness: 2,
          ),
          GestureDetector(
            onTap: () {
              show_time_picker();
            },
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        total_time.toString().split('.').first.padLeft(8, "0").substring(3),
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: main),
                      ),
                      Text("Time on Side"),
                    ],
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          GestureDetector(
            onTap: () {
              show_rest_picker();
            },
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rest_time.toString().split('.').first.padLeft(8, "0").substring(3),
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: main),
                      ),
                      Text("Rest Time"),
                    ],
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }

  Widget shot(String name, bool selected,int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GestureDetector(

        onTap: (){

          if(sides.contains(index)){

            setState(() {
              sides.remove(index);

            });


          }else{

            setState(() {
              sides.add(index);

            });


          }


        },

        child: Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: sides.contains(index) ? Colors.white : Color.fromRGBO(40, 70, 130, 1), width: 5), color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
            height: 175,
            width: 120,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(40, 70, 130, 1)),
                  ),
                ),
                Spacer(),
                Container(
                  height: 80,
                  width: 130,
                  child: Stack(
                    children: [
                      Positioned(left: 0, top: 15, child: Container(width: 130, height: 5, color: Color.fromRGBO(40, 70, 130, 1))),
                      Positioned(left: 50.0, top: 15, child: Container(width: 5, height: 100, color: Color.fromRGBO(40, 70, 130, 1))),
                      Positioned(left: 25.0, top: 15, child: Container(width: 5, height: 30, color: Color.fromRGBO(40, 70, 130, 1))),
                      Positioned(left: 0.0, top: 40, child: Container(width: 25, height: 5, color: Color.fromRGBO(40, 70, 130, 1))),
                      Positioned(right: 25.0, top: 15, child: Container(width: 5, height: 30, color: Color.fromRGBO(40, 70, 130, 1))),
                      Positioned(right: 0.0, top: 40, child: Container(width: 25, height: 5, color: Color.fromRGBO(40, 70, 130, 1))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mode_choice() {
    switch (segmentedControlGroupValue) {
      case 0:
        return Time_Input();

      case 1:
        return Target_input();

      case 2:
        return round();
    }
  }

  Widget button(int index, String name) {
    return GestureDetector(

      onTap: (){
        setState(() {
          segmentedControlGroupValue = index;
        });

      },

      child: Container(
        decoration: BoxDecoration(color: segmentedControlGroupValue!=index?Colors.white:Color.fromRGBO(40, 70, 130, 1), borderRadius: BorderRadius.all(Radius.circular(20))),
        height: 40,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(child: Text(name,style: TextStyle(fontWeight: FontWeight.bold,color: segmentedControlGroupValue==index?Colors.white:Color.fromRGBO(40, 70, 130, 1),)),

      ),
        )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(230, 240, 250, 1),
          Color.fromRGBO(230, 240, 250, 1),
        ],
      )),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 300),
            painter: LogoPainter(),
          ),
          Column(
            children: [
              Container(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Solo Exersises",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Icon(
                          Icons.info,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [shot("Forehand Drives", true,0), shot("Backhand Drives", true,1), shot("Forehand Volley", true,2), shot("Backhand Volley", false,3)],
                ),
              ),

              // Target_input(),

              //round(),
              // Time_Input(),

              Container(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [button(0, "Time"), button(1, "Target Count"), button(2, "Shot Count")],
                ),
              ),

              mode_choice(),
              Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    GestureDetector(
                      onTap: () async {
                        await loadModel();

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SoloHome(cameras, start_camera, location, shot_number, taraget_count, total_time, segmentedControlGroupValue, side_count)),
                        );
                      },
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 150,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              )),
                              elevation: 2,
                              color: main,
                              child: Center(
                                  child: Text(
                                "Start",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    var rect = Offset.zero & size;

    var path = Path();
    //path.lineTo(0, size.height - size.height / 5);
    //path.lineTo(size.width / 1.2, size.height);
    //Added this line

    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.6);

    path.quadraticBezierTo(size.width * 0.1, size.height * 0.6, size.width * 0.52, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.74, size.height * 0.92, size.width, size.height * 0.84);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);

    paint.shader = LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      stops: [0.1, 0.5, 1],
      colors: [
        Color.fromRGBO(40, 40, 80, 1),
        Color.fromRGBO(40, 40, 80, 1),
        Colors.indigo,
      ],
    ).createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
