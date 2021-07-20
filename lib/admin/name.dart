import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class name_edit extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  name_edit(this.analytics, this.observer);

  Future<void> _testSetCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Name Page',
      screenClassOverride: 'Name_Page',
    );
  }

  @override
  Widget build(BuildContext context) {
    _testSetCurrentScreen();
    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                "What is your name?",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              maxLength: 20,
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
                  counterStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white60),
                  labelStyle: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold)),
              onSubmitted: (name) {
                if (name.substring(name.length - 1) == "") {
                  name = name.substring(0, name.length - 1);
                }

                Navigator.pop(context, name);
              },
            )
          ],
        ),
      ),
    );
  }
}
