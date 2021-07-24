import 'package:FitLogger/forms/sets_reps.dart';
import 'package:FitLogger/helpers/custom_material_color.dart';
import 'package:FitLogger/widgets/build_workout_form.dart';
/// FORM FOR CREATING/UPDATING/REMOVING WORKOUT DAY

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import "package:collection/collection.dart";

import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;
import 'package:FitLogger/constants/ui_settings.dart' as UIConstants;
import 'package:FitLogger/constants/colors.dart' as ColorConstants;
import 'package:FitLogger/helpers/index_walker.dart';
import 'package:FitLogger/constants/hive_boxes_names.dart';
import 'package:FitLogger/widgets/add_exercise_inside_alertdialog.dart' as AddExerciseWidget;

class WorkoutForm extends StatefulWidget {
  final String hint;
  final TextEditingController workoutCommentController;
  final Map<String, dynamic> data;
  final Function updateStateToGetNewUpdatedData;
  final streamController;

  const WorkoutForm({Key key, this.hint, this.workoutCommentController, this.data, this.updateStateToGetNewUpdatedData, this.streamController}): super(key: key);

  @override
  _WorkoutFormState createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm> with TickerProviderStateMixin {

  // TextEditingController _exersiseNameController = TextEditingController();

  // String _exersiseName;

  int _symbolsRemains = LogicSettings.exerciseNameLength;
  String _maxAvailableExerciseNameText;
  FixedExtentScrollController setController;
  FixedExtentScrollController repController;
  FixedExtentScrollController uomController;
  Map<String, dynamic> cupertinoPickerControllers = {};

  FixedExtentScrollController bodyRegionController;
  FixedExtentScrollController exerciseController;
  Box<dynamic> exercisesDataBox;
  List<dynamic> bodyRegionsData;
  List<Widget> bodyRegionItems = [];
  String _currentBodyRegion = LogicSettings.allItems;
  String _currentExercisesToShow = LogicSettings.allItems;
  Map<dynamic, List<dynamic>> _groupedExercisesByRegionID;

  int justToCheck = 0;
  
  int updateDateTime = 0;

  GlobalKey _key = GlobalKey();
  double _heightOfEachAddedExercise = 0;

  bool _turnRotationForExpansionTile = false;

  @override
  void initState() {
    super.initState();
    widget.workoutCommentController.text = IndexWalker(widget.data)['workout']['comment'].value;
    

    
    widget.streamController.stream.listen((data) {
      print("listen value - $data");
      // print("listen value - ${widget.data}");
      setState(() {
        updateDateTime = data;
      });
    });


    if(IndexWalker(widget.data)['workout']['exercise'].value != null) {
      widget.data['workout']['exercise'].asMap().forEach((indexExercise, exercise) {
        int uomIndex = 0;
        if(
          IndexWalker(widget.data)['workout']['uom'].value != null &&
          IndexWalker(exercise)['uom'].value != null
        ) {
          uomIndex = exercise['uom'];
        }

        cupertinoPickerControllers['setController$indexExercise'] = FixedExtentScrollController(initialItem: 0);
        cupertinoPickerControllers['repController$indexExercise'] = FixedExtentScrollController(initialItem: 0);
        cupertinoPickerControllers['uomController$indexExercise'] = FixedExtentScrollController(initialItem: uomIndex);

          exercise['reps'].asMap().forEach((indexCurrentSet, currentSet) {
            // print('HERE');
            cupertinoPickerControllers['exercise$indexExercise'] = {
              'set$indexExercise': {
                'repController': FixedExtentScrollController(initialItem: currentSet - 1),
                'weightController': FixedExtentScrollController(initialItem: (exercise['weights'][indexCurrentSet] * 2 - 1).toInt()),
                'uomController': FixedExtentScrollController(initialItem: exercise['uom'])
              }
            };

            // cupertinoPickerControllers['exercise$indexExercise']['set$indexCurrentSet']['repController'] = FixedExtentScrollController(initialItem: currentSet - 1);
            // cupertinoPickerControllers['exercise$indexExercise']['set$indexCurrentSet']['weightController'] = FixedExtentScrollController(initialItem: exercise['weights'][indexCurrentSet] / 2 - 1);
            // cupertinoPickerControllers['exercise$indexExercise']['set$indexCurrentSet']['uomController'] = FixedExtentScrollController(initialItem: exercise['uom']);

          });


      });

      // for (int i = 0; i < widget.data['workout']['exercise'].length; i++) {
      //   int uomIndex = 0;
      //   if(
      //     IndexWalker(widget.data)['workout']['uom'].value != null &&
      //     IndexWalker(widget.data)['workout']['exercise'][i]['uom'].value != null
      //   ) {
      //     // print([widget.data['workout']['uom'][widget.data['workout']['exercise'][i]['uom']], widget.data['workout']['exercise'][i]['uom'] ]);
      //     uomIndex = widget.data['workout']['exercise'][i]['uom'];
      //   }

      //   cupertinoPickerControllers['setController$i'] = FixedExtentScrollController(initialItem: 0);
      //   cupertinoPickerControllers['repController$i'] = FixedExtentScrollController(initialItem: 0);
      //   cupertinoPickerControllers['uomController$i'] = FixedExtentScrollController(initialItem: uomIndex);
      // }
    }

    // cupertinoPickerControllers['setController'] = FixedExtentScrollController(initialItem: 0);
    repController = FixedExtentScrollController(initialItem: 0);
    uomController = FixedExtentScrollController(initialItem: 0);
    // print(IndexWalker(widget.data)['workout']['uom'].value);
    // print(IndexWalker(widget.data)['workout']['exercise'][0]['uom'].value);
    // 
    // 
    // 
    
    exercisesDataBox = Hive.box(exercisesDataBoxName);
    bodyRegionsData = []..addAll(exercisesDataBox.get('bodyRegions'));
    bodyRegionsData.insert(0, {'_id': LogicSettings.allItems, 'name': UIConstants.allItems});
    bodyRegionController = FixedExtentScrollController(initialItem: 0);
    bodyRegionsData.forEach((item) {
      bodyRegionItems.add(
        Center(child: Text(item['name']))
      );
    });


    _groupedExercisesByRegionID = groupBy(exercisesDataBox.get('exercises'), (exercise) => exercise['regionID']);
    // print(newMap['603ac277df746a381172f18e']);



  //     List<dynamic> exercisesItems = [];
  //     if(bodyRegionsData[bodyRegionController.selectedItem]['_id'] == LogicSettings.allItems) {
  //       exercisesItems = exercisesDataBox.get('exercises');
  //     } else {
  //       for(int e = 0; e < exercisesDataBox.get('exercises').length; e++) {
  //         if(exercisesDataBox.get('exercises')[e]['regionID'] == bodyRegionsData[bodyRegionController.selectedItem]['_id']) exercisesItems.add(exercisesDataBox.get('exercises')[e]);
  //       }
  //     }




  }

  @override
  void dispose() {
    super.dispose();
    bodyRegionController.dispose();
  }

  void _pickerHandler() {
    setState(() {
      justToCheck = justToCheck + 1;
    });
    // print(['SETS0', cupertinoPickerControllers['setController0'].selectedItem]);
    // print(['SETS1', cupertinoPickerControllers['setController1'].selectedItem]);
    // print(['REPS', repController.selectedItem]);
    // print(['UOM', uomController.selectedItem]);
    // widget.data['bodyRegionID'] = bodyRegions[bodyRegionController.selectedItem]['_id'];
    // print(bodyRegions[bodyRegionController.selectedItem]);
  }


  void _changeBodyRegionHandler() {
    // print(bodyRegionsData[bodyRegionController.selectedItem]['_id']);
    setState(() {
      _currentBodyRegion = bodyRegionsData[bodyRegionController.selectedItem]['_id'];
    });
  }

  void _changeExerciseHandler() {
    // print(_currentBodyRegion == LogicSettings.allItems ? exercisesDataBox.get('exercises') : _groupedExercisesByRegionID[_currentBodyRegion]);
    // print([_currentBodyRegion, exercisesData[bodyRegionController.selectedItem]['_id']]);
  }


  void afterBuild(BuildContext context) {
      RenderBox renderedWidget = _key.currentContext.findRenderObject();
      print(['!!!!!!', renderedWidget.size.height]);
      setState(() {
        _heightOfEachAddedExercise = renderedWidget.size.height;
      });
  }


  @override
  Widget build(BuildContext context) {
// print(widget.data['exercises'].length);
    if(widget.data['exercises'].length == 1 && _heightOfEachAddedExercise == 0) WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));

    print(['Exercises', widget.data]);
    // widget.data['some exersice'] = {
    //   1: 11,
    //   2: 22,
    //   3: 33
    // };

    // if(IndexWalker(widget.data)['workout']['exercise'].value != null) {
    //   widget.data['workout']['exercise'].asMap().forEach((indexExercise, exercise) {
    //     int uomIndex = 0;
    //     if(
    //       IndexWalker(widget.data)['workout']['uom'].value != null &&
    //       IndexWalker(exercise)['uom'].value != null
    //     ) {
    //       uomIndex = exercise['uom'];
    //     }
    //     cupertinoPickerControllers['setController$indexExercise'] = FixedExtentScrollController(initialItem: 0);
    //     cupertinoPickerControllers['repController$indexExercise'] = FixedExtentScrollController(initialItem: 0);
    //     cupertinoPickerControllers['uomController$indexExercise'] = FixedExtentScrollController(initialItem: uomIndex);
    //     exercise['reps'].asMap().forEach((indexCurrentSet, currentSet) {
    //       print('HERE');
    //       cupertinoPickerControllers['exercise$indexExercise'] = {
    //         'set$indexExercise': {
    //           'repController': FixedExtentScrollController(initialItem: currentSet - 1),
    //           'weightController': FixedExtentScrollController(initialItem: (exercise['weights'][indexCurrentSet] * 2 - 1).toInt()),
    //           'uomController': FixedExtentScrollController(initialItem: exercise['uom'])
    //         }
    //       };
    //     });
    //   });
    // }

    // print(['WorkoutForm', widget.data]);

    Widget _getExercise(exercise, index) {
      Color _color = customMaterialColor(Color(ColorConstants.GHOST_WHITE))[500];
      // Color _color = Colors.grey;
      // return Container(
      //   margin: const EdgeInsets.only(bottom: 10.0),
      //   decoration: BoxDecoration(
      //     color: _color,
      //     borderRadius: BorderRadius.circular(30.0),
      //   ),
      //   child: Theme(
      //     data: ThemeData().copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent),
      //     child: ExpansionTile(
      //       // leading: Icon(Icons.laptop),
      //       leading: Container(
      //         padding: const EdgeInsets.only(right: 5.0),
      //         decoration: BoxDecoration(
      //           border: Border(
      //             right: BorderSide(
      //               color: Colors.grey,
      //               width: 1.0,
      //             ),
      //           )
      //         ),
      //         child: Icon(Icons.touch_app)
      //       ),
      //       title: Text(exercise['name']),
      //       textColor: Colors.black,
      //       iconColor: Colors.black,
      //       // backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
      //       // backgroundColor: _color,
      //       children: <Widget>[
      //         Container(
      //           decoration: BoxDecoration(
      //             color: _color,
      //             // borderRadius: BorderRadius.circular(30.0),
      //             borderRadius: BorderRadius.only(
      //               bottomRight: Radius.circular(30.0),
      //               bottomLeft: Radius.circular(30.0),
      //             ),
      //           ),
      //           height: MediaQuery.of(context).size.height * 0.1,
      //           width: MediaQuery.of(context).size.width,
      //           child: Center(child: Text("Hi")),
      //         ),
      //         // new ListTile(
      //         //   title: const Text('One'),
      //         //   onTap: () {
      //         //     print('One');
      //         //   },              
      //         // ),
      //         // new ListTile(
      //         //   title: const Text('Two'),
      //         //   onTap: () {
      //         //     print('Two');
      //         //   },              
      //         // ),
      //         // new ListTile(
      //         //   title: const Text('Three'),
      //         //   onTap: () {
      //         //     print('Three');
      //         //   },              
      //         // ),

      //       ]
      //     )
      //   )
      // );


    // AnimationController _controller = AnimationController(
    //   duration: const Duration(milliseconds: 500),
    //   vsync: this,
    // )..repeat(reverse: true);
    
    // AnimationController _controller = _turnRotationForExpansionTile == false ?
    //                                     AnimationController(vsync: this, duration: Duration(milliseconds: 300)) :
    //                                     AnimationController(vsync: this, duration: Duration(milliseconds: 300))..animateTo(0.5);

    AnimationController _controller = null;
    if(_turnRotationForExpansionTile == false) {
      _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300))..forward();
    } else {
      _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300))..animateTo(0.5);
    }
                                        
    // Animation<double> _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    Animation<double> _animation = Tween(begin: _turnRotationForExpansionTile == false ? 0.5 : 0.0, end: 1.0).animate(_controller);

    // Animation<double> _animation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.elasticOut,
    // );
// print(widget.data['exercises'].length);
      return Stack(
        children: [
          ListTile(
            title: Container(
              key: widget.data['exercises'].length == 1 ? _key : null,
              margin: const EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                child: ExpansionTile(
                  // onExpansionChanged: (val) {
                  //   setState(() {
                  //     _turnRotationForExpansionTile = val;
                  //   });
                  // },
                  // trailing: Wrap(
                  //   spacing: 12, // space between two icons
                  //   children: <Widget>[
                  //     RotationTransition(
                  //       turns: _animation,
                  //       child: const Icon(Icons.expand_more),
                  //     ),
                  //     GestureDetector(
                  //       child: Icon(Icons.delete_forever, size: 25.0, color: Colors.grey,),
                  //       onTap: () {
                  //         print('remove');
                  //       }
                  //     )
                  //   ]),

                  leading: Container(
                    padding: const EdgeInsets.only(right: 5.0),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      )
                    ),
                    child: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.touch_app),
                    )
                  ),
                  
                  // trailing: Container(
                  //   padding: const EdgeInsets.only(left: 5.0),
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       left: BorderSide(
                  //         color: Colors.grey,
                  //         width: 1.0,
                  //       ),
                  //     )
                  //   ),
                  //   child: ReorderableDragStartListener(
                  //     index: index,
                  //     child: const Icon(Icons.touch_app),
                  //   )
                  // ),
                  title: Text(exercise['name']),
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: _color,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: SetsRepsForm(
                          exercises: widget.data['exercises'],
                          currentExerciseID: exercise['_id']
                        )
                      ),
                    ),
                  ]
                )
              )
            ),
          ),
          new Positioned(
            right: 0.0,
            top: (_heightOfEachAddedExercise - 30) / 2,
            child: GestureDetector(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  // color: Colors.orange,
                  color: customMaterialColor(Color(ColorConstants.GHOST_WHITE))[500],
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                // child: Icon(Icons.delete_forever, size: 25.0, color: Colors.grey,),
                child: Icon(Icons.clear, size: 25.0, color: Colors.grey,),
              ),
              onTap: () {
                print('remove');
              }
            )
          ),
        ],

        key: ValueKey(exercise['_id']),
      );




    }

      Widget _getExercises() {
        List<Widget> exercises = widget.data['exercises'].asMap().entries.map<Widget>((exercise) => _getExercise(exercise.value, exercise.key)).toList();

        void _onReorder(int oldIndex, int newIndex) {
          setState(
            () {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              // final Widget item = widget.data['exercises'].removeAt(oldIndex);
              final Map<String, dynamic> item = Map<String, dynamic>.from(widget.data['exercises'].removeAt(oldIndex));
              widget.data['exercises'].insert(newIndex, item);
            },
          );
        }

        return Container(
          // height: widget.data['exercises'].length < 6 ? widget.data['exercises'].length * _heightOfEachAddedExercise : 6 * _heightOfEachAddedExercise,
          height: MediaQuery.of(context).size.height * 0.1 + _heightOfEachAddedExercise * 2.5,
          child: Center(child:Theme(
            data: ThemeData(
              canvasColor: Colors.transparent, // remove dragging background color
              shadowColor: Colors.transparent, // remove dragging shadow
            ),
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              onReorder: _onReorder,
              children: exercises
            )
          ))
        );

        return Column(
          children: exercises,
        );
      }

    Widget _textareaComment(TextEditingController controller) {

        Color _color = customMaterialColor(Color(ColorConstants.GHOST_WHITE))[500];

        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('Comments to the workout', style: GoogleFonts.balsamiqSans()),
              textColor: Colors.black,
              iconColor: Colors.black,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                  // height: MediaQuery.of(context).size.height * 0.1,
                  // width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          onChanged: (value) {
                            widget.data['comment'] = value;
                            int isSymbolsRemainsIsBiggerThanZero = LogicSettings.exerciseNameLength - value.length;
                            setState(() {
                              _symbolsRemains = isSymbolsRemainsIsBiggerThanZero;
                            });
                            if(isSymbolsRemainsIsBiggerThanZero == 0) {
                              _maxAvailableExerciseNameText = controller.text;
                            }
                            if(isSymbolsRemainsIsBiggerThanZero < 0) {
                              setState(() {
                                _symbolsRemains = 0;
                              });
                              // The code below sets a current string and puts a cursor to the end of the string
                              // Thios is the only way to set a cursor to the end, others work async, so it jumps to start
                              controller.value = TextEditingValue(
                                text: _maxAvailableExerciseNameText,
                                selection: TextSelection.collapsed(offset: _maxAvailableExerciseNameText.length),
                              );
                            }
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          controller: controller,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.balsamiqSans(fontSize: 16, color: Colors.grey),
                            hintText: widget.hint,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.black87, width: 2)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.black54, width: 1)
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Symbols remained: ${_symbolsRemains.toString()}'),
                        SizedBox(height: 10)
                      ]
                    ),
                  ),
                ),
              ]
            )
          )
        );



      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          onChanged: (value) {
            widget.data['comment'] = value;
            int isSymbolsRemainsIsBiggerThanZero = LogicSettings.exerciseNameLength - value.length;
            setState(() {
              _symbolsRemains = isSymbolsRemainsIsBiggerThanZero;
            });
            if(isSymbolsRemainsIsBiggerThanZero == 0) {
              _maxAvailableExerciseNameText = controller.text;
            }
            if(isSymbolsRemainsIsBiggerThanZero < 0) {
              setState(() {
                _symbolsRemains = 0;
              });
              // The code below sets a current string and puts a cursor to the end of the string
              // Thios is the only way to set a cursor to the end, others work async, so it jumps to start
              controller.value = TextEditingValue(
                text: _maxAvailableExerciseNameText,
                selection: TextSelection.collapsed(offset: _maxAvailableExerciseNameText.length),
              );
            }
          },
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          controller: controller,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            hintText: widget.hint,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.black87, width: 2)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.black54, width: 1)
            ),
          ),
        ),
      );
    }



    Widget _exercises(TextEditingController controller) {

      // print(_groupedExercisesByRegionID[_currentBodyRegion]);
      // print(_groupedExercisesByRegionID[_currentBodyRegion]);

      List<Widget> exercisesItems = [];
      TextStyle textStyle;
      if(_currentBodyRegion == LogicSettings.allItems) {
        for(int i = 0; i < exercisesDataBox.get('exercises').length; i++) {
          textStyle = TextStyle(fontSize: exercisesDataBox.get('exercises')[i]['name'].length > 55 ? 13 : 16);
          exercisesItems.add(Center(child: Text(exercisesDataBox.get('exercises')[i]['name'], style: textStyle)));
        }
      } else {
        if(_groupedExercisesByRegionID[_currentBodyRegion] != null) {
          for(int i = 0; i < _groupedExercisesByRegionID[_currentBodyRegion].length; i++) {
            textStyle = TextStyle(fontSize: _groupedExercisesByRegionID[_currentBodyRegion][i]['name'].length > 55 ? 13 : 16);
            print(_groupedExercisesByRegionID[_currentBodyRegion]);
            exercisesItems.add(Center(child: Text(_groupedExercisesByRegionID[_currentBodyRegion][i]['name'], style: textStyle)));
          }
        }
      }



      if(IndexWalker(widget.data)['workout']['exercise'].value != null) {
        // print(widget.data['workout']['exercise']);

        List<Widget> exercises = [];
        widget.data['workout']['exercise'].forEach((exercise) {
          exercises.add(Center(child: Text(exercise['exerciseName'])));
          exercises.add(
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Set'),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Rep'),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Weight'),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Measure'),
                ),
              ],
            )
          );
          exercise['reps'].asMap().forEach((indexCurrentSet, currentSet) {
            // print(exercise['weights'][indexCurrentSet]);
            exercises.add(
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text((indexCurrentSet + 1).toString()),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(currentSet.toString()),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(exercise['weights'][indexCurrentSet].toString()),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(widget.data['workout']['uom'][exercise['uom']].toString()),
                  ),
                ],
              )
            );
          });
        });
        
        // return Column(
        //   children: exercises,
        // );

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Text('FIRST EXERCISE'),
            ),
            Expanded(
              flex: 3,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                scrollController: cupertinoPickerControllers['setController0'],
                onSelectedItemChanged: (int index) => _pickerHandler(),
                itemExtent: 40,
                children: [for(int i = 1; i < 10; i += 1) Text(i.toString())],
              ),
            ),
            Expanded(
              flex: 3,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                scrollController: cupertinoPickerControllers['repController0'],
                onSelectedItemChanged: (int index) => _pickerHandler(),
                itemExtent: 40,
                children: [for(int i = 1; i < 10; i += 1) Text(i.toString())],
              ),
            ),
            Expanded(
              flex: 3,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                scrollController: cupertinoPickerControllers['uomController0'],
                onSelectedItemChanged: (int index) => _pickerHandler(),
                itemExtent: 40,
                children: [for(int i = 1; i < 10; i += 1) Text(i.toString())],
              ),
            ),
            // Expanded(
            //   flex: 3,
            //   child: Text('SECOND EXERCISE'),
            // ),
            // Expanded(
            //   flex: 3,
            //   child: CupertinoPicker(
            //     backgroundColor: Colors.white,
            //     scrollController: cupertinoPickerControllers['setController1'],
            //     onSelectedItemChanged: (int index) => _pickerHandler(),
            //     itemExtent: 40,
            //     children: [for(int i = 1; i < 10; i += 1) Text(i.toString())],
            //   ),
            // ),
            // Expanded(
            //   flex: 3,
            //   child: CupertinoPicker(
            //     backgroundColor: Colors.white,
            //     scrollController: cupertinoPickerControllers['repController1'],
            //     onSelectedItemChanged: (int index) => _pickerHandler(),
            //     itemExtent: 40,
            //     children: [for(int i = 1; i < 10; i += 1) Text(i.toString())],
            //   ),
            // ),
            // Expanded(
            //   flex: 3,
            //   child: CupertinoPicker(
            //     backgroundColor: Colors.white,
            //     scrollController: cupertinoPickerControllers['uomController1'],
            //     onSelectedItemChanged: (int index) => _pickerHandler(),
            //     itemExtent: 40,
            //     children: [for(int i = 1; i < 10; i += 1) Text(i.toString())],
            //   ),
            // ),
          ],
        );

      } else {
        // print(['****', exercisesItems, '****']);
        // exercisesItems.length > 0 ? exercisesItems[0] : Text('No')

        Color _color = customMaterialColor(Color(ColorConstants.GHOST_WHITE))[200];

        return Container(
          color: Colors.orange,
          child: AddExerciseWidget.AddExerciseInsideAlertDialog(
            title: 'Add Exercise',
            // mainContent: Column(
            //   children: [
            //     Text('Some content'),
            //     Text('Some content'),
            //     Text('Some content'),
            //     Text('Some content'),
            //     Text('Some content'),
            //     Text('Some content'),
            //     Text('Some content'),
            //     Text('Some content'),
            //     Text('Some content'),
            //     Text('Some content'),
            //   ]
            // ),
          ),
        );

        return Container(
          // color: Colors.transparent,
          child: Column(
            children: [
              // Container(
              //   height: 50.0,
              //   width: 500.0,
              //   child: Center(child: Text('Add new exercise')),
              //   decoration: BoxDecoration(
              //     // color: Color(ColorConstants.GHOST_WHITE),
              //     color: _color,
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(30.0),
              //       topRight: Radius.circular(30.0),
              //     ),
              //   ),
              // ),
              Container(
                // color: Color(ColorConstants.GHOST_WHITE),
                decoration: BoxDecoration(
                  color: _color,
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        height: 90,
                        child: CupertinoPicker(
                          backgroundColor: _color,
                          scrollController: bodyRegionController,
                          onSelectedItemChanged: (int index) => _changeBodyRegionHandler(),
                          itemExtent: 45,
                          children: bodyRegionItems,
                        )
                      )
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 20,
                      child: Container(
                        height: 90,
                        child: exercisesItems.length > 0 ? CupertinoPicker(
                          backgroundColor: _color,
                          scrollController: exerciseController,
                          onSelectedItemChanged: (int index) => _changeExerciseHandler(),
                          itemExtent: 45,
                          children: exercisesItems,
                        ) : Center(child: Text('There are no exercises'))
                      )
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add, size: 30.0,),
                            color: Colors.black87,
                            onPressed: () {
                              print('Add new exercise to workout day');
                            },
                          ),
                        )
                      ),
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                  ],
                )
              )
            ],
          )
        );

        return Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                height: 90,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  scrollController: bodyRegionController,
                  onSelectedItemChanged: (int index) => _changeBodyRegionHandler(),
                  // onSelectedItemChanged: (value) {
                  //   setState(() {
                  //     selectedValue = value;
                  //   });
                  // },
                  itemExtent: 45,
                  children: bodyRegionItems,
                )
              )
            ),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 10,
              child: Container(
                height: 90,
                child: exercisesItems.length > 0 ? CupertinoPicker(
                  backgroundColor: Colors.white,
                  scrollController: exerciseController,
                  onSelectedItemChanged: (int index) => _changeExerciseHandler(),
                  // onSelectedItemChanged: (value) {
                  //   setState(() {
                  //     selectedValue = value;
                  //   });
                  // },
                  itemExtent: 45,
                  children: exercisesItems,
                ) : Center(child: Text('There are no exercises'))
              )
            ),
            Expanded(flex: 1, child: SizedBox()),
            // Expanded(
            //   flex: 2,
            //   child: FloatingActionButton(
            //     onPressed: () => {},
            //     // tooltip: 'Increment',
            //     child: RichText(text: TextSpan(children: [WidgetSpan(child: Icon(Icons.add), style: TextStyle(fontSize: 24))])),
            //   ),
            // ),

        //     Expanded(
        //       flex: 2,
        //       child:         CircleAvatar(
        //   backgroundColor: Colors.white,
        //   radius: 20,
        //   child: IconButton(
        //     padding: EdgeInsets.zero,
        //     icon: Icon(Icons.add),
        //     color: Colors.black87,
        //     onPressed: () {},
        //   ),
        // ),
        //     )


            Expanded(
              flex: 2,
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                  border: new Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.add, size: 30.0,),
                  color: Colors.black87,
                  onPressed: () {
                    print('Add new exercise to workout day');
                  },
                ),
              ),
            )

          ],
        );
      }

      
    }

    return Container(
      child: Column(
        children: <Widget>[
          // _exercises(widget.workoutCommentController),
          SizedBox(height: 20),
          // Text(updateDateTime.toString()),
          // SizedBox(height: 20),
          // Text('1'),
          // SizedBox(height: 20),
          // Text('2'),
          // SizedBox(height: 20),
          // Text('3'),
          // SizedBox(height: 20),
          // Text('4'),
          // SizedBox(height: 20),
          // Text('5'),
          // SizedBox(height: 20),
          // Text('6'),
          // SizedBox(height: 20),
          // Text('7'),
          // SizedBox(height: 20),
          // Text('8'),
          // SizedBox(height: 20),
          // Text('9'),
          // SizedBox(height: 20),
          // Text(updateDateTime.toString()),
          // SizedBox(height: 20),
          // Text('SOME TEXT'),
          // SizedBox(height: 20),
          // Text('SOME TEXT'),
          // SizedBox(height: 20),
          // Text('SOME TEXT'),
          // SizedBox(height: 20),
          // Text('SOME TEXT'),
          // SizedBox(height: 20),
          // Text('SOME TEXT'),
          _getExercises(),
          SizedBox(height: 20),
          Divider(
            color: Colors.black,
          ),
          _textareaComment(widget.workoutCommentController),
        ]
      )
    );

  }
}