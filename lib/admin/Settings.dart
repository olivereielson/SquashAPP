import 'package:direct_select/direct_select.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:in_app_review/in_app_review.dart';
import 'package:package_info/package_info.dart';
import 'package:email_launcher/email_launcher.dart';

import '../extra/headers.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();

  @override
  SettingsPageState createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  PackageInfo packageInfo;
  bool gotinfo = false;
  bool share_data = true;
  bool dark_mode = false;

  int themeIndex = 0;






  getversion() async {
    packageInfo = await PackageInfo.fromPlatform();
    gotinfo = true;
  }

  Widget darkmode() {

    if(EasyDynamicTheme.of(context).themeMode==ThemeMode.dark){
      themeIndex=0;
    }
    if(EasyDynamicTheme.of(context).themeMode==ThemeMode.light){
      themeIndex=1;
    }
    if(EasyDynamicTheme.of(context).themeMode==ThemeMode.system){
      themeIndex=2;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 140,
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(color: Theme.of(context).splashColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.dark_mode)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 40),
                        child: Text(
                          "Theme",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  CupertinoSlidingSegmentedControl(
                    onValueChanged: (value) {
                      if (value == 0) {
                        EasyDynamicTheme.of(context).changeTheme(dark: true);
                      }
                      if (value == 1) {
                        EasyDynamicTheme.of(context).changeTheme(dark: false);
                      }
                      if (value == 2) {
                        EasyDynamicTheme.of(context).changeTheme(dynamic: true);
                      }

                      setState(() {
                        themeIndex = value;
                      });
                    },
                    thumbColor: Theme.of(context).primaryColor,
                    groupValue: themeIndex,
                    children: <int, Widget>{
                      0: Text('Dark Mode', style: TextStyle(color: themeIndex == 0 ? Colors.white : Colors.grey)),
                      1: Text(
                        'Light Mode',
                        style: TextStyle(color: themeIndex == 1 ? Colors.white : Colors.grey),
                      ),
                      2: Text('System Default', style: TextStyle(color: themeIndex == 2 ? Colors.white : Colors.grey))
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget Rate_App() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          //final InAppReview inAppReview = InAppReview.instance;

        // if (await inAppReview.isAvailable()) {
         // inAppReview.requestReview();
         // }
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
                    child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.star_border)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Submit a Rating",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget FeedBack() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          Email email = Email(
              to: ['oliver.eielson@gmail.com'],
              //cc: ['foo@gmail.com'],
              //  bcc: ['bar@gmail.com'],
              subject: 'FeedBack',
              body: '');
          await EmailLauncher.launch(email);
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
                    child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.feedback_outlined)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Send Feedback",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget DataColect() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {},
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
                    child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.cloud)),
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
                      value: share_data,
                      activeColor: Theme.of(context).splashColor,
                      onChanged: (val) {
                        setState(() {
                          share_data = val;
                        });
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget VersionInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {},
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
                    child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.handyman)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Build Number",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  FutureBuilder(
                    future: getversion(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (gotinfo) {
                        return Text(packageInfo.buildNumber);
                      } else {
                        return Text(gotinfo.toString());
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {},
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
                    child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.handyman)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Build Version",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  FutureBuilder(
                    future: getversion(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (gotinfo) {
                        return Text(packageInfo.version);
                      } else {
                        return Text(gotinfo.toString());
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> credits() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Credits'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Created by: Oliver Eielson'),
                Text('Squash Icon by: add name here '),
                Text('Squash Icon by: add name here '),
                Text('Squash Icon by: add name here '),
                Text('Squash Icon by: add name here '),
                Text('Squash Icon by: add name here '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color.fromRGBO(66, 89, 138, 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> terms() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Dont sue me please i dont have any money'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Accept',
                style: TextStyle(
                  color: Color.fromRGBO(66, 89, 138, 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget settings() {
    return Column(
      children: [
        darkmode(),
        DataColect(),
      //  Rate_App(),
        FeedBack(),
        buildInfo(),
        //VersionInfo(),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      credits();
                    },
                    child: Text(
                      "Credits",
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
                    )),
              ),
              GestureDetector(
                  onTap: () {
                    terms();
                  },
                  child: Text(
                    "Terms and Conditions",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
                  )),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(fontSize: 30),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          toolbarHeight: 100,
        ),
        body: settings());
  }
}
