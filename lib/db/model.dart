import 'package:hive_flutter/hive_flutter.dart';
part 'model.g.dart';

@HiveType(typeId: 0)
class Model {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime sessionstartTime;
  @HiveField(2)
  DateTime sessionendTime;
  @HiveField(3)
  String description;
 

  Model(
      {required this.title,
      required this.sessionstartTime,
      required this.sessionendTime,
      required this.description,
      });
}
