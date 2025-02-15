// ignore_for_file: constant_identifier_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Crib.dart';
import 'package:rxdart/rxdart.dart';

class CribService {
  static Future updateCrib(String cribId, Map<String, dynamic> data) {
    return firestore.collection('cribs').doc(cribId).update(data);
  }

  static Stream<int> countCribs() {
    return firestore
        .collection('cribs')
        .where('users', arrayContains: auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Future deleteCrib(Crib crib) {
    bool isOwner = crib.access.any((access) =>
        access.status == ACCESSSTATUS.ADMIN &&
        access.user == auth.currentUser!.email);
    if (isOwner) {
      return firestore.collection("cribs").doc(crib.id).update({
        "status": "INACTIVE",
        "access": [],
        "users": [],
      });
    }
    return firestore.collection("cribs").doc(crib.id).update({
      "status": "INACTIVE",
      "access": FieldValue.arrayRemove(
        [
          {
            "accepted": false,
            "status": "OPERATOR",
            "user": auth.currentUser!.email,
          }
        ],
      )
    });
  }

  static Future deleteAllCribs() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('cribs')
        .where('users', arrayContains: auth.currentUser!.uid)
        .get();

    List<Future<void>> deleteFutures = [];
    for (var doc in snapshot.docs) {
      deleteFutures.add(doc.reference.delete());
    }

    await Future.wait(deleteFutures);
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getCrib(
      String cribId) async {
    return firestore.collection('cribs').doc(cribId).get();
  }

  static Stream<List<Crib>> getCribs(SEARCH_STATUS searchStatus) {
    return BehaviorSubject<SEARCH_STATUS>.seeded(searchStatus)
        .switchMap((status) {
      if (status == SEARCH_STATUS.ALL) {
        var userQuery = firestore
            .collection("cribs")
            .where("users", arrayContains: auth.currentUser!.uid)
            .orderBy("createdAt", descending: false)
            .snapshots();
        var accessQuery = firestore
            .collection("cribs")
            .where("access", arrayContains: {
              "accepted": false,
              "status": "OPERATOR",
              "user": auth.currentUser!.email,
            })
            .orderBy("createdAt", descending: false)
            .snapshots();

        return CombineLatestStream.list([
          userQuery,
          accessQuery,
        ]).map((List<QuerySnapshot<Map<String, dynamic>>> snapshots) {
          List<Crib> cribs = [];

          // Merge documents from both queries
          for (var snapshot in snapshots) {
            cribs.addAll(snapshot.docs.map((doc) {
              return Crib.fromJson({
                'id': doc.id,
                ...doc.data(),
              });
            }));
          }

          return cribs;
        });
      } else if (status == SEARCH_STATUS.PENDING) {
        return firestore
            .collection("cribs")
            .where("access", arrayContains: {
              "accepted": false,
              "status": "OPERATOR",
              "user": auth.currentUser!.email,
            })
            .orderBy("createdAt", descending: false)
            .snapshots()
            .map((snapshot) {
              return snapshot.docs.map((doc) {
                return Crib.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                });
              }).toList();
            });
      } else {
        return firestore
            .collection("cribs")
            .where(
              "users",
              arrayContains: auth.currentUser!.uid,
            )
            .where("status", isEqualTo: status.name)
            .orderBy(
              "createdAt",
              descending: false,
            )
            .snapshots()
            .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Crib.fromJson({
              'id': doc.id,
              ...doc.data(),
            });
          }).toList();
        });
      }
    });
  }
}

enum SEARCH_STATUS {
  ALL,
  ACTIVE,
  INACTIVE,
  PENDING,
}
