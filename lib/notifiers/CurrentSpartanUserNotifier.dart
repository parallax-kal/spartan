import 'package:flutter/material.dart';
import 'package:spartan/models/SpartanUser.dart';

class CurrentSpartanUserNotifier extends ChangeNotifier {
  SpartanUser? _currentSpartanUser;

  SpartanUser? get user => _currentSpartanUser;

  void setUser(SpartanUser user) {
    _currentSpartanUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentSpartanUser = null;
    notifyListeners();
  }
  
}
