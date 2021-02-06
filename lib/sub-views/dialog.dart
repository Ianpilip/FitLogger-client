import 'dart:ui';
import 'package:flutter/material.dart';


class BlurryDialog extends StatelessWidget {

  final String title;
  final Widget content;
  final VoidCallback callbackConfirm;
  final VoidCallback callbackCancel;

  BlurryDialog({this.title, this.content, this.callbackConfirm, this.callbackCancel});
  final TextStyle textStyle = TextStyle(color: Colors.black);

  // We need `MediaQuery.of(context).viewInsets.bottom` here to identify
  // the descending height of the window because of keyboard, which appears
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: AlertDialog(
        title: Text(title, style: textStyle,),
        content: Container(
          child: Center(child: SingleChildScrollView(child: content)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) / 4),
        // insetPadding: EdgeInsets.symmetric(horizontal: 10),
        actions: <Widget>[
          FlatButton(
            child: Text("Continue"),
            onPressed: () {
              callbackConfirm();
            },
          ),
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              callbackCancel();
            },
          ),
        ],
      )
    );
  }
}