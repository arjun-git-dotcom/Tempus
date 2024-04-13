import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hive_project/Design/colors.dart';
import 'package:hive_project/Design/styles.dart';

class TimerWidget extends StatefulWidget {
  final Duration duration;

  const TimerWidget({super.key, required this.duration});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Duration _currentTime;
  late Timer timer1;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.duration;
     startTimer1();
  }

  void startTimer1() {
    timer1 = Timer.periodic(const Duration(seconds: 1), (timer1) {
      setState(() {
        if (_currentTime.inSeconds > 0) {
          _currentTime -= const Duration(seconds: 1);
        } else {
          timer1.cancel();
          FlutterRingtonePlayer().playNotification();
          if (mounted) {
            Navigator.pop(context);
          }
        }
      });
    });
  }

  String formatTime(Duration currentTime) {
    int minutes = currentTime.inMinutes;
    int seconds = currentTime.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:\n${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatTime(_currentTime),
              style: AppTextStyles.customStrokedStyle(),
            ),
            IconButton(
              onPressed: () {},
              icon:  Icon(
                Icons.access_alarm,
                size: 35,
                color: AppColors.white(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer1.cancel();
    super.dispose();
  }
}
