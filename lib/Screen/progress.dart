import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_project/Design/colors.dart';
import 'package:hive_project/Design/fonts.dart';
import 'package:hive_project/Design/gradient.dart';
import 'package:hive_project/Design/styles.dart';
import 'package:hive_project/db/eventmodel.dart';
import 'package:hive_project/db/model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:hive_project/db/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  late Box<Model> homebox;
  late Box<Event> calenderbox;

  List<double> weekSummarySession1 = List.filled(7, 0.0);
  List<double> weekSummarySession2 = List.filled(7, 0.0);

  @override
  void initState() {
    super.initState();
    homebox = Hive.box<Model>('homebox');
    calenderbox = Hive.box<Event>('calenderbox');
    calculateWeekSummarySession1();
    calculateWeekSummarySession2();
  }

  void calculateWeekSummarySession1() {
    for (var i = 0; i < homebox.length; i++) {
      var boxItem = homebox.getAt(i)!;

      String dayOfWeekStart =
          DateFormat('EEEE').format(boxItem.sessionstartTime);
      int dayIndex = getDayIndex(dayOfWeekStart);

      double sessionDuration = boxItem.sessionendTime
          .difference(boxItem.sessionstartTime)
          .inMinutes
          .toDouble();
      weekSummarySession1[dayIndex] += sessionDuration;
    }
    setState(() {});
  }

  void calculateWeekSummarySession2() {
    for (var i = 0; i < calenderbox.length; i++) {
      var event = calenderbox.getAt(i)!;

      String dayOfWeekStart = DateFormat('EEEE').format(event.startingTime);
      int dayIndex = getDayIndex(dayOfWeekStart);

      weekSummarySession2[dayIndex]++;
    }
    setState(() {});
  }

  int getDayIndex(String dayOfWeek) {
    switch (dayOfWeek) {
      case 'Sunday':
        return 0;
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black(),
        title: Center(
          child: Text(
            'Performance chart',
            style: Appfonts.dancingScript(AppColors.white(), 50),
          ),
        ),
      ),
      body: 
           SafeArea(
              child: 
              Container(
                decoration:
                    BoxDecoration(gradient: AppGradient.calenderGradient1()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    calenderbox.isEmpty && homebox.isEmpty
          ? const Center(child: Text('No data to show')):
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Session 1'),
                        const Text('x axis - days of week'),
                        const Text('y axis - total duration'),
                        SizedBox(
                          height: 250,
                          width: 250,
                          child: BarChart(
                            BarChartData(
                              maxY: 10,
                              minY: 0,
                              barGroups: weekSummarySession1
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final dayIndex = entry.key;
                                final sessionCount = entry.value;
                                return BarChartGroupData(
                                  x: dayIndex,
                                  barRods: [
                                    BarChartRodData(toY: sessionCount),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text('Session 2'),
                        const Text('x axis - days of week'),
                        const Text('y axis - session count'),
                        SizedBox(
                          height: 250,
                          width: 250,
                          child: BarChart(
                            BarChartData(
                              maxY: 10,
                              minY: 0,
                              barGroups: weekSummarySession2
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final dayIndex = entry.key;
                                final sessionCount = entry.value;
                                return BarChartGroupData(
                                  x: dayIndex,
                                  barRods: [
                                    BarChartRodData(toY: sessionCount),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
