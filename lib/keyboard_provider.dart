import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class KeyboardProvider with ChangeNotifier {
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
    log('confirm!');
  }
}
