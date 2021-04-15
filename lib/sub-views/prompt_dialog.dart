import 'package:flutter/material.dart';
import 'package:FitLogger/sub-views/dialog.dart';
import 'dart:ui';

BlurryDialog promptDialog(BuildContext context, Function callbackConfirm, dynamic data) {

  VoidCallback callbackCancel = () => {
    Navigator.of(context).pop()
  };

  BlurryDialog alert = BlurryDialog(
    title: null,
    content: data,
    callbackConfirm: callbackConfirm,
    callbackCancel: callbackCancel
  );
  return alert;
}