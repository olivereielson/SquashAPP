import 'dart:async';
import 'dart:math';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:squash/Ghosting/Court.dart';
import 'package:squash/Ghosting/home.dart';
import 'package:squash/extra/data_collection.dart';
import 'package:squash/extra/headers.dart';
import 'package:tflite/tflite.dart';

import '../extra/hive_classes.dart';

class GhostScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  GhostScreen(this.cameras, this.analytics, this.observer);

  @override
  GhostScreenState createState() => new GhostScreenState(cameras);
}

class GhostScreenState extends State<GhostScreen> with SingleTickerProviderStateMixin {
  double number_set = 10;
  double round_num = 2;
  Duration rest_time = Duration(seconds: 30);
  final List<CameraDescription> cameras;
  Duration start_time = Duration(seconds: 10);
  List<double> corners = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  Duration round_time = Duration(minutes: 1);
  bool delete_mode = false;
  String name = "";
  String box = "Cutsom1234";
  final _mylistkey = GlobalKey<AnimatedListState>();
  Color main_color = Colors.lightBlueAccent;
  Box<Custom> Exersises;
  Color main = Color.fromRGBO(40, 70, 130, 1);

  bool is_shaking = false;

  List<Color> title_color = [
    //Colors.lightBlueAccent,
    //Colors.redAccen–t,
    //Colors.lightGreen,
    //Colors.pinkAccent,
    Color.fromRGBO(4, 12, 128, 1)
  ];
  TabController _tabController;

  Future<void> load_hive() async {
    Hive.registerAdapter(CustomAdapter());

    Exersises = await Hive.openBox<Custom>(box);

    setState(() {});
  }

  @override
  void initState() {
    _tabController = new TabController(
      vsync: this,
      length: 2,
    );

    Data_Sender().testSetCurrentScreen(widget.analytics,"Ghosting Selection Page","Ghosting_Selection_Page");

    super.initState();

    if (Hive.isBoxOpen(box)) {
      setState(() {
        Exersises = Hive.box<Custom>(box);
      });
    } else {
      load_hive();
    }
  }

  GhostScreenState(this.cameras);

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Ghosting Page',
      screenClassOverride: 'Ghosting_Page',
    );
  }


  void saved() {
    var exersie = Custom()
      ..name = "default"
      ..number_set = number_set
      ..round_num = round_num
      ..rest_time = rest_time.inSeconds
      ..start_time = start_time.inSeconds
      ..corners = corners
      ..type = 0
      ..round_time = round_time.inSeconds;

    Exersises.add(exersie); // Store this object for the first time

    _mylistkey.currentState.insertItem(Exersises.length - 1);
  }

  show_set_picker() {
    List<Widget> nums = [];
    nums.add(Text(
      "1 Ghost",
    ));
    for (int x = 2; x < 100; x++) {
      nums.add(Text(
        x.toString() + " Ghosts",
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
                scrollController: FixedExtentScrollController(initialItem: number_set.toInt() - 1),
                backgroundColor: Colors.transparent,
                onSelectedItemChanged: (value) {
                  setState(() {
                    number_set = value.toDouble() + 1;
                  });
                },
                itemExtent: 50,
                children: nums),
          );
        });
  }

  Widget input(String title, String value, Icon icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor,width: 3),

            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(height: 50, width: 50, decoration: BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(10))), child: icon),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(
                        value,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Icon(Icons.chevron_right,color: Theme.of(context).primaryColor,)
          ],
        ),
      ),
    );
  }

  show_round_picker() {
    List<Widget> nums = [];

    nums.add(Text("1 set", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)));

    for (int x = 2; x < 50; x++) {
      nums.add(Text(
        x.toString() + " sets",
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
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
                scrollController: FixedExtentScrollController(initialItem: round_num.toInt() - 1),
                backgroundColor: Colors.transparent,
                onSelectedItemChanged: (value) {
                  setState(() {
                    round_num = value.toDouble() + 1;
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
              initialTimerDuration: rest_time,
              onTimerDurationChanged: (data) {
                setState(() {
                  rest_time = data;
                });
              },
            ),
          );
        });
  }

  show_time_set_picker() {
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
              initialTimerDuration: round_time,
              onTimerDurationChanged: (data) {
                setState(() {
                  round_time = data;
                });
              },
            ),
          );
        });
  }

  show_initail_time_picker() {
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
              initialTimerDuration: start_time,
              onTimerDurationChanged: (data) {
                setState(() {
                  start_time = data;
                });
              },
            ),
          );
        });
  }

  void show_dialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("No Corners Selected"),
          content: new Text("Please select at least 1 Corner"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> text_dialog() async {

    String n= await Navigator.push(
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
                  child: Text("Enter Custom Workout Name",style: TextStyle(color: Colors.white,fontSize: 25),),
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

                  onSubmitted: (name){



                    if (name.substring(name.length-1)==""){
                      name=name.substring(0,name.length-1);
                    }


                    Navigator.pop(context,name);


                  },





                )


              ],


            ),
          ),


        ),
      ),
    );



    name = n.toString().toUpperCase();
    if(name.replaceAll(" ", "")==""){

      name="NO NAME";

    }
  }

  text_dialog2() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(18),
          )),
          title: new Text(
            "Name Custom Exersise",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: new TextField(
            autofocus: true,
            decoration: new InputDecoration(
                labelText: 'Custom Name',
                counterStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 10,
                    ),
                    gapPadding: 5),
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white54),
                ),
                labelStyle: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold)),
            maxLength: 6,
            style: TextStyle(color: Colors.white54),
            onSubmitted: (value) {
              name = value;

              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
      useGpuDelegate: true,
    );
  }

  AnimatedList tw() {
    return AnimatedList(
        key: _mylistkey,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        initialItemCount: Hive.box<Custom>(box).length,
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
                    widget.analytics.logEvent(name: "Ghost_Workout_From_Saved_List");


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                cameras,
                                Hive.box<Custom>(box).getAt(index).number_set,
                                Hive.box<Custom>(box).getAt(index).round_num,
                                Duration(seconds: Hive.box<Custom>(box).getAt(index).rest_time),
                                Hive.box<Custom>(box).getAt(index).corners,
                                Hive.box<Custom>(box).getAt(index).start_time,
                                Duration(seconds: Hive.box<Custom>(box).getAt(index).round_time),
                                Hive.box<Custom>(box).getAt(index).type,
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

  Widget Show_Custom_Card(int index) {
    return Container(
      width: 215,
      height: 215,

      child: ShakeAnimatedWidget(
        enabled: is_shaking,
        duration: Duration(milliseconds: 500),
        shakeAngle: Rotation.deg(z: 1),
        curve: Curves.linear,
        child: Stack(
          children: [
            Center(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white,width: 3),


                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  width: 200,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 170,
                                child: AutoSizeText(
                                  Hive.box<Custom>(box).getAt(index).name,
                                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                                  maxLines: 1,

                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).start_time.toString() + " Second count down",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).rest_time.toString() + " Second Rest",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).type == 1
                              ? Hive.box<Custom>(box).getAt(index).number_set.toInt().toString() + " Ghosts"
                              : Duration(seconds: Hive.box<Custom>(box).getAt(index).round_time).toString().substring(2, 7) + " Round Time",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).round_num.toInt().toString() + " Rounds",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).corners.length.toString() + " Corners ",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            is_shaking
                ? Positioned(
                    left: 0,
                    top: 0,
                    child: GestureDetector(
                        onTap: () {
                          if (Exersises.length != 1) {
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
                              Exersises.deleteAt(index);
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
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 200.0,
        child: Container(color: Colors.lightBlue, child: Center(child: Text(headerText))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: load_hive(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (Hive.isBoxOpen(box)) {
            if (Exersises.length == 0) {
              var exersie = Custom()
                ..name = "Default"
                ..number_set = number_set
                ..round_num = round_num
                ..rest_time = rest_time.inSeconds
                ..start_time = start_time.inSeconds
                ..corners = corners
                ..type = 0
                ..round_time = round_time.inSeconds;

              Exersises.add(exersie); // Store this object for the first time
              _mylistkey.currentState.insertItem(0);
            }

            return Scaffold(
              body: GestureDetector(
                onTap: () {
                  setState(() {
                    is_shaking = false;
                  });
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: MyDynamicHeader("Ghosting", "Workout", true,widget.analytics,widget.observer),
                    ),
                    SliverPersistentHeader(
                      pinned: false,
                      floating: false,
                      delegate: header_list(tw()),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: _SliverAppBarDelegate2(TabBar(
                        controller: _tabController,
                        automaticIndicatorColorAdjustment: true,
                        labelColor: Colors.white,
                        indicatorColor: Colors.white60,
                        indicatorWeight: 3,
                        tabs: [
                          new Tab(
                            text: "Timed",
                          ),
                          new Tab(
                            text: "Count",
                          ),
                        ],
                      )),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 700.0,
                      delegate: SliverChildListDelegate(
                        [
                          TabBarView(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        show_initail_time_picker();
                                      },
                                      child: input(
                                          "Inital Count Down",
                                          start_time.toString().split('.').first.padLeft(8, "0").substring(3),
                                          Icon(
                                            Icons.timer,
                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        show_time_picker();
                                      },
                                      child: input(
                                          "Rest time",
                                          rest_time.toString().split('.').first.padLeft(8, "0").substring(3),
                                          Icon(
                                            Icons.timer,

                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        show_time_set_picker();
                                      },
                                      child: input(
                                          "Time Per Round",
                                          round_time.toString().substring(2, 7),
                                          Icon(
                                            Icons.timer,
                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        show_round_picker();
                                      },
                                      child: input(
                                          "Number of rounds",
                                          round_num.toInt().toString(),
                                          Icon(
                                            EvaIcons.hashOutline,
                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        corners = await Navigator.push(context, PageTransition(type: PageTransitionType.size, alignment: Alignment.bottomCenter, child: Court_Screen(corners)));

                                        setState(() {});
                                      },
                                      child: input(
                                          "Number of Corners",
                                          corners.length.toInt().toString(),
                                          Icon(
                                            Icons.apps,
                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await loadModel();
                                            widget.analytics.logEvent(
                                              name: 'Ghosting_Workout_Started',
                                            );

                                            //
                                            //   _sendAnalyticsEvent();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                        cameras,
                                                        number_set,
                                                        round_num,
                                                        rest_time,
                                                        corners,
                                                        start_time.inSeconds,
                                                        round_time,
                                                        0,
                                                        analytics: widget.analytics,
                                                        observer: widget.observer,
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
                                                  color: Theme.of(context).splashColor,
                                                  child: Center(
                                                      child: Text(
                                                    "Start",
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                                  ))),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () async {
                                              await text_dialog();
                                              widget.analytics.logEvent(
                                                name: 'Ghosting_Workout_Saved',
                                                parameters: <String, dynamic>{
                                                  'name': name,
                                                  'number_set':number_set,
                                                  'round_num':round_num,
                                                  'rest_time':rest_time,
                                                  'start_time':start_time,
                                                  'corners':corners.length,
                                                  'round_time':round_time,
                                                  'type': _tabController.index==0?"count":"timed"
                                                },

                                              );
                                              if (name != null && name != "") {
                                                var exersie = Custom()
                                                  ..name = name
                                                  ..number_set = number_set
                                                  ..round_num = round_num
                                                  ..rest_time = rest_time.inSeconds
                                                  ..start_time = start_time.inSeconds
                                                  ..corners = corners
                                                  ..type = _tabController.index
                                                  ..round_time = round_time.inSeconds;

                                                Exersises.add(exersie); // Store this object for the first time
                                                _mylistkey.currentState.insertItem(0);
                                              }
                                            },
                                            child: Container(
                                              width: 200,
                                              height: 50,
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
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                                )),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        show_initail_time_picker();
                                      },
                                      child: input(
                                          "Inital Count Down",
                                          start_time.toString().split('.').first.padLeft(8, "0").substring(3),
                                          Icon(
                                            Icons.timer,
                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        show_time_picker();
                                      },
                                      child: input(
                                          "Rest time",
                                          rest_time.toString().split('.').first.padLeft(8, "0").substring(3),
                                          Icon(
                                            Icons.timer,
                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        show_set_picker();
                                      },
                                      child: input(
                                          "Number of Ghosts",
                                          number_set.toInt().toString(),
                                          Icon(
                                            EvaIcons.hashOutline,
                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        show_round_picker();
                                      },
                                      child: input(
                                          "Number of rounds",
                                          round_num.toInt().toString(),
                                          Icon(
                                            EvaIcons.hashOutline,
                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        corners = await Navigator.push(context, PageTransition(type: PageTransitionType.size, alignment: Alignment.bottomCenter, child: Court_Screen(corners)));

                                        setState(() {});
                                      },
                                      child: input(
                                          "Number of Corners",
                                          corners.length.toInt().toString(),
                                          Icon(
                                            Icons.apps,
                                            color:Theme.of(context).primaryColor,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {

                                            widget.analytics.logEvent(
                                              name: 'Ghosting_Workout_Start',
                                            );

                                            await loadModel();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                        cameras,
                                                        number_set,
                                                        round_num,
                                                        rest_time,
                                                        corners,
                                                        start_time.inSeconds,
                                                        round_time,
                                                        1,
                                                        analytics: widget.analytics,
                                                        observer: widget.observer,
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
                                                  color: Theme.of(context).splashColor,
                                                  child: Center(
                                                      child: Text(
                                                    "Start",
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                                  ))),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () async {

                                              await text_dialog();

                                              widget.analytics.logEvent(
                                                name: 'Ghosting_Workout_Saved',
                                                parameters: <String, dynamic>{
                                                  'name': name,
                                                  'number_set':number_set,
                                                  'round_num':round_num,
                                                  'rest_time':rest_time,
                                                  'start_time':start_time,
                                                  'corners':corners.length,
                                                  'round_time':round_time,
                                                  'type': _tabController.index==0?"count":"timed"
                                                },

                                              );


                                              if (name != null && name != "") {
                                                var exersie = Custom()
                                                  ..name = name
                                                  ..number_set = number_set
                                                  ..round_num = round_num
                                                  ..rest_time = rest_time.inSeconds
                                                  ..start_time = start_time.inSeconds
                                                  ..corners = corners
                                                  ..type = _tabController.index
                                                  ..round_time = round_time.inSeconds;

                                                Exersises.add(exersie); // Store this object for the first time
                                                _mylistkey.currentState.insertItem(0);
                                              }
                                            },
                                            child: Container(
                                              width: 200,
                                              height: 50,
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
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                                )),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            controller: _tabController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Text("");
          }
        });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

@HiveType()
class Custom extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double number_set;

  @HiveField(2)
  double round_num;

  @HiveField(3)
  int rest_time;

  @HiveField(4)
  int start_time;

  @HiveField(5)
  List<double> corners;

  @HiveField(6)
  int type;

  @HiveField(7)
  int round_time;
}

class CustomAdapter extends TypeAdapter<Custom> {
  @override
  final typeId = 0;

  @override
  Custom read(BinaryReader reader) {
    return Custom()
      ..name = reader.read()
      ..number_set = reader.read()
      ..round_num = reader.read()
      ..rest_time = reader.read()
      ..start_time = reader.read()
      ..corners = reader.read()
      ..type = reader.read()
      ..round_time = reader.read();
  }

  @override
  void write(BinaryWriter writer, Custom obj) {
    writer.write(obj.name);
    writer.write(obj.number_set);
    writer.write(obj.round_num);
    writer.write(obj.rest_time);
    writer.write(obj.start_time);
    writer.write(obj.corners);
    writer.write(obj.type);
    writer.write(obj.round_time);
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

class _SliverAppBarDelegate2 extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate2(this._tabBar);

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
  bool shouldRebuild(_SliverAppBarDelegate2 oldDelegate) {
    return true;
  }
}
