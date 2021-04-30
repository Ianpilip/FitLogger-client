import 'package:flutter/cupertino.dart';
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
import 'package:FitLogger/sub-views/prompt_dialog.dart';
import 'package:FitLogger/prompt-text-nodes/exercises.dart';
import 'package:FitLogger/sub-views/show_general_dialog.dart';
import 'package:FitLogger/constants/colors.dart' as ColorConstants;

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
    'delete': false
  };

  void _changeShowAllExercises(bool value) {
    print(value);
    setState(() {
      _showAllExercises = value;
    });
  }

  void createUpdateDeleteExercise() {
    exercisesRequests.createUpdateDeleteExercise(
      data['exerciseName'],
      data['exerciseID'],
      data['bodyRegionID'],
      userDataBox.get('userID'),
      data['showInUI'],
      data['delete']
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
    // @TODO: Investigate why here comes null in two cases (splash red screen):
    // 1. When we login
    // 2. When we logout
    if(exercisesDataBox.get('exercises') != null) {
      for (int i = 0; i < exercisesDataBox.get('exercises').length; i++) {
        if(_showAllExercises == false && exercisesDataBox.get('exercises')[i]['showInUI'] == false) continue;
        exercises.add(ListTile(
          title: Text(exercisesDataBox.get('exercises')[i]['name']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<Map<String, dynamic>>(
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (menu) {
                  if(menu['action'] == 'edit') {
                    VoidCallback callbackConfirm = () {
                      Navigator.of(context).pop();
                      createUpdateDeleteExercise();
                      _exersiseNameController.clear();
                    };

                    VoidCallback callbackCancel = () => {
                      Navigator.of(context).pop(),
                      _exersiseNameController.clear()
                    };

                    data['exerciseName'] = menu['value']['name'];
                    data['exerciseID'] = menu['value']['_id'];
                    data['bodyRegionID'] = menu['value']['regionID'];
                    data['showInUI'] = menu['value']['showInUI'];
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
                  } else if(menu['action'] == 'show') {
                    VoidCallback callbackConfirm = () {
                      Navigator.of(context).pop();
                      data['exerciseName'] = menu['value']['name'];
                      data['exerciseID'] = menu['value']['_id'];
                      data['bodyRegionID'] = menu['value']['regionID'];
                      data['showInUI'] = !menu['value']['showInUI'];
                      createUpdateDeleteExercise();
                    };
                    RichText dataAlert = showHideExercise(menu['value']);
                    BlurryDialog _alert = promptDialog(context, callbackConfirm, dataAlert);
                    // BlurryDialog _alert = setInvisibleExerciseDialog(context, callbackConfirm, menu['value']);
                    callShowGeneralDialog(context, _alert);
                  } else if(menu['action'] == 'delete') {
                    VoidCallback callbackConfirm = () {
                      Navigator.of(context).pop();
                      data['exerciseID'] = menu['value']['_id'];
                      data['bodyRegionID'] = menu['value']['regionID'];
                      data['delete'] = true;
                      createUpdateDeleteExercise();
                    };
                    RichText dataAlert = deleteExercise(menu['value']);
                    BlurryDialog _alert = promptDialog(context, callbackConfirm, dataAlert);
                    callShowGeneralDialog(context, _alert);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: {'action': 'show', 'value': exercisesDataBox.get('exercises')[i]},
                    child: Row(
                      children: <Widget>[
                        Text(exercisesDataBox.get('exercises')[i]['showInUI'] == true ? 'Hide' : 'Show'),
                        Spacer(),
                        exercisesDataBox.get('exercises')[i]['showInUI'] == true ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: {'action': 'edit', 'value': exercisesDataBox.get('exercises')[i]},
                    child: Row(
                      children: <Widget>[
                        Text('Edit'),
                        Spacer(),
                        Icon(Icons.edit),
                      ],
                    ),
                  ),
                  PopupMenuDivider(
                    height: 20,
                  ),
                  PopupMenuItem(
                    value: {'action': 'delete', 'value': exercisesDataBox.get('exercises')[i]},
                    child: Row(
                      children: <Widget>[
                        Text('Delete'),
                        Spacer(),
                        Icon(Icons.delete_forever),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
      }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('See all exercises'),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          trackColor: Colors.black12,
                          activeColor: Color(ColorConstants.DARK_OLIVE_GREEN),
                          value: _showAllExercises,
                          onChanged: _changeShowAllExercises,
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  ListView(
                    shrinkWrap: true,
                    children: _getListOfExercises(),
                  ),
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
                          createUpdateDeleteExercise();
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