import 'package:flutter/material.dart';

class AppGradient {
  static calenderGradient() {
    return const LinearGradient(colors: [Colors.white, Colors.black],stops: [0.6,0.9],begin: Alignment.center,end: Alignment.bottomCenter);
  }

   static calenderGradient1() {
    return const LinearGradient(colors: [Colors.white, Colors.black],stops: [0.9,1],begin: Alignment.center,end: Alignment.bottomCenter);
  }
}
