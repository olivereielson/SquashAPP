import 'dart:math';
import 'dart:io' show Platform;

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
import 'package:squash/Solo/Solo%20home%20page.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/Target_page.dart';
import 'package:squash/extra/headers.dart';
import 'package:tflite/tflite.dart';

class SoloScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  SoloScreen(this.cameras,this.analytics,this.observer);

  @override
  SoloScreenState createState() => new SoloScreenState(cameras);
}

class SoloScreenState extends State<SoloScreen> with SingleTickerProviderStateMixin {
  SoloScreenState(this.cameras);

  bool delete_mode = false;


  final List<CameraDescription> cameras;
  TabController _tabController;

  bool use_round = false;
  bool use_time = false;
  bool use_target = false;

  String name;

  int extra_num;
  int shot_number = 100;
  int start_camera = 1;
  int segmentedControlGroupValue = 1;
  Point location = Point(250.0, 250.0);
  bool target_locked = false;
  String box = "solo3";
  var Exersises;

  Duration total_time = Duration(seconds: 10);

  Duration rest_time = Duration(seconds: 30);

  //Color main = Color.fromRGBO(40, 70, 130, 1);
  Color main = Color.fromRGBO(66, 89, 138, 1);

  DateTime time;

  List<int> sides = [];

  List<Widget> settings;
  int side_count = 2;
  int taraget_count = 50;

  bool showGreen = true;



  @override
  void initState() {
    _tabController = new TabController(
      length: 2,
      vsync: this,
    );
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
      model: "assets/converted_model.tflite",
      labels: "assets/ball.txt",
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

  show_shot_picker() {
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
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            show_shot_picker();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 90,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: Theme.of(context).splashColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Icon(
                        EvaIcons.hash,
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
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.caption.color),
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
        show_green(),
      ],
    );
  }

  Widget Target_input() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            show_target_picker();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              height: 90,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: Color.fromRGBO(40, 70, 130, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Icon(
                        EvaIcons.hash,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Number of Targets", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(
                            taraget_count.toString(),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: main),
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
        /*
        GestureDetector(
          onTap: () {
            show_rest_picker();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              height: 90,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: Color.fromRGBO(40, 70, 130, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Icon(
                        Icons.timer,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rest Time", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(
                            rest_time.toString().split('.').first.padLeft(8, "0").substring(3),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: main),
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

         */
      ],
    );
  }

  Widget show_green() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 90,
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(color: Theme.of(context).splashColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(child: FaIcon(FontAwesomeIcons.bullseye)),
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
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(color: Theme.of(context).splashColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Icon(
                          Icons.timer,
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
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.caption.color),
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
        show_green(),

        /*
        GestureDetector(
          onTap: () {
            show_rest_picker();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              height: 90,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: Color.fromRGBO(40, 70, 130, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Icon(
                        Icons.timer,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rest Time", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(
                            rest_time.toString().split('.').first.padLeft(8, "0").substring(3),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: main),
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

         */
      ],
    );
  }

  Widget shot(Map data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();

          if (sides.contains(data["id"])) {
            setState(() {
              sides.remove(data["id"]);
            });
          } else {
            setState(() {
              sides.add(data["id"]);
            });
          }
          sides.sort();
        },
        child: Center(
          child: Card(
            elevation: 3,
            color: Color.fromRGBO(40, 70, 130, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: sides.contains(data["id"]) ? Theme.of(context).primaryColorLight : Color.fromRGBO(40, 70, 130, 1), width: 5),
            ),
            child: Container(
              height: 175,
              width: 110,
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
                        Positioned(left: 0, top: 15, child: Container(width: 130, height: 5, color: Theme.of(context).primaryColorLight)),
                        Positioned(left: 50.0, top: 15, child: Container(width: 5, height: 100, color: Theme.of(context).primaryColorLight)),
                        Positioned(left: 25.0, top: 15, child: Container(width: 5, height: 30, color: Theme.of(context).primaryColorLight)),
                        Positioned(left: 0.0, top: 40, child: Container(width: 25, height: 5, color: Theme.of(context).primaryColorLight)),
                        Positioned(right: 25.0, top: 15, child: Container(width: 5, height: 30, color: Theme.of(context).primaryColorLight)),
                        Positioned(right: 0.0, top: 40, child: Container(width: 25, height: 5, color: Theme.of(context).primaryColorLight)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await loadModel();
                          widget.analytics.logEvent(
                            name: 'Solo_Workout_Started',
                            parameters: <String, dynamic>{
                              'Sides': sides,
                              'Shot_Count':shot_number,
                              'time':total_time,
                              'Type':'Timed'
                            },
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SoloHome(
                                      cameras: cameras,
                                      start_camera: start_camera,
                                      type: 0,
                                      time: total_time,
                                      shot_count: shot_number,
                                      sides: sides,
                                      showgreen: showGreen,
                                    )),
                          );
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (sides.length == 0) {
                                  final snackBar = SnackBar(
                                    content: Text('No Exercises Selected'),
                                    duration: Duration(seconds: 1),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else {
                                  await loadModel();
                                  widget.analytics.logEvent(
                                    name: 'Solo_Workout_Started',
                                    parameters: <String, dynamic>{
                                      'Sides': sides,
                                      'Shot_Count':shot_number,
                                      'time':total_time,
                                      'Type':'Count'
                                    },
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SoloHome(
                                              cameras: cameras,
                                              start_camera: start_camera,
                                              type: 1,
                                              time: total_time,
                                              shot_count: shot_number,
                                              sides: sides,
                                              showgreen: showGreen,
                                            )),
                                  );
                                }
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
                                      color: Theme.of(context).splashColor,
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
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: MyDynamicHeader("Solo", "Exercise", false, true),
        ),
        SliverPersistentHeader(
          pinned: false,
          floating: false,
          delegate: header_shot(

            ListView.builder(

              itemCount: SoloDefs().Exersise.length,

              scrollDirection: Axis.horizontal,


              itemBuilder: (BuildContext context, int index) {

                return shot(SoloDefs().Exersise[index]);

              },



            )

          ),
        ),
        SliverPersistentHeader(
          floating: false,
          pinned: true,
          delegate: _SliverAppBarDelegate(
            TabBar(
                indicatorColor: Colors.lightBlueAccent,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  new Tab(
                    //  icon: new Icon(Icons.sports_tennis),
                    text: "Count",
                  ),
                  new Tab(
                    text: "Timed",
                  ),
                ],
                controller: _tabController),
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
    );

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
      color: Theme.of(context).primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
