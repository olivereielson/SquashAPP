import 'dart:math';
import 'dart:io' show Platform;

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:squash/Solo/Solo%20home%20page.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/Solo/Target_page.dart';
import 'package:squash/extra/headers.dart';
import 'package:squash/extra/hive_classes.dart';
import 'package:tflite/tflite.dart';

class SoloScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  SoloScreen(this.cameras, this.analytics, this.observer);

  @override
  SoloScreenState createState() => new SoloScreenState(cameras);
}

class SoloScreenState extends State<SoloScreen> with SingleTickerProviderStateMixin {
  SoloScreenState(this.cameras);

  final FocusNode _nodeText3 = FocusNode();
  final _mylistkey = GlobalKey<AnimatedListState>();

  bool delete_mode = false;

  final List<CameraDescription> cameras;
  TabController _tabController;

  bool use_round = false;
  bool use_time = false;
  bool use_target = false;
  bool is_shaking = false;

  String name;

  int extra_num;
  int shot_number = 100;
  int start_camera = 1;
  int segmentedControlGroupValue = 1;
  Point location = Point(250.0, 250.0);
  bool target_locked = false;
  String hive_box = "solosavaeaaaaz11saass9995";
  Box<Custom_Solo> solo;

  Duration total_time = Duration(seconds: 10);

  Duration rest_time = Duration(seconds: 30);

  //Color main = Color.fromRGBO(40, 70, 130, 1);
  Color main = Color.fromRGBO(66, 89, 138, 1);

  DateTime time;

  List<Solo_Defs> sides2 = [];

  List<Widget> settings;
  int side_count = 2;
  int taraget_count = 50;
  Future _load_data;

  bool showGreen = true;

  @override
  void initState() {
    _tabController = new TabController(
      length: 2,
      vsync: this,
    );

    _load_data = load_hive();

    _testSetCurrentScreen();

    super.initState();
  }

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Solo Selection Page',
      screenClassOverride: 'Solo_Selection_Page',
    );
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/models/converted_model.tflite",
      labels: "assets/models/ball.txt",
      useGpuDelegate: Platform.isAndroid ? true : true,
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

  show_shot_picker2() {
    List<Widget> nums = [];

    nums.add(Text(
      "1 Shot",
    ));

    for (int x = 2; x < 1000; x++) {
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

  show_shot_picker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(18),
          )),
          title: new Text(
            "Number of Shots",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: new TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
                counterStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 10,
                    ),
                    gapPadding: 5),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                labelStyle: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold)),
            style: TextStyle(color: Colors.white54),
            onChanged: (value) {
              setState(() {
                shot_number = int.parse(value);
              });
            },
            onSubmitted: (value) {
              setState(() {
                shot_number = int.parse(value);
              });

              Navigator.of(context).pop();
            },
          ),
          actions: [
            CupertinoButton(
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
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

  Future<void> text_dialog() async {
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

    name = n.toString().toUpperCase();
    if (name.replaceAll(" ", "") == "") {
      name = "NO NAME";
    }
  }

  Widget round() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              show_shot_picker();
              SoloDefs().setup();
            },
            child: Container(
              height: 90,
              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 3), color: Colors.grey.withOpacity(0.0), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Icon(
                        EvaIcons.hash,
                        color: Theme.of(context).primaryColor,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Number of Shots",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                            shot_number.toString(),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ),
        ),
        target_select(),
        show_green(),
      ],
    );
  }

  Widget show_green() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 90,
        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 3), color: Colors.grey.withOpacity(0.0), borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.bullseye,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Show Target Area",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                CupertinoSwitch(
                    activeColor: Theme.of(context).splashColor,
                    value: showGreen,
                    onChanged: (bool) {
                      setState(() {
                        showGreen = bool;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Time_Input() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              show_time_picker();
            },
            child: Container(
              height: 90,
              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 3), color: Colors.grey.withOpacity(0.0), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Icon(
                          Icons.timer,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Time on Side",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              total_time.toString().split('.').first.padLeft(8, "0").substring(3),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        target_select(),
        show_green(),
      ],
    );
  }

  Widget button(int index, String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          segmentedControlGroupValue = index;
        });
      },
      child: Container(
          decoration: BoxDecoration(color: segmentedControlGroupValue != index ? Colors.grey.withOpacity(0.2) : Color.fromRGBO(40, 70, 130, 1), borderRadius: BorderRadius.all(Radius.circular(20))),
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: segmentedControlGroupValue == index ? Colors.white : Color.fromRGBO(40, 70, 130, 1),
                  )),
            ),
          )),
    );
  }

  Widget target_select() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          sides2 = await Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: target(
                analytics: widget.analytics,
                observer: widget.observer,
                sides: sides2,
              ),
            ),
          );

          setState(() {});
        },
        child: Container(
          height: 90,
          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 3), color: Colors.grey.withOpacity(0.0), borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                        child: Image.asset(
                      "assets/icons/court_icon.png",
                      height: 40,
                      color: Theme.of(context).primaryColor,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Exercises",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${sides2.length.toString()} Selected",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right, color: Theme.of(context).primaryColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget timed() {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
            child: Column(
              children: [
                Time_Input(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (sides2.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('No Exercises Selected'),
                              duration: Duration(seconds: 1),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            await loadModel();
                            widget.analytics.logEvent(
                              name: 'Solo_Workout_Started',
                              parameters: <String, dynamic>{'Sides': sides2, 'Shot_Count': shot_number, 'time': total_time, 'Type': 'Timed'},
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SoloHome(
                                        cameras: cameras,
                                        start_camera: start_camera,
                                        type: _tabController.index,
                                        time: total_time,
                                        shot_count: shot_number,
                                        sides: sides2,
                                        showgreen: showGreen,
                                        analytics: widget.analytics,
                                        observer: widget.observer,
                                      )),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              )),
                              elevation: 2,
                              color: Theme.of(context).splashColor,
                              child: Center(
                                  child: Text(
                                "Start",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ))),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (sides2.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('No Exercises Selected'),
                              duration: Duration(seconds: 1),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            await text_dialog();

                            widget.analytics.logEvent(
                              name: 'Ghosting_Workout_Saved',
                              parameters: <String, dynamic>{
                                'name': name,
                                'number_shot': shot_number,
                                'solo_time': total_time.inSeconds,
                                'sides': sides2.length,
                                'type': _tabController.index == 0 ? "count" : "timed"
                              },
                            );

                            if (name != null && name != "") {
                              var exersie = Custom_Solo()
                                ..name = name
                                ..number_shot = shot_number.toDouble()
                                ..solo_time = total_time.inSeconds
                                ..sides = sides2
                                ..type = _tabController.index;

                              solo.add(exersie); // Store this object for the first time
                              _mylistkey.currentState.insertItem(0);
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              )),
                              elevation: 2,
                              color: Theme.of(context).splashColor,
                              child: Center(
                                  child: Text(
                                "Save Custom Set",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                              ))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget count() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: round(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (sides2.length == 0) {
                                  final snackBar = SnackBar(
                                    content: Text('No Exercises Selected'),
                                    duration: Duration(seconds: 1),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else {
                                  await loadModel();
                                  widget.analytics.logEvent(
                                    name: 'Solo_Workout_Started',
                                    parameters: <String, dynamic>{'Sides': sides2.length, 'Shot_Count': shot_number, 'time': total_time, 'Type': 'Count'},
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SoloHome(
                                              cameras: cameras,
                                              start_camera: start_camera,
                                              type: _tabController.index,
                                              time: total_time,
                                              shot_count: shot_number,
                                              sides: sides2,
                                              showgreen: showGreen,
                                              analytics: widget.analytics,
                                              observer: widget.observer,
                                            )),
                                  );
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                      Radius.circular(18),
                                    )),
                                    elevation: 2,
                                    color: Theme.of(context).splashColor,
                                    child: Center(
                                        child: Text(
                                      "Start",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ))),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (sides2.length == 0) {
                                  final snackBar = SnackBar(
                                    content: Text('No Exercises Selected'),
                                    duration: Duration(seconds: 1),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else {
                                  await text_dialog();

                                  widget.analytics.logEvent(
                                    name: 'Ghosting_Workout_Saved',
                                    parameters: <String, dynamic>{
                                      'name': name,
                                      'number_shot': shot_number,
                                      'solo_time': total_time.inSeconds,
                                      'sides': sides2.length,
                                      'type': _tabController.index == 0 ? "count" : "timed"
                                    },
                                  );

                                  if (name != null && name != "") {
                                    var exersie = Custom_Solo()
                                      ..name = name
                                      ..number_shot = shot_number.toDouble()
                                      ..solo_time = total_time.inSeconds.toInt()
                                      ..sides = sides2
                                      ..type = _tabController.index;

                                    solo.add(exersie); // Store this object fsor the first time
                                    _mylistkey.currentState.insertItem(0);
                                  }
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 200,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                      Radius.circular(18),
                                    )),
                                    elevation: 2,
                                    color: Theme.of(context).splashColor,
                                    child: Center(
                                        child: Text(
                                      "Save Custom Set",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                    ))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget Show_Custom_Card(int index) {
    return Container(
      width: 215,
      height: 220,
      child: ShakeAnimatedWidget(
        enabled: is_shaking,
        duration: Duration(milliseconds: 500),
        shakeAngle: Rotation.deg(z: 1),
        curve: Curves.linear,
        child: Stack(
          children: [
            Center(
              child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 3), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  width: 200,
                  height: 180,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Container(
                                width: 170,
                                child: AutoSizeText(
                                  solo.getAt(index).name,
                                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
                                  maxLines: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              Hive.box<Custom_Solo>(hive_box).getAt(index).type == 0
                                  ? Hive.box<Custom_Solo>(hive_box).getAt(index).number_shot.toInt().toString() + " shots"
                                  : Duration(seconds: Hive.box<Custom_Solo>(hive_box).getAt(index).solo_time).toString().substring(2, 7) + " Round Time",
                              style: TextStyle(
                                color: Colors.white60,
                              ),
                            ),
                            for (int i = 0; i < solo.getAt(index).sides.length; i++)
                              Text(
                                solo.getAt(index).sides[i].name,
                                //index.toString(),
                                style: TextStyle(
                                  color: Colors.white60,
                                ),
                              )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
            Container(
              child: is_shaking
                  ? Positioned(
                      left: 0,
                      top: 0,
                      child: GestureDetector(
                          onTap: () {
                            if (solo.length != 1) {
                              Widget temp = Show_Custom_Card(index);

                              _mylistkey.currentState.removeItem(
                                index,
                                (context, Animation<double> animation) => ScaleTransition(
                                  scale: animation,
                                  child: temp,
                                ),
                                duration: Duration(milliseconds: 700),
                              );

                              setState(() {
                                solo.deleteAt(index);
                              });
                            } else {
                              final snackBar = SnackBar(
                                content: Text('You must have at least one saved workout!'),
                              );

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.clear,
                                  color: Theme.of(context).primaryColorDark,
                                  size: 15,
                                )),
                          )),
                    )
                  : Text(""),
            ),
          ],
        ),
      ),
    );
  }

  load_hive() async {
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(CustomSoloAdapter());
    }

    if (Hive.isBoxOpen(hive_box)) {
      solo = Hive.box<Custom_Solo>(hive_box);
    } else {
      solo = await Hive.openBox<Custom_Solo>(hive_box);
    }

    if (solo.length == 0) {
      var exersie = Custom_Solo()
        ..name = "Default"
        ..number_shot = shot_number.toDouble()
        ..solo_time = total_time.inSeconds
        ..sides = [SoloDefs().get().getAt(0)]
        ..type = _tabController.index;

      solo.add(exersie); // Store this object for the first time
      _mylistkey.currentState.insertItem(0);
    }

    setState(() {});
  }

  AnimatedList tw() {
    return AnimatedList(
        key: _mylistkey,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        initialItemCount: Hive.box<Custom_Solo>(hive_box).length,
        itemBuilder: (BuildContext context, int index, Animation<double> animation) {
          return SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onLongPress: () {
                    setState(() {});
                    is_shaking = true;
                  },
                  onTap: () async {
                    await loadModel();
                    widget.analytics.logEvent(name: "Solo_Workout_From_Saved_List");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SoloHome(
                                cameras: cameras,
                                start_camera: start_camera,
                                type: Hive.box<Custom_Solo>(hive_box).getAt(index).type,
                                time: Duration(seconds: Hive.box<Custom_Solo>(hive_box).getAt(index).solo_time),
                                shot_count: Hive.box<Custom_Solo>(hive_box).getAt(index).number_shot.toInt(),
                                sides: Hive.box<Custom_Solo>(hive_box).getAt(index).sides,
                                showgreen: showGreen,
                                analytics: widget.analytics,
                                observer: widget.observer,
                              )),
                    );
                  },
                  child: Show_Custom_Card(index)),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _load_data,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (Hive.isBoxOpen(hive_box)) {
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                setState(() {
                  is_shaking = false;
                });
              },
              child: CustomScrollView(slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: MyDynamicHeader("Solo", "Exercise", false, widget.analytics, widget.observer, true),
                ),
                SliverPersistentHeader(
                  pinned: false,
                  floating: false,
                  delegate: header_shot(tw()),
                ),
                SliverPersistentHeader(
                  floating: false,
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(tabs: [
                      new Tab(
                        //  icon: new Icon(Icons.sports_tennis),
                        text: "Count",
                      ),
                      new Tab(
                        text: "Timed",
                      ),
                    ], controller: _tabController),
                  ),
                ),
                SliverFixedExtentList(
                  itemExtent: 700.0,
                  delegate: SliverChildListDelegate([
                    TabBarView(
                      children: [count(), timed()],
                      controller: _tabController,
                    ),
                  ], addAutomaticKeepAlives: true),
                ),
              ]),
            ),
          );
        }
        return Center(child: Text("Laoding"));
      },
    );
  }
}

@HiveType()
class Custom_Solo extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double number_shot;

  @HiveField(2)
  int solo_time;

  @HiveField(3)
  List<Solo_Defs> sides;

  @HiveField(4)
  int type;
}

class CustomSoloAdapter extends TypeAdapter<Custom_Solo> {
  @override
  final typeId = 12;

  @override
  Custom_Solo read(BinaryReader reader) {
    return Custom_Solo()
      ..name = reader.read()
      ..number_shot = reader.read()
      ..solo_time = reader.read()
      ..sides = reader.read()?.cast<Solo_Defs>()
      ..type = reader.read();
  }

  @override
  void write(BinaryWriter writer, Custom_Solo obj) {
    writer.write(obj.name);
    writer.write(obj.number_shot);
    writer.write(obj.solo_time);
    writer.write(obj.sides);
    writer.write(obj.type);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).splashColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
