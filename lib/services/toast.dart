import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class ToastService {
  final BuildContext context;

  ToastService(this.context);

  void showToast(
    ContentType contentType,
    String title,
    String message,
  ) async {
    final materialBanner = MaterialBanner(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      forceActionsBelow: true,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);
  }

  void showSuccessToast(String message) {
    showToast(
      ContentType.success,
      '🎉 Congulaturations!',
      message,
    );
  }

  void showErrorToast(String message) {
    return showToast(
      ContentType.failure,
      '😢 Oops!',
      message,
    );
  }
}
