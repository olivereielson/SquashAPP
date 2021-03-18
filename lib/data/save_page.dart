import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scidart/numdart.dart';

import 'Saved Data Page.dart';
import '../extra/hive_classes.dart';
import '../main.dart';

class SavedData extends StatefulWidget {
  Solo_stroage solo_storage_box;

  SavedData(this.solo_storage_box);

  @override
  SavedDataState createState() => new SavedDataState(solo_storage_box);
}

class SavedDataState extends State<SavedData> {
  SavedDataState(this.solo_storage_box);

  Solo_stroage solo_storage_box;

  Color main = Color.fromRGBO(4, 12, 128, 1);

  bool expanded = false;

  List<int> showing = [0, 1, 2, 3];

  Widget button_box(String name, int index) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          if (showing.contains(index)) {
            setState(() {
              showing.remove(index);
            });
          } else {
            setState(() {
              showing.add(index);
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(color: showing.contains(index) ? Colors.white : Colors.white10, borderRadius: BorderRadius.all(Radius.circular(20.0))),
          height: 60,
          width: 130,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: showing.contains(index) ? Colors.black : Colors.white),
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
  }

  Widget draw_court() {
    Color court_color = Color.fromRGBO(40, 45, 81, 1);

    double h = (MediaQuery.of(context).size.width * 1645) / 1080;

    double offset = MediaQuery.of(context).size.height - h;

    return Stack(
      children: [
        Positioned(
            top: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(color: court_color, borderRadius: BorderRadius.only(bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40))),
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Column(
                  children: [
                    ExpansionTile(
                      leading: IconButton(
                        icon: Icon(Icons.close,color: Colors.white,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      trailing:Icon(expanded?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,color: Colors.white,) ,

                      onExpansionChanged: (bool) {
                        setState(() {
                          expanded = bool;
                        });
                      },
                      title: Center(
                          child: Text(
                        'Statistics',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            height: 90,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                    child: Icon(Icons.timer),
                                  ),
                                ),
                                Text(
                                  "Duration",
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    solo_storage_box.end.difference(solo_storage_box.start).toString().substring(2, 7),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            height: 90,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                    child: Icon(EvaIcons.hashOutline),
                                  ),
                                ),
                                Text(
                                  "Total Shots",
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    solo_storage_box.bounces.length.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  button_box("Forehand Drives", 0),
                                  button_box("BackHand Drives", 1),
                                ],
                              ),
                              Column(
                                children: [button_box("Forehand Service Box", 2), button_box("Backhand Service Box", 3)],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
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

  Widget flat_bounce() {
    List<Widget> spots = [];
    double h = (MediaQuery.of(context).size.width * 1645) / 1080;

    double offset = MediaQuery.of(context).size.height - h;

    for (int i = 0; i < solo_storage_box.bounces.length; i++) {
      //(bounces[i]);

      double x1 = (solo_storage_box.bounces[i].x_pos * MediaQuery.of(context).size.width) / 1080;
      double y1 = ((solo_storage_box.bounces[i].y_pos * h) / 1645) + offset;

      Color spot_color = Colors.black;

      int gfg = solo_storage_box.bounces[i].type.toInt();

      switch (gfg) {
        case 0:
          {
            spot_color = Colors.blue;
          }
          break;

        case 1:
          {
            spot_color = Colors.redAccent;
          }
          break;
        case 2:
          {
            spot_color = Colors.green;
          }
          break;
        case 3:
          {
            spot_color = Colors.pink;
          }
          break;
      }

      spots.add(Positioned(
        top: y1 - 10,
        left: x1 - 10,
        child: Icon(
          Icons.circle,
          size: 20,
          color: showing.contains(gfg)?spot_color:Colors.transparent,
        ),
      ));
    }

    return Stack(
      children: spots,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          draw_court(),
          flat_bounce(),
        ],
      ),
    );
  }
}
