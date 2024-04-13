import 'package:flutter/material.dart';


class AppTextStyles {
  static TextStyle customStrokedStyle(
      {double strokeWidth = 2,
      Color strokeColor = Colors.white,
      double fontsize = 120,
      PaintingStyle paintingStyle = PaintingStyle.stroke}) {
    return TextStyle(
        fontSize: fontsize,
        foreground: Paint()
          ..style = paintingStyle
          ..strokeWidth = strokeWidth
          ..color = strokeColor);
  }

  
}
