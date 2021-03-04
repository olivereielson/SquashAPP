import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:squash/maginfine/touchBubble.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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

  List<String> ghost_data_names = [
    "Average",
    "Speed",
    "Average",
    "Duration",
  ];

  List<String> solo_data_names = ["Average", "Duration", "Average", "Accuracy", "Average", "Shot Count"];

  List<double> ghost_data = [100, 80, 40];
  List<double> solo_data = [100, 80, 40];

  int solo_index = 0;
  int ghost_index = 0;

  Offset position;
  double currentBubbleSize;
  bool magnifierVisible = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(20, 20, 50, 1), borderRadius: BorderRadius.all(Radius.circular(20))),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Data",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Analytics",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 200,
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color.fromRGBO(40, 45, 81, 1), borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Ghosting Data", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 30)),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                        child: CircularPercentIndicator(
                          progressColor: Color.fromRGBO(20, 20, 50, 1),
                          arcBackgroundColor: Colors.transparent,
                          arcType: ArcType.FULL,
                          lineWidth: 20,
                          percent: (ghost_data[ghost_index] / 100),
                          radius: 180,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            ghost_data[ghost_index].toInt().toString(),
                            style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          animation: true,
                          animateFromLastPercent: true,
                          animationDuration: 1200,
                          startAngle: 90.0,
                          backgroundWidth: 10,
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 170,
                        child: new Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ghost_data_names[index * 2],
                                      style: TextStyle(fontSize: 30, color: Colors.white54),
                                    ),
                                    Text(
                                      ghost_data_names[(index * 2) + 1],
                                      style: TextStyle(fontSize: 30, color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          itemCount: ghost_data_names.length ~/ 2,
                          scrollDirection: Axis.vertical,
                          autoplayDelay: 4000,
                          duration: 1200,
                          pagination: new SwiperPagination(builder: new DotSwiperPaginationBuilder(color: Colors.grey, activeColor: Colors.white, size: 10.0, activeSize: 10.0)),
                          control: new SwiperControl(
                            color: Colors.transparent,
                          ),
                          loop: true,
                          onIndexChanged: (index) {
                            setState(() {
                              ghost_index = index;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Text(
                      "Solo Data",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CircularPercentIndicator(
                          progressColor: Color.fromRGBO(40, 45, 81, 1),
                          arcBackgroundColor: Colors.transparent,
                          arcType: ArcType.FULL,
                          lineWidth: 20,
                          percent: (solo_data[solo_index] / 100),
                          radius: 170,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            solo_data[solo_index].toInt().toString(),
                            style: TextStyle(color: Color.fromRGBO(40, 45, 81, 1), fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          animation: true,
                          animateFromLastPercent: true,
                          animationDuration: 600,
                          startAngle: 0.45,
                          backgroundWidth: 10,
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 200,
                        color: Colors.transparent,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      solo_data_names[index * 2],
                                      style: TextStyle(fontSize: 30, color: Color.fromRGBO(40, 45, 81, 1), fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      solo_data_names[(index * 2) + 1],
                                      style: TextStyle(fontSize: 30, color: Color.fromRGBO(40, 45, 81, 1), fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          itemCount: solo_data_names.length ~/ 2,
                          scrollDirection: Axis.vertical,
                          duration: 600,
                          pagination: new SwiperPagination(builder: new DotSwiperPaginationBuilder(color: Colors.grey, activeColor: Color.fromRGBO(40, 45, 81, 1), size: 10.0, activeSize: 10.0)),
                          control: new SwiperControl(
                            color: Colors.transparent,
                            disableColor: Colors.pink,
                          ),
                          loop: true,
                          onIndexChanged: (index) {
                            setState(() {
                              solo_index = index;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
