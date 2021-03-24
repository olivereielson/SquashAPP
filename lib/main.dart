import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hive/hive.dart';
import 'package:squash/Ghosting/Selection%20Screen.dart';
import 'package:squash/Ghosting/finish%20screen.dart';
import 'package:squash/data/save_page.dart';
import 'package:squash/Solo/solo%20screen.dart';
import 'data/Saved Data Page.dart';
import 'account.dart';
import 'Ghosting/home.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HiveHelper.init();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GhostScreen gs = new GhostScreen(cameras);

  PageController _pageController = new PageController();

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          dividerTheme: DividerThemeData(),
          textTheme: TextTheme(caption: TextStyle(color: Color.fromRGBO(40, 70, 130, 1)),
          bodyText1: TextStyle(color: Colors.black)
          ),
          splashColor: Color.fromRGBO(40, 70, 130, 1),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          primaryColorDark: Colors.black87,
        primaryColorLight: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Color.fromRGBO(40, 70, 130, 1),
        unselectedItemColor: Colors.grey,
      ),
      ),



      darkTheme: ThemeData(
          brightness: Brightness.dark,
          splashColor: Color.fromRGBO(20, 20, 50, 1),
          textTheme: TextTheme(
              caption: TextStyle(
            color: Color.fromRGBO(20, 20, 60, 1),
          )),
          accentColor: Colors.lightBlueAccent,
          cardTheme: CardTheme(),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.lightBlue,
            unselectedItemColor: Colors.grey,
          ),
          primaryColorDark: Colors.grey,
          iconTheme: IconThemeData(color: Colors.white)),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Image(
                  color: current == 0 ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor : Colors.grey,
                  height: 25,
                  width: 25,
                  image: AssetImage(
                    'assets/ghost_icon.png',
                  )),
              label: 'Ghosting',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_tennis_outlined),
              label: 'Solo',
            ),
            BottomNavigationBarItem(
              icon: Icon(EvaIcons.activityOutline),
              label: 'Saved Data',
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
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            gs,
            SoloScreen(cameras),
            SavedDataPage(),
          ],
        ),
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
