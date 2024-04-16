import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class LoadingService {
  final BuildContext context;

  LoadingService(this.context);

  void show() {
    SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    pd.show(
      message: 'Please wait',
      hideText: true,
    );
  }

  void hide() {
    SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    pd.hide();
  }
}
