import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

enum POSITION { top, bottom }

class ToastService {
  static void showToast(BuildContext context, ContentType contentType,
      POSITION position, String title, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(
        bottom: position == POSITION.top
            ? MediaQuery.of(context).size.height - 150
            : 0,
        right: 20,
        left: 20,
      ),
      duration: duration,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSuccessToast(BuildContext context, String message) {
    showToast(
      context,
      ContentType.success,
      POSITION.bottom,
      '🎉 Congulaturations!',
      message,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    showToast(
      context,
      ContentType.failure,
      POSITION.bottom,
      '😢 Oops!',
      message,
    );
  }
}
