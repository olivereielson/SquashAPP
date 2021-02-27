import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squash/maginfine/touchBubble.dart';

import 'maginfine/magnifier.dart';

class SavedDataPage extends StatefulWidget {
  DateTime date;
  String duration;
  String bounces;

  //SavedDataPage(this.date, this.duration, this.bounces);

  @override
  SavedDataPageSate createState() => new SavedDataPageSate();
}



class SavedDataPageSate extends State<SavedDataPage> {

  static const double touchBubbleSize = 50;

  Offset position;
  double currentBubbleSize;
  bool magnifierVisible = false;

  @override
  void initState() {
    currentBubbleSize = touchBubbleSize;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Magnifier(
          position: position,
          visible: magnifierVisible,
          child: Image(image: AssetImage('assets/lenna.png')),
        ),
        TouchBubble(
          position: position,
          bubbleSize: currentBubbleSize,
          onStartDragging: _startDragging,
          onDrag: _drag,
          onEndDragging: _endDragging,
        ),
      ],
    );
  }
  void _startDragging(Offset newPosition) {
    setState(() {
      magnifierVisible = true;
      position = newPosition;
      currentBubbleSize = touchBubbleSize * 1.5;
    });
  }
  void _drag(Offset newPosition) {
    setState(() {
      position = newPosition;
    });
  }
  void _endDragging() {
    setState(() {
      currentBubbleSize = touchBubbleSize;
      magnifierVisible = false;
    });
  }


}


/*
class SavedDataPageSate extends State<SavedDataPage> {
  Color main = Color.fromRGBO(4, 12, 128, 1);

  List<Point> bounces = [];

  @override
  void initState() {

    List<String> string_bounce = widget.bounces.replaceAll("]", "").replaceAll("[", "").replaceAll("Point", "").replaceAll("(", "").split("),");

    for (int i = 0; i < string_bounce.length; i++) {
      List<String> p = string_bounce[i].replaceAll(")", "").split(",");

      bounces.add(Point(double.parse(p[0]), double.parse(p[1])));
    }

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [

          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                    child: Text("Close",style: TextStyle(color: Colors.black),),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pop())
              ],
            ),
          ),


          draw_court(), flat_bounce()],
      ),
    );
  }
}


 */