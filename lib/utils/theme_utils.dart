import 'package:flutter/material.dart';

class ThemeUtils {
  static Color? getResultColor(int? result) {
    switch (result) {
      case 0:
        return Colors.blueGrey;
      case 2:
        return Colors.green;
      case 1:
        return Colors.orangeAccent;
    }
  }

  static const Color backgroundColor = Color(0xffF8FCFF);
  static const Color neumorphismColor = Color(0xffE5F4FE);
  static const Color highlightColor = Color(0xff29A8F6);
  static const Color textColor = Color(0xff0D0D3D);
}
