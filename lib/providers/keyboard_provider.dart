import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwordle/ui/dialogs/clear.dart';
import 'package:kwordle/utils/game_utils.dart';
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

  bool checkWordExist() {
    final inputWord = keyInputs.join('');
    return WORD_LIST_SIX.contains(inputWord);
  }

  bool? submit() {
    if (keyInputs.length < 6) {
      return null;
    }
    if (!checkWordExist()) {
      return false;
    }
    log(word);
    final result = GameUtils.validateInput(word, keyInputs);
    inputHistory = [...inputHistory, result];
    keyInputs.clear();
    isReadyToInput = false;
    notifyListeners();
    return true;
  }

  void checkClear(BuildContext context, VoidCallback callback) {
    final isClear = inputHistory.last.every((e) => e['result'] == 2);
    Timer(const Duration(milliseconds: 1400), () {
      if (isClear) {
        showDialog(
            context: context,
            builder: (context) => ClearDialog(
                wordIndex: wordIndex,
                count: inputHistory.length,
                onPress: restart));
      } else {
        isReadyToInput = true;
        callback();
        notifyListeners();
      }
    });
  }

  void restart() {
    wordIndex = Random().nextInt(WORD_LIST_SIX.length);
    inputHistory = [];
    keyInputs = [];
    isReadyToInput = false;
    notifyListeners();
  }
}
