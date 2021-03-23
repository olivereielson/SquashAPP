import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';



class MyDynamicHeader extends SliverPersistentHeaderDelegate {


  MyDynamicHeader(this.text1,this.text2,this.ghosting,[this.info=false]);

  String text1;
  String text2;

  bool ghosting;
  bool info=false;

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
      final double posx2 = ghosting?pos_x2_g.lerp(percentage):pos_x2.lerp(percentage);
      final double posy2 = pos_y2.lerp(percentage);
      final double font = Font.lerp(percentage);
      final double font2 = Font2.lerp(percentage);

      if (++index > Colors.primaries.length - 1) index = 0;

      return Container(
        color: Color.fromRGBO(20, 20, 50, 1),
        child: SafeArea(
          child: Stack(
            children: [

              Positioned(
                  top: posy2,
                  right: 20,
                  child:info? Row(
                    children: [
                      Text("Beta",style: TextStyle(color: Colors.white),),
                      IconButton(icon: Icon(Icons.info_outline,color: Colors.white,),onPressed: (){
                        CoolAlert.show(
                          context: context,
                          confirmBtnColor: Color.fromRGBO(20, 20, 50, 1),
                          animType: CoolAlertAnimType.scale,
                          backgroundColor:Color.fromRGBO(50, 50, 100, 1),

                          title: "Important Information",
                          flareAnimationName:"play",
                          flareAsset: "assets/info_check.flr",
                          type: CoolAlertType.success,
                          text: "Solo Exercise is still in beta testing.  The Artificial Intelligence has only been taught to play squash on a few courts and might have trouble on your court. ",

                        );

                      },),
                    ],
                  ):Text("")),

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
  double get minExtent => 100.0;
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
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 50,
              )),
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(20, 20, 50, 1), borderRadius: BorderRadius.only(bottomRight: Radius.circular(0),bottomLeft: Radius.circular(0))),

            child: Stack(
              children: [

                Positioned(
                    left: 0,
                    top: posy,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: am)),



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


