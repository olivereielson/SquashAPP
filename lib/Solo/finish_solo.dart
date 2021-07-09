import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/services.dart';
import 'package:scidart/numdart.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/extra/hive_classes.dart';
import 'package:random_color/random_color.dart';

class Finish_Screen_Solo extends StatefulWidget {
  Finish_Screen_Solo(this.total_shots, this.total_time,this.total_bounces,this.analytics,this.observer);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  List<Bounce> total_bounces;

  String total_time;
  int total_shots;

  @override
  _Finish_ScreenState createState() => _Finish_ScreenState(total_bounces);
}

class _Finish_ScreenState extends State<Finish_Screen_Solo> {

  Color court_color = Color.fromRGBO(40, 45, 81, 1);

  _Finish_ScreenState(this.total_bounces);
  List<Bounce> total_bounces;

  ConfettiController _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
  bool expanded = false;

  List<int> showing = [];
  List<int> show_dots = [];
  List<Color> dots_colors=[];


  @override
  void initState() {

    RandomColor _randomColor = RandomColor();

    for (int i=0;i<SoloDefs().Exersise.length; i++){
      dots_colors.add(_randomColor.randomColor(colorHue: ColorHue.blue));

    }


    for(int i=0; i<total_bounces.length;i++){

      if(!showing.contains(total_bounces[i].type)){

        showing.add(total_bounces[i].type.toInt());
        show_dots.add(total_bounces[i].type.toInt());
      }



    }


    _testSetCurrentScreen();

    super.initState();


  }



  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Finished_Solo_Page',
      screenClassOverride: 'Finished_Solo_Page',
    );
  }

  Widget button_box(String name, int index) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          widget.analytics.logEvent(name: "Solo_View_Button_Toggled");

          if (show_dots.contains(index)) {
            setState(() {
              show_dots.remove(index);
            });
          } else {
            setState(() {
              show_dots.add(index);
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: show_dots.contains(index) ? Theme.of(context).primaryColor : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: Colors.white, width: 3)),
          height: 60,
          width: 130,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: show_dots.contains(index) ? Colors.white : Colors.black),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      ),
    );
  }

  Widget draw_court() {
    Color court_color = Colors.white;

    double h = (MediaQuery.of(context).size.width * 1645) / 1080;

    return Stack(
      children: [
        Positioned(
            bottom: h * 0.44 ,
            child: Container(
              height: 10,
              width: MediaQuery.of(context).size.width,
              color: court_color,
            )),
        Positioned(
            bottom: 0 ,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: h * 0.44,
              width: 10,
              color: court_color,
            )),
        Positioned(
          bottom: (h * 0.44 )-MediaQuery.of(context).size.width / 4 ,
          left: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4 + 10,
            height: MediaQuery.of(context).size.width / 4 + 10,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: court_color,
                  // set border color
                  width: 10.0), // set border width
              // set rounded corner radius
            ),
          ),
        ),
        Positioned(
          bottom: (h * 0.44 )-MediaQuery.of(context).size.width / 4 ,
          right: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4 + 10,
            height: MediaQuery.of(context).size.width / 4 + 10,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: court_color,
                  // set border color
                  width: 10.0), // set border width
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

    for (int i = 0; i < total_bounces.length; i++) {
      //(bounces[i]);

      double x1 = ( total_bounces[i].x_pos * MediaQuery.of(context).size.width) / 1080;
      double y1 = (MediaQuery.of(context).size.height-offset)-(( total_bounces[i].y_pos * (h)) / 1645);

      int gfg =  total_bounces[i].type.toInt();

      Color spot_color = dots_colors[gfg];

      spots.add(Positioned(
        bottom: y1 - 10,
        left: x1 - 10,
        child: Icon(
          Icons.circle,
          size: 20,
          color: show_dots.contains(gfg) ? spot_color : Colors.transparent,
        ),
      ));
    }

    return Stack(
      children: spots,
    );
  }

  Widget single_card(String top_name, String bottom_name, String data) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent,

          border: Border.all(color: Colors.white,width: 3),


          borderRadius: BorderRadius.all(


              Radius.circular(20.0))),

      height: 175,
      width: 175,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              top_name,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            Text(
              bottom_name,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
            )
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      appBar: AppBar(title: Text("Data Analytics",style: TextStyle(fontSize: 30),),elevation: 0,toolbarHeight: 80,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: (){
          Navigator.pop(context);

        }
      ),
      ),


      body: Stack(

        children: [
          draw_court(),
          flat_bounce(),
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              single_card("Total", "Shots",total_bounces.length.toString(),),
              single_card("Total", "Time", widget.total_time.toString().substring(2, 7))



            ],


          )


        ],



      ),


    );
  }

}
