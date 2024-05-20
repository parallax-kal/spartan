import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Notification.dart';
import 'notification_access.dart';

class NotificationService {
  static Future<void> postSendNotification(
    ANotification notification,
  ) async {
    try {
      final body = {
        "message": {
          "token": notification.token,
          "android": {
            "priority": notification.priority,
          },
          // "apns": {
          //     "payload": {
          //         "aps": {
          //             "mutable-content": 1,
          //             "badge": 15
          //         },
          //         "headers": {
          //             "apns-priority": 5
          //         }
          //     }
          // },
          "notification": {
            "title": notification.title,
            "body": notification.body,
            "image": notification.image,
          },

          // "data": {
          //     "content": "{\"id\":-1,\"badge\":1,\"channelKey\":\"alerts\",\"displayOnForeground\":true,\"notificationLayout\":\"BigPicture\",\"largeIcon\":\"https://br.web.img3.acsta.net/pictures/19/06/18/17/09/0834720.jpg\",\"bigPicture\":\"https://www.dw.com/image/49519617_303.jpg\",\"showWhen\":true,\"autoDismissible\":true,\"privacy\":\"Private\",\"payload\":{\"category\":\"like\",\"userId\":\"oUGw1AHfmkQPDuP9DOAT1J0iQ1X2\",\"ownerId\":\"AppleBoy\",\"notifId\":\"liked_279f33c9-9c58-4099-940b-06a463a9d929\",\"pageId\":\"notifsPage\",\"gameAction\":\"\"}}",
          //     "actionButtons": "[{\"key\":\"REDIRECT\",\"label\":\"Redirect\",\"autoDismissible\":true},{\"key\":\"CANCEL\",\"label\":\"Dismiss\",\"actionType\":\"DismissAction\",\"isDangerousOption\":true,\"autoDismissible\":true}]"
          // }
        }
      };

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'spartan-3b328';

      // get firebase admin token
      final bearerToken = await NotificationAccessToken.getToken;

      // handle null token
      if (bearerToken == null) return;
      await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
        },
        body: jsonEncode(body),
      );
    } on Exception catch (e) {
      print("Error with sending push notification - $e");
    }
  }

  static Stream<List<ANotification>> getNotifications() {
    return firestore
        .collection('notifications')
        .where('user', isEqualTo: auth.currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ANotification.fromJson({
                    'id': doc.id,
                    ...doc.data(),
                  }))
              .toList(),
        );
  }
}
