import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class credits {
  List<String> cred = [
    "Created By: Oliver Eielson",
    "Squash Icons: Oliver Eielson"
  ];
}

class credit_page extends StatelessWidget {

  credit_page(this.analytics,this.observer);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  Future<void> _testSetCurrentScreen() async {
    print("Logged Page");
    await analytics.setCurrentScreen(
      screenName: 'Credit Page',
      screenClassOverride: 'Credit_Page',
    );
  }





  @override
  Widget build(BuildContext context) {

    _testSetCurrentScreen();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Credits",style: TextStyle(fontSize: 30),),
        elevation: 0,
        leading: Text(""),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.transparent
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(

                      itemCount: credits().cred.length,
                      itemBuilder: (BuildContext context, int index) {

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(credits().cred[index],style: TextStyle(color: Colors.white,fontSize: 20),),),
                        );

                      },


                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
                child: CupertinoButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
