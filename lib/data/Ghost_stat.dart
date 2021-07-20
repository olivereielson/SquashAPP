

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/extra/hive_classes.dart';

import 'calculations.dart';

class Ghost_Stat extends StatefulWidget{
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Ghost_Stat(this.analytics,this.observer);

  @override
  _Ghost_StatState createState() => _Ghost_StatState();
}

class _Ghost_StatState extends State<Ghost_Stat> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  Box<Ghosting> ghosting_box;
  List<double> ghost_type_pie_chart_data = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  int ave_ghost_dur;
  int ave_ghost_num;
  double rest = 0;
  double work = 0;
  List<FlSpot> speed = [];
  List<BarChartGroupData> barchrt = [];
  List<double> single_corner_speed = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  Map<DateTime, List<String>> eventDay = {};
 int _count=0;

  @override
  void initState() {

    super.initState();
  }

  calculate_ghost() {
    List<double> WVR = DataMethods().WorkRestPie(ghosting_box);
    work = WVR[0];
    rest = WVR[1];

    speed = DataMethods().speed(ghosting_box);

    ave_ghost_dur = DataMethods().ave_ghost_dur(ghosting_box);

    ave_ghost_num = DataMethods().ave_ghost_num(ghosting_box);

    single_corner_speed = DataMethods().SingleCornerSpeed(ghosting_box);

    ghost_type_pie_chart_data = DataMethods().GhostPieChart(ghosting_box);

    barchrt = DataMethods().BarChartSpeed(ghosting_box, single_corner_speed, Theme.of(context).splashColor);

    widget.analytics.setUserProperty(name: "ave_ghost_dur", value: ave_ghost_dur.toString());
    widget.analytics.setUserProperty(name: "ave_ghost_num", value: ave_ghost_num.toString());


    print("ghost calucated");
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
      calculate_ghost();
  }

  Widget single_card(String top_name, String bottom_name, String data) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent,

          border: Border.all(color: Theme.of(context).primaryColor,width: 3),


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
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              top_name,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
            ),
            Text(
              bottom_name,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
    );
  }

  Widget resting() {
    //(rest);

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

                    pieTouchData: PieTouchData(touchCallback: (PieTouchResponse val) {
                      if (val.touchedSectionIndex != -1) {
                        setState(() {
                          _count = val.touchedSectionIndex;
                          widget.analytics.logEvent(name: "Ghost_Breakdown_Toggled");
                        });
                      }
                    }),

                    sections: [
                      PieChartSectionData(
                        color: Theme.of(context).splashColor,
                        value: work,
                        title: (work / (work + rest) * 100).toInt().toString() + '%',
                        radius: _count==0?60:50,
                        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        titlePositionPercentageOffset: 0.55,

                      ),
                      PieChartSectionData(
                        color: Theme.of(context).splashColor,

                        value: rest,
                        title: (rest / (work + rest) * 100).ceil().toString() + '%',
                        radius: _count==1?60:50,
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
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: _count==1?35:25,
                      width: _count==1?35:25,
                      decoration: BoxDecoration(color:Theme.of(context).splashColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Resting",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: _count==0?35:25,
                      width: _count==0?35:25,
                      decoration: BoxDecoration(color: Theme.of(context).splashColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ghosting",
                        style: TextStyle(color: Theme.of(context).primaryColor),
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

  Widget speed2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Average Conner Ghosting Speed",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: BarChart(
            BarChartData(
              barGroups: barchrt,
              borderData: FlBorderData(
                show: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).primaryColor),
                  margin: 16,
                  rotateAngle: 90,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'FL';
                      case 1:
                        return 'FR';
                      case 2:
                        return 'FML';
                      case 3:
                        return 'FMR';
                      case 4:
                        return 'ML';
                      case 5:
                        return 'MR';
                      case 6:
                        return 'BML';
                      case 7:
                        return 'BMR';
                      case 8:
                        return 'BL';
                      case 9:
                        return 'BR';
                      case 10:
                        return 'S';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Theme.of(context).splashColor,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String weekDay;
                      switch (group.x.toInt()) {
                        case 0:
                          weekDay = 'Front Left';
                          break;
                        case 1:
                          weekDay = 'Front Right';
                          break;
                        case 2:
                          weekDay = 'Front Middle Left';
                          break;
                        case 3:
                          weekDay = 'Front Middle Right';
                          break;
                        case 4:
                          weekDay = 'Left Middle';
                          break;
                        case 5:
                          weekDay = 'Right Middle';
                          break;
                        case 6:
                          weekDay = 'Left Back Middle';
                          break;
                        case 7:
                          weekDay = 'right Back Middle';
                          break;
                        case 8:
                          weekDay = 'Left Back';
                          break;
                        case 9:
                          weekDay = 'Right Back';
                          break;
                      }
                      return BarTooltipItem(weekDay + '\n' + rod.y.toStringAsFixed(2) + " Seconds", TextStyle(color: Colors.white));
                    }),
                touchCallback: (barTouchResponse) {},
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget Speed() {
    bool data = false;

    for (final ghost in ghosting_box.values) {
      if (ghost.corner_array.length > 0) {
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
                "Average Ghosting Speed",
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
                              return DateFormat('Md').format(ghosting_box.getAt(val.toInt()).start).toString();
                            },
                            margin: 10,
                            interval: 2),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) =>  TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          getTitles: (val) {
                            return val.toStringAsFixed(1) + " secs";
                          },
                          reservedSize: 30,
                          margin: 10,
                          interval: 1,
                        ),
                      ),
                      minX: 0,
                      maxY: 10,
                      minY: 0,
                      lineBarsData: [
                        LineChartBarData(
                          spots: data
                              ?speed:[FlSpot(0, 0)],
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
  void _onRefresh() async{
    await load_ghost_hive();
    calculate_ghost();

    _refreshController.refreshCompleted();
    widget.analytics.logEvent(name: "Ghost_Refresh");

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: FutureBuilder(
        future:load_ghost_hive(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (Hive.isBoxOpen("Ghosting1") && ghosting_box.length != 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,

                onRefresh: (){
                  _onRefresh();
                },
                scrollDirection: Axis.vertical,

                header: CustomHeader(

                  builder: (BuildContext context, RefreshStatus mode) {

                    return CupertinoActivityIndicator();

                  },

                ),
                child: ListView(
                  children: [
                    resting(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          single_card("Average", "Duration", Duration(seconds: ave_ghost_dur).toString().substring(2, 7)),
                          single_card("Average", "Ghosts", ave_ghost_num.toString(), ),
                        ],
                      ),
                    ),
                    Speed(),
                    //Card(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))), child: Container(child: ghost_type_pie_chart())),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: speed != null ? speed2() : Text(""),
                    )
                  ],
                ),
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
      )



    );

  }
}