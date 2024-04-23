import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class LoadingService {
  final BuildContext context;
  late SimpleFontelicoProgressDialog pd;

  LoadingService(this.context) {
    pd = SimpleFontelicoProgressDialog(
      context: context,
      barrierDimisable: false,
    );
  }

  void show({
    SimpleFontelicoProgressDialogType type =
        SimpleFontelicoProgressDialogType.phoenix,
    String message = 'Loading ...',
  }) {
    pd.show(
      type: type,
      message: message,
      hideText: false,
      indicatorColor: const Color(0XFF0C3D6B),
    );
  }

  void hide() {
    pd.hide();
  }
}
