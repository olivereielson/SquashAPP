import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';
import 'package:theme_provider/theme_provider.dart';

class theme_page extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  theme_page(this.analytics, this.observer);

  @override
  _theme_pageState createState() => _theme_pageState();
}

class _theme_pageState extends State<theme_page> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  Color _currentColor=Colors.blue;



  @override
  void initState() {
    _testSetCurrentScreen();

    super.initState();
  }

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Theme Page',
      screenClassOverride: 'Theme_Page',
    );
  }

  AppTheme customAppTheme(Color splashColor, Color primaryColor, String id) {
    return AppTheme(
      id: id,
      description: "Custom Color Scheme",
      data: ThemeData(
          splashColor: splashColor,
          primaryColor: Color.fromRGBO(66, 89, 138, 1),
          dividerTheme: DividerThemeData(),
          textTheme: TextTheme(bodyText2: TextStyle(color: Color.fromRGBO(60, 90, 130, 1)), caption: TextStyle(color: Color.fromRGBO(40, 70, 130, 1)), bodyText1: TextStyle(color: Colors.black)),
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
          highlightColor: Colors.black,
          focusColor: Color.fromRGBO(66, 89, 138, 1)),
    );
  }

  Widget theme_card(int index,ThemeController controller) {



    return GestureDetector(

      onTap: (){

        controller.setTheme(controller.allThemes[index].id);


      },

      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(

            color: controller.currentThemeId!=controller.allThemes[index].id?Colors.transparent:Colors.white,

            border: Border.all(


            color: controller.currentThemeId!=controller.allThemes[index].id? Colors.white:Colors.transparent,

            width: 3), borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(ThemeProvider.controllerOf(context).allThemes[index].description,style: TextStyle(color: controller.currentThemeId==controller.allThemes[index].id?Theme.of(context)
              .primaryColor:Colors.white),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeController controller = ThemeProvider.controllerOf(context);


    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      appBar: AppBar(
        title: Text("Theme Settings"),
        elevation: 0,

      ),
      body: GridView.count(crossAxisCount: 2,

        crossAxisSpacing:40,
        mainAxisSpacing: 40,
      padding: EdgeInsets.all(20.0),


      children: [

        theme_card(0, controller),
        theme_card(1, controller),
        theme_card(2, controller),
        theme_card(3, controller),
        theme_card(4, controller),
        theme_card(5, controller),
        //theme_card(6, controller),




      ],

      )
    );
  }
}
