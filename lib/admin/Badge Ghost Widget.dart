import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Ghost_Bagde extends StatefulWidget{
  final FirebaseAnalytics analytics;
  Ghost_Bagde({@required this.analytics});



  @override
  _Ghost_BagdeState createState() => _Ghost_BagdeState();
}



class _Ghost_BagdeState extends State<Ghost_Bagde> {
  
  String box_name="badges";
  

  List<int> badge_total_numbers=[
    10,100,500,1000,5000
  ];

  List<String> badge_total_title=[
    "10 Ghosts",
    "100 Ghosts",
    "500 Ghosts",
    "1000 Ghosts",
    "5000 Ghosts",
  ];


  List<int> badge_speed_numbers=[
    10,6,4,3
  ];

  List<String> badge_speed_title=[
    "10 second average",
    "6 second average",
    "4 second average",
    "3 second average",
  ];

  List<int> badges_won=[];

  List<int> badges_speed_won=[];



  openBadgeBox() async {
     var box = await Hive.openBox('badges');

     int ghost_total = box.get("ghost_total",defaultValue: 0);
     double best_speed = box.get("best_speed",defaultValue: 999.0);


     for(int i =0; i<badge_total_numbers.length;i++){
       if (badge_total_numbers[i]<ghost_total){
         badges_won.add(i);
       }
     }

     for(int i =0; i<badge_speed_numbers.length;i++){
       if (badge_speed_numbers[i]>best_speed){
         badges_speed_won.add(i);
       }
     }

  }



  Widget Badge(String title,String image,bool hasWon){

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(


              onTap: (){

                Navigator.of(context).push(
                    new PageRouteBuilder(
                        opaque: false,
                        barrierDismissible:true,
                        //transitionDuration: Duration(seconds: 5),
                        pageBuilder: (BuildContext context, _, __) {
                          return GestureDetector(

                            onTap: (){

                              Navigator.pop(context);

                            },

                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),


                              child: Padding(
                                padding: const EdgeInsets.all(100.0),
                                child: Hero(
                                  tag: title,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(

                                        height: 500,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).splashColor,

                                            shape: BoxShape.circle

                                        ),

                                        child: Padding(
                                          padding: const EdgeInsets.all(40.0),
                                          child: hasWon?Image.asset("assets/badges/$image.png",height: 20,width:20,color: Colors.white,):Icon(Icons.lock,color: Colors.white,size: 40,),
                                        ),

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    )
                );
                widget.analytics.logEvent(name:"Badge_Clicked",
                  parameters: <String, dynamic>{
                    'type': 'Ghost_Badge',
                    'title': title,
                    'haswon': hasWon,
                  },
                );

              },


              child: Hero(
                tag: title,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(

                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Theme.of(context).splashColor,

                          shape: BoxShape.circle

                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: hasWon?Image.asset("assets/badges/$image.png",height: 20,color: Colors.white,):Icon(Icons.lock,color: Colors.white,size: 40,),
                      ),

                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
               title,style: (TextStyle(fontWeight: FontWeight.bold)),),
            )
          ],
        ),
      ),
    );


  }


  @override
  Widget build(BuildContext context) {
    openBadgeBox();
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        return Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("Ghosting Badges",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),


            Container(
              height: 200,

              child: ListView.builder(

                scrollDirection: Axis.horizontal,
                itemCount: badge_total_numbers.length,
                itemBuilder: (BuildContext context, int index) {

                return Badge(badge_total_title[index],"ga$index",badges_won.contains(index));

              },





              ),


            ),

            Container(
              height: 200,

              child: ListView.builder(

                scrollDirection: Axis.horizontal,
                itemCount: badge_speed_numbers.length,
                itemBuilder: (BuildContext context, int index) {

                  return Badge(badge_speed_title[index],"gas$index",badges_won.contains(index));

                },





              ),

            ),




          ],


        );



      },



    );

  }
}