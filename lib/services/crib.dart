import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';

class CribService {
  static Future updateCrib(String cribId, Map<String, dynamic> data) {
    return firestore.collection('cribs').doc(cribId).update(data);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCribs() {
    return firestore
        .collection("cribs")
        .where("access", arrayContains: {"user": auth.currentUser!.uid})
        .orderBy(
          "createdAt",
          descending: false,
        )
        .snapshots();
  }
}
