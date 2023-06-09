import 'package:flutter/cupertino.dart';

class ChangeNotifierHUQR extends ChangeNotifier {
  bool _isDone = false;

  bool get isDone => _isDone;

  void setPosition(bool isClicked) {
    _isDone = isClicked;
    print(_isDone);
    notifyListeners();
  }
}
