import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:squash/Court.dart';
import 'package:squash/Ghosting/home.dart';
import 'package:tflite/tflite.dart';

class GhostScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  GhostScreen(this.cameras);

  @override
  GhostScreenState createState() => new GhostScreenState(cameras);
}

class GhostScreenState extends State<GhostScreen> {
  double number_set = 10;
  double round_num = 2;
  Duration rest_time = Duration(seconds: 30);
  final List<CameraDescription> cameras;
  Duration start_time = Duration(seconds: 10);
  List<double> corners = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  bool delete_mode = false;
  String name = "";
  String box = "Cutsom123";
  final _mylistkey = GlobalKey<AnimatedListState>();
  Color main_color = Colors.lightBlueAccent;
  var Exersises;
  Color main = Color.fromRGBO(40, 70, 130, 1);

  List<Color> title_color = [
    //Colors.lightBlueAccent,
    //Colors.redAccent,
    //Colors.lightGreen,
    //Colors.pinkAccent,
    Color.fromRGBO(4, 12, 128, 1)
  ];

  Future<void> load_hive() async {
    Hive.registerAdapter(CustomAdapter());

    Exersises = await Hive.openBox<Custom>(box);
    print("1");
  }

  @override
  void initState() {
    super.initState();

    if (Hive.isBoxOpen(box)) {
      Exersises = Hive.box<Custom>(box);
    }
  }

  GhostScreenState(this.cameras);

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
      child: Column(
        children: [

          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                Row(
                  children: [
                    icon,
                    Container(width: 30,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(value,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: main),
                        ),
                        Text(title,style: TextStyle(fontSize: 10)),
                      ],
                    ),

                  ],
                ),

                Icon(Icons.chevron_right)
              ],
            ),
          ),

          Divider(
            thickness: 2,
          ),
        ],
      ),
    );

  }


  show_round_picker() {
    List<Widget> nums = [];

    nums.add(Text(
      "1 set",
    ));

    for (int x = 1; x < 50; x++) {
      nums.add(Text(
        x.toString() + " sets",
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

  Widget check(double x) {
    return IconButton(
      onPressed: () {
        setState(() {
          if (corners.contains(x)) {
            corners.remove(x);
          } else {
            corners.add(x);
          }
        });

        print(corners);
      },
      icon: corners.contains(x)
          ? Icon(
              Icons.radio_button_checked,
              color: Colors.blue,
              size: 35,
            )
          : Icon(
              Icons.radio_button_unchecked,
              size: 35,
            ),
    );
  }

  Widget select_corners() {
    return Stack(
      children: [
        Positioned(bottom: 15, child: check(0)),
        Positioned(bottom: 15, right: 10, child: check(1)),
        Positioned(bottom: 150, child: check(2)),
        Positioned(bottom: 150, right: 10, child: check(3)),
        Positioned(bottom: 300, child: check(4)),
        Positioned(bottom: 300, right: 10, child: check(5)),
      ],
    );
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
            new FlatButton(
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

  loadModel() async {
    await Tflite.loadModel(model: "assets/posenet_mv1_075_float_from_checkpoints.tflite", useGpuDelegate: true);
  }

  Widget Show_Custom_Card(int index) {
    return Container(
      width: 205,
      height: 205,
      child: Stack(
        children: [
          Positioned(
            top: 5,
            child: Container(
                width: 200,
                height: 200,


                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              Hive.box<Custom>(box).getAt(index).name,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: main),
                            )
                          ],
                        ),
                        Divider(
                          color: main,
                          thickness: 2,
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).start_time.toString() + " Second count down",style: TextStyle(color: Colors.black,),
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).rest_time.toString() + " Second Rest",style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).number_set.toInt().toString() + " Ghosts",style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).round_num.toInt().toString() + " Rounds",style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          Hive.box<Custom>(box).getAt(index).corners.length.toString() + " Corners ",style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                )),
          ),
          delete_mode
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                      onTap: () {
                        Widget test = Show_Custom_Card(index);

                        _mylistkey.currentState.removeItem(index, (context, Animation<double> animation) => ScaleTransition(scale: animation,child: test,));

                        Hive.box<Custom>(box).getAt(index).delete();
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              color: Colors.black,
                              height: 2,
                              width: 10,
                            )),
                      )),
                )
              : Text(""),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: load_hive(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (Hive.isBoxOpen(box)) {
        return Container(
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

              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Saved Ghosting Sets",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                          delete_mode
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                delete_mode = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                                child: Text("done"),
                              ),
                            ),
                          )
                              : Text("")
                        ],
                      ),
                    ),

                    Container(
                      height: 240,
                      child: AnimatedList(
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
                                      delete_mode = true;
                                    },
                                    onTap: () async {
                                      await loadModel();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                cameras,
                                                Hive.box<Custom>(box).getAt(index).number_set,
                                                Hive.box<Custom>(box).getAt(index).round_num,
                                                Duration(seconds: Hive.box<Custom>(box).getAt(index).rest_time),
                                                Hive.box<Custom>(box).getAt(index).corners,
                                                Hive.box<Custom>(box).getAt(index).start_time)),
                                      );
                                    },
                                    child: Show_Custom_Card(index)),
                              ),
                            );
                          }),
                    ),
                    Padding(


                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "Custom Ghosting Set",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 360,
                        decoration: BoxDecoration(color:Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),

                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [





                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  show_initail_time_picker();
                                },
                                child: input(
                                    "Inital Count Down",
                                    start_time.toString().split('.').first.padLeft(8, "0").substring(3),
                                    Icon(
                                      Icons.timer,
                                      color: main,
                                      size: 30,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  show_time_picker();
                                },
                                child: input(
                                    "Rest time",
                                    rest_time.toString().split('.').first.padLeft(8, "0").substring(3) ,
                                    Icon(
                                      Icons.timer,
                                      color: main,
                                      size: 30,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  show_set_picker();
                                },
                                child: input(
                                    "Number of Ghosts",
                                    number_set.toInt().toString(),
                                    Icon(
                                      EvaIcons.hashOutline,
                                      color: main,
                                      size: 30,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  show_round_picker();
                                },
                                child: input(
                                    "Number of rounds",
                                    round_num.toInt().toString(),
                                    Icon(
                                      EvaIcons.hashOutline,
                                      color: main,
                                      size: 30,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () async {
                                  corners = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Court_Screen(corners)),
                                  );

                                  setState(() {});
                                },
                                child: Hero(
                                    tag: "courtscreen",
                                    child: input(
                                        "Number of Corners",
                                        corners.length.toInt().toString(),
                                        Icon(
                                          Icons.apps,
                                          color: main,
                                          size: 30,
                                        ))),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await loadModel();

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage(cameras, number_set, round_num, rest_time, corners, start_time.inSeconds)),
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
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                                        ))),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                await text_dialog();

                                var exersie = Custom()
                                  ..name = name
                                  ..number_set = number_set
                                  ..round_num = round_num
                                  ..rest_time = rest_time.inSeconds
                                  ..start_time = start_time.inSeconds
                                  ..corners = corners
                                  ..color_index= Random().nextInt(title_color.length);

                                Exersises.add(exersie); // Store this object for the first time

                                _mylistkey.currentState.insertItem(Exersises.length - 1);
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
                                  color: main,
                                  child: Center(
                                      child: Text(
                                        "Save Custom Set",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                                      )),
                                ),
                              )),
                        ],
                      ),
                    ),



                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(child: Text(""));
      }
        },
      ),
    );
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
  int color_index;
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
      ..color_index = reader.read();

  }

  @override
  void write(BinaryWriter writer, Custom obj) {
    writer.write(obj.name);
    writer.write(obj.number_set);
    writer.write(obj.round_num);
    writer.write(obj.rest_time);
    writer.write(obj.start_time);
    writer.write(obj.corners);
    writer.write(obj.color_index);

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
