import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:squash/admin/Settings.dart';

class MyDynamicHeader extends SliverPersistentHeaderDelegate {
  MyDynamicHeader(this.text1, this.text2, this.ghosting, [this.info = false]);

  String text1;
  String text2;

  bool ghosting;
  bool info = false;

  int index = 0;

  Tween pos_x = Tween<double>(begin: 20, end: 20);

  Tween pos_y = Tween<double>(begin: 30, end: 20);

  Tween pos_x2 = Tween<double>(begin: 20, end: 85);
  Tween pos_x2_g = Tween<double>(begin: 20, end: 140);

  Tween pos_y2 = Tween<double>(begin: 80, end: 20);

  Tween Font = Tween<double>(begin: 50, end: 25);
  Tween Font2 = Tween<double>(begin: 40, end: 25);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final double percentage = 1 - (constraints.maxHeight - minExtent) / (maxExtent - minExtent);

      final double posx = pos_x.lerp(percentage);
      final double posy = pos_y.lerp(percentage);
      final double posx2 = ghosting ? pos_x2_g.lerp(percentage) : pos_x2.lerp(percentage);
      final double posy2 = pos_y2.lerp(percentage);
      final double font = Font.lerp(percentage);
      final double font2 = Font2.lerp(percentage);

      if (++index > Colors.primaries.length - 1) index = 0;

      return Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  top: posy2,
                  right: 20,
                  child: info
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Beta",
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                CoolAlert.show(
                                  context: context,
                                  confirmBtnColor: Theme.of(context).primaryColor,
                                  animType: CoolAlertAnimType.scale,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  title: "Important Information",
                                  flareAnimationName: "play",
                                  flareAsset: "assets/info_check.flr",
                                  type: CoolAlertType.success,
                                  text: "Solo Exercise is still in beta testing.  The Artificial Intelligence has only been taught to play squash on a few courts and might have trouble on your court."
                                      "To train the AI on your court click here",
                                );
                              },
                            ),
                          ],
                        )
                      : Text("")),
              Positioned(
                  left: posx,
                  top: posy,
                  child: Text(
                    text1,
                    style: TextStyle(color: Colors.white, fontSize: font, fontWeight: FontWeight.bold),
                  )),
              Positioned(left: posx2, top: posy2, child: Text(text2, style: TextStyle(color: percentage == 1 ? Colors.white : Colors.white70, fontSize: font2, fontWeight: FontWeight.bold)))
            ],
          ),
        ),
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 200.0;

  @override
  double get minExtent => 110.0;
}

class header_list extends SliverPersistentHeaderDelegate {
  header_list(this.am);

  AnimatedList am;

  int index = 0;

  Tween pos_t = Tween<double>(begin: -300, end: 50);
  Tween pos_y = Tween<double>(begin: 10, end: -300);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final double percentage = 1 - (constraints.maxHeight - minExtent) / (maxExtent - minExtent);

      final double posy = pos_y.lerp(percentage);

      return Stack(
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                color: Theme.of(context).primaryColor,
                width: MediaQuery.of(context).size.width,
                height: 50,
              )),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(0), bottomLeft: Radius.circular(0))),
            child: Stack(
              children: [
                Positioned(left: 0, top: posy, child: Container(width: MediaQuery.of(context).size.width, height: 250, child: am)),
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 300.0;

  @override
  double get minExtent => 10.0;
}

class header_shot extends SliverPersistentHeaderDelegate {
  header_shot(this.am);

  Widget am;

  int index = 0;

  Tween pos_t = Tween<double>(begin: -300, end: 50);
  Tween pos_y = Tween<double>(begin: 10, end: -300);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final double percentage = 1 - (constraints.maxHeight - minExtent) / (maxExtent - minExtent);

      final double posy = pos_y.lerp(percentage);

      return Stack(
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                color: Theme.of(context).primaryColor,
                width: MediaQuery.of(context).size.width,
                height: 50,
              )),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(0), bottomLeft: Radius.circular(0))),
            child: Stack(
              children: [
                Positioned(left: 0, top: posy, child: Container(width: MediaQuery.of(context).size.width, height: 200, child: am)),
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 250.0;

  @override
  double get minExtent => 10.0;
}

class profileHeader extends SliverPersistentHeaderDelegate {
  profileHeader(this.name, this.inital, this.center, this.edit);

  Widget edit;
  String name;
  String inital;
  double center;

  bool ghosting;
  bool info = false;

  int index = 0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    Tween icon_x = Tween<double>(begin: center - 50, end: 0);
    Tween icon_y = Tween<double>(begin: 40, end: -100);
    Tween name_x = Tween<double>(begin: center - 100, end: center - 100);
    Tween name_y = Tween<double>(begin: 130, end: 15);
    Tween pos_y2 = Tween<double>(begin: 15, end: 30);
    Tween iconsize = Tween<double>(begin: 50, end: 20);
    Tween iconopacity = Tween<double>(begin: 1, end: 0);
    return LayoutBuilder(builder: (context, constraints) {
      final double percentage = 1 - (constraints.maxHeight - minExtent) / (maxExtent - minExtent);

      final double iconx = icon_x.lerp(percentage);
      final double icony = icon_y.lerp(percentage);
      final double namex = name_x.lerp(percentage);
      final double namey = name_y.lerp(percentage);
      final double opacityedit = iconopacity.lerp(percentage);
      final double posy2 = pos_y2.lerp(percentage);
      final double Iconsize = iconsize.lerp(percentage);

      if (++index > Colors.primaries.length - 1) index = 0;

      return Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  top: 20,
                  left: 15,
                  child: edit
              ),
              Positioned(
                  top: icony,
                  left: iconx,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 100,
                          decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(opacityedit),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child:

                            AutoSizeText(
                              inital,
                              style: TextStyle(fontSize: Iconsize,color: Colors.grey.withOpacity(opacityedit) ),
                              maxLines: 1,
                            )
                          ))),
                    ],
                  )),
              Positioned(
                  top: namey,
                  left: namex,
                  child: Container(
                    width: 200,
                    height: 70,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: AutoSizeText(
                          name,
                          style: TextStyle(fontSize: posy2,color: Colors.white ),
                          maxLines: 1,
                        )
                      ),
                    ),
                  )),
              Positioned(
                  top: 20,
                  right: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsPage()),
                          );
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 250.0;

  @override
  double get minExtent => 150.0;
}
