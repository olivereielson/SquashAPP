import 'dart:math';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:blobs/blobs.dart';
import 'package:custom_clippers/Clippers/directional_wave_clipper.dart';
import 'package:custom_clippers/Clippers/multiple_points_clipper.dart';
import 'package:custom_clippers/Clippers/sin_cosine_wave_clipper.dart';
import 'package:custom_clippers/enum/enums.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scidart/numdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import 'package:squash/data/save_page.dart';
import 'package:squash/data/save_page_ghost.dart';
import 'package:squash/extra/headers.dart';
import 'package:squash/maginfine/touchBubble.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../extra/hive_classes.dart';
import '../maginfine/magnifier.dart';

class SavedDataPage extends StatefulWidget {
  //SavedDataPage(this.date, this.duration, this.bounces);

  @override
  SavedDataPageSate createState() => new SavedDataPageSate();
}

class SavedDataPageSate extends State<SavedDataPage> with SingleTickerProviderStateMixin {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();
  final GlobalKey<SliverAnimatedListState> _listKey2 = GlobalKey<SliverAnimatedListState>();

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

  int ave_solo_dur;
  int ave_shot_num;

  int ave_ghost_dur;
  int ave_ghost_num;
  double accuracy;

  List<double> solo_type_pie_chart_data = [0, 0, 0, 0];
  List<double> ghost_type_pie_chart_data = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  List<Color> type_pie_color = [
    Colors.lightBlue,
    Colors.grey,
    Color.fromRGBO(20, 20, 60, 1),
    Color(0xff044d7c),
    Colors.lightBlue,
    Colors.lightBlue,
    Colors.lightBlue,
    Colors.lightBlue,
    Colors.lightBlue,
    Colors.lightBlue,
    Colors.lightBlue,
  ];

  TabController _tabController;

  bool is_shaking = false;

  List<FlSpot> speed = [];

  @override
  void initState() {
    //load_hive();
    //calculate_data();
    _tabController = new TabController(length: 3, vsync: this);

    super.initState();
  }

  void calculate_solo() {

    var n = Array([]);

    List<double> xL =[];
    List<double> yL =[];




    for (int i = 0; i < solo_storage_box.length; i++) {
      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {
        solo_type_pie_chart_data[solo_storage_box.getAt(i).bounces[x].type.toInt()]++;

        //xL.add(solo_storage_box.getAt(i).bounces[x].x_pos);
        //yL.add(solo_storage_box.getAt(i).bounces[x].y_pos);

        //print(hypotenuse(solo_storage_box.getAt(i).bounces[x].y_pos,solo_storage_box.getAt(i).bounces[x].x_pos));
        n.add(hypotenuse(solo_storage_box.getAt(i).bounces[x].y_pos,solo_storage_box.getAt(i).bounces[x].x_pos));


      }
    }

    //double x_avge= xL.reduce((a, b) => a + b)/xL.length;
    //double y_avge=yL.reduce((a, b) => a + b)/yL.length;


    print(100-(standardDeviation(n)*100/mean(n)));
    accuracy=100-(standardDeviation(n)*100/mean(n));

    for (int i = 0; i < solo_storage_box.length; i++) {
      if (ave_solo_dur == null) {
        ave_solo_dur = solo_storage_box.getAt(i).end.difference(solo_storage_box.getAt(i).start).inSeconds;
      } else {
        ave_solo_dur = (solo_storage_box.getAt(i).end.difference(solo_storage_box.getAt(i).start).inSeconds + ave_solo_dur) ~/ 2;
      }

      if (ave_shot_num == null) {
        ave_shot_num = solo_storage_box.getAt(i).bounces.length;
      } else {
        ave_shot_num = (solo_storage_box.getAt(i).bounces.length + ave_shot_num) ~/ 2;
      }
    }

    for (int i = 0; i < solo_storage_box.length; i++) {




    }

    }

  void calculate_ghost() {
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
      //print(speed);

      if (ave_ghost_dur == null) {
        ave_ghost_dur = ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds;
      } else {
        ave_ghost_dur = (ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds + ave_ghost_dur) ~/ 2;
      }

      if (ave_ghost_dur == null) {
        ave_ghost_dur = ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds;
      } else {
        ave_ghost_dur = (ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds + ave_ghost_dur) ~/ 2;
      }

      if (ave_ghost_num == null) {
        ave_ghost_num = ghosting_box.getAt(i).corner_array.length;
      } else {
        ave_ghost_num = (ghosting_box.getAt(i).corner_array.length + ave_ghost_num) ~/ 2;
      }
    }

    for (int i = 0; i < ghosting_box.length; i++) {
      for (int x = 0; x < ghosting_box.getAt(i).corner_array.length; x++) {
        ghost_type_pie_chart_data[ghosting_box.getAt(i).corner_array[x].toInt()]++;
      }
    }
    print(ghost_type_pie_chart_data);
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
    setState(() {
      calculate_solo();
    });
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
    setState(() {
      calculate_ghost();
    });
  }

  Widget Speed() {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                "Average Ghosting Speed",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                          reservedSize: 40,
                          getTextStyles: (value) => const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
                          rotateAngle: 90,
                          getTitles: (val) {
                            return DateFormat('Md').format(ghosting_box.getAt(val.toInt()).start).toString();
                          },
                          margin: 20,
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
                      borderData: FlBorderData(
                          show: false,
                          border: Border.fromBorderSide(BorderSide(
                            color: Colors.pink,
                            width: 5,
                          ))),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 250,
              width: 200,
              child: PieChart(
                PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sections: [
                      PieChartSectionData(
                        color: Color.fromRGBO(20, 20, 60, 1),
                        value: work,
                        title: (work / (work + rest) * 100).toInt().toString() + '%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: Color(0xff044d7c),
                        value: rest,
                        title: (rest / (work + rest) * 100).ceil().toString() + '%',
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Work Vs Rest",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
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
                        style: TextStyle(color: Colors.grey),
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
                        style: TextStyle(color: Colors.grey),
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

  Widget type_pie_chart() {
    var sum = solo_type_pie_chart_data.reduce((a, b) => a + b);

    return Container(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 250,
              width: 180,
              child: PieChart(
                PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sections: [
                      PieChartSectionData(
                        color: type_pie_color[0],
                        value: solo_type_pie_chart_data[0],
                        title: ((solo_type_pie_chart_data[0] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:((solo_type_pie_chart_data[0] / sum) * 100).toInt()==0?Colors.transparent: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[1],
                        value: solo_type_pie_chart_data[1],
                        title: ((solo_type_pie_chart_data[1] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:((solo_type_pie_chart_data[1] / sum) * 100).toInt()==0?Colors.transparent: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[2],
                        value: solo_type_pie_chart_data[2],
                        title: ((solo_type_pie_chart_data[2] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:((solo_type_pie_chart_data[2] / sum) * 100).toInt()==0?Colors.transparent: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[3],
                        value: solo_type_pie_chart_data[3],
                        title: ((solo_type_pie_chart_data[3] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        showTitle: true,
                        titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color:((solo_type_pie_chart_data[3] / sum) * 100).toInt()==0?Colors.transparent: Colors.white),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Solo\nBreakDown",
                    style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: type_pie_color[0], borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Forehand Drives",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: type_pie_color[1], borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "BackHand Drives",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: type_pie_color[2], borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Forehand Service Box",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: type_pie_color[3], borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "BackHand Service Box",
                        style: TextStyle(color: Colors.grey),
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

  Widget ghost_type_pie_chart() {
    var sum = ghost_type_pie_chart_data.reduce((a, b) => a + b);

    return Container(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 250,
              width: 180,
              child: PieChart(
                PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),

                    sections: [
                      PieChartSectionData(
                        color: type_pie_color[0],
                        value: ghost_type_pie_chart_data[0],
                        title: ((ghost_type_pie_chart_data[0] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[1],
                        value: ghost_type_pie_chart_data[1],
                        title: ((ghost_type_pie_chart_data[1] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[2],
                        value: ghost_type_pie_chart_data[2],
                        title: ((ghost_type_pie_chart_data[2] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[3],
                        value: ghost_type_pie_chart_data[3],
                        title: ((ghost_type_pie_chart_data[3] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        showTitle: true,
                        titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,

                      ),
                      PieChartSectionData(
                        color: type_pie_color[4],
                        value: ghost_type_pie_chart_data[4],
                        title: ((ghost_type_pie_chart_data[4] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        showTitle: true,
                        titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[5],
                        value: ghost_type_pie_chart_data[5],
                        title: ((ghost_type_pie_chart_data[5] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        showTitle: true,
                        titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[6],
                        value: ghost_type_pie_chart_data[6],
                        title: ((ghost_type_pie_chart_data[6] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        showTitle: true,
                        titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[7],
                        value: ghost_type_pie_chart_data[7],
                        title: ((ghost_type_pie_chart_data[7] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        showTitle: true,
                        titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[8],
                        value: ghost_type_pie_chart_data[8],
                        title: ((ghost_type_pie_chart_data[8] / sum) * 100).toInt().toString() + '%',
                        radius: 50,
                        showTitle: true,
                        titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,
                      ),
                      PieChartSectionData(
                        color: type_pie_color[9],
                        value: ghost_type_pie_chart_data[9],
                        title: ((ghost_type_pie_chart_data[9] / sum) * 100).toInt().toString() + '%',
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Solo\nBreakDown",
                    style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: type_pie_color[0], borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Forehand Drives",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: type_pie_color[1], borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "BackHand Drives",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: type_pie_color[2], borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Forehand Service Box",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(color: type_pie_color[3], borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "BackHand Service Box",
                        style: TextStyle(color: Colors.grey),
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

  Widget ghost_saved(int index) {
    return ShakeAnimatedWidget(
      enabled: is_shaking,
      duration: Duration(milliseconds: 500),
      shakeAngle: Rotation.deg(z: 1),
      curve: Curves.linear,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GestureDetector(
                onLongPress: () {
                  setState(() {
                    is_shaking = true;
                  });
                },
                onTap: () {
                  if (!is_shaking) {
                    Navigator.push(
                        context, PageTransition(type: PageTransitionType.size, alignment: Alignment.center, duration: Duration(milliseconds: 200), child: SavedDataGhost(ghosting_box.getAt(index))));
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))),
                  elevation: 10,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(color: Color.fromRGBO(20, 20, 60, 1), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Stack(
                      children: [
                        Center(
                          child: ClipPath(
                            clipper: CustomClipperImage2(),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Image(
                                    color: Colors.white,
                                    height: 40,
                                    width: 25,
                                    image: AssetImage(
                                      'assets/ghost_icon.png',
                                    )),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(DateFormat('MMMMd').format(ghosting_box.getAt(index).start).toString(), style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text(DateFormat('jm').format(ghosting_box.getAt(index).start).toString(), style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Spacer(),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            is_shaking
                ? Positioned(
                    top: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        Widget temp=ghost_saved(index);

                        _listKey2.currentState.removeItem(index, (context, animation) => SizeTransition(sizeFactor: animation, child: temp), duration: Duration(milliseconds: 500));
                        setState(() {
                          ghosting_box.deleteAt(index);
                        });
                      },
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey,
                          )),
                    ))
                : Text("")
          ],
        ),
      ),
    );
  }

  Widget Solo_Saved(int index) {
    return ShakeAnimatedWidget(
      enabled: is_shaking,
      duration: Duration(milliseconds: 500),
      shakeAngle: Rotation.deg(z: 1),
      curve: Curves.linear,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GestureDetector(
              onLongPress: () {
                setState(() {
                  is_shaking = true;
                });
              },
              onTap: () {
                if (!is_shaking) {
                  Navigator.push(
                      context, PageTransition(type: PageTransitionType.size, alignment: Alignment.center, duration: Duration(milliseconds: 200), child: SavedData(solo_storage_box.getAt(index))));
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))),
                elevation: 10,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.sports_tennis,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(DateFormat('MMMMd').format(solo_storage_box.getAt(index).start).toString(), style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold)),
                                Text(DateFormat('jm').format(solo_storage_box.getAt(index).start).toString(), style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
             Positioned(
                top: 0,
                left: 0,
                child: is_shaking?GestureDetector(
                  onTap: () {
                    Widget temp=Solo_Saved(index);
                    solo_storage_box.deleteAt(index);

                    _listKey.currentState.removeItem(index, (context, animation) => SizeTransition(sizeFactor: animation, child: temp), duration: Duration(milliseconds: 500));
                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      )),
                ):Text(""))

          ],
        ),
      ),
    );
  }

  Widget single_card(String top_name, String bottom_name, String data, Color color) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))),
      child: Container(
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
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(40))),
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                bottom_name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget page_2() {
    return GestureDetector(
      onTap: () {
        setState(() {
          is_shaking = false;
        });
      },
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (Hive.isBoxOpen("Ghosting1") && Hive.isBoxOpen("Solo1") && solo_storage_box.length + ghosting_box.length != 0) {
            return CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  // This is the flip side of the SliverOverlapAbsorber
                  // above.

                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverAnimatedList(
                    key: _listKey, initialItemCount: solo_storage_box.length, itemBuilder: (context, index, animation) => SizeTransition(sizeFactor: animation, child: Solo_Saved(index))),
                SliverAnimatedList(key: _listKey2, initialItemCount: ghosting_box.length, itemBuilder: (context, index, animation) => SizeTransition(sizeFactor: animation, child: ghost_saved(index))),
              ],
            );
          } else {
            return Center(
                child: Text(
              "No Saved Data",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ));
          }
        },
      ),
    );
  }

  Widget ghost_stat() {
    return FutureBuilder(
      future: load_ghost_hive(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (Hive.isBoxOpen("Ghosting1") && ghosting_box.length != 0) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Card(elevation: 10, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))), child: Container(child: resting())),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    single_card("Average", "Duration", Duration(seconds: ave_ghost_dur).toString().substring(2, 7), Colors.blue),
                    single_card("Average", "Ghosts", ave_ghost_num.toString(), Color.fromRGBO(40, 40, 120, 1)),
                  ],
                ),
              ),
              Card(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))), child: Container(child: Speed())),
              //Card(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))), child: Container(child: ghost_type_pie_chart())),
            ],
          );
        } else {
          return Center(
              child: Text(
            "No Data to Analyze",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ));
        }
      },
    );
  }

  Widget solo_stat() {
    return FutureBuilder(
      future: load_hive(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (Hive.isBoxOpen("Solo1") && solo_storage_box.length != 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Card(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))), child: type_pie_chart()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      single_card("Average", "Duration", Duration(seconds: ave_solo_dur).toString().substring(2, 7), Colors.blue),
                      single_card("Average", "Shots", ave_shot_num.toString(), Color.fromRGBO(40, 40, 120, 1)),
                    ],
                  ),
                ),
                percsion()
              ],
            ),
          );
        } else {
          return Center(
              child: Text(
            "No Data to Analyze",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ));
        }
      },
    );
  }

  Widget percsion(){

    return Container(

      width: MediaQuery.of(context).size.width,
      height: 200,

      child: Card(
        elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Column(

                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Shot",                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  Text("Precision",                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )



                ],


              ),

              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(40, 40, 120, 1), borderRadius: BorderRadius.all(Radius.circular(40))),


                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(accuracy.floor().toString()+"%",style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold,color: Colors.white)),
                  ),

                ),
              )

            ],
          ),
        ),

      ),

    );

  }

  int pagenum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            is_shaking = false;
          });
        },
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: MyDynamicHeader("Data", "Analytics", false),
              ),
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  floating: false,
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                        indicatorColor: Colors.lightBlueAccent,
                        tabs: [
                          new Tab(
                            //  icon: new Icon(Icons.sports_tennis),
                            text: "Solo",
                          ),
                          new Tab(
                            text: "Ghosting",
                          ),
                          new Tab(
                            // icon: new Icon(Icons.save),
                            text: "Saved",
                          ),
                        ],
                        controller: _tabController),
                  ),
                ),
              ),
            ];
          },
          floatHeaderSlivers: false,
          body: TabBarView(
            children: [
              solo_stat(),
              ghost_stat(),
              page_2(),
            ],
            controller: _tabController,
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Color.fromRGBO(20, 20, 50, 1),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

