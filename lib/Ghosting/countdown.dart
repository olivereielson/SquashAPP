import 'dart:async';

import 'package:flutter/material.dart';

typedef void Callback(bool done);

class CountDown extends StatefulWidget {
  final Callback done;
  int _start;

  CountDown(this._start,{this.done});

  @override
  _CountDownState createState() => new _CountDownState(_start);
}

class _CountDownState extends State<CountDown> {
  bool countdown = false;


  _CountDownState(this._start);

  String timer = "15";
  Timer _timer;
  int _start;
  Color main= Color.fromRGBO(40, 45, 81, 1);



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        countdown = true;

        const oneSec = const Duration(seconds: 1);
        _timer = new Timer.periodic(
          oneSec,
          (Timer timer) {

            setState(
                  () {
                if (_start < 1) {
                  timer.cancel();
                  print("hehee");
                  _start=100;
                  _timer.cancel();
                  widget.done(true);
                } else {
                  _start = _start - 1;

                }
              },
            );
          },
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: main,
          border: Border.all(
              color: main,
              // set border color
              width: 6.0), // set border width
          borderRadius: BorderRadius.all(
              Radius.circular(25.0)), // set rounded corner radius
        ),
        child: countdown
            ? Center(
                child: Text(
                _start.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50,color: Colors.white),
              ))
            : Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 60,
              ),
      ),
    );
  }
  @override
  void dispose() {
    if(_timer!=null){
      _timer.cancel();
    }

    super.dispose();
  }
}
