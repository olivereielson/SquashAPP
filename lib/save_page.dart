import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SavedData extends StatefulWidget {

  SavedData();

  @override
  SavedDataState createState() => new SavedDataState();
}

class SavedDataState extends State<SavedData> {


  Color main = Color.fromRGBO(4, 12, 128, 1);


  @override
  Widget build(BuildContext context) {



    return Scaffold(



      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                "Saved Solo Workouts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Divider(
                color: main,
                thickness: 3,
              ),


            ],



          ),
        ),
      ),


    );




  }


}