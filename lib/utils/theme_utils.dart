import 'package:flutter/material.dart';

class ThemeUtils {
  static const Color backgroundColor = Color(0xffF8FCFF);
  static const Color neumorphismColor = Color(0xffDFE9FE);
  static const Color highlightColor = Color(0xff83A0F0);
  static const Color titleColor = Color(0xff6B748F);
  static const Color contentColor = Color(0xff9FA8BC);

  static Color? getResultColor(int? result) {
    switch (result) {
      case 0:
        return Colors.blueGrey;
      case 2:
        return Colors.green;
      case 1:
        return Colors.orangeAccent;
      default:
        return null;
    }
  }
}
