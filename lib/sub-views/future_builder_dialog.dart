import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:FitLogger/requests/calendar.dart';
import 'package:FitLogger/sub-views/dialog.dart';

class FutureBuilderDialog extends StatelessWidget {

  final String title;
  final Widget content;
  final VoidCallback callbackConfirm;
  final VoidCallback callbackCancel;
  final CalendarRequests calendarRequests;

  FutureBuilderDialog({this.title, this.content, this.callbackConfirm, this.callbackCancel, this.calendarRequests});
  final TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: this.calendarRequests.fetchDataMock(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, int>> snapshot) {
        Widget _dialogContent;
        if (snapshot.hasData) {
          // _dialogContent = Text('${snapshot.data["dayOfMonth"]}');
          _dialogContent = this.content;
        } else if (snapshot.hasError) {
          _dialogContent = Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ],
          );
        } else {
          _dialogContent = SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          );
        }
        return BlurryDialog(
          title: this.title,
          content: _dialogContent,
          callbackConfirm: this.callbackConfirm,
          callbackCancel: this.callbackCancel
        );
      },
    );
  }
}