import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

enum POSITION { top, bottom }

class ToastService {
  final BuildContext context;

  ToastService(this.context);

  Future<void> showToast(
      ContentType contentType, POSITION position, String title, String message,
      {Duration duration = const Duration(seconds: 3)}) async {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(
        // bottom: 0,
        // top: 0,
        // right: 20,
        // left: 20,
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
    // wait for duration
    await Future.delayed(duration);
  }

  Future<void> showSuccessToast(String message) {
    return showToast(
      ContentType.success,
      POSITION.top,
      '🎉 Congulaturations!',
      message,
    );
  }

  Future<void> showErrorToast(String message) {
    return showToast(
      ContentType.failure,
      POSITION.top,
      '😢 Oops!',
      message,
    );
  }
}
