import 'dart:math';

import 'package:camera/camera.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:squash/Solo%20home%20page.dart';
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

  Duration total_time = Duration(seconds: 30);

  Color main = Color.fromRGBO(4, 12, 128, 1);

  DateTime time;

  List<Widget> settings;
  int side_count = 2;
  int taraget_count = 50;

  List<String> type_list=["Timed Solo","Target Practice","Shot Count"];

  @override
  void initState() {
    super.initState();
    if (Hive.isBoxOpen(box)) {
      Exersises = Hive.box<Solo_Custom>(box);
    }
    settings = [Time_Input(), Target_input(), round()];
  }

  Future<void> load_hive() async {
    Hive.registerAdapter(Solo_CustomAdapter());

    Exersises = await Hive.openBox<Solo_Custom>(box);
  }


  loadModel() async {
    await Tflite.loadModel(model: "assets/converted_model.tflite", labels: "assets/ball.txt", useGpuDelegate: true,);
  }

  String test (index){

    switch (index) {
      case 0:

        return "Time: "+(Hive.box<Solo_Custom>(box).getAt(index).time/60).floor().toString()+":"+(Hive.box<Solo_Custom>(box).getAt(index).time%60).toString();

      case 1:
      // do something else
        return "Targets: "+Hive.box<Solo_Custom>(box).getAt(index).target_num.toString() ;
      case 2:
      // do something else
        return "Shots: "+Hive.box<Solo_Custom>(box).getAt(index).shot_num.toString() ;
    }

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



  Widget saved_set() {
    return Container(
      height: 210,
      width: MediaQuery.of(context).size.width,
      child: AnimatedList(
          key: _solokey,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          initialItemCount: Hive.box<Solo_Custom>(box).length,
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
                        MaterialPageRoute(builder: (context) => SoloHome(cameras, start_camera, location,shot_number,taraget_count,total_time,segmentedControlGroupValue,side_count)),
                      );

                    },
                    child: Show_Custom_Card(index)),
              ),
            );
          })
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

  show_side_picker() {
    List<Widget> nums = [];

    nums.add(Text(
      "1 Side",
    ));

    for (int x = 2; x < 20; x++) {
      nums.add(Text(
        x.toString() + " Sides",
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
                    side_count = value + 1;
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
                    extra_num= value + 1;
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
                  extra_num= data.inSeconds;

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

  Widget Show_Custom_Card(int index) {
    return Container(
      width: 180,
      height: 180,
      child: Stack(
        children: [
          Positioned(
            top: 5,
            child: Container(
                width: 170,
                height: 170,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),

                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.3, 0.5, 0.9],
                    colors: [
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,

                      //Color.fromRGBO(4, 12, 200, 1),
                      //Color.fromRGBO(4, 12, 200, 1),
                      //Color.fromRGBO(4, 12, 200, 1),
                    ],
                  ),
                ),
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
                              Hive.box<Solo_Custom>(box).getAt(index).name,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: main),
                            )
                          ],
                        ),
                        Divider(
                          color: main,
                          thickness: 2,
                        ),

                        Text(
                         "Type: " +type_list[Hive.box<Solo_Custom>(box).getAt(index).type] ,style: TextStyle(color: Colors.black),
                        ),
                        Text(test(Hive.box<Solo_Custom>(box).getAt(index).type),style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "Sides: "+ Hive.box<Solo_Custom>(box).getAt(index).side_num.toString(),style: TextStyle(color: Colors.black),
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

                  _solokey.currentState.removeItem(index, (context, Animation<double> animation) => ScaleTransition(scale: animation,child: test,));

                  Hive.box<Solo_Custom>(box).getAt(index).delete();
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
                show_side_picker();
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
                          side_count.toString(),
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: main),
                        ),
                        Text("Number of Sides"),
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
                show_side_picker();
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
                          side_count.toString(),
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: main),
                        ),
                        Text("Number of Sides"),
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
              show_side_picker();
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
                        side_count.toString(),
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: main),
                      ),
                      Text("Number of Sides"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: load_hive(),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {


          if(Hive.isBoxOpen(box)){

            return       ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        "Solo Workout",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: main,
                    thickness: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: saved_set(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "Custom Workout",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: main,
                    thickness: 3,
                  ),
                ),

                // Target_input(),

                //round(),
                // Time_Input(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: CupertinoSegmentedControl(
                      borderColor: main,
                      selectedColor: main,
                      groupValue: segmentedControlGroupValue,
                      children: <int, Widget>{0: Text("Time"), 1: Text("Target"), 2: Text("Shot Count")},
                      onValueChanged: (i) {
                        setState(() {
                          segmentedControlGroupValue = i;

                        });
                      }),
                ),

                Container(

                    child: settings[segmentedControlGroupValue]),



                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await loadModel();

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SoloHome(cameras, start_camera, location,shot_number,taraget_count,total_time,segmentedControlGroupValue,side_count)),
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
                      GestureDetector(
                          onTap: () async {


                            await text_dialog();

                            var exersie = Solo_Custom()
                              ..name = name
                              ..type = segmentedControlGroupValue
                              ..side_num = side_count
                              ..target_num = taraget_count
                              ..time = total_time.inSeconds
                              ..shot_num = shot_number;

                            Exersises.add(exersie); // Store this object for the first time

                            _solokey.currentState.insertItem(Exersises.length - 1);




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
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  )),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            );



    }else{

            return Center(child: Text("hiii"));

          }



    })


    );
  }
}

@HiveType()
class Solo_Custom extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int type;

  @HiveField(2)
  int side_num;

  @HiveField(3)
  int target_num;

  @HiveField(4)
  int time;

  @HiveField(5)
  int shot_num;


}

class Solo_CustomAdapter extends TypeAdapter<Solo_Custom> {
  @override
  final typeId = 1;

  @override
  Solo_Custom read(BinaryReader reader) {
    return Solo_Custom()
      ..name = reader.read()
      ..type = reader.read()
      ..side_num = reader.read()
      ..target_num = reader.read()
      ..time = reader.read()
      ..shot_num = reader.read();


  }

  @override
  void write(BinaryWriter writer, Solo_Custom obj) {
    writer.write(obj.name);
    writer.write(obj.type);
    writer.write(obj.side_num);
    writer.write(obj.target_num);
    writer.write(obj.time);
    writer.write(obj.shot_num);

  }
}
