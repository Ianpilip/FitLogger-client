import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hive/hive.dart';
// import 'package:FitLogger/widgets/alert.dart';
import 'package:FitLogger/requests/calendar.dart';
import 'package:FitLogger/sub-views/wrapper_dialog.dart';
import 'package:FitLogger/forms/workouts.dart';
import 'package:FitLogger/sub-views/dialog.dart';

import 'package:FitLogger/constants/hive_boxes_names.dart';
import 'package:FitLogger/helpers/index_walker.dart';

import 'package:FitLogger/widgets/add_exercise_inside_alertdialog.dart' as AddExerciseWidget;

import 'get_body_regions_as_tabs.dart';

class BuildWorkoutForm {

  final Map<String, dynamic> data;

  BuildWorkoutForm({this.data});

  final TextEditingController _workoutCommentController = TextEditingController();
  final CalendarRequests calendarRequests = CalendarRequests();
  
  final TextStyle textStyle = TextStyle(color: Colors.black);
  final String title = 'Training day';
  final String hint = 'Workout duration 1h 15m';


    StreamController streamController = new StreamController<int>();

    void updateStateToGetNewUpdatedData(millisecondsSinceEpoch) {
      streamController.sink.add(millisecondsSinceEpoch);
    }


  build(BuildContext context) async{
    

    void callbackConfirm () {
      print('save workout');
      print(['data', data]);
      Navigator.of(context).pop();
    }

    void callbackCancel() {
      print('cancel workout');
      Navigator.of(context).pop();
    }

   


    Widget buildContent() {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 81.0
                ),
                Container(
                  // padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: WorkoutForm(
                      hint: "Workout duration 1h 15m",
                      workoutCommentController: _workoutCommentController,
                      data: data,
                      updateStateToGetNewUpdatedData: updateStateToGetNewUpdatedData,
                      streamController: streamController
                    )
                  ),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
                )
              ]
            )
          ),
          AddExerciseWidget.AddExerciseInsideAlertDialog(
              title: 'Add Exercise',
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      child: Text('Add new exercise'),
                      onTap: () {
                        data['exercise from widget'] = {
                          1111: 1111111,
                          2222: 2222222,
                          3333: 3333333
                        };
                        updateStateToGetNewUpdatedData(DateTime.now().millisecondsSinceEpoch);
                      },
                    ),
                    AddBodyRegionsAsTabs()
                    // Text('11'),
                    // Text('22'),
                    // Text('33'),
                    // Text('44'),
                    // Text('55'),
                    // Text('66'),
                    // Text('77'),
                    // Text('88'),
                    // Text('99'),
                  ]
                )
              )
            )
        ],
      );
    }


    data['workout'] = IndexWalker(Hive.box(calendarDataBoxName).get('workouts'))[data['year'].toString()][data['month'].toString()][data['day'].toString()].value;
    Widget _dialogContent = buildContent();
    BlurryDialog dialog = BlurryDialog(
      title: title,
      content: _dialogContent,
      callbackConfirm: callbackConfirm,
      callbackCancel: callbackCancel
    );


    // FutureBuilder futureBuilderDialog = FutureBuilder<Map<String, dynamic>>(
    //   future: calendarRequests.fetchData(data['year'], data['month'], data['day']),
    //   builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    //     Widget _dialogContent;
    //     // ATTENTION!!!
    //     // @TODO:
    //     // IN snapshot.data can be {validationErrors: {user: Token is not valid anymore}, body: {}}
    //     // SHOW THIS ERROR, DO NOT FORGET
    //     if (snapshot.hasData) {
    //       if(snapshot.data['body']['workout'] != null) {
    //         data['workout'] = snapshot.data['body']['workout'];
    //         print(['From Hive', IndexWalker(Hive.box(calendarDataBoxName).get('workouts'))[data['year'].toString()][data['month'].toString()][data['day'].toString()].value]);
    //         print(['From server', snapshot.data['body']['workout']]);
    //         // print(['snapshot', snapshot.data['body']['workout']]);
    //       }
    //       // _dialogContent = Text('${snapshot.data["dayOfMonth"]}');
    //       _dialogContent = buildContent();
    //     } else if (snapshot.hasError) {
    //       _dialogContent = Column(
    //         // mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Icon(
    //             Icons.error_outline,
    //             color: Colors.red,
    //             size: 60,
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 16),
    //             child: Text('Error: ${snapshot.error}'),
    //           )
    //         ],
    //       );
    //     } else {
    //       _dialogContent = SizedBox(
    //         child: CircularProgressIndicator(),
    //         width: 60,
    //         height: 60,
    //       );
    //     }
    //     return BlurryDialog(
    //       title: title,
    //       content: _dialogContent,
    //       callbackConfirm: callbackConfirm,
    //       callbackCancel: callbackCancel
    //     );
    //   },
    // );
    
    await showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: Duration(milliseconds: 100),
      pageBuilder: (ctx, anim1, anim2) => WrapperBlurryDialog(child: dialog),
      // pageBuilder: (ctx, anim1, anim2) => WrapperBlurryDialog(child: futureBuilderDialog),
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