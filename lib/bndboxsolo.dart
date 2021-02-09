import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'models.dart';
import 'dart:ui' as ui;
import 'dart:io' show Platform;

class BndBoxSolo extends StatelessWidget {
  List<dynamic> results;

  BndBoxSolo(this.results,);

  @override
  Widget build(BuildContext context) {



    List<Widget> _renderBoxes() {

      //print(results);


      return results.map((re) {



        var x = re["rect"]["x"]*MediaQuery.of(context).size.width;
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
                border: Border.all(
                  color: Colors.red,
                  width: 3.0,
                ),
              ),
            ),
          );








      }).toList();
    }


    return results.length > 0 ? Stack(children: _renderBoxes()) : Container(child: Center(child: Text("")),);
  }
}

