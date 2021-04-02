import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:soundpool/soundpool.dart';

typedef void Callback(bool done);
typedef void Callback1(int current_side);
typedef void Callback2(bool is_working);

class counter_widget extends StatefulWidget {
  final Callback done;
  final Callback1 current_side;
  final Callback2 is_working;

  List<int> activities;

  Color main;
  Duration time;
  int counter_value;
  int counter_goal;
  int type;
  bool pause;

  counter_widget({this.type, this.main, this.time, this.done, this.is_working, this.counter_value, this.counter_goal, this.activities, this.current_side,this.pause});

  @override
  counter_widget_state createState() => new counter_widget_state(time.inSeconds, type,counter_value);
}

class counter_widget_state extends State<counter_widget> {
  List<String> names = ["Forehand Drives", "Forehand ServiceBox", "BackHand Drives", "BackHand ServiceBox"];
  Soundpool _soundpool;

  counter_widget_state(this._start, this.type,this.counter_value);

  int type;

  SwiperController sc = new SwiperController();

  bool finished = false;

  Widget t;
  Timer _timer;
  int _start;
  int counter_value;

  bool stop_done=true;

  bool is_working = false;

  int sides_done = 0;
  Future<int> _soundId;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            is_working = false;
            playsound();

            widget.is_working(is_working);

            if (sides_done == widget.activities.length - 1) {
              widget.done(true);
            } else {
              //widget.done(false);

              print("sides=$sides_done");
              sides_done++;
              print("sides=$sides_done");

              widget.current_side(widget.activities[sides_done]);
            }
          });
        } else {
          if(!widget.pause){

            setState(() {
              _start--;
            });
          }

        }
      },
    );
  }


  Widget timer() {
    if (is_working) {
      return CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        lineWidth: 20,
        backgroundColor: Colors.white54,
        percent: type == 0 ? _start / widget.time.inSeconds : (_start % 60) / 60,
        radius: 210,
        animation: true,
        linearGradient: LinearGradient(colors: [
          widget.main,
          Colors.indigo,
        ]),
        animateFromLastPercent: true,
        addAutomaticKeepAlive: true,
        animationDuration: 1000,
        backgroundWidth: 20,
        center: Text(
          Duration(seconds: _start).toString().substring(2, 7),
          style: TextStyle(fontSize: 49, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        header: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text(
            "Timer",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              names[widget.activities[sides_done]],
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  is_working = true;
                  widget.is_working(is_working);
                  widget.current_side(widget.activities[sides_done]);
                  print("cur=${widget.activities[sides_done]}");
                  _start = widget.time.inSeconds;
                  startTimer();
                });
              },
              child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(color: Color.fromRGBO(20, 20, 50, 1), borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 90,
                  )),
            ),
          ],
        ),
      );
    }
  }

  Widget Counter() {
    if (is_working) {
      if (widget.counter_value == widget.counter_goal) {


        playsound();

        if (sides_done == widget.activities.length - 1) {

          if(stop_done){
            widget.done(true);
            stop_done=false;
            print("done");

          }

        } else {
          print(widget.counter_value);
          is_working = false;
          widget.is_working(is_working);
          sides_done++;
          print("sides done $sides_done");
          Future.delayed(Duration.zero, () async {
            widget.current_side(widget.activities[sides_done]);
          });

        }
      }

      return CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        lineWidth: 20,
        backgroundColor: Colors.white54,
        percent: (widget.counter_value / widget.counter_goal),
        radius: 200,
        animation: true,
        linearGradient: LinearGradient(colors: [
          widget.main,
          Colors.lightBlueAccent,
        ]),
        animateFromLastPercent: true,
        animationDuration: 1200,
        backgroundWidth: 20,
        center: Text(
          widget.counter_value.toString(),
          style: TextStyle(fontSize: 49, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        header: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text(
            "Shot Count",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              names[widget.activities[sides_done]],
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
            ),
            GestureDetector(
              onTap: () async {





                setState(() {





                  is_working = true;
                  widget.current_side(widget.activities[sides_done]);
                  widget.is_working(is_working);

                  _start = 0;
                  //StopWatch();
                });
              },
              child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(color:  Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 90,
                  )),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.8), borderRadius: BorderRadius.all(Radius.circular(25))),
        child: type == 0 ? timer() : Counter(),
      ),
    );
  }

  Future<void> playsound() async {

    var _alarmSound = await _soundId;

    int streamId = await _soundpool.play(_alarmSound,repeat: 2);


  }

  Future<void> loadsound() async {


    _soundId = await rootBundle.load("assets/sounds/ding.mp4").then((ByteData soundData) {
      return _soundpool.load(soundData);
    });

    var id= await _soundId;

    _soundpool.setVolume(soundId: id, volume: 1.0);

  }


  @override
  void initState() {

    _soundpool = Soundpool(streamType: StreamType.notification,);
    loadsound();


    super.initState();

  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    _soundpool.dispose();
    sc.dispose();
    super.dispose();
  }
}
