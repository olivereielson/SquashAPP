import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash/admin/terms_and_conditions.dart';

import '../main.dart';

class TestScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  TestScreen(this.analytics, this.observer);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final pages = [
    PageViewModel(
      pageColor: Color.fromRGBO(60, 90, 130, 1),
      titleTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white, fontSize: 30),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      mainImage: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to Squash Labs",
            style: TextStyle(fontFamily: 'MyFont', color: Colors.white, fontSize: 30),
          ),
        ],
      ),
    ),
    PageViewModel(
      pageColor: Color.fromRGBO(60, 90, 130, 1),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Whats your name?"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: TextField(
              onSubmitted: (name) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("first_name", name);
              },
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
            ),
          ),
        ],
      ),
      titleTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white, fontSize: 30),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Color.fromRGBO(60, 90, 130, 1),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Terms and Conditions"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Container(
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: Text(
                    terms().terms_text,
                    style: TextStyle(fontSize: 10),
                  )),
                )),
          ),
        ],
      ),
      titleTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white, fontSize: 30),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Color.fromRGBO(60, 90, 130, 1),
      body: const Text(
        'Ghosting exercises powered by artificial intelligence',
      ),
      title: const Text(
        'Ghosting Practice',
        softWrap: false,
        maxLines: 1,
        overflow: TextOverflow.visible,
      ),
      titleTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white, fontSize: 40),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      mainImage: Image.asset(
        'assets/court_intro.png',
      ),
    ),
    PageViewModel(
      pageColor: Color.fromRGBO(60, 90, 130, 1),
      body: const Text(
        'Improve your game with the help a artificial intelligence powered solo exercises',
      ),
      title: const Text('Solo Practice'),
      mainImage: Image.asset(
        'assets/solo_intro.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Color.fromRGBO(60, 90, 130, 1),
      body: const Text(
        'Track your progress with real time data analytics',
      ),
      title: const Text('Data Analytics  '),
      mainImage: Image.asset(
        'assets/data_intro.png',
        color: Colors.white,
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IntroViewsFlutter(
        pages,
        showNextButton: true,
        showBackButton: true,
        showSkipButton: false,
        doneText: SafeArea(child: Text("Start")),
        nextText: SafeArea(child: Text("Next")),
        backText: SafeArea(child: Text("Back")),
        columnMainAxisAlignment: MainAxisAlignment.center,
        onTapDoneButton: () {
          // Use Navigator.pushReplacement if you want to dispose the latest route
          // so the user will not be able to slide back to the Intro Views.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyApp(widget.analytics, widget.observer)),
          );
        },
        pageButtonTextStyles: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
