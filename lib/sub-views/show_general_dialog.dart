import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:FitLogger/sub-views/dialog.dart';

Future callShowGeneralDialog(BuildContext context, BlurryDialog alert) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: Duration(milliseconds: 100),
    pageBuilder: (ctx, anim1, anim2) => alert,
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
            child: FadeTransition(
                child: child,
                opacity: anim1,
            ),
        ),
    context: context,
  );
}