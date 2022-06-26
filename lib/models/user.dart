import 'dart:math' as math;

import 'package:kwordle/utils/game_utils.dart';

class User {
  String uid;
  String email;
  String name;
  int fiveClear;
  int fiveCount;
  int sixClear;
  int sixCount;
  int sevenClear;
  int sevenCount;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.fiveClear,
    required this.fiveCount,
    required this.sixClear,
    required this.sixCount,
    required this.sevenClear,
    required this.sevenCount,
  });

  factory User.fromMap(Map<dynamic, dynamic> map) => User(
        uid: map['uid'] ?? "",
        email: map['email'] ?? "",
        name: map['name'] ?? "",
        fiveClear: map['fiveClear'] ?? 0,
        fiveCount: map['fiveCount'] ?? 0,
        sixClear: map['sixClear'] ?? 0,
        sixCount: map['sixCount'] ?? 0,
        sevenClear: map['sevenClear'] ?? 0,
        sevenCount: map['sevenCount'] ?? 0,
      );

  factory User.empty() => User(
        uid: "",
        email: "",
        name: "",
        fiveClear: 0,
        fiveCount: 0,
        sixClear: 0,
        sixCount: 0,
        sevenClear: 0,
        sevenCount: 0,
      );

  factory User.register({required String email, required String name}) => User(
      uid: "",
      email: email,
      name: name,
      fiveClear: 0,
      fiveCount: 0,
      sixClear: 0,
      sixCount: 0,
      sevenClear: 0,
      sevenCount: 0);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (uid.isNotEmpty) {
      map['uid'] = uid;
    }
    map['email'] = email;
    map['name'] = name;
    map['fiveClear'] = fiveClear;
    map['fiveCount'] = fiveCount;
    map['sixClear'] = sixClear;
    map['sixCount'] = sixCount;
    map['sevenClear'] = sevenClear;
    map['sevenCount'] = sevenCount;
    return map;
  }

  int getScore(int mode) {
    switch (mode) {
      case GameMode.FIVE:
        if (fiveCount == 0) {
          return 0;
        } else {
          return (math.pow(fiveClear, 2) / fiveCount * 100).floor();
        }
      case GameMode.SIX:
        if (sixCount == 0) {
          return 0;
        } else {
          return (math.pow(sixClear, 2) / sixCount * 100).floor();
        }
      case GameMode.SEVEN:
        if (sevenCount == 0) {
          return 0;
        } else {
          return (math.pow(sevenClear, 2) / sevenCount * 100).floor();
        }
      default:
        return 0;
    }
  }
}
