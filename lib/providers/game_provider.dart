import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:kwordle/ui/dialogs/clear.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/word_data/five.dart';
import 'package:kwordle/word_data/seven.dart';
import 'package:kwordle/word_data/six.dart';

class GameProvider with ChangeNotifier {
  int mode;
  late List<String> WORD_POOL;
  late int wordIndex;
  late String word;
  GameProvider(this.mode) {
    switch (mode) {
      case 5:
        WORD_POOL = WORD_LIST_FIVE;
        break;
      case 6:
        WORD_POOL = WORD_LIST_SIX;
        break;
      case 7:
        WORD_POOL = WORD_LIST_SEVEN;
        break;
      default:
        WORD_POOL = WORD_LIST_SIX;
    }
    wordIndex = Random().nextInt(WORD_POOL.length);
    word = WORD_POOL[wordIndex];
  }

  List<List<Map<String, dynamic>>> inputHistory = [];
  List<String> keyInputs = [];

  bool isReadyToInput = false;

  void setReadyToInput(bool value) {
    isReadyToInput = value;
    notifyListeners();
  }

  void input(String key) {
    if (isReadyToInput && keyInputs.length < mode) {
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
    return WORD_POOL.contains(inputWord);
  }

  // null: 입력 단어 수 6개 이하
  // false: 단어풀에 없는 단어
  // true: 통과
  bool? submit() {
    if (keyInputs.length < mode) {
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
    Timer(const Duration(milliseconds: 1500), () {
      if (isClear) {
        showDialog(
            context: context,
            builder: (context) =>
                ClearDialog(wordIndex: wordIndex, count: inputHistory.length, onPress: restart));
      } else {
        isReadyToInput = true;
        callback();
        notifyListeners();
      }
    });
  }

  void restart() {
    wordIndex = Random().nextInt(WORD_POOL.length);
    word = WORD_POOL[wordIndex];
    inputHistory = [];
    keyInputs = [];
    isReadyToInput = false;
    notifyListeners();
  }

  bool isToastCalled = false;

  void showToast() {
    isToastCalled = true;
    notifyListeners();
  }

  void dismissToast() {
    isToastCalled = false;
    notifyListeners();
  }
}
