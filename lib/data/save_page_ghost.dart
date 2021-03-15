import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scidart/numdart.dart';

import 'Saved Data Page.dart';
import '../hive_classes.dart';
import '../main.dart';

class SavedDataGhost extends StatefulWidget {
  Ghosting ghost_box;

  SavedDataGhost(this.ghost_box);

  @override
  SavedGhostState createState() => new SavedGhostState(ghost_box);
}

class SavedGhostState extends State<SavedDataGhost> {
  SavedGhostState(this.ghost_box);

  Ghosting ghost_box;

  Color main = Color.fromRGBO(4, 12, 128, 1);

  bool expanded = false;

  List<int> num_conrer=[0,0,0,0,0,0,0,0,0,0];

  List<int> showing = [0, 1, 2, 3];


  @override
  void initState() {

    for( int i =0; i < ghost_box.corner_array.length; i++){

      num_conrer[ghost_box.corner_array[i].toInt()]++;

    }



    super.initState();
  }


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
   Color court_color=Color.fromRGBO(40, 45, 81, 1);
    return Stack(
      children: [
        Positioned(
            top: MediaQuery.of(context).size.height / 2,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: court_color,
            )),
        Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: 15,
              color: court_color,
            )),
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          left: -15,
          child: Container(
            width: 125.0,
            height: 125.0,
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
          top: MediaQuery.of(context).size.height / 2,
          right: -15,
          child: Container(
            width: 125.0,
            height: 125.0,
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

  Widget check(int x) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Color.fromRGBO(40, 70, 130, 1),
          border: Border.all(
              color: Color.fromRGBO(40, 70, 130, 1),
              // set border color
              width: 6.0), // set border width
          borderRadius: BorderRadius.all(Radius.circular(15.0)), // set rounded corner radius
        ),

        child: Center(child: Text(num_conrer[x].toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),

      ),
    );
  }
  Widget select_corners() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [check(0), check(1)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [check(2), check(3)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [check(4), check(5)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [check(6), check(7)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [check(8), check(9)],
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    print(ghost_box.corner_array);

    return Scaffold(
      body: Stack(
        children: [
          draw_court(),
          select_corners(),
          Positioned(
              top: -20,
              left: (MediaQuery.of(context).size.width - 170) / 2,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                      width: 170,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(40, 45, 81, 1),
                          border: Border.all(
                            color: Color.fromRGBO(40, 45, 81, 1),
                          ),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                      child: Center(
                          child: Text(
                            "Close",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          ))),
                ),
              )),
        ],
      ),
    );
  }
}
