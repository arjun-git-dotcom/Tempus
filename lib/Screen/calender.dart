import 'package:flutter/material.dart';

import 'package:tempus/Design/colors.dart';
import 'package:tempus/Design/fonts.dart';
import 'package:tempus/Design/gradient.dart';
import 'package:tempus/db/radio.dart';
import 'package:tempus/main.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tempus/db/eventmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:tempus/db/pdf.dart';
//dfdfdd
String? globalId;
String? radioId;
Color cardColor = AppColors.black();
final TextEditingController _eventController = TextEditingController();

late Box<Event> calenderbox;
late Box<Radio1> radiobox;
final TextEditingController startingtimecontroller = TextEditingController();
final TextEditingController endingTimeController = TextEditingController();

Future<void> _savePDFPathToHive(String path, String name) async {
  final box = await Hive.openBox<PDFDocument>('pdf_box');
  final pdfDocument = PDFDocument(name: name, path: path);
  box.add(pdfDocument);
}

bool ischecked = false;
bool _isExpanded = false;

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Calender> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    calenderbox = Hive.box<Event>('calenderbox');
    radiobox = Hive.box<Radio1>('radio');

    // Initialize AwesomeNotifications
  }

  Future<FilePickerResult?> _selectPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      return result;
    } on PlatformException {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _alertdialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _eventController,
              ),
              TextButton(
                onPressed: () async {
                  FilePickerResult? result = await _selectPDF();
                  if (result != null) {
                    String pdfPath = result.files.single.path!;
                    await _savePDFPathToHive(
                      pdfPath,
                      _eventController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('pdf saved to Hive'),
                      ),
                    );
                  }
                },
                child: const Text('Select pdf'),
              ),
              SizedBox(
                height: 60,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return CheckboxListTile(
                        title: const Text('is it important?'),
                        value: ischecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            ischecked = newValue!;
                          });
                        });
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(startTime ?? DateTime.now()),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      startTime = DateTime(
                        _selectedDay.year,
                        _selectedDay.month,
                        _selectedDay.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
                child: Text(
                  'startTime',
                  style: Appfonts.dancingScript(AppColors.black(), 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(endTime ?? DateTime.now()),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      endTime = DateTime(
                        _selectedDay.year,
                        _selectedDay.month,
                        _selectedDay.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
                child: Text(
                  ' end time',
                  style: Appfonts.dancingScript(AppColors.black(), 20),
                ),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String endTimeRailway = DateFormat('HH:mm:ss').format(endTime);
                String startTimeRailway =
                    DateFormat('HH:mm:ss').format(startTime);
                const uuid = Uuid();
                globalId = uuid.v4();
                calenderbox.add(
                  Event(
                    id: globalId!,
                    title: _eventController.text,
                    selectedDay: _selectedDay,
                    startingTime: startTime,
                    endingTime: endTime,
                  ),
                );

                DateTime now = DateTime.now();

                int secondsDifference = startTime.difference(now).inSeconds;

                shownotification(secondsDifference);

                // Listen to notification actions

                _eventController.clear();
                radioId = DateTime.now().millisecondsSinceEpoch.toString();
                radiobox.add(Radio1(selectedOption: ischecked, id: radioId!));

                Navigator.pop(context);
              },
              child: const Text('submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _alertdialog();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.black(),
        title: Text(
          'Calender Schedule',
          style: Appfonts.dancingScript(AppColors.white(), 40),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppGradient.calenderGradient()),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: ExpansionTile(
                  title: Center(
                    child: Text('calender...', style: Appfonts.kelly(25)),
                  ),
                  onExpansionChanged: (isExpanded) {
                    setState(() {
                      _isExpanded = isExpanded;
                    });
                  },
                  initiallyExpanded: true,
                  children: [
                    TableCalendar(
                      headerStyle: HeaderStyle(
                        titleTextStyle:
                            Appfonts.dancingScript(AppColors.black(), 20),
                        titleCentered: true,
                        formatButtonVisible: false,
                      ),
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      calendarStyle:
                          const CalendarStyle(outsideDaysVisible: false),
                      availableGestures: AvailableGestures.all,
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(2025, 1, 1),
                      onDaySelected: ((selectedDay, focusedDay) => setState(
                            () {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            },
                          )),
                    ),
                  ]),
            ),
            ValueListenableBuilder(
                valueListenable: calenderbox.listenable(),
                builder: (context, Box<Event> calenderbox, child) {
                  if (calenderbox.isEmpty) {
                    return const Center(
                        child: Text(
                      'No schedules yet',
                      style: TextStyle(fontSize: 20),
                    ));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: calenderbox.length,
                      itemBuilder: ((context, index) {
                        Event event = calenderbox.getAt(index)!;

                        String formattedDate =
                            DateFormat.yMd().format(event.selectedDay);

                        String formatTime =
                            DateFormat('h:mm a').format(event.startingTime);

                        String formatendTime =
                            DateFormat('h:mm a').format(event.endingTime);

                        return Card(
                          color: event.endingTime.isBefore(DateTime.now())
                              ? Colors.red
                              : cardColor,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  MainAxisAlignment.spaceEvenly,
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
                                                    style:
                                                        Appfonts.dancingScript(
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
                                                    style:
                                                        Appfonts.dancingScript(
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
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
