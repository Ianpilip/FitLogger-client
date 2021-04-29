/// FORM FOR CREATING/UPDATING/REMOVING WORKOUT DAY

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;
import 'package:FitLogger/helpers/index_walker.dart';

class WorkoutForm extends StatefulWidget {
  final String hint;
  final TextEditingController workoutCommentController;
  final Map<String, dynamic> data;

  const WorkoutForm({Key key, this.hint, this.workoutCommentController, this.data}): super(key: key);

  @override
  _WorkoutFormState createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm> {

  // TextEditingController _exersiseNameController = TextEditingController();

  // String _exersiseName;

  int _symbolsRemains = LogicSettings.exerciseNameLength;
  String _maxAvailableExerciseNameText;
  FixedExtentScrollController setController;
  FixedExtentScrollController repController;
  FixedExtentScrollController uomController;
  Map<String, dynamic> cupertinoPickerControllers = {};

  int justToCheck = 0;

  @override
  void initState() {
    super.initState();
    widget.workoutCommentController.text = IndexWalker(widget.data)['workout']['comment'].value;
    
    // int uomIndex;
    // if(
    //   IndexWalker(widget.data)['workout']['uom'].value != null &&
    //   IndexWalker(widget.data)['workout']['exercise'][0]['uom'].value != null
    // ) {
    //   uomIndex = widget.data['workout']['uom'][widget.data['workout']['exercise'][0]['uom']];
    // }
    // 
    
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

  @override
  Widget build(BuildContext context) {

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

    Widget _textareaComment(TextEditingController controller) {
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
        return Text('No exercises');
      }

      
    }

    return Container(
      child: Column(
        children: <Widget>[
          _exercises(widget.workoutCommentController),
          _textareaComment(widget.workoutCommentController),
          SizedBox(height: 10),
          Text('Symbols remained: ${_symbolsRemains.toString()}')
        ]
      )
    );

  }
}