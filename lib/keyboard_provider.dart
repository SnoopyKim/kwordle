import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwordle/ui/dialogs/clear.dart';
import 'package:kwordle/word_data/six.dart';
import 'package:provider/provider.dart';

class KeyboardProvider with ChangeNotifier {
  int wordIndex = Random().nextInt(WORD_LIST_SIX.length);
  String get word => WORD_LIST_SIX[wordIndex];

  List<List<Map<String, dynamic>>> inputHistory = [];
  List<String> keyInputs = [];

  bool isReadyToInput = false;

  void setReadyToInput(bool value) {
    isReadyToInput = value;
    notifyListeners();
  }

  void input(String key) {
    if (isReadyToInput && keyInputs.length < 6) {
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
    log(word);
    final result = validateInput(keyInputs);
    inputHistory = [...inputHistory, result];
    keyInputs.clear();
    isReadyToInput = false;
    notifyListeners();
  }

  void checkClear(BuildContext context, VoidCallback callback) {
    final isClear = inputHistory.last.every((e) => e['result'] == 2);
    Timer(
        const Duration(milliseconds: 1400),
        () => isClear
            ? showDialog(
                context: context,
                builder: (context) => ClearDialog(
                    wordIndex: wordIndex,
                    count: inputHistory.length,
                    onPress: restart))
            : isReadyToInput = true);
  }

  void restart() {
    wordIndex = Random().nextInt(WORD_LIST_SIX.length);
    inputHistory = [];
    keyInputs = [];
    isReadyToInput = false;
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
      if (copyWord.contains(result[i]['letter']) &&
          (result[i]['result'] != 2)) {
        result[i]['result'] = 1;
      }
    }
    return result;
  }
}
