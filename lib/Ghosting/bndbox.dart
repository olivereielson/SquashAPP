import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:io' show Platform;

class BndBox extends StatelessWidget {
  List<dynamic> results;

  BndBox(
    this.results,
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      results.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          double x, y;

          // x = MediaQuery.of(context).size.width-(_y*MediaQuery.of(context).size.width);
          //y = _x * MediaQuery.of(context).size.height;
          x =(_x * MediaQuery.of(context).size.width);
          y = _y * MediaQuery.of(context).size.height;

          return Positioned(
            left: x - 6,
            top: y - 6,
            child: Container(
              child: Text(
                "●",
                style: TextStyle(
                  color: Color.fromRGBO(40, 70, 130, 1),
                  fontSize: 50.0,
                ),
              ),
            ),
          );
        }).toList();

        lists..addAll(list);
      });

      return lists;
    }
    List<Widget> _renderBoxes() {

      //print(results);


      return results.map((re) {



        if (re["detectedClass"]=="person"){

          var x = (re["rect"]["x"]*MediaQuery.of(context).size.width);
          var w = re["rect"]["w"]*MediaQuery.of(context).size.width;
          var y = re["rect"]["y"]*MediaQuery.of(context).size.height;
          var h = re["rect"]["h"]*MediaQuery.of(context).size.height;






          return Positioned(
            left: math.max(0, x),
            top: math.max(0, y),
            width: w,
            height: h,
            child: Container(
              padding: EdgeInsets.only(top: 5.0, left: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                border: Border.all(

                  color: Colors.grey,
                  width: 3.0,
                ),




              ),

            ),
          );

        }else{


          return Text("");

        }










      }).toList();
    }


    return results.length > 0
        ? Stack(children: _renderBoxes())
        : Container(
            child: Center(child: Text("")),
          );
  }
}
