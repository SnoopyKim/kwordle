import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

class AppUtils {
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

  static List<Map<String, dynamic>> mergeHistory(
      List<List<Map<String, dynamic>>> history) {
    return [
      ...history.map((e) => [...e.map((m) => Map<String, dynamic>.from(m))])
    ].fold([], (result, letters) {
      for (var letter in letters) {
        final idx = result.indexWhere((e) => e['letter'] == letter['letter']);
        if (idx == -1) {
          result.add(letter);
        } else if (result[idx]['result'] < letter['result']) {
          result[idx]['result'] = letter['result'];
        }
      }
      return result;
    });
  }
}
