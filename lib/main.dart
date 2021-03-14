import 'package:eva_icons_flutter/eva_icons_flutter.dart';
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
      theme: ThemeData(brightness: Brightness.light, dividerTheme: DividerThemeData()),
      darkTheme: ThemeData(brightness: Brightness.light, primaryTextTheme: TextTheme(), textTheme: TextTheme()),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Image(
                  color: current==0?Color.fromRGBO(4, 12, 128, 1):Colors.grey,
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
          fixedColor: Color.fromRGBO(4, 12, 128, 1),
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
