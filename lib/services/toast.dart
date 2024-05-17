import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class ToastService {
  final BuildContext context;

  ToastService(this.context);

  void showSuccessToast(String message) {
    MotionToast.success(
      title: const Text("🎉 Congulaturations!"),
      description: Text(message),
      dismissable: true,
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
      height: 110,
      width: MediaQuery.of(context).size.width,
      toastDuration: const Duration(seconds: 5),
    ).show(context);
  }

  void showErrorToast(String message) {
    MotionToast.error(
      title: const Text("😢 Opps"),
      description: Text(message),
      dismissable: true,
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
      height: 110,
      width: MediaQuery.of(context).size.width,
      toastDuration: const Duration(seconds: 5),
    ).show(context);
  }
}
