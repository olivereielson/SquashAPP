import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'extra/headers.dart';

class SettingsPage extends StatefulWidget {

  SettingsPage();

  @override
  SettingsPageState createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {


  Widget DataColect() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
            },
            child: Container(
              height: 90,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(color: Theme.of(context).splashColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/icons/artificial-intelligence.png",color: Colors.white,height: 10,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Share Anonymous Data",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),

                      CupertinoSwitch(

                          value: true,
                          activeColor: Theme.of(context).splashColor,

                          onChanged: (val){


                      })


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }



  Widget settings(){

    return Column(

      children: [

        DataColect(),


        Spacer(),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Text("Credits",style: TextStyle(color:Colors.indigo,fontSize: 20),),
        )


      ],


    );



  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: CustomScrollView(slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: MyDynamicHeader("Settings", "", false, false),
        ),
        SliverFixedExtentList(
          itemExtent: 700.0,
          delegate: SliverChildListDelegate([
            settings()
          ], addAutomaticKeepAlives: true),
        ),
      ]),



    );



  }

}