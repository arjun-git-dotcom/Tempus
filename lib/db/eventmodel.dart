import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'eventmodel.g.dart';

@HiveType(typeId: 1)
class Event {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime selectedDay;
  @HiveField(2)
  DateTime startingTime;
  @HiveField(3)
  DateTime endingTime;
  @HiveField(4)
  String id;


  Event(
      {required this.title,
      required this.selectedDay,
      required this.startingTime,
      required this.endingTime,
      required this.id,
      });
}
