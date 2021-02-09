import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class Finish_Screen extends StatelessWidget {


  Finish_Screen(this.total_ghost,this.total_time,this.time_array);
  List<double> time_array = [];

  String total_time;
  int total_ghost;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Time: $total_time",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Ghosts: $total_ghost",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),



              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  Container(
                    child: MaterialButton(
                    color: Colors.red,
                      minWidth: 200,


                      onPressed: (){

                        Navigator.pop(
                            context
                        );


                      }, child: Text("Done",style: TextStyle(color: Colors.white),)),
                  )],
              )
            ],
          )
        ],
      ),
    );
  }
}
