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
import 'package:FitLogger/helpers/custom_material_color.dart';
import 'package:FitLogger/constants/logic_settings.dart' as LogicConstants;
import 'package:FitLogger/constants/ui_settings.dart' as UIConstants;
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
  String _currentTabBodyRegion = LogicConstants.allItems;

  Map<String, dynamic> data = {
    'exerciseName': '',
    'exerciseID': '',
    'bodyRegionID': '',
    'showInUI': true,
    'delete': false
  };

  void _changeShowAllExercises(bool value) {
    // print(value);
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
      List<dynamic> exercisesData = [];
      if(_currentTabBodyRegion == LogicConstants.allItems) {
        exercisesData = exercisesDataBox.get('exercises');
      } else {
        for(int e = 0; e < exercisesDataBox.get('exercises').length; e++) {
          if(exercisesDataBox.get('exercises')[e]['regionID'] == _currentTabBodyRegion) exercisesData.add(exercisesDataBox.get('exercises')[e]);
        }
      }
      for (int i = 0; i < exercisesData.length; i++) {
        if(_showAllExercises == false && exercisesData[i]['showInUI'] == false) continue;
        exercises.add(ListTile(
          title: Text(exercisesData[i]['name']),
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
                    value: {'action': 'show', 'value': exercisesData[i]},
                    child: Row(
                      children: <Widget>[
                        Text(exercisesData[i]['showInUI'] == true ? 'Hide' : 'Show'),
                        Spacer(),
                        exercisesData[i]['showInUI'] == true ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: {'action': 'edit', 'value': exercisesData[i]},
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
                    value: {'action': 'delete', 'value': exercisesData[i]},
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

  Container _getBodyRegionsAsTabs() {

    // We need to copy a list like that - List<String> clone = []..addAll(originalList);
    // Because if make just like that - List<dynamic> bodyRegionsData = exercisesDataBox.get('bodyRegions');
    // each change will be done in exercisesDataBox.get('bodyRegions') also and we will have 'All' body region in the exercise form
    List<dynamic> bodyRegionsData = []..addAll(exercisesDataBox.get('bodyRegions'));
    if(bodyRegionsData[0]['_id'] != LogicConstants.allItems) bodyRegionsData.insert(0, {'_id': LogicConstants.allItems, 'name': UIConstants.allItems});
    double horizontalMargin = 5.0;
    List<Widget> bodyRegions = [];
    for (int i = 0; i < bodyRegionsData.length; i++) {
      bodyRegions.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          // width: (MediaQuery.of(context).size.width - horizontalMargin * 5) / 2.5, // show third body region on the half so user can see that they are scrollable
          width: (MediaQuery.of(context).size.width - horizontalMargin * 7) / 3.5, // show forth body region on the half so user can see that they are scrollable
          child: ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent), // remove any shadow
              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
              side: MaterialStateProperty.all<BorderSide>(BorderSide(width: 1.0, color: bodyRegionsData[i]['_id'] == _currentTabBodyRegion ? customMaterialColor(Color(ColorConstants.BLUE))[100] : Colors.grey[400],)),
              backgroundColor: MaterialStateProperty.all<Color>(bodyRegionsData[i]['_id'] == _currentTabBodyRegion ? customMaterialColor(Color(ColorConstants.BLUE))[100] : Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                )
              )
            ),

            // style: ElevatedButton.styleFrom(
            //   side: BorderSide(width: 1.0, color: Colors.red,),
            //   shape: new RoundedRectangleBorder(
            //     borderRadius: new BorderRadius.circular(30.0),
            //   ),
            // ),

            child: Text(
              bodyRegionsData[i]['name'],
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 16)
            ),
            onPressed: () {
              setState(() {
                _currentTabBodyRegion = bodyRegionsData[i]['_id'];
              });
              
              // print(bodyRegionsData[i]['_id']);
            }
          )
        )
      );
    }

    return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 40.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: bodyRegions,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.height);
    // print(AppBar().preferredSize.height);
    // print(kToolbarHeight);
    // print(Scaffold.of(context).appBarMaxHeight);

    return Container(
      child: ValueListenableBuilder(
        valueListenable: exercisesDataBox.listenable(),
        builder: (context, exercisesDataBox, _) {
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _getBodyRegionsAsTabs(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        // margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
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
                            ),
                          ],
                        )
                      ),
                      RaisedButton(
                        // shape: CircleBorder(),
                        shape: CircleBorder(side: BorderSide(color: Colors.black87)),
                        color: Colors.white,
                        child: Icon(Icons.add, color: Colors.black87, size: 40),
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
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: _getListOfExercises(),
                      )
                    )
                  ),
                ]
              ),
              // Positioned(
              //   right: 0,
              //   bottom: 30.0,
              //   child: Align(
              //     alignment: Alignment.bottomRight,
              //     child: Container(
              //       margin: EdgeInsets.all(15.0),
              //       child: RaisedButton(
              //         // shape: CircleBorder(),
              //         shape: CircleBorder(side: BorderSide(color: Colors.black87)),
              //         color: Colors.white,
              //         child: Icon(Icons.add, color: Colors.black87, size: 60),
              //         onPressed: () {
                        
              //           data = {
              //             'exerciseName': '',
              //             'exerciseID': '',
              //             'bodyRegionID': '',
              //             'showInUI': true,
              //           };

              //           // Navigator.of(context).pop() removes alert dialog
              //           VoidCallback callbackConfirm = () {
              //             Navigator.of(context).pop();
              //             // print(_exersiseNameController.text),
              //             createUpdateDeleteExercise();
              //             _exersiseNameController.clear();
              //           };

              //           VoidCallback callbackCancel = () => {
              //             Navigator.of(context).pop(),
              //             // print(_exersiseNameController.text),
              //             _exersiseNameController.clear()
              //           };

              //           BlurryDialog alert = BlurryDialog(
              //             title: "Add new exercises",
              //             content: ExerciseForm(
              //               hint: "Bench press",
              //               exersiseNameController: _exersiseNameController,
              //               data: data
              //             ),
              //             callbackConfirm: callbackConfirm,
              //             callbackCancel: callbackCancel
              //           );

              //           return showGeneralDialog(
              //             barrierDismissible: true,
              //             barrierLabel: '',
              //             barrierColor: Colors.black38,
              //             transitionDuration: Duration(milliseconds: 100),
              //             pageBuilder: (ctx, anim1, anim2) => alert,
              //             transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
              //                 filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
              //                     child: FadeTransition(
              //                         child: child,
              //                         opacity: anim1,
              //                     ),
              //                 ),
              //             context: context,
              //           );
              //         },
              //       ),
              //     )
              //   )
              // ),
            ],
          );
        }
      )
    );
  }
}