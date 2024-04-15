import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

const locales = [
  // Locale('en', 'US'), // English
  // Locale('rw', 'RW'), // Kinyarwanda
  // Locale('es', 'ES'), // Spanish
  // Locale('fr', 'FR'), // French
  // Locale('ru', 'RU'), // Russian
  // Locale('ar', 'SA'), // Arabic
  // Locale('zh', 'CN'), // Chinese
  // Locale('hi', 'IN'), // Hindi
  // Locale('ko', 'KR'), // Korean
  // Locale('ja', 'JP'), // Japanese
];

const public_routes = ['/login', '/register', '/location'];

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseApp app = Firebase.app();
