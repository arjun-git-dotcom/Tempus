import 'package:hive/hive.dart';
part 'radio.g.dart';

@HiveType(typeId: 3)
class Radio1 {
  @HiveField(0)
  final bool selectedOption;
  @HiveField(1)
  String id;

  Radio1({required this.selectedOption, required this.id});
}
