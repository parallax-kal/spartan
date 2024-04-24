import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreamModel extends ChangeNotifier {
  Layout _layout = Layout(deviceView: DeviceView.EXPANDED, sortBy: SortBy.DEVICE_TYPE);

  Layout get layout => _layout;

  void setLayout(DeviceView deviceView, SortBy sortBy) {
    _layout = Layout(deviceView: deviceView, sortBy: sortBy);
    notifyListeners();
  }

  Future<void> saveLayout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceView', _layout.deviceView.value);
    await prefs.setString('sortBy', _layout.sortBy.value);
  }

}

enum DeviceView {
  EXPANDED('Expanded'),
  CONDENSED('Condensed'),
  LIST('List');

  final String value;
  const DeviceView(this.value);
}

enum SortBy {
  SPACES('Spaces'),
  DEVICE_TYPE('Device Type');

  final String value;
  const SortBy(this.value);
}

class Layout {
  DeviceView deviceView;
  SortBy sortBy;

  Layout({required this.deviceView, required this.sortBy});
}
