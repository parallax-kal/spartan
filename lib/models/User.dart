import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spartan/constants/firebase.dart';

class UserModel extends ChangeNotifier {
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

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(
      String uid) async {
    return await firestore.collection('users').doc(uid).get();
  }

  bool countrySet(DocumentSnapshot<Map<String, dynamic>> user) {
    return user.exists && user.data()!['country'] != null;
  }

  bool termsSet(DocumentSnapshot<Map<String, dynamic>> user) {
    return user.exists && user.data()!['terms'] != null;
  }
}
