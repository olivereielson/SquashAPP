import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/services.dart';
import 'package:squash/data/calculations.dart';
import 'package:squash/extra/hive_classes.dart';

class Finish_Screen extends StatefulWidget {
  Finish_Screen(this.total_ghost, this.total_time, this.time_array);

  List<double> time_array;

  String total_time;
  int total_ghost;

  @override
  _Finish_ScreenState createState() => _Finish_ScreenState();
}

class _Finish_ScreenState extends State<Finish_Screen> {
  ConfettiController _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
  Box<Ghosting> ghosting_box;


  List<FlSpot> speed = [];

  Widget confeti() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            shouldLoop: false,

            blastDirection: pi / 2,
            // radial value - RIGHT
            emissionFrequency: 0.6,
            minimumSize: const Size(10, 10),
            // set the minimum potential size for the confetti (width, height)
            maximumSize: const Size(20, 20),
            // set the maximum potential size for the confetti (width, height)
            numberOfParticles: 1,
            gravity: 0.1,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: MaterialButton(
              onPressed: () {
                _controllerCenter.play();
              },
              child: Text('blast\nstars')),
        ),
      ],
    );
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

    speed=DataMethods().SingleSpeed(ghosting_box.getAt(ghosting_box.length-1));


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

  Widget Speed() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(

        elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((20.0)))),

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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width-30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: LineChart(
                      LineChartData(


                          borderData: FlBorderData(
                            show: true,

                            border:  Border(
                              bottom: BorderSide(

                                color: Theme.of(context).primaryColor,
                                width: 1,

                              ),
                              left: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1,


                              ),
                              right: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                              top: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                              );
                            },
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Theme.of(context).primaryColor,
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
                              getTextStyles: (value) => const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
                              rotateAngle: 0,
                              getTitles: (val) {

                                if(val==0){

                                  return "Start";


                                }

                                if(val==speed.length-1){

                                  return "End";


                                }

                                return "";
                              },
                              margin: 10,
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) => const TextStyle(
                                color: Color(0xff67727d),
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
                              spots: speed,
                              isCurved: true,

                              colors: [
                                Theme.of(context).primaryColor,
                                //Color(0xff044d7c),
                                //  Colors.lightBlue,
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
        ),
      ),
    );
  }

  @override
  void initState() {



    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    print(widget.time_array);
    return Scaffold(

      appBar: AppBar(

        title: Text("Ghosting Finished",style: TextStyle(fontSize: 25),),
        toolbarHeight: 90,
        elevation: 0,
        leading: Text(""),
        actions: [

          IconButton(onPressed: (){

            Navigator.pop(context);


          }, icon: Icon(Icons.close,size: 30,))

        ],


      ),

      body: Stack(
        children: [


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [




              FutureBuilder(
                future: load_ghost_hive(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                  if (Hive.isBoxOpen("Ghosting1") && ghosting_box.length != 0) {

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(

                        child: Column(

                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                single_card("Total", "Time", widget.total_time.substring(2,7), Theme.of(context).primaryColor),
                                single_card("Total", "ghosts", widget.time_array.length.toString(), Theme.of(context).primaryColor)

                              ],
                            ),

                            ghosting_box.getAt(0).corner_array.length!=0?Speed():Text(""),





                          ],


                        )


                      ),
                    );

                  }else{


                    return CircularPercentIndicator(radius: 5);

                  }



                },),







            ],
          )
        ],
      ),
    );
  }
}
