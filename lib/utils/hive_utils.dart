import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:kwordle/models/history.dart';
import 'package:kwordle/utils/game_utils.dart';

class HiveUtils {
  HiveUtils._init();
  static final HiveUtils _instance = HiveUtils._init();

  factory HiveUtils() => _instance;

  late Box settingBox;
  late Box<History> fiveBox, sixBox, sevenBox;

  init() async {
    Hive.registerAdapter(HistoryAdapter());
    settingBox = await Hive.openBox('setting');
  }

  configBox(String uid) async {
    log('Configure boxes with $uid');
    fiveBox = await Hive.openBox<History>('${uid}_five');
    sixBox = await Hive.openBox<History>('${uid}_six');
    sevenBox = await Hive.openBox<History>('${uid}_seven');
  }

  Box<History> getBox(int mode) {
    switch (mode) {
      case GameMode.FIVE:
        return fiveBox;
      case GameMode.SIX:
        return sixBox;
      case GameMode.SEVEN:
        return sevenBox;
      default:
        return sixBox;
    }
  }

  closeBox() async {
    await Future.wait([
      fiveBox.close(),
      sixBox.close(),
      sevenBox.close(),
    ]);
  }

  clearBox() async {
    await Future.wait([
      fiveBox.clear(),
      sixBox.clear(),
      sevenBox.clear(),
    ]);
    await closeBox();
  }
}
