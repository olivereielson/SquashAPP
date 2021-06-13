import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'extra/headers.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();

  @override
  SettingsPageState createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  PackageInfo packageInfo;
  bool gotinfo = false;
  bool share_data=true;

  getversion() async {
    packageInfo = await PackageInfo.fromPlatform();
    gotinfo = true;

  }

  Widget darkmode(){
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
                    child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.dark_mode)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Dark Mode",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  CupertinoSwitch(value: share_data, activeColor: Theme.of(context).splashColor, onChanged: (val) {

                    setState(() {
                      share_data=val;
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
                  CupertinoSwitch(value: share_data, activeColor: Theme.of(context).splashColor, onChanged: (val) {

                    setState(() {
                      share_data=val;
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

  Widget settings() {
    return Column(
      children: [
        DataColect(),        darkmode(),

        buildInfo(),
        VersionInfo(),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: GestureDetector(
              onTap: () {
                credits();
              },
              child: Text(
                "Credits",
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
              )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Settings",style: TextStyle(fontSize: 30),),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 100,

      ),
      body: settings()
    );
  }
}
