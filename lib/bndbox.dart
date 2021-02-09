import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'models.dart';
import 'dart:ui' as ui;
import 'dart:io' show Platform;

class BndBox extends StatelessWidget {
  List<dynamic> results;

  BndBox(this.results,);

  @override
  Widget build(BuildContext context) {



    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      results.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var  x, y;


          if(Platform.isIOS){
            x=(_x*MediaQuery.of(context).size.width);



          }else{
            x=MediaQuery.of(context).size.width-(_x*MediaQuery.of(context).size.width);


          }
          x=(_x*MediaQuery.of(context).size.width);

          y=_y*MediaQuery.of(context).size.height;



          return Positioned(
            left: x - 6,
            top: y - 6,
            child: Container(
              child: Text(
                "●",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }).toList();

        lists..addAll(list);
      });

      return lists;
    }


    return results.length > 0 ? Stack(children: _renderKeypoints()) : Container(child: Center(child: Text("")),);
  }
}

