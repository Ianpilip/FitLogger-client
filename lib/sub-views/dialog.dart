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
    double verticalInsetPadding = MediaQuery.of(context).viewInsets.bottom > 0.0 ? 4.5 : 3.5;
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: GestureDetector(
        onTap: () {
          // Hide keyboard and make textField unfocused after click in the area of the alert
          FocusScope.of(context).unfocus();
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          title: Center(child: Text(title, style: textStyle)),
          insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) / verticalInsetPadding),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Center(child: SingleChildScrollView(child: content)),
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlineButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    highlightedBorderColor: Colors.black54,
                    borderSide: BorderSide(color: Colors.transparent),
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Continue", style: TextStyle(color: Colors.black87, fontSize: 18)),
                    onPressed: () {
                      callbackConfirm();
                    },
                  ),
                  OutlineButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    highlightedBorderColor: Colors.black54,
                    borderSide: BorderSide(color: Colors.transparent),
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Cancel", style: TextStyle(color: Colors.black87, fontSize: 18)),
                    onPressed: () {
                      callbackCancel();
                    },
                  ),
                ],
              )
            ]
          )
        )
      )
    );
  }
}