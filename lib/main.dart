import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spartan/notifiers/CurrentRoomNotifier.dart';
import 'package:spartan/notifiers/CurrentSpartanUserNotifier.dart';
import 'package:spartan/notifiers/CountryTermsNotifier.dart';
import 'package:spartan/utils/notifications.dart';
import 'package:spartan/utils/router.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:spartan/notifiers/CurrentCribIdNotifier.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  firestore.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();

  initializeDateFormatting().then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CountryAndTermsNotifier(),
          ),
          ChangeNotifierProvider(
            create: (context) => CurrentSpartanUserNotifier(),
          ),
          ChangeNotifierProvider(
            create: (context) => CurrentRoomNotifier(),
          ),
          ChangeNotifierProvider(
            create: (context) => CurrentCribIdNotifier(),
          ),
        ],
        child: const SpartanApp(),
      ),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  FlutterNativeSplash.remove();
}

class SpartanApp extends StatefulWidget {
  const SpartanApp({super.key});

  @override
  State<SpartanApp> createState() => _SpartanAppState();
}

class _SpartanAppState extends State<SpartanApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Spartan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        bottomSheetTheme: const BottomSheetThemeData(
          surfaceTintColor: Colors.white,
        ),
      ),
      routerConfig: router,
    );
  }
}
