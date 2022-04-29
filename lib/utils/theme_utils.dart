import 'package:flutter/material.dart';

class ThemeUtils {
  static Color? getColor(int? result) {
    switch (result) {
      case 0:
        return Colors.blueGrey;
      case 2:
        return Colors.green;
      case 1:
        return Colors.orangeAccent;
    }
  }
}
