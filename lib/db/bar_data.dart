import 'package:tempus/db/induvidual_bar.dart';

class BarData {
  final double sunday;
  final double monday;
  final double tuesday;
  final double wednesday;
  final double thursday;
  final double friday;
  final double saturday;

  BarData(
      {required this.sunday,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday});

  List<InduvidualBar> barData = [];

  void inittializeBarData() {
    barData = [
      InduvidualBar(x: 0, y: sunday),
      InduvidualBar(x: 1, y: monday),
      InduvidualBar(x: 2, y: tuesday),
      InduvidualBar(x: 3, y: wednesday),
      InduvidualBar(x: 4, y: thursday),
      InduvidualBar(x: 5, y: friday),
      InduvidualBar(x: 6, y: saturday)
    ];
  }
}
