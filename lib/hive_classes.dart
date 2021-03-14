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
  List<double> time_array;

  @HiveField(3)
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
      ..time_array = reader.read()?.cast<double>()
      ..corner_array = reader.read()?.cast<double>();
  }

  @override
  void write(BinaryWriter writer, Ghosting obj) {
    writer.write(obj.start);
    writer.write(obj.end);
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
    path.lineTo(0.0, 30);

    var endPoint = Offset(60, size.height);
    var controlPoint = Offset(size.width / 0.6, size.height);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(0.0, size.height);

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
    path.lineTo(size.width, 0);
    path.lineTo(size.width, 0);

    var controlPoint = Offset(size.width, size.height * 0.9);
    var endPoint = Offset(size.width * 0.1, 0);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
