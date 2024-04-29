import 'package:flutter/material.dart';

class CountryAndTermsNotifier extends ChangeNotifier {
  String? _country;
  bool _acceptedTerms = false;


  String? get country => _country;
  bool get acceptedTerms => _acceptedTerms;

  void setCountry(String country) {
    _country = country;
    notifyListeners();
  }

  void changeTerms(bool value) {
    _acceptedTerms = value;
    notifyListeners();
  }
}
