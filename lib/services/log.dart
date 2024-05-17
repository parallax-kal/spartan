import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Log.dart';

class LogService {
  static Future addUserLog(Log log) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('logs')
        .add(log.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserLog() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('logs')
        .snapshots();
  }

}
