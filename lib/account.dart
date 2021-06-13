import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:liquid_progress_indicator_ns/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'extra/headers.dart';
import 'extra/hive_classes.dart';

class Acount extends StatefulWidget {
  @override
  _AcountState createState() => _AcountState();
}

class _AcountState extends State<Acount> with SingleTickerProviderStateMixin {
  String name = "name";
  String gender = "name";
  String location = "name";
  String email = "name";

  bool edit = false;
  bool loadfeed=false;
  TabController _tabController;
  Box<Solo_stroage> solo_storage_box;
  Box<Ghosting> ghosting_box;
  List feed = [];

  List<int> goals=[10,100,1000,10000,100000,1000000,10000000,100000000];

  int shots_hit=0;
  int ball_level=0;


  int ghosts_done=0;
  int ghost_level=0;

  @override
  void initState() {
    _tabController = new TabController(
      length: 2,
      vsync: this,
    );


    super.initState();
  }

  Future<void> load_hive() async {
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
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(GhostingAdapter());
    }

    if (Hive.isBoxOpen("Ghosting1")) {
      ghosting_box = Hive.box<Ghosting>("Ghosting1");
    } else {
      ghosting_box = await Hive.openBox<Ghosting>("Ghosting1");
    }

    loadfeed=true;


  }

  Future<void> get_pref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('first_name');
      email = prefs.getString('email');
      gender = prefs.getString('gender');
      location = prefs.getString('location');
    });
  }

  void calcualte_levels(){
    shots_hit=0;
    ghosts_done=0;
    for (int i=0; i<solo_storage_box.length;i++){
      shots_hit=solo_storage_box.getAt(i).bounces.length+shots_hit;
    }
    for (int i=0; i<goals.length;i++){

      if(goals[i]<shots_hit){
        ball_level=i;
      }

    }



    for (int i=0; i<ghosting_box.length;i++){
      ghosts_done=ghosting_box.getAt(i).corner_array.length+ghosts_done;

    }
setState(() {

});


  }

  Widget info() {
    calcualte_levels();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Solo Level ${ball_level+1}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LiquidLinearProgressIndicator(
                      value: (shots_hit/goals[ball_level+1]),
                      // Defaults to 0.5.
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                      // Defaults to the current Theme's accentColor.
                      //backgroundColor: Theme.of(context).backgroundColor,
                      // Defaults to the current Theme's backgroundColor.
                      borderColor: Theme.of(context).primaryColor,
                      borderWidth: 5.0,
                      borderRadius: 30.0,

                      direction: Axis.horizontal,
                      // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                      center: Text(
                        shots_hit!=1?"$shots_hit Balls Hit":"0 Balls Hit",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Ghosting Level ${ghost_level+1}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LiquidLinearProgressIndicator(
                      value: (ghosts_done/goals[ghost_level+1]),
                      // Defaults to 0.5.
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                      // Defaults to the current Theme's accentColor.
                      backgroundColor: Theme.of(context).backgroundColor,
                      // Defaults to the current Theme's backgroundColor.
                      borderColor: Theme.of(context).primaryColor,
                      borderWidth: 5.0,
                      borderRadius: 30.0,

                      direction: Axis.horizontal,
                      // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                      center: Text(
                        "$ghosts_done Ghosts",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget feedCard(bool solo,date) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
                  child: solo?Icon(
                    Icons.sports_tennis,
                  ):Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/ghost_icon.png",color: Colors.white,height: 30,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        solo?"Solo workout":"Ghosting workout",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      Text(DateFormat('yMMMMd').format(date),style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget exersise_feed() {

    for (int i = 0; i < solo_storage_box.length; i++) {
      feed.add({"date": solo_storage_box.getAt(i).end, "wid": feedCard(true,solo_storage_box.getAt(i).end)});
      //feed[solo_storage_box.getAt(i).end]= Text(solo_storage_box.getAt(i).end.toString());

    }

    for (int i = 0; i < ghosting_box.length; i++) {
      feed.add({"date": ghosting_box.getAt(i).end, "wid": feedCard(false,ghosting_box.getAt(i).end)});

      //feed[ghosting_box.getAt(i).end]= Text(ghosting_box.getAt(i).end.toString());

    }

    feed.sort((a, b) {

      return a["date"].compareTo(b["date"]);
    });

    if (feed.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              "No data",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    return Scrollbar(
      child: ListView.builder(
        itemCount: feed.length,
        itemBuilder: (BuildContext context, int index) {
          return feed[feed.length-index-1]["wid"];
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: profileHeader("Oliver Eielson", "OE", MediaQuery.of(context).size.width / 2),
        ),
        SliverPersistentHeader(
          floating: false,
          pinned: true,
          delegate: _SliverAppBarDelegate(
            TabBar(
                indicatorColor: Colors.lightBlueAccent,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  new Tab(
                    //  icon: new Icon(Icons.sports_tennis),
                    text: "Levels",
                  ),
                  new Tab(
                    text: "Exercise Feed",
                  ),
                ],
                controller: _tabController),
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 700.0,
          delegate: SliverChildListDelegate([
            TabBarView(
              children: [info(), FutureBuilder(

                future:  load_hive(),
                builder: (

                  BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                  if(loadfeed){

                    return exersise_feed();

                  }else{

                    return Text("Loading feed");

                  }


              },)],
              controller: _tabController,
            ),
          ], addAutomaticKeepAlives: true),
        ),
      ]),
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
