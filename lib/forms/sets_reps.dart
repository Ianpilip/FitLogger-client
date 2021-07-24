import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

    List<CupertinoPicker> cupertinoPickers = [];

    // print(widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps']);

    if(widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'] != null) {
      for(int setOfTheCurrentExercise = 0; setOfTheCurrentExercise < widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'].length; setOfTheCurrentExercise++) {
        print(['1111', setOfTheCurrentExercise]);
        cupertinoPickerControllers['repController$indexOfTheCurrentExerciseInArrayOfExercises-$setOfTheCurrentExercise'] = FixedExtentScrollController(initialItem: 0);

        cupertinoPickers.add(
          CupertinoPicker(
            selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.red.withOpacity(0.12)
            ),
            // backgroundColor: Colors.white,
            scrollController: cupertinoPickerControllers['repController$indexOfTheCurrentExerciseInArrayOfExercises-$setOfTheCurrentExercise'],
            onSelectedItemChanged: (int index) => _pickerHandler(),
            itemExtent: 40,
            children: cupertinoPickerItems,
          )
        );
      }
    }

    return Column(
      children: cupertinoPickers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              children: [
                _getSets(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    primary: Colors.white,
                    side: BorderSide(width: 1.0, color: Colors.black87),
                  ),
                  child: Icon(Icons.add, color: Colors.black87, size: 40),
                  onPressed: () {
                    // Box<dynamic> exercisesDataBox = Hive.box(exercisesDataBoxName);
                    // print(['222', exercisesDataBox.get('exercises')]);

                    widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'] != null
                      ? widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'].add(0)
                      : widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]['reps'] = [0];
                    
                    // print(['333', exercisesDataBox.get('exercises')]);
                      
                      // print([
                      //   'indexOfTheCurrentExerciseInArrayOfExercises',
                      //   indexOfTheCurrentExerciseInArrayOfExercises,
                      //   widget.exercises[indexOfTheCurrentExerciseInArrayOfExercises]
                      // ]);
                    setState(() {});
                  }
                )
              ],
            )
          )
        )
      )
    );
  }


}