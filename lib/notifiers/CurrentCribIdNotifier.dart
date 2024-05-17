import 'package:flutter/material.dart';

class CurrentCribIdNotifier extends ChangeNotifier {
  String? _cribId;

  String? get cribId => _cribId;

  void setCribId(String? cribId) {
    _cribId = cribId;
    notifyListeners();
  }
}
