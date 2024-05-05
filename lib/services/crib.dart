import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';

class CribService {
  static Future updateCrib(String cribId, Map<String, dynamic> data) {
    return firestore.collection('cribs').doc(cribId).update(data);
  }


}