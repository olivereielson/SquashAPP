import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/extra/hive_classes.dart';

import 'calculations.dart';

class Solo_Stat extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Solo_Stat(this.analytics, this.observer);

  @override
  _Solo_StatState createState() => _Solo_StatState();
}

class _Solo_StatState extends State<Solo_Stat> {
  Box<Solo_stroage> solo_storage_box;
  double accuracy;
  int ave_solo_dur;
  int ave_shot_num;
  Map<DateTime, List<String>> eventDay = {};
  List<double> solo_type_pie_chart_data = [0, 0, 0, 0];
  int _count = 1;
  List<Color> type_pie_color = [
    Color.fromRGBO(66, 89, 138, 1),
    Colors.grey,
    Color.fromRGBO(20, 20, 60, 1),
    Color(0xff044d7c),
    Color.fromRGBO(20, 20, 60, 1),
    Colors.lightBlueAccent,
    Color.fromRGBO(20, 20, 80, 1),
    Colors.indigoAccent,
    Colors.blueGrey,
    Color.fromRGBO(20, 50, 120, 1),
    Colors.indigo
  ];

  Future _load_data;
  List<FlSpot> dista = [];

  @override
  void initState() {
    _load_data = load_hive();

    super.initState();
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
    print(solo_storage_box.length);
    setState(() {
      calculate_solo();
    });
  }

  void calculate_solo() {
    print("solo calcuated");

    solo_type_pie_chart_data = DataMethods().solo_pie_chart(solo_storage_box);


    ave_solo_dur = DataMethods().ave_solo_dur(solo_storage_box);
    ave_shot_num = DataMethods().ave_shot_num(solo_storage_box);
    accuracy = DataMethods().percision(solo_storage_box);

    dista= DataMethods().normal_d(solo_storage_box);


    setState(() {});

    print("solo calcuated");
  }

  Widget single_card(String top_name, String bottom_name, String data) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Theme.of(context).primaryColor, width: 3), borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              top_name,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              bottom_name,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget percsion() {
    //print(accuracy);
    return GestureDetector(

      onTap: (){

        calculate_solo();

      },

      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Theme.of(context).primaryColor, width: 3), borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shot",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    "Precision",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Text(accuracy.floor().toString() + "%",
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget type_pie_chart() {
    return Container(
      color: Colors.transparent,
      height: 320,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Solo\nBreakDown",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        child: child,
                        scale: animation,
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          SoloDefs().Exersise[_count]["name"],
                          // This key causes the AnimatedSwitcher to interpret this as a "new"
                          // child each time the count changes, so that it will begin its animation
                          // when the count changes.
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                        ),
                      ],
                      key: ValueKey<int>(_count),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 230,
              width: 300,
              child: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(touchCallback: (PieTouchResponse val) {
                      if (val.touchedSectionIndex != -1) {
                        setState(() {
                          _count = val.touchedSectionIndex;
                          widget.analytics.logEvent(name: "Solo_Breakdown_Toggled");
                        });
                      }
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sections: DataMethods().solo_type_slice_data(solo_type_pie_chart_data, Theme.of(context).splashColor, _count,Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dist() {
    bool data = false;

    for (final ghost in solo_storage_box.values) {
      if (ghost.bounces.length > 0) {
        data = true;
        break;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Precision Over Time",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Theme.of(context).primaryColor),
          ),
        ),
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: LineChart(
              LineChartData(
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      left: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),

                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: false,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).splashColor,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).splashColor,
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
                        getTextStyles: (value) =>  TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                        rotateAngle: 90,
                        getTitles: (val) {
                          return DateFormat('Md').format(solo_storage_box.getAt(val.toInt()).start).toString();
                        },

                        margin: 10,
                        interval: 1),

                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) =>  TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      getTitles: (val) {
                        return val.toInt().toString() + "%";
                      },
                      interval: 10,
                      reservedSize: 30,
                      margin: 10,

                    ),
                  ),
                  minX: 0,
                  maxY: 100,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: data?DataMethods().normal_d(solo_storage_box):[FlSpot(0,0)] ,
                      isCurved: true,
                      colors: [
                        Theme.of(context).primaryColor                            //Color(0xff044d7c),
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

                          Colors.white

                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _load_data,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (Hive.isBoxOpen("Solo1") && solo_storage_box.length != 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  type_pie_chart(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        single_card(
                          "Average",
                          "Duration",
                          Duration(seconds: ave_solo_dur).toString().substring(2, 7),
                        ),
                        single_card(
                          "Average",
                          "Shots",
                          ave_shot_num.toString(),
                        ),
                      ],
                    ),
                  ),
                  percsion(),
                  dist()
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
      ),
    );
  }

  Widget old() {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder(
        future: _load_data,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (Hive.isBoxOpen("Solo1") && solo_storage_box.length != 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  type_pie_chart(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        single_card(
                          "Average",
                          "Duration",
                          Duration(seconds: ave_solo_dur).toString().substring(2, 7),
                        ),
                        single_card(
                          "Average",
                          "Shots",
                          ave_shot_num.toString(),
                        ),
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
      ),
    );
  }
}
