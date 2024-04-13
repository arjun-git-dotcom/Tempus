import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_project/Design/colors.dart';
import 'package:hive_project/Design/fonts.dart';
import 'package:hive_project/Screen/home.dart';
import 'package:hive_project/Screen/timer.dart';
import 'package:hive_project/db/eventmodel.dart';
import 'package:hive_project/db/model.dart';
import 'package:hive_project/db/radio.dart';
import 'package:hive_project/main.dart';
import 'package:intl/intl.dart';

class schedule extends StatefulWidget {
  const schedule({super.key});

  @override
  State<schedule> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<schedule> {
  late Box<Event> calenderbox;
  late Box<Model> homebox;
  late Box<Radio1> radiobox;
  DateTime today = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calenderbox = Hive.box<Event>('calenderbox');
    homebox = Hive.box<Model>('homebox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black(),
      ),
      backgroundColor: AppColors.black(),
      body: calenderbox.isEmpty
          ? Center(child:  Text('No schedules yet',style: TextStyle(color: AppColors.white()),))
          : Column(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: calenderbox.listenable(),
                    builder: (context, Box<Event> calenderbox, child) {
                      List<Event> selectedDays =
                          calenderbox.values.where((event) {
                        return event.selectedDay.year == today.year &&
                            event.selectedDay.month == today.month &&
                            event.selectedDay.day == today.day;
                      }).toList();

                      if (selectedDays.isEmpty) {
                        const Text('No schedules today');
                      }
                      return ListView.builder(
                        itemCount: selectedDays.length,
                        itemBuilder: ((context, index) {
                          Event event = calenderbox.getAt(index)!;

                          String formattedDate =
                              DateFormat.yMd().format(event.selectedDay);

                          String formatTime =
                              DateFormat('h:mm a').format(event.startingTime);

                          String formatendTime =
                              DateFormat('h:mm a').format(event.endingTime);

                          return Card(
                            color: AppColors.black(),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        event.title,
                                        style:
                                            TextStyle(color: AppColors.white()),
                                      ),
                                      Text(
                                        formattedDate,
                                        style:
                                            TextStyle(color: AppColors.white()),
                                      ),
                                      Text(
                                        '$formatTime - $formatendTime',
                                        style:
                                            TextStyle(color: AppColors.white()),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: const Text(
                                                'Are you sure you want to delete?'),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        calenderbox
                                                            .deleteAt(index);
                                                        flutterLocalNotificationsPlugin
                                                            .cancel(0);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'yes',
                                                      style: Appfonts
                                                          .dancingScript(
                                                              AppColors.black(),
                                                              20),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'cancel',
                                                      style: Appfonts
                                                          .dancingScript(
                                                              AppColors.black(),
                                                              20),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete_forever_outlined,
                                      color: AppColors.white(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
