import 'dart:math';
import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:squash/Solo/Solo%20home%20page.dart';
import 'package:squash/Target_page.dart';
import 'package:squash/extra/headers.dart';
import 'package:tflite/tflite.dart';

class SoloScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  SoloScreen(this.cameras);

  @override
  SoloScreenState createState() => new SoloScreenState(cameras);
}

class SoloScreenState extends State<SoloScreen>  with SingleTickerProviderStateMixin{
  SoloScreenState(this.cameras);

  bool delete_mode = false;

  final _solokey = GlobalKey<AnimatedListState>();

  final List<CameraDescription> cameras;
  TabController _tabController;

  bool use_round = false;
  bool use_time = false;
  bool use_target = false;

  String name;

  int extra_num;
  int shot_number = 100;
  int start_camera = 0;
  int segmentedControlGroupValue = 1;
  Point location = Point(250.0, 250.0);
  bool target_locked = false;
  String box = "solo3";
  var Exersises;

  Duration total_time = Duration(seconds: 10);

  Duration rest_time = Duration(seconds: 30);

  Color main = Color.fromRGBO(40, 70, 130, 1);

  DateTime time;

  List<int> sides = [0, 1, 2, 3];

  List<Widget> settings;
  int side_count = 2;
  int taraget_count = 50;

  List<String> type_list = ["Timed Solo", "Target Practice", "Shot Count"];

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/converted_model.tflite",
      labels: "assets/ball.txt",
      useGpuDelegate: Platform.isAndroid?false:true,
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
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            show_shot_picker();
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
                          Text("Number of Shots", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(
                            shot_number.toString(),
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
      ],
    );
  }

  Widget Time_Input() {
    return Column(
      children: [
        GestureDetector(
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
                          Text(
                            "Time on Side",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          Text(
                            total_time.toString().split('.').first.padLeft(8, "0").substring(3),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: main),
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
      ],
    );
  }

  Widget shot(String name, bool selected, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GestureDetector(
        onTap: () {
          if (sides.contains(index)) {
            setState(() {
              sides.remove(index);
            });
          } else {
            setState(() {
              sides.add(index);
            });
          }
        },
        child: Center(
          child: Card(
            elevation: 3,
            color: Color.fromRGBO(40, 70, 130, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: sides.contains(index) ? Colors.white : Color.fromRGBO(40, 70, 130, 1), width: 5),
            ),
            child: Container(
              height: 175,
              width: 120,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 80,
                    width: 130,
                    child: Stack(
                      children: [
                        Positioned(left: 0, top: 15, child: Container(width: 130, height: 5, color: Colors.white)),
                        Positioned(left: 50.0, top: 15, child: Container(width: 5, height: 100, color: Colors.white)),
                        Positioned(left: 25.0, top: 15, child: Container(width: 5, height: 30, color: Colors.white)),
                        Positioned(left: 0.0, top: 40, child: Container(width: 25, height: 5, color: Colors.white)),
                        Positioned(right: 25.0, top: 15, child: Container(width: 5, height: 30, color: Colors.white)),
                        Positioned(right: 0.0, top: 40, child: Container(width: 25, height: 5, color: Colors.white)),
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

  Widget mode_choice() {
    switch (segmentedControlGroupValue) {
      case 0:
        return Time_Input();
      case 1:
        return round();
      case 2:
        return Target_input();
    }
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

  Widget timed(){

    return Stack(

      children: [
        Container(height:20,color:    Color.fromRGBO(50, 50, 100, 1)),

        Container(

            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))),
            child: Column(
              children: [
                Time_Input(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await loadModel();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SoloHome(
                                  cameras: cameras,
                                  start_camera: 0,
                                  type: segmentedControlGroupValue,
                                  time: total_time,
                                  shot_count: shot_number,
                                  sides: sides,
                                )),
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

            )),
      ],
    );


  }

  Widget count(){

    return Column(

      children: [


        Expanded(
          child: Stack(

            children: [
              Container(height:20,color:    Color.fromRGBO(50, 50, 100, 1)),

              Container(

                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))),
                  child: Column(
                    children: [
                      round(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await loadModel();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SoloHome(
                                        cameras: cameras,
                                        start_camera: 0,
                                        type: segmentedControlGroupValue,
                                        time: total_time,
                                        shot_count: shot_number,
                                        sides: sides,
                                      )),
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

                  )),
            ],
          ),
        ),



      ],


    );


  }

  @override
  Widget build(BuildContext context) {

    return NestedScrollView(

      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[

          SliverPersistentHeader(
            pinned: true,
            floating: false,

            delegate: MyDynamicHeader("Solo","Exersise",false),
          ),

          SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                    indicatorColor: Colors.lightBlueAccent,
                    indicatorWeight: 1,
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


        ];



      }, body: SingleChildScrollView(
        child: Column(


          children: [
            Stack(
              children: [
                Container(height:20,color:    Color.fromRGBO(20, 20, 60, 1),),
                Container(
                  height: 250,
                  decoration: BoxDecoration(color: Color.fromRGBO(50, 50, 100, 1), borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [shot("Forehand Drives", true, 0), shot("Backhand Drives", true, 1), shot("Forehand Service Box", true, 2), shot("Backhand Service Box", false, 3)],
                  ),
                ),
              ],
            ),
            Container(
              height: 400,
              child: TabBarView(

              children: [

                count(),timed()




              ],
              controller: _tabController,
    ),
            ),
          ],
        ),
      ),





    );


    return Scaffold(
        body: Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      )),
      child: Stack(
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(color: Color.fromRGBO(20, 20, 50, 1), borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 550,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color.fromRGBO(40, 45, 81, 1),  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),
            ),
          ),
          Column(
            children: [
              Container(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Solo",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Exersise",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white54,
                              ),
                            ),
                          ],
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
                  children: [shot("Forehand Drives", true, 0), shot("Backhand Drives", true, 1), shot("Forehand Service Box", true, 2), shot("Backhand Service Box", false, 3)],
                ),
              ),

              // Target_input(),

              //round(),
              // Time_Input(),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                  child: ListView(

                    children: [
                      Container(
                        height: 70,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [button(0, "Time"), button(1, "Shot Count")],
                        ),
                      ),
                      mode_choice(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await loadModel();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SoloHome(
                                            cameras: cameras,
                                            start_camera: 0,
                                            type: segmentedControlGroupValue,
                                            time: total_time,
                                            shot_count: shot_number,
                                            sides: sides,
                                          )),
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
                ),
              ),
            ],
          ),
        ],
      ),
    ));
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
      color: Color.fromRGBO(20, 20, 50, 1),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }

}