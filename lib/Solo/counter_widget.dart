import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

typedef void Callback(bool done);


class counter_widget extends StatefulWidget {

  final Callback done;

  int type;
  int sides;
  Color main;
  Duration time;
  int counter_value;
  int counter_goal;

  counter_widget(this.type,this.sides,this.main,{this.time,this.done,this.counter_value,this.counter_goal});

  @override
  counter_widget_state createState() => new counter_widget_state();
}

class counter_widget_state extends State<counter_widget> {

  bool finished = false;


  int sides_done=0;

  CountDownController _countDownController = CountDownController();




  Widget timer() {
    return Positioned(
      left: (MediaQuery.of(context).size.width - 180) / 2,
      top: 10,
      child: SafeArea(
        child: CircularCountDownTimer(
          duration: widget.time.inSeconds,
          controller: _countDownController,
          width: 200,
          height: 200,
          color: Colors.grey[300],
          fillColor: widget.main,
          backgroundColor: Colors.white,
          strokeWidth: 20.0,
          textStyle: TextStyle(
              fontSize: 33.0, color: widget.main, fontWeight: FontWeight.bold),
          isReverse: false,
          isReverseAnimation: false,
          isTimerTextShown: true,

          onComplete: () {


            sides_done++;

            if(sides_done<(widget.sides*2)){

              _countDownController.restart(duration: widget.time.inSeconds);

            }else{

              //print(sides_done);
              //print(widget.sides);

              widget.done(true);


            }

          },
        ),
      ),
    );
  }

  Widget Counter(){



    if(widget.counter_value==widget.counter_goal){

      widget.done(true);


    }


    return Positioned(
      left: (MediaQuery.of(context).size.width - 180) / 2,
      top: 10,
      child: SafeArea(
        child: CircularPercentIndicator(
          progressColor: widget.main,
          arcBackgroundColor: Colors.white,
          arcType: ArcType.FULL,
          lineWidth: 20,
          startAngle: 0.5,
          backgroundColor: Colors.white,
          percent: (widget.counter_value/widget.counter_goal),
          radius: 180,

          animation: true,
          animateFromLastPercent: true,
          animationDuration: 1,
          backgroundWidth: 20,
          center: Text(
             widget.counter_value.toString(),
            style: TextStyle(fontSize: 49, fontWeight: FontWeight.bold, color: widget.main),
          ),
        ),
      ),
    );


  }



  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 0:
        return Counter();

      case 1:
        return Counter();
    }
    ;
  }
}
