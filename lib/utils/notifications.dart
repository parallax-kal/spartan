import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spartan/utils/router.dart';
import 'package:http/http.dart' as http;

///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************

class NotificationController extends ChangeNotifier {
  /// *********************************************
  ///   SINGLETON PATTERN
  /// *********************************************

  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  /// *********************************************
  ///  OBSERVER PATTERN
  /// *********************************************

  String _firebaseToken = '';
  String get firebaseToken => _firebaseToken;

  String _nativeToken = '';
  String get nativeToken => _nativeToken;

  ReceivedAction? initialAction;

  /// *********************************************
  ///   INITIALIZATION METHODS
  /// *********************************************

  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Alerts',
            channelDescription: 'Notification as alerts',
            playSound: true,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple)
      ],
      debug: debug,
      languageCode: 'ko',
    );

    // Get initial notification action is optional
    _instance.initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
        onFcmTokenHandle: NotificationController.myFcmTokenHandle,
        onNativeTokenHandle: NotificationController.myNativeTokenHandle,
        onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
        licenseKeys:
            // On this example app, the app ID / Bundle Id are different
            // for each platform, so i used the main Bundle ID + 1 variation
            [
          // me.carda.awesomeNotificationsFcmExample
          '2024-01-02==kZDwJQkSR7mrjEgDk7afWDSrqYCiqW6Ao/7wn/w6v5OKOgAnoEWt'
              'gqO0ELI1BxWNzSde2gbaW+9Ki6Tx94pU2gQRJuJxXGsvcmCRla1mB/0U/rPh'
              'f77bxgPRG+PHn9+p9sQ5nfvY6Ytw9IvDn4NjH3ccbjoXFRrs7R/ou9aapq2a'
              'jRHqXlIzDR1ihyQHC91Wvkviw2qTOEYDhR5hE4T2l1iHsTTpeXOqWk0XmgnC'
              'gO18e4Hv0P5WKICCull+PCh+OXQYTK5x0UwQPNOGN20rQu5zR9C0ph0hFQxk'
              'WLa/ft206pBZmWDf4HiyAawXPoR1AMWAh/t0cjh8gRTTNfHeog==',

          // me.carda.awesome_notifications_fcm_example
          '2024-01-02==lYUBqt9kKmObnP7UzWd2KK9FOTOySkVATX/j/CGEzSlSKsQx5y5S9'
              'RKHG1lP1TZ5KHO6+wwkNbzxmni4uJ418WM3ywTY199bHAp5MHWxZEEgvMMG4/'
              '/V2W0acFhSgxH6GL/6XNYvhS2RwaX7X/z4NX7Z4dgZVOn0VW3GRyg7I/zLcgl'
              'Dhh+n9obRuGnZI+Xakw2id97PSG4QZOCw15A0LzE1lip/Fzj0cMRsqpvcAW2K'
              'VWYZm5ZmK2yKVcop1kxiq1faZGL1fBteJCQ8YeQKpqS+aaVmexdJXmB7sJVl0'
              '5o87ORRfijpO+Q6gmTYfjYxoiQMismHUx6NAnoB/txaLw=='
        ],
        debug: debug);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
          (silentData) => onActionReceivedImplementationMethod(silentData));

    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     LOCAL NOTIFICATION EVENTS
  ///  *********************************************

  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction == null) return;

    // Fluttertoast.showToast(
    //     msg: 'Notification action launched app: $receivedAction',
    //   backgroundColor: Colors.deepPurple
    // );
    // print('App launched by a notification action: $receivedAction');
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print(receivedAction);
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      // print('Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
      return;
    } else {
      if (receivePort == null) {
        // onActionReceivedMethod was called inside a parallel dart isolate.
        SendPort? sendPort =
            IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          // Redirecting the execution to main isolate process (this process is
          // only necessary when you need to redirect the user to a new page or
          // use a valid context)
          sendPort.send(receivedAction);
          return;
        }
      }
    }

    return onActionReceivedImplementationMethod(receivedAction);
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
        (route) =>
            (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }

  ///  *********************************************
  ///     REMOTE NOTIFICATION EVENTS
  ///  *********************************************

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    // Fluttertoast.showToast(
    //     msg: 'Silent data received',
    //     backgroundColor: Colors.blueAccent,
    //     textColor: Colors.white,
    //     fontSize: 16);

    // print('"SilentData": ${silentData.toString()}');

    // if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
    //   print("bg");
    // } else {
    //   print("FOREGROUND");
    // }

    // print('mySilentDataHandle received a FcmSilentData execution');
    await executeLongTaskInBackground();
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    // if (token.isNotEmpty){
    // Fluttertoast.showToast(
    //       msg: 'Fcm token received',
    //       backgroundColor: Colors.blueAccent,
    //       textColor: Colors.white,
    //       fontSize: 16);

    //   debugPrint('Firebase Token:"$token"');
    // }
    // else {
    //   Fluttertoast.showToast(
    //       msg: 'Fcm token deleted',
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16);

    //   debugPrint('Firebase Token deleted');
    // }

    _instance._firebaseToken = token;
    _instance.notifyListeners();
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    // Fluttertoast.showToast(
    //     msg: 'Native token received',
    //     backgroundColor: Colors.blueAccent,
    //     textColor: Colors.white,
    //     fontSize: 16);
    // debugPrint('Native Token:"$token"');

    _instance._nativeToken = token;
    _instance.notifyListeners();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************

  static Future<void> executeLongTaskInBackground() async {
    // print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    await http.get(url);
    // print(re.body);
    // print("long task done");
  }

  ///  *********************************************
  ///     REQUEST NOTIFICATION PERMISSIONS
  ///  *********************************************

  static Future<bool> displayNotificationRationale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userAuthorized = prefs.getBool('userAuthorized') ?? false;
    BuildContext context = rootNavigatorKey.currentContext!;

    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Spartan to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                onPressed: () async {
                  prefs.setBool('userAuthorized', true);
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Allow',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.deepPurple),
                ),
              ),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     LOCAL NOTIFICATION CREATION METHODS
  ///  *********************************************

  // static Future<void> createNewNotification() async {
  //   bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

  //   if (!isAllowed) {
  //     isAllowed = await displayNotificationRationale();
  //   }

  //   if (!isAllowed) return;

  //   await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id: -1, // -1 is replaced by a random number
  //           channelKey: 'alerts',
  //           title: 'Huston! The eagle has landed!',
  //           body:
  //               "A small step for a man, but a giant leap to Flutter's community!",
  //           bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
  //           largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
  //           notificationLayout: NotificationLayout.BigPicture,
  //           payload: {'notificationId': '1234567890'}),
  //       actionButtons: [
  //         NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
  //         NotificationActionButton(
  //             key: 'REPLY',
  //             label: 'Reply Message',
  //             requireInputText: true,
  //             actionType: ActionType.SilentAction),
  //         NotificationActionButton(
  //             key: 'DISMISS',
  //             label: 'Dismiss',
  //             actionType: ActionType.DismissAction,
  //             isDangerousOption: true)
  //       ]);
  // }

  static Future<void> resetBadge() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> deleteToken() async {
    await AwesomeNotificationsFcm().deleteToken();
    await Future.delayed(const Duration(seconds: 5));
    await requestFirebaseToken();
  }

  ///  *********************************************
  ///     REMOTE TOKEN REQUESTS
  ///  *********************************************

  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        return await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        // debugPrint('$exception');
      }
    } else {
      // debugPrint('Firebase is not available on this project');
    }
    return '';
  }
}
