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

  void confirm() {
    inputHistory.add(validateInput(keyInputs));
    keyInputs.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> validateInput(List<String> input) {
    String copyWord = word;
    return input
        .asMap()
        .map((idx, letter) {
          Map<String, dynamic> result = {'letter': letter};
          int _idx = copyWord.indexOf(letter);

          if (_idx == -1) {
            result['result'] = 0;
          } else if (_idx == idx) {
            result['result'] = 1;
            copyWord = copyWord.substring(0, _idx) +
                'X' +
                copyWord.substring(_idx + 1);
          } else {
            result['result'] = 2;
          }
          return MapEntry(idx, result);
        })
        .values
        .toList();
  }
}
