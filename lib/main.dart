import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:soundpool/soundpool.dart';
import 'package:squash/Ghosting/Selection%20Screen.dart';
import 'package:squash/Ghosting/finish%20screen.dart';
import 'package:squash/admin/Settings.dart';
import 'package:squash/data/save_page.dart';
import 'package:squash/Solo/solo%20screen.dart';
import 'admin/intro_screen.dart';
import 'data/Saved Data Page.dart';
import 'admin/account.dart';
import 'Ghosting/home.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  HiveHelper.init();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  //await Firebase.initializeApp();

  runApp(
    EasyDynamicThemeWidget(child: setup()),
    //MyApp()
  );
}

class setup extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  _setupState createState() => _setupState();
}

class _setupState extends State<setup> {
  bool first_run;

  Future _future;

  @override
  void initState() {

    _future=first_time();
    super.initState();

  }


  first_time() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("First Time Check");
    if (prefs.containsKey("first_time")) {
      setState(() {
        first_run = false;
      });
    } else {
      prefs.setBool("first_time", true);
      setState(() {
        first_run = true;
      });
    }
  }

  Widget app(home) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: <NavigatorObserver>[setup.observer],
      themeMode: EasyDynamicTheme.of(context).themeMode,
      theme: ThemeData(
          brightness: Brightness.light,
          dividerTheme: DividerThemeData(),
          textTheme: TextTheme(
              bodyText2: TextStyle(color: Color.fromRGBO(60, 90, 130, 1)),

              caption: TextStyle(color: Color.fromRGBO(40, 70, 130, 1)), bodyText1: TextStyle(color: Colors.black)),
          splashColor: Color.fromRGBO(60, 90, 130, 1),
          backgroundColor: Colors.white,
          tabBarTheme: TabBarTheme(
            labelColor: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          primaryColorDark: Colors.black87,
          primaryColorLight: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Color.fromRGBO(66, 89, 138, 1),
            unselectedItemColor: Colors.grey,
          ),
          focusColor: Color.fromRGBO(66, 89, 138, 1),
          primaryColor: Color.fromRGBO(66, 89, 138, 1)),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: Color.fromRGBO(50, 50, 50, 1),
          splashColor: Color.fromRGBO(20, 20, 50, 1),
          focusColor: Colors.grey,
          textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.white),
              bodyText2: TextStyle(color: Colors.white),
              caption: TextStyle(
                color: Color.fromRGBO(20, 20, 60, 1),
              )),
          accentColor: Colors.lightBlueAccent,
          cardTheme: CardTheme(),
          primaryColor: Color.fromRGBO(20, 20, 60, 1),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.white,
            selectedIconTheme: IconThemeData(
              color: Colors.white,
            ),
            unselectedItemColor: Colors.grey,
          ),
          primaryColorDark: Colors.grey,
          indicatorColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white)),
      home: home,
    );
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (first_run == null) {
          return app(Scaffold(backgroundColor: Color.fromRGBO(60, 90, 130, 1), body: Text("")));
        }

        if (first_run) {
          return app(TestScreen(setup.analytics, setup.observer));
        }

        if (!first_run) {
          return app(MyApp(setup.analytics, setup.observer));
        }

        return app(Scaffold(backgroundColor: Color.fromRGBO(60, 90, 130, 1), body: Text("")));
      },
    );

  }
}

class MyApp extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  MyApp(this.analytics, this.observer);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController _pageController = new PageController();

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.ghost), label: "Ghosting"),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_tennis_outlined),
            label: 'Solo',
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.activityOutline),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
          ),
        ],
//fixedColor:ThemeData().bottomNavigationBarTheme.selectedItemColor,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            current = index;
          });
        },
        currentIndex: current,
      ),
      body: PageView(
        pageSnapping: true,
        allowImplicitScrolling: true,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[GhostScreen(cameras, widget.analytics, widget.observer),
          SoloScreen(cameras,widget.analytics,widget.observer),
          SavedDataPage(widget.analytics,widget.observer),
          Acount(widget.analytics,widget.observer)],


      ),
    );
  }
}

class HiveHelper {
  static void init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }
}
