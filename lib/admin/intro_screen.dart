import 'dart:async';
import 'dart:math';

//import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash/admin/terms_and_conditions.dart';

import '../main.dart';

class TestScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  TestScreen(this.analytics, this.observer);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int number = 2;
  Timer _timer;
  PageController _pageController;

  double bottom = 100;
  double right = 20;
  bool can_scroll = true;

  String hand = "";

  void startTimer() {
    const oneSec = const Duration(seconds: 2);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (number == 2) {
            number = 0;
          } else {
            number++;
          }

          bottom = Random().nextInt(100).toDouble();
          right = Random().nextInt(70).toDouble();
        });
      },
    );
  }

  Widget page1() {
    return Stack(
      children: [
        Positioned(
            bottom: 40,
            right: 40,
            child: TextButton(
                onPressed: () {
                  _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
                },
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ))),
        Center(
          child: Text(
            "Welcome to Squash Labs",
            style: TextStyle(fontFamily: 'MyFont', color: Colors.white, fontSize: 30),
          ),
        ),
      ],
    );
  }

  Widget name() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Whats your name?",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: TextField(
              onSubmitted: (name) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("first_name", name);
                _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                widget.analytics.logEvent(name: "Named_Edited", parameters: <String, dynamic>{"name": name});
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Eg Joe Smith",
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  hintStyle: TextStyle(color: Colors.white60),
                  labelStyle: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget lefty() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "What is your dominate hand?",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var box = await Hive.openBox('solo_def');
                        box.put("hand", "Left");

                        setState(() {
                          hand = "Left";
                        });
                        widget.analytics.logEvent(
                          name: "Log_Hand",
                          parameters: <String, dynamic>{
                            'dom_hand': 'Left',
                          },
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                            border: Border.all(color: hand != "Left" ? Colors.white.withOpacity(0.5) : Colors.white, width: hand != "Left" ? 4 : 7),
                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        child: Center(
                            child: Text(
                          "Left Hand",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var box = await Hive.openBox('solo_def');
                        box.put("hand", "Right");

                        setState(() {
                          hand = "Right";
                        });
                        widget.analytics.logEvent(
                          name: "Log_Hand",
                          parameters: <String, dynamic>{
                            'dom_hand': 'Right',
                          },
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                            border: Border.all(color: hand != "Right" ? Colors.white.withOpacity(0.5) : Colors.white, width: hand != "Right" ? 4 : 7),
                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        child: Center(
                            child: Text(
                          "Right Hand",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: hand == "" ? 0 : 1,
                  duration: Duration(milliseconds: 300),
                  child: CupertinoButton(
                    child: Text(
                      "Next",
                      style: TextStyle(color: Theme.of(context).splashColor),
                    ),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget Term() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                "Terms and Conditions",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), border: Border.all(color: Colors.white.withOpacity(0.1)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                          child: Text(
                        terms().terms_text,
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      )),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                      color: Colors.white,
                      child: Text(
                        "Accept",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        widget.analytics.logEvent(name: "Terms_Accepted");

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp(widget.analytics, widget.observer)),
                        );
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget draw_court() {
    Color court_color = Colors.white;

    double h = (MediaQuery.of(context).size.width * 1645) / 1080;

    double offset = MediaQuery.of(context).size.height - h;

    return Stack(
      children: [
        Positioned(
          bottom: 10,
          left: 5,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: 0 == number ? Colors.white : Colors.transparent,
              border: Border.all(
                  color: 0 == number ? Colors.white : Colors.transparent,
                  // set border color
                  width: 6.0), // set border width
              borderRadius: BorderRadius.all(Radius.circular(25.0)), // set rounded corner radius
            ),
            width: 0 == number ? 80 : 40,
            height: 0 == number ? 80 : 40,
          ),
        ),
        Positioned(
          bottom: 400,
          right: 5,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: 1 == number ? Colors.white : Colors.transparent,
              border: Border.all(
                  color: 1 == number ? Colors.white : Colors.transparent,
                  // set border color
                  width: 6.0), // set border width
              borderRadius: BorderRadius.all(Radius.circular(25.0)), // set rounded corner radius
            ),
            width: 1 == number ? 80 : 40,
            height: 1 == number ? 80 : 40,
          ),
        ),
        Positioned(
          bottom: 100,
          right: 5,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: 2 == number ? Colors.white : Colors.transparent,
              border: Border.all(
                  color: 2 == number ? Colors.white : Colors.transparent,
                  // set border color
                  width: 6.0), // set border width
              borderRadius: BorderRadius.all(Radius.circular(25.0)), // set rounded corner radius
            ),
            width: 2 == number ? 80 : 40,
            height: 2 == number ? 80 : 40,
          ),
        ),
        Positioned(
            top: h * 0.44 + offset,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: court_color,
            )),
        Positioned(
            top: h * 0.44 + offset,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.56,
              width: 15,
              color: court_color,
            )),
        Positioned(
          top: h * 0.44 + offset,
          left: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4 + 15,
            height: MediaQuery.of(context).size.width / 4 + 15,
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
          top: h * 0.44 + offset,
          right: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4 + 15,
            height: MediaQuery.of(context).size.width / 4 + 15,
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

  Widget draw_court_solo() {
    Color court_color = Colors.white;

    double h = (MediaQuery.of(context).size.width * 1645) / 1080;

    double offset = MediaQuery.of(context).size.height - h;

    return Stack(
      children: [
        Positioned(
            top: h * 0.44 + offset,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: court_color,
            )),
        Positioned(
            top: h * 0.44 + offset,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.56,
              width: 15,
              color: court_color,
            )),
        Positioned(
          top: h * 0.44 + offset,
          left: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4 + 15,
            height: MediaQuery.of(context).size.width / 4 + 15,
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
          top: h * 0.44 + offset,
          right: -15,
          child: Container(
            width: MediaQuery.of(context).size.width / 4 + 15,
            height: MediaQuery.of(context).size.width / 4 + 15,
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

  Widget g_show() {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          draw_court(),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    "Practice Ghosting ",
                    style: TextStyle(fontFamily: 'MyFont', color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget s_show() {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Positioned(bottom: bottom, right: right, child: SafeArea(child: Icon(Icons.circle))),
          draw_court_solo(),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    "Practice Solo",
                    style: TextStyle(fontFamily: 'MyFont', color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget speed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Ghosting Speed",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        color: Colors.white,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white,
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
                        showTitles: false,
                        reservedSize: 40,
                        getTextStyles: (value) => TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        rotateAngle: 90,
                        getTitles: (val) {
                          return "";
                        },
                        margin: 10,
                        interval: 2),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      getTitles: (val) {
                        return val.toStringAsFixed(1) + " secs";
                      },
                      reservedSize: 40,
                      margin: 10,
                      interval: 2,
                    ),
                  ),
                  minX: 0,
                  maxY: 10,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 2),
                        FlSpot(1, 3),
                        FlSpot(2, 3),
                        FlSpot(3, 4),
                        FlSpot(4, 5),
                        FlSpot(5, 3),
                        FlSpot(6, 2),
                        FlSpot(7, 2.2),
                        FlSpot(9, 2.5),
                        FlSpot(10, 3.5),
                      ],
                      isCurved: true,
                      colors: [
                        Colors.white //Color(0xff044d7c),
                        //  Colors.lightBlue,
                      ],
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: false,
                      ),
                      belowBarData: BarAreaData(
                        show: false,
                        colors: [Colors.white],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget single_card(String top_name, String bottom_name, String data) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.white, width: 3), borderRadius: BorderRadius.all(Radius.circular(20.0))),
        height: 175,
        width: MediaQuery.of(context).size.width - 40,
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
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                bottom_name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget data_show() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Text(
              "Data Analytics",
              style: TextStyle(fontFamily: 'MyFont', color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: speed(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              single_card("Shot", "Accuracy", "78%"),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: PageView(
        controller: _pageController,
        physics: can_scroll ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          print(page);

          if (page == 1) {
            can_scroll = false;

            widget.analytics.setCurrentScreen(
              screenName: 'Intro Welcome Screen',
              screenClassOverride: 'Intro_Welcome_Screen',
            );
          }

          if (page == 2) {
            can_scroll = false;
            widget.analytics.setCurrentScreen(
              screenName: 'Intro Name Screen',
              screenClassOverride: 'Intro_Name_Screen',
            );
          }

          if (page == 0) {
            can_scroll = true;
            widget.analytics.setCurrentScreen(
              screenName: 'Intro Terms Screen',
              screenClassOverride: 'Intro_Terms_Screen',
            );
          }
        },
        scrollDirection: Axis.horizontal,
        children: [
          page1(),
          name(),
          lefty(),
          Term(),
        ],
      ),
    );
  }

  @override
  void initState() {
    _pageController = PageController();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
