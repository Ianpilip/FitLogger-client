import 'package:flutter/material.dart';
import 'dart:ui';
// import 'package:FitLogger/widgets/alert.dart';
import 'package:FitLogger/requests/calendar.dart';
import 'package:FitLogger/sub-views/wrapper_dialog.dart';
import 'package:FitLogger/forms/workouts.dart';
import 'package:FitLogger/sub-views/dialog.dart';

class BuildWorkoutForm {

  final Map<String, dynamic> data;

  BuildWorkoutForm({this.data});

  final TextEditingController _workoutCommentController = TextEditingController();
  final CalendarRequests calendarRequests = CalendarRequests();
  
  final TextStyle textStyle = TextStyle(color: Colors.black);
  final String title = 'Training day';
  final String hint = 'Workout duration 1h 15m';

build(BuildContext context) async{
    // print(data);

    void callbackConfirm () {
      Navigator.of(context).pop();
    }

    void callbackCancel() {
      Navigator.of(context).pop();
    }

    Widget buildContent() {
      return WorkoutForm(
        hint: "Workout duration 1h 15m",
        workoutCommentController: _workoutCommentController,
        data: data
      );
    }

    FutureBuilder futureBuilderDialog = FutureBuilder<Map<String, dynamic>>(
      future: calendarRequests.fetchData(data['year'], data['month'], data['day']),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Widget _dialogContent;
        if (snapshot.hasData) {
          if(snapshot.data['body']['workout'] != null) {
            data['workout'] = snapshot.data['body']['workout'];
            // print(['snapshot', snapshot.data['body']['workout']]);
          }
          // _dialogContent = Text('${snapshot.data["dayOfMonth"]}');
          _dialogContent = buildContent();
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
          title: title,
          content: _dialogContent,
          callbackConfirm: callbackConfirm,
          callbackCancel: callbackCancel
        );
      },
    );
    
    await showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: Duration(milliseconds: 100),
      pageBuilder: (ctx, anim1, anim2) => WrapperBlurryDialog(child: futureBuilderDialog),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
              child: FadeTransition(
                  child: child,
                  opacity: anim1,
              ),
          ),
      context: context,
    ).then((result) {
      if(result == null && data['callbackFunction'] != null) data['callbackFunction']();
    });
  }
}