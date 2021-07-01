

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class name_edit extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).primaryColor,


      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text("What is your name?",style: TextStyle(color: Colors.white,fontSize: 25),),
            ),

            TextField(
              style: TextStyle(color: Colors.white),

              decoration: InputDecoration(
                  hintText: "Eg Joe Smith",
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),

                  hintStyle: TextStyle(color: Colors.white60),
                  labelStyle: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold)),

              onSubmitted: (name){

                Navigator.pop(context,name);


              },





            )


          ],


        ),
      ),


    );


  }



}