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
import 'package:FitLogger/sub-views/prompt_invisible_exercise.dart';
import 'package:FitLogger/sub-views/show_general_dialog.dart';

class Exercises extends StatefulWidget {
  @override
  _ExercisesState createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  
  // Maybe TextEditingController should be moved directly to lib/forms/exercises.dart
  TextEditingController _exersiseNameController = TextEditingController();
  ExercisesRequests exercisesRequests = ExercisesRequests();
  Box<dynamic> userDataBox = Hive.box(userDataBoxName);
  Box<dynamic> exercisesDataBox = Hive.box(exercisesDataBoxName);
  bool _showAllExercises = false;

  Map<String, dynamic> data = {
    'exerciseName': '',
    'exerciseID': '',
    'bodyRegionID': '',
    'showInUI': true,
  };

  void _changeShowAllExercises(bool value) {
    print(value);
    setState(() {
      _showAllExercises = value;
    });
  }

  void createUpdateExercise() {
    exercisesRequests.createUpdateExercise(
      data['exerciseName'],
      data['exerciseID'],
      data['bodyRegionID'],
      userDataBox.get('userID'),
      data['showInUI']
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
            print(exercises['body']['exercises']);
            exercisesDataBox.put('exercises', exercises['body']['exercises']);
          });
        Fluttertoast.showToast(
            msg: response['body']['text'],
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.black87
        );
      }
    })
    .catchError((err) => print(err));
  }

  List<Widget> _getListOfExercises() {
    List<ListTile> exercises = [];
    for (int i = 0; i < exercisesDataBox.get('exercises').length; i++) {
      if(_showAllExercises == false && exercisesDataBox.get('exercises')[i]['showInUI'] == false) continue;
      exercises.add(ListTile(
        title: Text(exercisesDataBox.get('exercises')[i]['name']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              child: exercisesDataBox.get('exercises')[i]['showInUI'] == true ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
              onTap: () {
                VoidCallback callbackConfirm = () {
                  Navigator.of(context).pop();
                  data['exerciseName'] = exercisesDataBox.get('exercises')[i]['name'];
                  data['exerciseID'] = exercisesDataBox.get('exercises')[i]['_id'];
                  data['bodyRegionID'] = exercisesDataBox.get('exercises')[i]['regionID'];
                  data['showInUI'] = !exercisesDataBox.get('exercises')[i]['showInUI'];
                  createUpdateExercise();
                };
                BlurryDialog _alert = setInvisibleExerciseDialog(context, callbackConfirm, exercisesDataBox.get('exercises')[i]);
                callShowGeneralDialog(context, _alert);
              },
            ),
            SizedBox(width: 25),
            GestureDetector(
              child: Icon(Icons.edit),
              onTap: () {
                
                VoidCallback callbackConfirm = () {
                  Navigator.of(context).pop();
                  createUpdateExercise();
                  _exersiseNameController.clear();
                };

                VoidCallback callbackCancel = () => {
                  Navigator.of(context).pop(),
                  _exersiseNameController.clear()
                };

                data['exerciseName'] = exercisesDataBox.get('exercises')[i]['name'];
                data['exerciseID'] = exercisesDataBox.get('exercises')[i]['_id'];
                data['bodyRegionID'] = exercisesDataBox.get('exercises')[i]['regionID'];
                data['showInUI'] = !exercisesDataBox.get('exercises')[i]['showInUI'];
                BlurryDialog alert = BlurryDialog(
                  title: "Edit an exercise",
                  content: ExerciseForm(
                    hint: "Bench press",
                    exersiseNameController: _exersiseNameController,
                    data: data
                  ),
                  callbackConfirm: callbackConfirm,
                  callbackCancel: callbackCancel
                );

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
            )
          ],
        ),
      ));
    }

    return exercises;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: ValueListenableBuilder(
        valueListenable: exercisesDataBox.listenable(),
        builder: (context, exercisesDataBox, _) {
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 25),
                  ListView(
                    shrinkWrap: true,
                    children: _getListOfExercises(),
                    // children: exercisesDataBox.get('exercises')
                    //   // We need here `.map<Widget>((exercise)` instead of `.map((exercise)` because we have not primitive type inside list in a children prop above
                    //   .map<Widget>((exercise) => ListTile(
                    //     title: Text(exercise['name']),
                    //     trailing: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         GestureDetector(
                    //           child: exercise['showInUI'] == true ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                    //           onTap: () {
                    //             VoidCallback callbackConfirm = () {
                    //               Navigator.of(context).pop();
                    //               data['exerciseName'] = exercise['name'];
                    //               data['exerciseID'] = exercise['_id'];
                    //               data['bodyRegionID'] = exercise['regionID'];
                    //               data['showInUI'] = !exercise['showInUI'];
                    //               createUpdateExercise();
                    //             };
                    //             BlurryDialog _alert = setInvisibleExerciseDialog(context, callbackConfirm, exercise);
                    //             callShowGeneralDialog(context, _alert);
                    //           },
                    //         ),
                    //         SizedBox(width: 25),
                    //         Icon(Icons.edit),
                    //       ],
                    //     ),
                    //   ))
                    //   .toList(),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('See all exercises'),
                      Checkbox(
                        checkColor: Colors.black54,
                        value: _showAllExercises,
                        onChanged: _changeShowAllExercises,
                      )
                    ],
                  )
                ]
              ),
              Positioned(
                right: 0,
                bottom: 30.0,
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
                        
                        data = {
                          'exerciseName': '',
                          'exerciseID': '',
                          'bodyRegionID': '',
                          'showInUI': true,
                        };

                        // Navigator.of(context).pop() removes alert dialog
                        VoidCallback callbackConfirm = () {
                          Navigator.of(context).pop();
                          // print(_exersiseNameController.text),
                          createUpdateExercise();
                          _exersiseNameController.clear();
                        };

                        VoidCallback callbackCancel = () => {
                          Navigator.of(context).pop(),
                          // print(_exersiseNameController.text),
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