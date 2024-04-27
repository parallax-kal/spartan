import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseApp app = Firebase.app();
FirebaseMessaging messaging = FirebaseMessaging.instance;

String displayErrorMessage(
  Exception e,
) {
  if (e is FirebaseAuthException) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided for that user.';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    } else if (e.code == 'invalid-email') {
      return 'The email address is badly formatted.';
    } else {
      return e.message ?? 'An error occurred, please check your credentials.';
    }
  } else {
    return e.toString();
  }
}
