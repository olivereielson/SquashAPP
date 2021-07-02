

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/extra/hive_classes.dart';

import 'calculations.dart';

class Solo_Stat extends StatefulWidget{
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Solo_Stat(this.analytics,this.observer);

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
  int _count = 0;
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

  @override
  void initState() {


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
    setState(() {
      calculate_solo();
    });
  }

  void calculate_solo() {
    solo_type_pie_chart_data = DataMethods().solo_pie_chart(solo_storage_box);

    accuracy = DataMethods().percision(solo_storage_box);

    ave_solo_dur = DataMethods().ave_solo_dur(solo_storage_box);
    ave_shot_num = DataMethods().ave_shot_num(solo_storage_box);

    eventDay.clear();

    for (int i = 0; i < solo_storage_box.length; i++) {
      DateTime cdate = DateTime(solo_storage_box.getAt(i).start.year, solo_storage_box.getAt(i).start.month, solo_storage_box.getAt(i).start.day);

      //print(cdate.day);

      if (eventDay[cdate] != null) {
        List<String> l = eventDay[cdate];
        l.add("0" + i.toString());

        eventDay[cdate] = l;
      } else {
        eventDay[cdate] = ["0" + i.toString()];
      }
    }

    setState(() {});
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

  Widget percsion() {
    //print(accuracy);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(color: Colors.transparent,

          border: Border.all(color: Colors.white,width: 3),


          borderRadius: BorderRadius.all(


              Radius.circular(20.0))),
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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                Text(
                  "Precision",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(accuracy.floor().toString() + "%", style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            )
          ],
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
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),
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
                    sections: DataMethods().solo_type_slice_data(solo_type_pie_chart_data, type_pie_color, _count)),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: Theme.of(context).primaryColor,

      body: FutureBuilder(
        future: load_hive(),
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
                        single_card("Average", "Duration", Duration(seconds: ave_solo_dur).toString().substring(2, 7),),
                        single_card("Average", "Shots", ave_shot_num.toString(),),
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