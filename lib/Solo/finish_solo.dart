import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/services.dart';

class Finish_Screen_Solo extends StatefulWidget {
  Finish_Screen_Solo(this.total_shots, this.total_time);


  String total_time;
  int total_shots;

  @override
  _Finish_ScreenState createState() => _Finish_ScreenState();
}

class _Finish_ScreenState extends State<Finish_Screen_Solo> {
  ConfettiController _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              shouldLoop: false,

              blastDirection: pi / 2,
              // radial value - RIGHT
              emissionFrequency: 1,
              minimumSize: const Size(10, 10),
              // set the minimum potential size for the confetti (width, height)
              maximumSize: const Size(20, 20),
              // set the maximum potential size for the confetti (width, height)
              numberOfParticles: 1,
              gravity: 0.1,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(40, 45, 81, 1),
                  border: Border.all(
                      color: Color.fromRGBO(40, 45, 81, 1),
                      // set border color
                      width: 6.0), // set border width
                  borderRadius: BorderRadius.all(Radius.circular(25.0)), // set rounded corner radius
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      DateFormat("MMMMd").format(DateTime.now()),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40,bottom: 20),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.all(Radius.circular(20.0))

                  )

                  ,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Text(
                          "Total Time",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Container(
                          child: new CircularPercentIndicator(
                            radius: 150.0,

                            animation: true,
                            animationDuration: 1200,


                            lineWidth: 20.0,
                            percent: 1,
                            center: new Text(
                              widget.total_time,
                              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.white70,

                            onAnimationEnd: (){

                              HapticFeedback.heavyImpact();
                              //_controllerCenter.play();



                            },

                            linearGradient: LinearGradient(

                                colors: [

                                  Colors.indigo
                                  ,Color.fromRGBO(40, 45, 81, 1)
                                ]

                            ),
                            //progressColor: Color.fromRGBO(40, 45, 81, 1)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.all(Radius.circular(20.0))

                  )

                  ,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Text(
                          "Total Ghosts",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Container(
                          child: new CircularPercentIndicator(

                            radius: 150.0,

                            animation: true,
                            animationDuration: 1800,
                            onAnimationEnd: (){

                              HapticFeedback.heavyImpact();



                            },

                            lineWidth: 20.0,
                            percent: 1,
                            center: new Text(
                              widget.total_shots.toString(),
                              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.white70,
                            linearGradient: LinearGradient(

                                colors: [

                                  Colors.indigo
                                  ,Colors.lightBlueAccent
                                ]

                            ),
                            //progressColor: Color.fromRGBO(40, 45, 81, 1)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: CupertinoButton(
                          color: Color.fromRGBO(40, 45, 81, 1),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
