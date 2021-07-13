
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Left Hand Page',
      screenClassOverride: 'Left_Hand_Page',
    );
  }

  @override
  void initState() {
    _testSetCurrentScreen();
    super.initState();
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
                        child: Text("Close",style: TextStyle(color: Theme.of(context).splashColor),), onPressed: (){

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