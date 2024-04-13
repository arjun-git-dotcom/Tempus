import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_project/Design/colors.dart';
import 'package:hive_project/main.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NavPage()));
    });
    return Scaffold(
      backgroundColor: AppColors.black(),
      body: Center(child: Lottie.asset('lib/Assets/lottie.json'),),
    );
  }
}
