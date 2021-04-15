import 'package:flutter/material.dart';
import 'package:FitLogger/sub-views/dialog.dart';
import 'dart:ui';

BlurryDialog setInvisibleExerciseDialog(BuildContext context, Function callbackConfirm, Map<dynamic, dynamic>exercise) {
  // VoidCallback callbackConfirm = () {
  //   Navigator.of(context).pop();
  //   print('Send a query to make it invisible');
  //   print(exercise);
  // };

  VoidCallback callbackCancel = () => {
    Navigator.of(context).pop()
  };

  BlurryDialog alert = BlurryDialog(
    title: null,
    content: RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black87, fontSize: 18),
        children: <InlineSpan>[
          TextSpan(text: 'Are you sure you want to make exercise '),
          TextSpan(text: exercise['name'], style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' invisible?'),
          TextSpan(text: '\n\n'),
          TextSpan(text: 'You can still see it in '),
          TextSpan(text: 'See all exercises ', style: TextStyle(fontWeight: FontWeight.bold)),
          // WidgetSpan(child: Icon(Icons.preview)),
          TextSpan(text: ' mode'),
        ],
      ),

    ),
    callbackConfirm: callbackConfirm,
    callbackCancel: callbackCancel
  );
  return alert;
}