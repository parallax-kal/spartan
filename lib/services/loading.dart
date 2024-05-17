import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class LoadingService {
  final BuildContext context;

  late ProgressDialog pd;

  LoadingService(this.context) {
    pd = ProgressDialog(context: context);
  }

  void show({
    String message = 'Loading ...',
  }) {
    pd.show(
      msg: message,
      msgColor: const Color(0XFF0C3D6B),
      backgroundColor: Colors.white,
      progressBgColor: Colors.black.withOpacity(0.5),
      surfaceTintColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.7),
      valuePosition: ValuePosition.center,
    );
  }

  void hide() {
    pd.close();
  }
}
