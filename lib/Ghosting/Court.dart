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
  //Color court_color = Color.fromRGBO(40, 45, 81, 1);
  Color court_color = Colors.grey;

  Widget draw_court() {
     court_color = Theme.of(context).focusColor;

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
    return MaterialButton(
      splashColor: Colors.transparent,
        onPressed: () {
          setState(() {
            if (corners.contains(x)) {
              corners.remove(x);
            } else {
              corners.add(x);
            }
          });
        },
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: corners.contains(x)?court_color:Colors.transparent,
            border: Border.all(
                color: court_color,
                // set border color
                width: 6.0), // set border width
            borderRadius: BorderRadius.all(Radius.circular(15.0)), // set rounded corner radius
          ),
        ));
  }

  Widget select_corners() {
    return SafeArea(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    court_color = Theme.of(context).focusColor;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: -20,
              left: (MediaQuery.of(context).size.width - 170) / 2,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    if(corners.length==0){

                      final snackBar = SnackBar(
                        content: Text('No Corners Selected'),
                        duration: Duration(seconds: 1),


                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    }else{

                      Navigator.of(context).pop(corners);

                  }
                  },
                  child: Container(
                      width: 170,
                      height: 60,
                      decoration: BoxDecoration(
                          color: court_color,
                          border: Border.all(
                            color: court_color,
                          ),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                      child: Center(
                          child: Text(
                        "Close",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ))),
                ),
              )),
          draw_court(),
          select_corners()
        ],
      ),
    );
  }
}
