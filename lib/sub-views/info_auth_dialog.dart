import 'package:flutter/material.dart';
import 'package:FitLogger/sub-views/dialog.dart';
import 'dart:ui';
import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;

BlurryDialog getInfoAuthDialog(BuildContext context) {
  VoidCallback callbackConfirm = () => {
    Navigator.of(context).pop()
  };

  VoidCallback callbackCancel = () => {
    Navigator.of(context).pop()
  };

  BlurryDialog alert = BlurryDialog(
    title: null,
    content: RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black87, fontSize: 18),
        children: <TextSpan>[
          TextSpan(text: 'If '),
          TextSpan(text: 'you are not registered yet', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ', type email and password and you will be both registered and logged in at the same time.'),
          TextSpan(text: '\n\n'),
          TextSpan(text: 'If '),
          TextSpan(text: 'you are registered, but not logged in', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ', type your email and password as usual.'),
          TextSpan(text: '\n\n'),
          TextSpan(text: 'If '),
          TextSpan(text: 'you are registered, but you lost your password', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ', type your email,'),
          TextSpan(text: ' new password', style: TextStyle(decoration: TextDecoration.underline)),
          TextSpan(text: ' and click on checkbox '),
          TextSpan(text: 'Restore password', style: TextStyle(decoration: TextDecoration.underline)),
          TextSpan(text: ' under submit button. '),
          TextSpan(text: 'Then you will have 10 minutes to follow instructions we sent you on your email.'),
        ],
      ),
    ),
    callbackConfirm: callbackConfirm,
    callbackCancel: callbackCancel,
    options: {LogicSettings.dialogCancelButton: false}
  );
  return alert;
}