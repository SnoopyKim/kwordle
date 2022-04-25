import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class KeyboardProvider with ChangeNotifier {
  String word = 'ㄱㅜㅓㄴㅌㅜ';
  List<List<Map<String, dynamic>>> inputHistory = [];
  List<String> keyInputs = [];

  void input(String key) {
    if (keyInputs.length < 6) {
      keyInputs.add(key);
      notifyListeners();
    }
  }

  void erase() {
    if (keyInputs.isNotEmpty) {
      keyInputs.removeLast();
      notifyListeners();
    }
  }

  void submit() {
    if (keyInputs.length < 6) {
      return;
    }
    final result = validateInput(keyInputs);
    inputHistory = [...inputHistory, result];
    keyInputs.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> validateInput(List<String> input) {
    String copyWord = word;
    List<Map<String, dynamic>> result =
        input.map((v) => {'letter': v, 'result': 0}).toList();
    for (int i = 0; i < result.length; i++) {
      if (copyWord.indexOf(result[i]['letter']) == i) {
        result[i]['result'] = 2;
        copyWord = copyWord.substring(0, i) + 'X' + copyWord.substring(i + 1);
      }
    }
    for (int i = 0; i < result.length; i++) {
      if (copyWord.contains(result[i]['letter'])) {
        result[i]['result'] = 1;
      }
    }
    return result;
  }
}
