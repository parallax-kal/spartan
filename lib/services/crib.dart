import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Crib.dart';

class CribService {
  static Future updateCrib(String cribId, Map<String, dynamic> data) {
    return firestore.collection('cribs').doc(cribId).update(data);
  }

  static Future createCrib(Crib crib) async {
    await firestore.collection('cribs').doc(crib.id).set(crib.toJson());
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
