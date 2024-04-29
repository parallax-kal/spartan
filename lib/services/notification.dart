import 'package:spartan/constants/firebase.dart';

class NotificationService {
  Future sendNotification(
    String channel,
    String title,
    String body,
    String? image,
  ) async {
    messaging.requestPermission();
  }
}