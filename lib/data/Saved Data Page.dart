import 'dart:math';

import 'package:blobs/blobs.dart';
import 'package:custom_clippers/Clippers/directional_wave_clipper.dart';
import 'package:custom_clippers/Clippers/multiple_points_clipper.dart';
import 'package:custom_clippers/Clippers/sin_cosine_wave_clipper.dart';
import 'package:custom_clippers/enum/enums.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash/data/save_page.dart';
import 'package:squash/data/save_page_ghost.dart';
import 'package:squash/maginfine/touchBubble.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../hive_classes.dart';
import '../maginfine/magnifier.dart';

class SavedDataPage extends StatefulWidget {
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

  List<String> ghost_data_units = ["Ghosts/Second", "Seconds"];

  List<String> solo_data_names = ["Average", "Duration", "Average", "Accuracy", "Average", "Shot Count"];

  List<double> ghost_data = [100, 80];
  List<double> solo_data = [100, 80, 40];

  int solo_index = 0;
  int ghost_index = 0;

  Box<Solo_stroage> solo_storage_box;
  Box<Ghosting> ghosting_box;

  double rest = 0;
  double work = 0;

  List<FlSpot> speed = [];

  @override
  void initState() {
    //load_hive();
    //calculate_data();
    super.initState();
  }

  void calculate_data() {
    speed.clear();

    for (int i = 0; i < ghosting_box.length; i++) {
      if (ghosting_box.getAt(i).rest_time != null && ghosting_box.getAt(i).rounds != null) {
        if (rest == 0 && work == 0) {
          rest = (ghosting_box.getAt(i).rest_time * (ghosting_box.getAt(i).rounds)).toDouble();
          work = ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds - rest;
        } else {
          rest = (rest + (ghosting_box.getAt(i).rest_time * (ghosting_box.getAt(i).rounds)).toDouble()) / 2;
          work = (work + ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds - rest) / 2;
        }

        //print(work);

      }

      if (ghosting_box.getAt(i).time_array.length > 0) {
        print(ghosting_box.getAt(i).time_array);

        var result = ghosting_box.getAt(i).time_array.reduce((num a, num b) => a + b) / ghosting_box.getAt(i).time_array.length;
        speed.add(FlSpot(i.toDouble(), result));
        print(result);
      } else {
        speed.add(FlSpot(i.toDouble(), 8.0));
      }
      print(speed);
    }
  }

  Future<void> load_hive() async {
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(Solo_stroage_Adapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(BounceAdapter());
    }

    if (Hive.isBoxOpen("Solo1")) {
      solo_storage_box = Hive.box<Solo_stroage>("Solo1");
    } else {
      solo_storage_box = await Hive.openBox<Solo_stroage>("Solo1");
    }
  }

  Future<void> load_ghost_hive() async {
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(GhostingAdapter());
    }

    if (Hive.isBoxOpen("Ghosting1")) {
      ghosting_box = Hive.box<Ghosting>("Ghosting1");
    } else {
      ghosting_box = await Hive.openBox<Ghosting>("Ghosting1");
    }
  }

  Widget Speed() {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Ghosting Speed",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 125,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: LineChart(
                  LineChartData(
                      gridData: FlGridData(
                        show: false,
                        drawHorizontalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                          )),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTextStyles: (value) => const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
                          rotateAngle: 90,
                          getTitles: (val) {
                            return DateFormat('Md').format(ghosting_box.getAt(val.toInt()).start).toString();
                          },
                          margin: 8,
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                            color: Color(0xff67727d),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),

                          getTitles: (val) {
                            return val.toInt().toString() + " secs";
                          },
                          reservedSize: 28,
                          margin: 12,
                          interval: 5,
                        ),
                      ),

                      borderData: FlBorderData(show: false,

                          border: Border.fromBorderSide(BorderSide(color: Colors.pink,width: 5,))),
                      lineBarsData: [
                        LineChartBarData(
                          spots: speed,
                          isCurved: true,
                          colors: [
                            Color.fromRGBO(20, 20, 50, 1),
                            Color(0xff044d7c),
                            Colors.lightBlueAccent,
                          ],
                          barWidth: 5,
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
    );
  }

  Widget resting() {
    return Container(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 175,
              width: 175,
              child: PieChart(
                PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sections: [
                      PieChartSectionData(
                        color: Color.fromRGBO(20, 20, 60, 1),
                        value: work,
                        title: work.toInt().toString() + '%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: Color(0xff044d7c),
                        value: rest,
                        title: rest.toInt().toString() + '%',
                        radius: 50,
                        showTitle: true,
                        titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      )
                    ]),
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: Color(0xff044d7c), borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Resting",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: Color.fromRGBO(20, 20, 60, 1), borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ghosting",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget page_3() {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(20, 20, 50, 1),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              Stack(
                children: [
                  Container(
                    height: 50,
                    color: Color.fromRGBO(20, 20, 50, 1),
                  ),
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color.fromRGBO(40, 45, 81, 1), borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                                  radius: 150,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (ghost_data[ghost_index]).toInt().toString(),
                                        style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                                      ),
                                      Text(ghost_data_units[ghost_index], style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
                                    ],
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              ghost_data_names[index * 2],
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white54,
                                              ),
                                              textAlign: TextAlign.center,
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
                                  itemCount: 2,
                                  scrollDirection: Axis.horizontal,
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
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 40,
                      color: Color.fromRGBO(40, 45, 81, 1),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                                    radius: 150,
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                    scrollDirection: Axis.horizontal,
                                    duration: 600,
                                    pagination:
                                        new SwiperPagination(builder: new DotSwiperPaginationBuilder(color: Colors.grey, activeColor: Color.fromRGBO(40, 45, 81, 1), size: 10.0, activeSize: 10.0)),
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
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget page_1() {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(20, 20, 50, 1),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              Stack(
                children: [
                  Container(
                    height: 50,
                    color: Color.fromRGBO(20, 20, 50, 1),
                  ),
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color.fromRGBO(40, 45, 81, 1), borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                          Container(
                            height: 200,
                            child: new Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                switch (index) {
                                  case 1:
                                    return resting();
                                  case 2:
                                    return Speed();
                                  case 8:
                                }

                                return Container(width: 100, color: Colors.transparent, child: Speed());
                              },
                              itemCount: 2,
                              scrollDirection: Axis.horizontal,
                              autoplayDelay: 4000,
                              duration: 1200,
                              pagination: new SwiperPagination(builder: new DotSwiperPaginationBuilder(color: Colors.transparent, activeColor: Colors.transparent, size: 10.0, activeSize: 10.0)),
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
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 40,
                      color: Color.fromRGBO(40, 45, 81, 1),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                                    radius: 150,
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                    scrollDirection: Axis.horizontal,
                                    duration: 600,
                                    pagination:
                                        new SwiperPagination(builder: new DotSwiperPaginationBuilder(color: Colors.grey, activeColor: Color.fromRGBO(40, 45, 81, 1), size: 10.0, activeSize: 10.0)),
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
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget page_2() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color.fromRGBO(20, 20, 50, 1), borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Exersise",
                      style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Data",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                color: Color.fromRGBO(20, 20, 50, 1),
                height: 100,
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(color: Color.fromRGBO(45, 45, 80, 1), borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: load_hive(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (Hive.isBoxOpen("Solo1")) {
                      return ListView.builder(
                        itemCount: solo_storage_box.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true, //just set this property

                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.size, alignment: Alignment.center, duration: Duration(milliseconds: 200), child: SavedData(solo_storage_box.getAt(index))));
                                },
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(color: Color.fromRGBO(20, 20, 60, 1), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: ClipPath(
                                          clipper: CustomClipperImage(),
                                          child: Container(
                                            decoration: BoxDecoration(color: Color.fromRGBO(40, 40, 100, 1), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.sports_tennis,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            Text(DateFormat('MMMMd').format(solo_storage_box.getAt(index).start).toString(),
                                                style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                                            Text(DateFormat('jm').format(solo_storage_box.getAt(index).start).toString(),
                                                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        },
                      );
                    } else {
                      return Text("Loading");
                    }
                  },
                ),
              ),
            ],
          ),
          Expanded(
              child: Stack(
            children: [
              Container(height: 100, color: Color.fromRGBO(45, 45, 80, 1)),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                child: FutureBuilder(
                  future: load_ghost_hive(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (Hive.isBoxOpen("Ghosting1")) {
                      return ListView.builder(
                        itemCount: ghosting_box.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true, //just set this property

                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.size, alignment: Alignment.center, duration: Duration(milliseconds: 200), child: SavedDataGhost(ghosting_box.getAt(index))));
                                },
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(color: Color.fromRGBO(20, 20, 60, 1), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: ClipPath(
                                          clipper: CustomClipperImage2(),
                                          child: Container(
                                            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image(
                                                color: Colors.white,
                                                height: 40,
                                                width: 25,
                                                image: AssetImage(
                                                  'assets/ghost_icon.png',
                                                )),
                                            Text(DateFormat('MMMMd').format(ghosting_box.getAt(index).start).toString(),
                                                style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                                            Text(DateFormat('jm').format(ghosting_box.getAt(index).start).toString(), style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        },
                      );
                    } else {
                      return Text("Loading");
                    }
                  },
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  int pagenum = 0;

  @override
  Widget build(BuildContext context) {
    if (Hive.isBoxOpen("Ghosting1")) {
      calculate_data();
    }

    return Scaffold(
      backgroundColor: pagenum == 0 ? Color.fromRGBO(20, 20, 50, 1) : Colors.white,
      body: PageView(
        allowImplicitScrolling: true,
        pageSnapping: true,
        onPageChanged: (int) {
          setState(() {
            pagenum = int;
          });
        },
        scrollDirection: Axis.vertical,
        children: [
          page_1(),
          page_2(),
        ],
      ),
    );
  }
}
