import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:FitLogger/widgets/alert.dart';
import 'package:FitLogger/sub-views/dialog.dart';
import 'package:FitLogger/forms/exercises.dart';
import 'package:FitLogger/requests/exercises.dart';

import 'package:FitLogger/constants/hive_boxes_names.dart';
class Exercises extends StatelessWidget {
  
  // Maybe TextEditingController should be moved directly to lib/forms/exercises.dart
  TextEditingController _exersiseNameController = TextEditingController();
  ExercisesRequests exercisesRequests = ExercisesRequests();
  Box<dynamic> userDataBox = Hive.box(userDataBoxName);
  Box<dynamic> exercisesDataBox = Hive.box(exercisesDataBoxName);

  Map<String, dynamic> data = {
    'exerciseName': '',
    'bodyRegionID': '',
  };

  @override
  Widget build(BuildContext context) {

  // Navigator.of(context).pop() removes alert dialog
  VoidCallback callbackConfirm = () {
    Navigator.of(context).pop();
    // print(_exersiseNameController.text),
    exercisesRequests.createUpdateExercise(
      data['exerciseName'],
      '',
      data['bodyRegionID'],
      userDataBox.get('userID'),
      true
    )
    .then((response) {
      if(response['validationErrors'].length > 0) {
        Fluttertoast.showToast(
            msg: response['validationErrors']['exercise'],
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.black87
        );
      } else {
        exercisesRequests.getAllExercises(userDataBox.get('userID'), userDataBox.get('tokenID'))
          .then((exercises) {
            exercisesDataBox.put('exercises', exercises['body']['exercises']);
          });
        Fluttertoast.showToast(
            msg: response['body']['text'],
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.black87
        );
      }
      print(response['body']['exercise']);
    })
    .catchError((err) => print(err) );
    _exersiseNameController.clear();
  };

  VoidCallback callbackCancel = () => {
    Navigator.of(context).pop(),
    print(_exersiseNameController.text),
    _exersiseNameController.clear()
  };

  BlurryDialog alert = BlurryDialog(
    title: "Add new exercises",
    content: ExerciseForm(
      hint: "Bench press",
      exersiseNameController: _exersiseNameController,
      data: data
    ),
    callbackConfirm: callbackConfirm,
    callbackCancel: callbackCancel
  );

    return Container(
      child: ValueListenableBuilder(
        valueListenable: exercisesDataBox.listenable(),
        builder: (context, exercisesDataBox, _) {
          return Stack(
            children: <Widget>[
              new ListView(
              children: exercisesDataBox.get('exercises')
                // We need here `.map<Widget>((exercise)` instead of `.map((exercise)` because we have not primitive type inside list in a children prop above
                .map<Widget>((exercise) => new ListTile(title: new Text(exercise['name'])))
                .toList(),
              ),
              new Positioned(
                left: 30.0,
                top: 30.0,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    child: RaisedButton(
                      // shape: CircleBorder(),
                      shape: CircleBorder(side: BorderSide(color: Colors.black87)),
                      color: Colors.white,
                      child: Icon(Icons.add, color: Colors.black87, size: 60),
                      onPressed: () {
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
                      },
                    ),
                  )
                )
                ),
            ],
          );
        }
      )
    );
  }
}