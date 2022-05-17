import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kwordle/models/history.dart';
import 'package:kwordle/providers/auth_provider.dart';
import 'package:kwordle/ui/dialogs/clear.dart';
import 'package:kwordle/utils/game_utils.dart';
import 'package:kwordle/word_data/five.dart';
import 'package:kwordle/word_data/seven.dart';
import 'package:kwordle/word_data/six.dart';
import 'package:provider/provider.dart';

class GameProvider with ChangeNotifier {
  int mode;
  late List<String> WORD_POOL;
  late int wordIndex;
  late String word;
  Box<History> get _historyBox => Hive.box<History>(GameUtils.getBoxName(mode));

  GameProvider(this.mode) {
    switch (mode) {
      case GameMode.FIVE:
        WORD_POOL = WORD_LIST_FIVE;
        break;
      case GameMode.SIX:
        WORD_POOL = WORD_LIST_SIX;
        break;
      case GameMode.SEVEN:
        WORD_POOL = WORD_LIST_SEVEN;
        break;
      default:
        WORD_POOL = WORD_LIST_SIX;
    }
    History? savedHistory = _historyBox.get('unsolved');
    if (savedHistory != null) {
      wordIndex = WORD_POOL.indexOf(savedHistory.letters);
      word = savedHistory.letters;
      inputHistory = savedHistory.history;
    } else {
      wordIndex = Random().nextInt(WORD_POOL.length);
      word = WORD_POOL[wordIndex];
    }
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
    _historyBox.put(
        'unsolved',
        History(
            clearTime: null,
            word: '',
            letters: word,
            definition: '',
            history: inputHistory));
    keyInputs.clear();
    isReadyToInput = false;
    notifyListeners();
    return true;
  }

  void checkClear(BuildContext context, VoidCallback callback) {
    final isClear = inputHistory.last.every((e) => e['result'] == 2);
    Timer(const Duration(milliseconds: 1500), () async {
      if (isClear) {
        final result = await showDialog<int>(
            context: context,
            barrierDismissible: false,
            builder: (_) => ClearDialog(
                mode: mode, wordIndex: wordIndex, history: inputHistory));
        if (result == 1) {
          restart();
        } else {
          Navigator.of(context).pop();
        }
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
