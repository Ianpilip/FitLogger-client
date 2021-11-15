import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:FitLogger/helpers/custom_material_color.dart';
import 'package:FitLogger/constants/colors.dart' as ColorConstants;
import 'package:FitLogger/sub-views/cupertino_sets_reps.dart';
// import 'package:hive/hive.dart';

// import 'package:FitLogger/constants/hive_boxes_names.dart';
class SetsRepsForm extends StatefulWidget {
  final List<dynamic> exercises;
  final String currentExerciseID;

  const SetsRepsForm({Key key, this.exercises, this.currentExerciseID}): super(key: key);

  @override
  _SetsRepsFormState createState() => _SetsRepsFormState();
}

class _SetsRepsFormState extends State<SetsRepsForm> {

  Map<String, dynamic> cupertinoPickerControllers = {};
  int indexOfTheCurrentExerciseInArrayOfExercises;

  @override
  void initState() {
    super.initState();
    // cupertinoPickerControllers['repController0'] = FixedExtentScrollController(initialItem: 0);

    if(indexOfTheCurrentExerciseInArrayOfExercises == null) {
      for(int i = 0; i < widget.exercises.length; i++) {
        if(widget.exercises[i]['_id'] == widget.currentExerciseID) {
          setState(() {
            indexOfTheCurrentExerciseInArrayOfExercises = i;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // cupertinoPickerControllers['repController0'].dispose();
  }

  void _pickerHandler() {
    // print(cupertinoPickerControllers['repController0'].selectedItem);
    print(cupertinoPickerControllers);
  }

  _getSets() {

    List<Widget> cupertinoPickerItems = [
      Center(child: Text('111')),
      Center(child: Text('222')),
      Center(child: Text('333'))
    ];

    // cupertinoPickerControllers['repController$indexOfTheCurrentExerciseInArrayOfExercises'] = FixedExtentScrollController(initialItem: 0);

    List<Container> cupertinoPickers = [];

    // print(widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps']);

    if(widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'] != null) {
      for(int setOfTheCurrentExercise = 0; setOfTheCurrentExercise < widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'].length; setOfTheCurrentExercise++) {
        // print(['setOfTheCurrentExercise', setOfTheCurrentExercise]);
        cupertinoPickerControllers['repController$indexOfTheCurrentExerciseInArrayOfExercises-$setOfTheCurrentExercise'] = FixedExtentScrollController(initialItem: 0);

        cupertinoPickers.add(
          Container(
            width: 60,
            child: CupertinoPicker(
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: Colors.red.withOpacity(0.12)
              ),
              // backgroundColor: Colors.white,
              scrollController: cupertinoPickerControllers['repController$indexOfTheCurrentExerciseInArrayOfExercises-$setOfTheCurrentExercise'],
              onSelectedItemChanged: (int index) => _pickerHandler(),
              itemExtent: 40,
              children: cupertinoPickerItems,
            )
          )

        );
      }
    }

    return Column(
      children: cupertinoPickers,
    );
  }

  _getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(child: Text('reps', style: TextStyle(color: Colors.grey)))
        ),
        Expanded(
          flex: 1,
          child: Center(child: Text('weight', style: TextStyle(color: Colors.grey)))
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }

  _getIndexOfTheCurrentExerciseInArrayOfExercises() {
    for(int i = 0; i < widget.exercises.length; i++) {
      if(widget.exercises[i]['_id'] == widget.currentExerciseID) {
        return i;
      }
    }
  }

  _getSets1(index) {
    List<Row> children = [];
    if(
      widget.exercises[index]['reps'] != null &&
      widget.exercises[index]['weights'] != null &&
      widget.exercises[index]['reps'].length > 0 &&
      widget.exercises[index]['weights'].length > 0 &&
      widget.exercises[index]['reps'].length == widget.exercises[index]['weights'].length
    ) {
      for(int i = 0; i < widget.exercises[index]['reps'].length; i++) {
        children.add(Row(children: [
          CupertinoSetsReps(initialValue: widget.exercises[index]['reps'][i], type: 'reps'),
          CupertinoSetsReps(initialValue: widget.exercises[index]['weights'][i], type: 'weights'),
        ],));
      }
    } else {
      children.add(Row(children: [SizedBox()]));
    }
    return children;
    // return CupertinoSetsReps(initialValue: 0, type: 'reps');
  }

  @override
  Widget build(BuildContext context) {
    int index = _getIndexOfTheCurrentExerciseInArrayOfExercises();

    return Column(
      children: [
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Divider(color: Colors.grey, height: 1.0,),
        ),
        SizedBox(height: 10.0),  
        _getHeader(),
        Expanded(
        child: SingleChildScrollView(
            child: Column(
              children: [
                Column(children: _getSets1(index)),

              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  child: Container(
                    // margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: customMaterialColor(Color(ColorConstants.GHOST_WHITE))[500],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text('Add new set', style: TextStyle(color: Colors.grey),)
                  ),
                  onTap: () {
                    setState(() {
                      if(widget.exercises[index]['reps'] == null && widget.exercises[index]['weights'] == null) {
                        widget.exercises[index]['reps'] = [0];
                        widget.exercises[index]['weights'] = [0];
                      }
                    });
                      // setState(() {
                      //   widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'] != null
                      //     ? widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'].add(0)
                      //     : widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'] = [0];
                      // });
                  }
                )
              )

                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     shape: CircleBorder(),
                //     primary: Colors.white,
                //     side: BorderSide(width: 1.0, color: Colors.black87),
                //   ),
                //   child: Icon(Icons.add, color: Colors.black87, size: 40),
                //   onPressed: () {
                //     // Box<dynamic> exercisesDataBox = Hive.box(exercisesDataBoxName);
                //     // print(['222', exercisesDataBox.get('exercises')]);

                //     widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'] != null
                //       ? widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'].add(0)
                //       : widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'] = [0];
                    
                //     // print(['333', exercisesDataBox.get('exercises')]);
                      
                //       // print([
                //       //   'indexOfTheCurrentExerciseInArrayOfExercises',
                //       //   indexOfTheCurrentExerciseInArrayOfExercises,
                //       //   widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]
                //       // ]);
                //     setState(() {});
                //   }
                // )
              ],
            )
          )
      )
      ]
    );
  }


}