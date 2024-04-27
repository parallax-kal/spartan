import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth facebookauth = FacebookAuth.instance;

  // Sign in with Google
  Future<AuthCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      return credential;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign in with Facebook
  Future<OAuthCredential> signInWithFacebook() async {
    final LoginResult loginResult = await facebookauth.login();
    if (loginResult.status != LoginStatus.success) {
      throw Exception('Failed to sign in with Facebook');
    }
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return facebookAuthCredential;
  }

  // Sign in with Email and Password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user == null) {
      throw Exception('Failed to sign in with Email and Password');
    }
    return userCredential;
  }

  // Sign up with Email and Password
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (userCredential.user == null) {
      throw Exception('Failed to sign up with Email and Password');
    }
    return userCredential;
  }

  // Sign out
  Future<void> signOut() async {
    await auth.signOut();
    await _googleSignIn.signOut();
    await facebookauth.logOut();
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final users = await firestore.collection('users').get();
      return users.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }
}
