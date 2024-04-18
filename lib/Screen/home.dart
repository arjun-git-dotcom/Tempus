import 'package:flutter/material.dart';
import 'package:tempus/Design/colors.dart';
import 'dart:async';

import 'package:tempus/Design/styles.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:tempus/Screen/termsofuse.dart';

import 'package:tempus/db/model.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  int currentTime = 0;
  int timerDuration = 0;
  Timer timer = Timer(Duration.zero, () {});
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  DateTime sessionstartTime = DateTime.now();
  DateTime sessionendTime = DateTime.now();
  late Box homebox;
  final _formKey = GlobalKey<FormState>();
  bool flag = false;

  @override
  void initState() {
    super.initState();

    homebox = Hive.box<Model>('homebox');
  }

  startTime() {
    Model model = Model(
        title: _controller2.text,
        sessionstartTime: DateTime.now(),
        sessionendTime: DateTime.now(),
        description: _controller3.text);

    homebox.add(model);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentTime > 0) {
          currentTime--;
        } else {
          model.sessionendTime = DateTime.now();

          timer.cancel();
          FlutterRingtonePlayer().playNotification();
        }
      });
    });
  }

  resetTimer() {
    setState(() {
      currentTime = timerDuration;
      startTime();
    });
  }

  String formatTime(int currentTime) {
    int minutes = currentTime ~/ 60;
    int seconds = currentTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:\n${seconds.toString().padLeft(2, '0')}';
  }

  setTimerDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              autovalidateMode: flag
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Add Title'),
                    controller: _controller2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please add title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Add Time'),
                    controller: _controller,
                    maxLength: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please add time';
                      }
                      return null;
                    },
                  ),
                  TextField(
                    controller: _controller3,
                    decoration: const InputDecoration(
                        hintText: 'description(optional)'),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          int newDuration = int.parse(_controller.text);
                          if (newDuration > 0) {
                            setState(() {
                              timerDuration = newDuration * 60;

                              resetTimer();
                              _controller.clear();
                            });
                          }
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            flag = true;
                          });
                        }
                      },
                      icon: const Icon(Icons.add)),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel))
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black(),
      appBar: AppBar(
        backgroundColor: AppColors.black(),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                return Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: AppColors.white(),
              ));
        }),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.black(),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.black()),
              child: Center(
                  child: Text(
                'Tempus',
                style: TextStyle(color: AppColors.white(), fontSize: 30),
              )),
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text('Terms Of Use',
                  style: TextStyle(color: AppColors.white())),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TermsOfUse())),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text('About', style: TextStyle(color: AppColors.white())),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutApp())),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text('Privacy Policy',
                  style: TextStyle(color: AppColors.white())),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutApp())),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text('share', style: TextStyle(color: AppColors.white())),
              onTap: () {},
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(formatTime(currentTime),
                  style: AppTextStyles.customStrokedStyle())),
          IconButton(
              onPressed: () {
                currentTime == 0 ? setTimerDialog() : null;
              },
              icon: Icon(
                Icons.access_alarm,
                size: 35,
                color: AppColors.white(),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }
}
