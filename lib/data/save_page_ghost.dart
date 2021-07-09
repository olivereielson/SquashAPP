import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scidart/numdart.dart';

import 'Saved Data Page.dart';
import '../extra/hive_classes.dart';
import '../main.dart';
import 'calculations.dart';

class SavedDataGhost extends StatefulWidget {
  Ghosting ghost_box;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  SavedDataGhost(this.ghost_box,this.analytics,this.observer);

  @override
  SavedGhostState createState() => new SavedGhostState(ghost_box);
}

class SavedGhostState extends State<SavedDataGhost> {
  SavedGhostState(this.ghost_box);

  Ghosting ghost_box;

  Color main = Color.fromRGBO(4, 12, 128, 1);

  bool expanded = false;

  List<int> num_conrer = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  List<int> showing = [0, 1, 2, 3];

  List<FlSpot> speed = [];


  @override
  void initState() {
    for (int i = 0; i < ghost_box.corner_array.length; i++) {
      num_conrer[ghost_box.corner_array[i].toInt()]++;
    }

    speed = DataMethods().SingleSpeed(ghost_box);
    _testSetCurrentScreen();
    super.initState();
  }
  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Old_Ghost_Data_View',
      screenClassOverride: 'Old_Ghost_Data_View',
    );
  }

  Widget ave_speed(data){

if(data.toString()=="Infinity"){

  data=0;

}
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent,

            border: Border.all(color: Colors.white,width: 3),


            borderRadius: BorderRadius.all(


                Radius.circular(20.0))),

        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Average",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  Text(
                    "Speed",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        data.toStringAsFixed(1),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                      Text("Seconds per Ghost",style: TextStyle(color: Colors.white,fontSize: 10),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }
  Widget single_card(String top_name, String bottom_name, String data, Color color) {




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
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
                      ),
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

  Widget Speed() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    "Ghosting Speed",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                  ),
                ),
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: LineChart(
                      LineChartData(
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              left: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                  style: BorderStyle.solid
                              ),
                              right: BorderSide(
                                color: Colors.transparent,
                              ),
                              top: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: true,
                            horizontalInterval: 2,
                            verticalInterval: 2,
                            getDrawingVerticalLine: (value) {


                              return FlLine(
                                color: Colors.transparent,
                                strokeWidth: 1,

                              );
                            },
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.transparent,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          lineTouchData: LineTouchData(
                              enabled: false,
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                              )),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTextStyles: (value) => const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              rotateAngle: 0,
                              getTitles: (val) {
                                if (val == 0) {
                                  return "Start";
                                }

                                if (val == DataMethods().SingleSpeed(ghost_box).length - 1) {
                                  return "End";
                                }

                                return "";
                              },
                              margin: 10,
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) => const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                              getTitles: (val) {
                                return val.toStringAsFixed(0) + " secs";
                              },
                              reservedSize: 20,
                              margin: 20,
                              interval: 2,
                            ),
                          ),
                          minX: 0,
                          maxY: 10,
                          minY: 0,
                          lineBarsData: [
                            LineChartBarData(
                              spots: ghost_box.time_array.length > 0 ?DataMethods().SingleSpeed(ghost_box):[
                                FlSpot(0, 0)
                              ],
                              isCurved: true,
                              colors: [
                                Colors.white,
                                //Color(0xff044d7c),
                                //  Colors.lightBlue,
                              ],
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: false,
                              ),
                              belowBarData: BarAreaData(
                                show: false,
                                colors: [
                                  Color.fromRGBO(20, 20, 50, 1),
                                  Color(0xff044d7c),
                                  Colors.lightBlueAccent,
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
    Color court_color = Theme.of(context).primaryColor;
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
          color: Theme.of(context).primaryColor,
          border: Border.all(
              color: Theme.of(context).primaryColor,
              // set border color
              width: 6.0), // set border width
          borderRadius: BorderRadius.all(Radius.circular(15.0)), // set rounded corner radius
        ),
        child: Center(
            child: Text(
          num_conrer[x].toString(),
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        )),
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
    return  Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      appBar: AppBar(title: Text("Ghosting Analytics",style: TextStyle(fontSize: 30),),
        elevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: (){

            Navigator.pop(context);

          },

        ),
      ),
      body: ListView(
        children: [

          Speed(),

          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20),
            child: Column(
              children: [
                ave_speed(ghost_box.end.difference(ghost_box.start).inSeconds/ghost_box.time_array.length),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    single_card("Total", "Time", ghost_box.end.difference(ghost_box.start).toString().substring(2, 7), Theme.of(context).primaryColor),
                    single_card("Total", "ghosts", ghost_box.time_array.length.toString(), Theme.of(context).primaryColor)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  Widget old(){
    return PageView(
      scrollDirection: Axis.vertical,
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      // set border color
                      width: 6.0), // set border width
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.0), bottomLeft: Radius.circular(25.0)), // set rounded corner radius
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Text(
                          "Data Anylitics",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    single_card("Total", "Time", ghost_box.end.difference(ghost_box.start).toString().substring(2, 7), Theme.of(context).primaryColor),
                    single_card("Total", "ghosts", ghost_box.time_array.length.toString(), Theme.of(context).primaryColor)
                  ],
                ),
              ),
              ghost_box.time_array.length > 0 ? Speed() : Text(""),
            ],
          ),
        ),
        Scaffold(
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
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
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
        ),
      ],
    );

  }

}
