import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class beta extends StatelessWidget {

  beta(this.analytics,this.observer);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  Future<void> _testSetCurrentScreen() async {
    print("Logged Page");
    await analytics.setCurrentScreen(
      screenName: 'Terms Page',
      screenClassOverride: 'Terms_Page',
    );
  }


  @override
  Widget build(BuildContext context) {
    _testSetCurrentScreen();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Terms and Conditions"),
        elevation: 0,
        leading: Text(""),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView(
                        children: [
                          Text(
                            "terms().terms_text",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: CupertinoButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Accept",
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
