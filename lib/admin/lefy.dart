
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:squash/Solo/solo%20screen.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/extra/hive_classes.dart';

class Left extends StatefulWidget{
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  String hand;

  Left({@required this.analytics,this.observer,this.hand});


  @override
  _LeftState createState() => _LeftState(hand);
}

class _LeftState extends State<Left> {


  _LeftState(this.hand);

  String hand;
  String box = "Solo_Defs1";
  String hive_box = "solo_saved10";
  String start_hand;

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Left Hand Page',
      screenClassOverride: 'Left_Hand_Page',
    );
  }

  @override
  void initState() {
    start_hand=widget.hand.toString();
    _testSetCurrentScreen();
    super.initState();
  }

  self_destruct() async {

    Box<Solo_Defs> Exersise2;
    Box<Custom_Solo> solo;

    if (Hive.isBoxOpen(box)) {
      Exersise2 = Hive.box<Solo_Defs>(box);
    } else {
      Exersise2 = await Hive.openBox<Solo_Defs>(box);
    }

    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(CustomSoloAdapter());
    }

    if (Hive.isBoxOpen(hive_box)) {
      solo = Hive.box<Custom_Solo>(hive_box);
    } else {
      solo = await Hive.openBox<Custom_Solo>(hive_box);
    }

    await solo.clear();
    await Exersise2.clear();
    await SoloDefs().setup();


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).splashColor,

      body: ClipRect(
        child: Padding(
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
                            widget.analytics.setUserProperty(name: "Dominate_Hand", value: "Lefty");
                            widget.analytics.logEvent(name: "Log_Hand",
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
                                border: Border.all(color: hand != "Left" ? Colors.white.withOpacity(0.5) : Colors.white, width: hand != "Left" ? 4 : 7), borderRadius: BorderRadius.all(Radius
                                .circular(20.0))),
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
                            widget.analytics.setUserProperty(name: "Dominate_Hand", value: "Righty");

                            widget.analytics.logEvent(name: "Log_Hand",
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

                      opacity: hand==""?0:1,
                      duration: Duration(milliseconds: 300),

                      child: CupertinoButton(
                        child: Text("Save",style: TextStyle(color: Theme.of(context).splashColor),), onPressed: () async {


                          if(start_hand!=hand){

                            await self_destruct();
                            print("reset saved workouts");

                          }


                          Navigator.pop(context,hand);

                      },
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      )


    );

  }
}