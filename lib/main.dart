import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_project/Screen/calender.dart';
import 'package:hive_project/Screen/home.dart';
import 'package:hive_project/Screen/progress.dart';

import 'package:hive_project/Screen/schedule.dart';
import 'package:hive_project/Screen/search.dart';
import 'package:hive_project/Screen/splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_project/Screen/timer.dart';
import 'package:hive_project/db/model.dart';
import 'package:hive_project/db/eventmodel.dart';
import 'package:hive_project/db/radio.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:path_provider/path_provider.dart';
import 'package:hive_project/db/pdf.dart';
import 'package:hive_project/Screen/pdfpage.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
//dsasdfdff
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await Hive.initFlutter();
  var homebox = await Hive.openBox<Model>('homebox');
  var calenderbox = await Hive.openBox<Event>('calenderbox');
  var pdfbox = await Hive.openBox<PDFDocument>('pdf_box');
  var radiobox = await Hive.openBox<Radio1>('radio');

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      Event getEventByUUID(String uuid) {
        for (var key in calenderbox.keys) {
          Event event = calenderbox.get(key)!;

          if (event.id == uuid) {
            return event;
          }
        }

        throw Exception('Event with UUID $uuid not found.');
      }

      Radio1 getradioId(String radioId) {
        for (var key in radiobox.keys) {
          Radio1 radio1 = radiobox.get(key)!;

          if (radio1.id == radioId) {
            return radio1;
          }
        }
        throw Exception('Radio1 with radioId $radioId not found');
      }

      String desiredUUID = globalId!;
      String desiredRadioId = radioId!;
      Event? desiredEvent = getEventByUUID(desiredUUID);
      Radio1 desiredradio1 = getradioId(desiredRadioId);
      DateTime notificationclickedTime = DateTime.now();
      print(' start is ${desiredEvent.startingTime}');
      print('end is ${desiredEvent.endingTime}');
      Duration time =
          desiredEvent.endingTime.difference(desiredEvent.startingTime);
      Duration timeforPlay =
          desiredEvent.endingTime.isBefore(notificationclickedTime)
              ? notificationclickedTime.difference(desiredEvent.endingTime)
              : desiredEvent.endingTime.difference(notificationclickedTime);

      int timeforPlayinSec = timeforPlay.inSeconds;
      print(timeforPlayinSec);
      int timeinSec = time.inSeconds;
      print(timeinSec);
      print(desiredradio1.selectedOption);

      if (desiredradio1.selectedOption == false) {
        Navigator.push(
          MyApp.navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => TimerWidget(duration: timeforPlay),
          ),
        );
      } else {
        Navigator.push(
          MyApp.navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => TimerWidget(duration: time),
          ),
        );
      }
    },
  );

  Hive.registerAdapter(PDFDocumentAdapter());
  Hive.registerAdapter(ModelAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(Radio1Adapter());

  runApp(const MyApp());
}

Future<void> shownotification(int duration) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'scheduled title',
      'scheduled body',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: duration)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description')),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NavPage> {
  int selectedIndex = 0;
  List<Icon> items = [
    const Icon(Icons.abc),
    const Icon(Icons.home),
    const Icon(Icons.timelapse),
    const Icon(Icons.calendar_month),
    const Icon(Icons.person),
    const Icon(Icons.document_scanner_outlined)
  ];
  List<Widget> screens = [
    const schedule(),
    const Home(),
    const Search(),
    const Calender(),
    const Progress(),
    const PdfPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        items: items,
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: screens[selectedIndex],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
