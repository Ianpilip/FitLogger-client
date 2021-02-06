import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:FitLogger/requests/calendar.dart';


class BlurryDialog extends StatelessWidget {

  final String title;
  final Widget content;
  final VoidCallback callbackConfirm;
  final VoidCallback callbackCancel;
  final CalendarRequests calendarRequests;

  BlurryDialog({this.title, this.content, this.callbackConfirm, this.callbackCancel, this.calendarRequests});
  final TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: AlertDialog(
        title: new Text(title, style: textStyle,),
        content: Container(
          child: content,
          width: MediaQuery.of(context).size.width,
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Continue"),
            onPressed: () {
              callbackConfirm();
            },
          ),
          new FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              callbackCancel();
            },
          ),
        ],
      ),
    );
  }
}