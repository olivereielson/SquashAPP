import 'package:hive/hive.dart';

@HiveType()
class Solo_stroage extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  String duration;

  @HiveField(2)
  String bounces;
}

class Solo_stroage_Adapter extends TypeAdapter<Solo_stroage> {
  @override
  final typeId = 3;

  @override
  Solo_stroage read(BinaryReader reader) {
    return Solo_stroage()
      ..date = reader.read()
      ..duration = reader.read()
      ..bounces = reader.read();
  }

  @override
  void write(BinaryWriter writer, Solo_stroage obj) {
    writer.write(obj.date);
    writer.write(obj.duration);
    writer.write(obj.bounces);
  }
}
