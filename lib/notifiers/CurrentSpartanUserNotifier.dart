import 'package:flutter/material.dart';
import 'package:spartan/models/SpartanUser.dart';

class CurrentSpartanUserNotifier extends ChangeNotifier {
  SpartanUser? _currentSpartanUser;

  SpartanUser? get currentSpartanUser => _currentSpartanUser;

  void setCurrentSpartanUser(SpartanUser user) {
    _currentSpartanUser = user;
    notifyListeners();
  }

  void clearSpartanUser() {
    _currentSpartanUser = null;
    notifyListeners();
  }
  
}
