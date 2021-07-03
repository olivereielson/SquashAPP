import 'dart:math';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:blobs/blobs.dart';
import 'package:custom_clippers/Clippers/directional_wave_clipper.dart';
import 'package:custom_clippers/Clippers/multiple_points_clipper.dart';
import 'package:custom_clippers/Clippers/sin_cosine_wave_clipper.dart';
import 'package:custom_clippers/enum/enums.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scidart/numdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/data/Solo_Stat.dart';
import 'package:squash/data/calculations.dart';
import 'package:squash/data/save_page.dart';
import 'package:squash/data/save_page_ghost.dart';
import 'package:squash/extra/headers.dart';
import 'package:squash/maginfine/touchBubble.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../extra/hive_classes.dart';
import '../maginfine/magnifier.dart';
import 'Ghost_stat.dart';

class SavedDataPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  SavedDataPage(this.analytics,this.observer);

  @override
  SavedDataPageSate createState() => new SavedDataPageSate();
}

class SavedDataPageSate extends State<SavedDataPage> with SingleTickerProviderStateMixin {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();
  final GlobalKey<SliverAnimatedListState> _listKey2 = GlobalKey<SliverAnimatedListState>();

  List<String> ghost_data_names = [
    "Average",
    "Speed",
    "Average",
    "Duration",
  ];

  List<String> ghost_data_units = ["Ghosts/Second", "Seconds"];

  List<String> solo_data_names = ["Average", "Duration", "Average", "Accuracy", "Average", "Shot Count"];

  List<double> ghost_data = [100, 80];
  List<double> solo_data = [100, 80, 40];

  int solo_index = 0;
  int ghost_index = 0;

  Box<Solo_stroage> solo_storage_box;
  Box<Ghosting> ghosting_box;

  double rest = 0;
  double work = 0;

  int ave_solo_dur;
  int ave_shot_num;

  int ave_ghost_dur;
  int ave_ghost_num;
  double accuracy;

  List<double> solo_type_pie_chart_data = [0, 0, 0, 0];
  List<double> ghost_type_pie_chart_data = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  List<Color> type_pie_color = [
    Color.fromRGBO(66, 89, 138, 1),
    Colors.grey,
    Color.fromRGBO(20, 20, 60, 1),
    Color(0xff044d7c),
    Color.fromRGBO(20, 20, 60, 1),
    Colors.lightBlueAccent,
    Color.fromRGBO(20, 20, 80, 1),
    Colors.indigoAccent,
    Colors.blueGrey,
    Color.fromRGBO(20, 50, 120, 1),
    Colors.indigo
  ];

  List<BarChartGroupData> barchrt = [];
  List<double> single_corner_speed = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  TabController _tabController;

  bool is_shaking = false;

  List<FlSpot> speed = [];

  Map<DateTime, List<String>> eventDay = {};

  DateTime _currentDate = DateTime.now();
  DateTime _monthdate = DateTime.now();
  int _count = 0;
  Future _load_calander;


  @override
  void initState() {
    //load_hive();
    //calculate_data();
    _load_calander=calculate_calender();
    _testSetCurrentScreen();
    _tabController = new TabController(length: 3, vsync: this,);

    super.initState();
  }

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Data_Page',
      screenClassOverride: 'Data_Page',
    );
  }




  Future<void> calculate_calender() async {

    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(GhostingAdapter());
    }

    if (Hive.isBoxOpen("Ghosting1")) {
      ghosting_box = Hive.box<Ghosting>("Ghosting1");
    } else {
      ghosting_box = await Hive.openBox<Ghosting>("Ghosting1");
    }

    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(Solo_stroage_Adapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(BounceAdapter());
    }

    if (Hive.isBoxOpen("Solo1")) {
      solo_storage_box = Hive.box<Solo_stroage>("Solo1");
    } else {
      solo_storage_box = await Hive.openBox<Solo_stroage>("Solo1");
    }

    for (int i = 0; i < solo_storage_box.length; i++) {
      DateTime cdate = DateTime(solo_storage_box.getAt(i).start.year, solo_storage_box.getAt(i).start.month, solo_storage_box.getAt(i).start.day);

      //print(cdate.day);

      if (eventDay[cdate] != null) {
        List<String> l = eventDay[cdate];
        l.add("0" + i.toString());

        eventDay[cdate] = l;
      } else {
        eventDay[cdate] = ["0" + i.toString()];
      }
    }
    for (int i = 0; i < ghosting_box.length; i++) {
      DateTime cdate = DateTime(ghosting_box.getAt(i).start.year, ghosting_box.getAt(i).start.month, ghosting_box.getAt(i).start.day);

      if (eventDay[cdate] != null) {
        List<String> l = eventDay[cdate];
        l.add("1" + i.toString());

        eventDay[cdate] = l;
      } else {
        eventDay[cdate] = ["1" + i.toString()];
      }
    }
  }


  Widget ghost_saved(int index) {
    return ShakeAnimatedWidget(
      enabled: is_shaking,
      duration: Duration(milliseconds: 500),
      shakeAngle: Rotation.deg(z: 1),
      curve: Curves.linear,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GestureDetector(
                onLongPress: () {
                  setState(() {
                    // is_shaking = true;
                  });
                },
                onTap: () {
                  if (!is_shaking) {
                    Navigator.push(
                        context, PageTransition(type: PageTransitionType.size, alignment: Alignment.center, duration: Duration(milliseconds: 200), child: SavedDataGhost(ghosting_box.getAt(index),
                        widget.analytics,widget.observer)));
                  }
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor,width: 3),


                       borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Image.asset(
                            "assets/ghost_icon.png",
                            color: Theme.of(context).primaryColor,
                            height: 40,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DateFormat('MMMMd').format(ghosting_box.getAt(index).start).toString(), style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                            Text(DateFormat('jm').format(ghosting_box.getAt(index).start).toString(), style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right,color: Theme.of(context).primaryColor,)
                      ],
                    ),
                  ),
                )),
            is_shaking
                ? Positioned(
                    top: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        Widget temp = ghost_saved(index);

                        _listKey2.currentState.removeItem(index, (context, animation) => SizeTransition(sizeFactor: animation, child: temp), duration: Duration(milliseconds: 500));
                        setState(() {
                          ghosting_box.deleteAt(index);
                        });
                      },
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey,
                          )),
                    ))
                : Text("")
          ],
        ),
      ),
    );
  }

  Widget Solo_Saved(int index) {
    return ShakeAnimatedWidget(
      enabled: is_shaking,
      duration: Duration(milliseconds: 500),
      shakeAngle: Rotation.deg(z: 1),
      curve: Curves.linear,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GestureDetector(
              onLongPress: () {
                setState(() {
                  //is_shaking = true;
                });
              },
              onTap: () {
                if (!is_shaking) {
                  Navigator.push(
                      context, PageTransition(type: PageTransitionType.size, alignment: Alignment.center, duration: Duration(milliseconds: 200), child: SavedData(solo_storage_box.getAt(index),
                      widget.analytics,widget.observer)));
                }
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(

                    border: Border.all(color: Theme.of(context).primaryColor,width: 3),

                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.sports_tennis,
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('MMMMd').format(solo_storage_box.getAt(index).start).toString(), style: TextStyle(fontSize: 25, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                          Text(DateFormat('jm').format(solo_storage_box.getAt(index).start).toString(), style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                child: is_shaking
                    ? GestureDetector(
                  onTap: () {
                    Widget temp = Solo_Saved(index);

                    DateTime cdate = DateTime(ghosting_box.getAt(index).start.year, ghosting_box.getAt(index).start.month, ghosting_box.getAt(index).start.day);

                    eventDay[cdate].remove(index);

                    solo_storage_box.deleteAt(index);

                    //_listKey.currentState.removeItem(index, (context, animation) => SizeTransition(sizeFactor: animation, child: temp), duration: Duration(milliseconds: 500));


                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      )),
                )
                    : Text(""))
          ],
        ),
      ),
    );
  }


  Widget page_2() {
    //print(events);

    return ListView(
      children: [
        FutureBuilder(
          future: _load_calander,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (Hive.isBoxOpen("Ghosting1") && Hive.isBoxOpen("Solo1") && solo_storage_box.length + ghosting_box.length != 0) {


              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    CalendarCarousel<Event>(
                      onDayPressed: (DateTime date, List<Event> events) {
                        this.setState(() => _currentDate = date);
                      },
                      weekendTextStyle: TextStyle(
                        color: Colors.black,
                      ),
                      todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
                      weekdayTextStyle: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold),
                      selectedDayBorderColor: Theme.of(context).primaryColor,
                      todayButtonColor: Theme.of(context).primaryColor.withOpacity(0.5),
                      todayBorderColor: Theme.of(context).primaryColor,
                      selectedDayButtonColor: Theme.of(context).primaryColor,
                      iconColor: Theme.of(context).primaryColor,
                      thisMonthDayBorderColor: Colors.grey,
                      selectedDateTime: _currentDate,
                      headerTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 30),
                      headerText: DateFormat("MMMM y").format(_monthdate),
                      customGridViewPhysics: NeverScrollableScrollPhysics(),

                      onCalendarChanged: (date) {
                        setState(() {
                          _monthdate = date;
                        });
                      },
                      isScrollable: false,
                      weekFormat: false,
                      height: 420.0,
                      daysHaveCircularBorder: null,
                    ),
                    Column(
                      children: eventDay[DateTime(_currentDate.year, _currentDate.month, _currentDate.day)] != null
                          ? eventDay[DateTime(_currentDate.year, _currentDate.month, _currentDate.day)]
                              .map((e) => e.substring(0, 1) == "1" ? ghost_saved(int.parse(e.substring(1))) : Solo_Saved(int.parse(e.substring(1))))
                              .toList()
                          : [Text("No Data")],
                    )
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Text(
                    "No Saved Data",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget page_22() {
    return GestureDetector(
      onTap: () {
        setState(() {
          is_shaking = false;
        });
      },
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (Hive.isBoxOpen("Ghosting1") && Hive.isBoxOpen("Solo1") && solo_storage_box.length + ghosting_box.length != 0) {
            return CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  // This is the flip side of the SliverOverlapAbsorber
                  // above.

                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverAnimatedList(
                    key: _listKey, initialItemCount: solo_storage_box.length, itemBuilder: (context, index, animation) => SizeTransition(sizeFactor: animation, child: Solo_Saved(index))),
                SliverAnimatedList(key: _listKey2, initialItemCount: ghosting_box.length, itemBuilder: (context, index, animation) => SizeTransition(sizeFactor: animation, child: ghost_saved(index))),
              ],
            );
          } else {
            return Center(
                child: Text(
              "No Saved Data",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ));
          }
        },
      ),
    );
  }


  int pagenum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            is_shaking = false;
          });
        },
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: MyDynamicHeader("Data", "Analytics", false),
              ),
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  floating: false,
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                        indicatorColor: Colors.white60,
                        indicatorWeight: 3,
                        tabs: [
                          new Tab(
                            //  icon: new Icon(Icons.sports_tennis),
                            text: "Solo",
                          ),
                          new Tab(
                            text: "Ghosting",
                          ),
                          new Tab(
                            // icon: new Icon(Icons.save),
                            text: "Saved",
                          ),
                        ],
                        controller: _tabController),
                  ),
                ),
              ),
            ];
          },
          floatHeaderSlivers: false,
          body: TabBarView(
            children: [
              Solo_Stat(widget.analytics,widget.observer),
              Ghost_Stat(widget.analytics,widget.observer),
              page_2(),
            ],
            controller: _tabController,
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
