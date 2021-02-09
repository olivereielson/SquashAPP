import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Court_Screen extends StatefulWidget {
  Court_Screen(this.corners);

  List<double> corners;

  @override
  Court_Screen_State createState() => new Court_Screen_State(corners);
}

class Court_Screen_State extends State<Court_Screen> {
  Court_Screen_State(this.corners);

  List<double> corners;

  Color court_color = Color.fromRGBO(4, 12, 128, 1);

  Widget draw_court() {
    return Stack(
      children: [
        Positioned(
            top: MediaQuery.of(context).size.height / 2,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: court_color,
            )),
        Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: 15,
              color: court_color,
            )),
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          left: -15,
          child: Container(
            width: 125.0,
            height: 125.0,
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
          top: MediaQuery.of(context).size.height / 2,
          right: -15,
          child: Container(
            width: 125.0,
            height: 125.0,
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

  Widget check(double x) {
    return IconButton(
      onPressed: () {
        setState(() {
          if (corners.contains(x)) {
            corners.remove(x);
          } else {
            corners.add(x);
          }
        });
      },
      icon: corners.contains(x)
          ? Icon(
              Icons.radio_button_checked,
              color: Colors.grey,
              size: 35,
            )
          : Icon(
              Icons.radio_button_unchecked,
              size: 35,
        color: Colors.grey,

      ),
    );
  }

  Widget select_corners() {
    return Container(

      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,


      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [check(0), check(1)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [check(2), check(3)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [check(4), check(5)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [check(6), check(7)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [check(8), check(9)],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "courtscreen",
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    child: Text("Close",style: TextStyle(color: Colors.black),),
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop(corners))
                ],
              ),
            ),
            draw_court(),
            select_corners()
          ],
        ),
      ),
    );
  }
}
