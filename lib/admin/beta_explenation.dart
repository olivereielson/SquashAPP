import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class beta extends StatelessWidget {
  beta(this.analytics, this.observer);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  String url = 'https://flutter.dev';

  Future<void> _testSetCurrentScreen() async {
    print("Solo Beta Page Logged");
    await analytics.setCurrentScreen(
      screenName: 'Solo Beta Page',
      screenClassOverride: 'Solo_Beta_Page',
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    _testSetCurrentScreen();
    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      appBar: AppBar(
        title: Text(
          "Beta Information",
          style: TextStyle(fontSize: 30),
        ),
        elevation: 0,
        toolbarHeight: 100,
        leading: Text(""),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Image.asset(
                "assets/icons/robot_learning.png",
                color: Colors.white,
                height: 190,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "The AI is still leaning and might have trouble tracking the ball on your court.",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 30,bottom: 20),
                child: Row(
                  children: [
                    Text(
                      "Ways to trouble shoot this:",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [

                    Text(
                      "1) Use a court with standard white walls",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "2) Use a court with good lighting",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "3) Place the phone at shoulder level",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "4) Don't wear clothes with images of squash balls",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "5) Remove extra objects from the frame",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],


                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30,bottom: 20),
                child: Row(
                  children: [
                    Text(
                      "Help Teach the AI",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  text: "If these fixes don't work you can help teach the AI how to play squash on your court by",
                ),
                TextSpan(

                  style: TextStyle(fontWeight: FontWeight.bold),
                  text: " clicking here ",

                  recognizer:new TapGestureRecognizer()
                    ..onTap = (){

                     _launchInBrowser(url);
                    }
                ),

              ],
            ),
          ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CupertinoButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Text(
                        "Understand",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
