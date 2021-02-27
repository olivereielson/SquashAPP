import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'Saved Data Page.dart';
import 'hive_classes.dart';
import 'main.dart';

class SavedData extends StatefulWidget {
  SavedData();

  @override
  SavedDataState createState() => new SavedDataState();
}

class SavedDataState extends State<SavedData> {
  Color main = Color.fromRGBO(4, 12, 128, 1);

  var solo_storage_box;

  Future<void> load_hive() async {
    Hive.registerAdapter(Solo_stroage_Adapter());

    solo_storage_box = await Hive.openBox<Solo_stroage>("SoloStorage");
    print(Hive.box<Solo_stroage>("SoloStorage").values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 200),
          painter: LogoPainter(),
        ),
        SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Preformance Analytics",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              child: Row(
                children: [
                  Container(
                    height: 200,
                    child: CircularPercentIndicator(
                      radius: 150.0,
                      lineWidth: 15.0,
                      backgroundWidth: 10,
                      percent: 0.9,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Color.fromRGBO(40, 40, 80, 1),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              child: Row(
                children: [
                  Container(
                    height: 200,
                    child: CircularPercentIndicator(
                      radius: 150.0,
                      lineWidth: 15.0,
                      backgroundWidth: 10,
                      percent: 0.9,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Color.fromRGBO(40, 40, 80, 1),
                    ),
                  ),
                ],
              ),
            )
          ],
        ))
      ],
    ));
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    var rect = Offset.zero & size;

    var path = Path();
    //path.lineTo(0, size.height - size.height / 5);
    //path.lineTo(size.width / 1.2, size.height);
    //Added this line

    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.6);

    path.quadraticBezierTo(size.width * 0.1, size.height * 0.6, size.width * 0.52, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.74, size.height * 0.92, size.width, size.height * 0.84);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);

    paint.shader = LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      stops: [0.1, 0.5, 1],
      colors: [
        Color.fromRGBO(40, 40, 80, 1),
        Color.fromRGBO(40, 40, 80, 1),
        Colors.indigo,
      ],
    ).createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
