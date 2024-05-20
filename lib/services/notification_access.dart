import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async =>
      _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "spartan-3b328",
          "private_key_id": "f21952ebba86bdbe1c173a535a44690877bc42e9",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDJUJySgUO71cwz\nU8Q9xJZR7tMNnnlb979m4Lj3VUlYOvTKSbTz/NKLZs/w9jVDB38uUZEzYty/xRz9\nZvjyWE4ixAms1xXM4RCAaqUNyE8FuPN74SOxNGLkKwYhRS0LeS2TGzPJHtN8IWR0\niXGYunoCocJQRCxfE/c8YGL1dXnhM3Uc6maVuRrdPHsyQFBIwbzWONMM0FQj3gzE\nZveBnMELUSLzS/n6wrLj1vX7fSDESxhNfVr5W+XtUgk7cJhOWwxHTKRVqMhGn3jh\nkCoH4HgnyGBEwEfxbjd8iYl/gYGdLkmC5qn6agmxcb25W1/HjWBTaN4aeCaHzT4a\n4uCQwP9lAgMBAAECggEAHYzrrsWyv5u+gbpGEBsPRa+c417jyZAwVFWgUQ3/2iet\nTxRKr5XpAfVxiJlbcB9ll9L5UWWtqaixfLDk0g4MSiYklW5tEMnotjDxUXiZwOlJ\nNGHz70sVSRDXsYKJ/ikne3R+wYL44Du2lzSlrBmTV1ePQmD/cmVn4UD0xbsczOWR\n9fbUqJkw0QUCc2hYVCTzZxw7RHMKk0epiLHZl6bLzD9W04AEo2FxRQowxORutwRD\nJefAI/3cf9bUFPUa7hB0c+Ox95Mo4z0ftWLupAukbmb2AlmG2YtfJh2HhSO8X6KF\nLcKssOTeKtW7q79gmM/aorQeKQj/efJx24aJCw2KgQKBgQDz11UBqc5zLP1r4Uy/\n/TprErFg+V83KSXue29xr7IBWpdxF+aYmGOdrDg9mZEvfcLOxfiQ2w50znJDBkno\nWqcZgvwEzXlKfJ6KREi9Bo/1UEhLhuyAHZNoZ5oXUILlKnmeVvyz/4vvA1+UWlHV\n81cnlowQN1pP/ztydrNHYAF+mQKBgQDTWmz7V+izjS1ncQX8UtbYhXs/Y9pOhVt9\nVLE1TsQ6+p8AcbobXAkqHvBr+r6bft5zMrYgIfmM24MrVgLRgRQARrS9CWEwVv1X\nShNEXtGdt8vAnXr5PiJSSe1GC1r3DKeN5EfHsBoOxBuRipk613/lbgUftm6duE/p\nSXwCvdNCrQKBgQDGwBtPscLO6jrdtdRDIPp+z8u4yUosweNjEUVzGswygk6yJdMV\nShDYMcndm9BVL2Kb+41xNLwBxUwpCXUwaMOO7c7Rc1GLvyvSc3n+aNzqDTgAJ8eZ\nXYILNXbJzhwDAq4Cu9BaPs8mUE+VslDF3QSLBhDAHv4D+nvP/qR+ZuiQ8QKBgGt7\n9CqKlXQimvGdQA8HTe3FTF17eX0vQszlMk3K5e6coBoIvD3Hu31pSJmRZjgL+DMb\nmhWTUab5x6ZVUo+bFkHhs27jg0KjKqmmqU++7NlJrFwjenOgzrGMmRdjFPrIu7lk\nW8DI5SeXQfHtS2nqSEe0gPSUwYKCRll8no2CXhrtAoGBALVSLxilEZvd8DeGDaJL\nkXyeQM6buNqdsa1d0f1ik6XecgHiQ/xy3y/PssOyQtdHEo16cmLNUqOIAP20kGfl\nwUli32aejk21+6t5k8r/kmZNbM8srmKwI6vCXaRLJ3VMb1Cw1WpXqxtS5E8RiPxR\nnWIT1Vf95ug4D0satvp4Lm0s\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-a1i9u@spartan-3b328.iam.gserviceaccount.com",
          "client_id": "118361066541075852929",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-a1i9u%40spartan-3b328.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
