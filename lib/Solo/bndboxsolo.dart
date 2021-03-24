import 'package:flutter/material.dart';
import 'dart:math' as math;
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




        var x = (re["rect"]["x"]*MediaQuery.of(context).size.width);
        var w = re["rect"]["w"]*MediaQuery.of(context).size.width;
        var y = re["rect"]["y"]*MediaQuery.of(context).size.height;
        var h = re["rect"]["h"]*MediaQuery.of(context).size.height;






        return Positioned(
          left: math.max(0, x-5),
          top: math.max(0, y-5),
          width: w+5,
          height: h+5,
          child: Container(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              border: Border.all(

                color: Colors.redAccent,
                width: 3.0,
              ),
            ),
          ),
        );








      }).toList();
    }



    return results.length > 0 ? Stack(children: _renderBoxes()) : Container(

      height: 50,
      width: 50,
      color: Colors.greenAccent,



      child: Center(child: Text("")),);
  }
}

