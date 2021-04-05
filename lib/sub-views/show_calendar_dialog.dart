import 'package:flutter/material.dart';
import 'dart:ui';
// import 'package:FitLogger/widgets/alert.dart';
import 'package:FitLogger/requests/calendar.dart';
import 'package:FitLogger/sub-views/future_builder_dialog.dart';
import 'package:FitLogger/sub-views/wrapper_dialog.dart';
import 'package:FitLogger/forms/workouts.dart';

class ShowCalendarDialog {
  // final Map<String, int> date;

  // ShowCalendarDialog({this.date});

  final CalendarRequests calendarRequests;

  ShowCalendarDialog({this.calendarRequests});

  TextEditingController _workoutCommentController = TextEditingController();

  Map<String, dynamic> data = {
    'comment': ''
  };

  void show(BuildContext context) {
      VoidCallback callbackConfirm = () => {
        Navigator.of(context).pop(),
        print('_exersiseNameController.text'),
        print(data)
      };

      VoidCallback callbackCancel = () => {
        Navigator.of(context).pop(),
        print('_exersiseNameController.text')
      };

      Widget buildContent() {
        return WorkoutForm(
          hint: "Workout duration 1h 15m",
          workoutCommentController: _workoutCommentController,
          data: data
        );
        // return Column(
        //   children: [
        //     GestureDetector(
        //       child: Text('TAP'),
        //       onTap: () {
        //         data['comment'] = 'some text here';
        //       }
        //     ),
        //     Text(this.calendarRequests.date['year'].toString())
        //   ],
        // );

        // return Text(this.calendarRequests.date['year'].toString());
      }

      // dynamic callback = (dynamic data) => {
      //   print('Here will be switch in order to understand what to do with data param')
      // };

      // BlurryDialog alert = BlurryDialog(
      //   title: "Add new exercises",
      //   content: buildContent(),
      //   callbackConfirm: callbackConfirm,
      //   callbackCancel: callbackCancel,
      //   calendarRequests: calendarRequests
      // );

      FutureBuilderDialog futureBuilderDialog = FutureBuilderDialog(
        title: "Training day",
        content: buildContent(),
        callbackConfirm: callbackConfirm,
        callbackCancel: callbackCancel,
        calendarRequests: calendarRequests
      );

      showGeneralDialog(
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
      );
  }
}