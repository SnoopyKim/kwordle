import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier {
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
