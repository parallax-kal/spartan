import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Crib.dart';

class CribService {
  static Future updateCrib(String cribId, Map<String, dynamic> data) async {
    await firestore.collection('cribs').doc(cribId).update(data);
  }

  static Future<Crib?> getCrib(String cribId) async {
    DocumentSnapshot<Map<String, dynamic>> crib =
        await firestore.collection('cribs').doc(cribId).get();
    if (!crib.exists) {
      return null;
    }
    return Crib.fromJson({
      'id': crib.id,
      ...crib.data()!,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCribs(
      SEARCH_STATUS search_status) {
    if (search_status == SEARCH_STATUS.ALL) {
      return firestore
          .collection("cribs")
          .where(
            "users",
            arrayContains: auth.currentUser!.uid,
          )
          .orderBy(
            "createdAt",
            descending: false,
          )
          .snapshots();
    } else {
      return firestore
          .collection("cribs")
          .where(
            "users",
            arrayContains: auth.currentUser!.uid,
          )
          .where("status", isEqualTo: search_status.name)
          .orderBy(
            "createdAt",
            descending: false,
          )
          .snapshots();
    }
  }
}

enum SEARCH_STATUS {
  ALL,
  ACTIVE,
  INACTIVE,
}
