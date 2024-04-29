import 'package:flutter/material.dart';
import 'package:spartan/models/Room.dart';

class CurrentRoomNotifier extends ChangeNotifier {
  Room? _currentRoom;

  Room? get currentRoom => _currentRoom;

  void setCurrentRoom(Room room) {
    _currentRoom = room;
    notifyListeners();
  }

  void clearRoom() {
    _currentRoom = null;
    notifyListeners();
  }
}