import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

@HiveType()
class Solo_stroage extends HiveObject {
  @HiveField(0)
  DateTime start;

  @HiveField(1)
  DateTime end;

  @HiveField(2)
  List<Bounce> bounces;
}

class Solo_stroage_Adapter extends TypeAdapter<Solo_stroage> {
  @override
  final typeId = 5;

  @override
  Solo_stroage read(BinaryReader reader) {
    return Solo_stroage()
      ..start = reader.read()
      ..end = reader.read()
      ..bounces = reader.read()?.cast<Bounce>();
  }

  @override
  void write(BinaryWriter writer, Solo_stroage obj) {
    writer.write(obj.start);
    writer.write(obj.end);
    writer.write(obj.bounces);
  }
}

@HiveType()
class Ghosting extends HiveObject {
  @HiveField(0)
  DateTime start;

  @HiveField(1)
  DateTime end;

  @HiveField(2)
  int rest_time;

  @HiveField(3)
  int rounds;



  @HiveField(4)
  List<double> time_array;

  @HiveField(5)
  List<double> corner_array;
}

class GhostingAdapter extends TypeAdapter<Ghosting> {
  @override
  final typeId = 9;

  @override
  Ghosting read(BinaryReader reader) {
    return Ghosting()
      ..start = reader.read()
      ..end = reader.read()
      ..rest_time = reader.read()
      ..rounds = reader.read()
      ..time_array = reader.read()?.cast<double>()
      ..corner_array = reader.read()?.cast<double>();
  }

  @override
  void write(BinaryWriter writer, Ghosting obj) {
    writer.write(obj.start);
    writer.write(obj.end);
    writer.write(obj.rest_time);
    writer.write(obj.rounds);
    writer.write(obj.time_array);
    writer.write(obj.corner_array);
  }
}

@HiveType(typeId: 101)
class Bounce extends HiveObject {
  Bounce(this.x_pos, this.y_pos, this.type, this.date);

  @HiveField(0)
  double x_pos;

  @HiveField(1)
  double y_pos;

  @HiveField(2)
  double type;

  @HiveField(3)
  DateTime date;
}

class BounceAdapter extends TypeAdapter<Bounce> {
  @override
  final typeId = 6;

  @override
  Bounce read(BinaryReader reader) {
    return Bounce(reader.read(), reader.read(), reader.read(), reader.read());
  }

  @override
  void write(BinaryWriter writer, Bounce obj) {
    writer.write(obj.x_pos);
    writer.write(obj.y_pos);
    writer.write(obj.type);
    writer.write(obj.date);
  }
}

class CustomClipperImage extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(50, 0.0);

    var endPoint = Offset(size.width*0.5, size.height);
    var controlPoint = Offset(size.width *1.3, size.height*0.3);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(.0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class CustomClipperImage2 extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(size.width, 0.0);

    var controlPoint = Offset(size.width, 0);
    var endPoint = Offset(size.width ,size.height);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width*0.5, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class CustomClipperImage3 extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, 0);
    path.lineTo(size.width, 0);

    var endPoint = Offset(0, size.height);
    var controlPoint = Offset(size.width / 0.7, size.height);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(0.0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

//    {"name": "Forehand Drives", "id": 0, "xmin": 540, "ymin": 930, "xmax": 1080, "ymax": 1645, "BackHand": false},
@HiveType()
class Solo_Defs extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int id;

  @HiveField(2)
  int xmin;

  @HiveField(3)
  int ymin;

  @HiveField(4)
  int xmax;

  @HiveField(5)
  int ymax;

  @HiveField(6)
  bool right_side;


}

class Solo_Defs_Adapter extends TypeAdapter<Solo_Defs> {
  @override
  final typeId = 78;

  @override
  Solo_Defs read(BinaryReader reader) {
    return Solo_Defs()
      ..name = reader.read()
      ..id = reader.read()
      ..xmin = reader.read()
      ..ymin = reader.read()
      ..xmax = reader.read()
      ..ymax = reader.read()
      ..right_side = reader.read();
  }

  @override
  void write(BinaryWriter writer, Solo_Defs obj) {
    writer.write(obj.name);
    writer.write(obj.id);
    writer.write(obj.xmin);
    writer.write(obj.ymin);
    writer.write(obj.xmax);
    writer.write(obj.ymax);
    writer.write(obj.right_side);

  }
}