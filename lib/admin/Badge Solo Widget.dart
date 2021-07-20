import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Solo_Bagde extends StatefulWidget {
  Solo_Bagde({@required this.analytics});

  final FirebaseAnalytics analytics;

  @override
  _Solo_BagdeState createState() => _Solo_BagdeState();
}

class _Solo_BagdeState extends State<Solo_Bagde> {
  String box_name = "badges";

  List<int> badge_total_numbers = [100, 500, 1000, 5000, 10000];

  List<String> badge_total_title = [
    "100 Shots",
    "500 Shots",
    "1000 Shots",
    "5000 Shots",
    "10000 Shots",
  ];

  List<int> badge_speed_numbers = [50, 75, 85, 95];

  List<String> badge_speed_title = [
    "50% Precision",
    "75% Precision",
    "85% Precision",
    "95% Precision",
  ];

  List<int> badges_won = [];

  List<int> badges_perc_won = [];

  openBadgeBox() async {
    var box = await Hive.openBox('badges');

    int ghost_total = box.get("solo_total", defaultValue: 0);
    double solo_p = box.get("solo_p", defaultValue: 0.0);



    for (int i = 0; i < badge_total_numbers.length; i++) {
      if (badge_total_numbers[i] < ghost_total) {
        badges_won.add(i);
      }
    }

    for (int i = 0; i < badge_speed_numbers.length; i++) {
      if (badge_speed_numbers[i] < solo_p) {
        badges_perc_won.add(i);
      }
    }
  }

  Widget Badge(String title, String image, bool hasWon) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(new PageRouteBuilder(
                    opaque: false,
                    barrierDismissible: true,
                   // transitionDuration: Duration(seconds: 5),
                    pageBuilder: (BuildContext context, _, __) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(100.0),
                            child: Hero(
                              tag: title + image,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(color: Theme.of(context).splashColor, shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: hasWon
                                          ? Image.asset(
                                        "assets/badges/$image.png",
                                        height: 20,
                                        color: Colors.white,
                                      )
                                          : Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }));

                widget.analytics.logEvent(
                  name: "Badge_Clicked",
                  parameters: <String, dynamic>{
                    'type': 'Solo_Badge',
                    'title': title,
                    'haswon': hasWon,
                  },
                );
              },
              child: Hero(
                tag: title + image,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(color: Theme.of(context).splashColor, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: hasWon
                            ? Image.asset(
                                "assets/badges/$image.png",
                                height: 20,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 40,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: (TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    openBadgeBox();
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Solo Badges",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: badge_total_numbers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Badge(badge_total_title[index], "sa$index", badges_won.contains(index));
                },
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: badge_speed_numbers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(

                    height: 200,
                      width: 200,


                      child: Center(child: Badge(badge_speed_title[index], "saa$index", badges_perc_won.contains(index))));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
