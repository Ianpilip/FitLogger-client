/// FORM FOR CREATING NEW EXERCISE

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;
import 'package:FitLogger/constants/hive_boxes_names.dart';

class ExerciseForm extends StatefulWidget {
  final String hint;
  TextEditingController exersiseNameController;
  final Map<String, dynamic> data;

  ExerciseForm({Key key, this.hint, this.exersiseNameController, this.data}): super(key: key);

  @override
  _ExerciseFormState createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {

  // TextEditingController _exersiseNameController = TextEditingController();

  // String _exersiseName;
  
  FixedExtentScrollController bodyRegionController;
  Box<dynamic> exercisesData;
  List<dynamic> exercises;
  List<dynamic> bodyRegions;
  int _symbolsRemains;

  @override
  void initState() {
    super.initState();
    exercisesData = Hive.box(exercisesDataBoxName);
    exercises = exercisesData.get('exercises');
    bodyRegions = exercisesData.get('bodyRegions');
    int bodyRegionInitialItem = 0;
    String bodyRegionInitialValue = bodyRegions[0]['_id'];
    for (int i = 0; i < bodyRegions.length; i++) {
      if(bodyRegions[i]['_id'] == widget.data['bodyRegionID']) {
        bodyRegionInitialItem = i;
        bodyRegionInitialValue = bodyRegions[i]['_id'];
      }
    }
    bodyRegionController = FixedExtentScrollController(initialItem: bodyRegionInitialItem);
    widget.data['bodyRegionID'] = bodyRegionInitialValue;
    widget.exersiseNameController.text = widget.data['exerciseName'];
    _symbolsRemains = widget.exersiseNameController.text.length > 0 ? LogicSettings.exerciseNameLength - widget.exersiseNameController.text.length : LogicSettings.exerciseNameLength;
    // widget.data['bodyRegionID'] = bodyRegions[0]['_id'];
  }

  @override
  void dispose() {
    super.dispose();
    bodyRegionController.dispose();
  }

  void _pickerHandler() {
    // print(bodyRegionController.selectedItem);
    widget.data['bodyRegionID'] = bodyRegions[bodyRegionController.selectedItem]['_id'];
    // print(bodyRegions[bodyRegionController.selectedItem]);
  }


  
  String _maxAvailableExerciseNameText;
  // static Box<dynamic> exercisesData = Hive.box(exercisesDataBoxName);
  // static List<dynamic> exercises = exercisesData.get('exercises');
  // static List<dynamic> bodyRegions = exercisesData.get('bodyRegions');
  // String _exersizeID = exercises[0]['_id'];
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    
    Widget _input(TextEditingController controller) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          onChanged: (value) {
            widget.data['exerciseName'] = value;
            int isSymbolsRemainsIsBiggerThanZero = LogicSettings.exerciseNameLength - value.length;
            setState(() {
              _symbolsRemains = isSymbolsRemainsIsBiggerThanZero;
            });
            // if(isSymbolsRemainsIsBiggerThanZero == 0) {
            //   _maxAvailableExerciseNameText = controller.text;
            // }
            if(isSymbolsRemainsIsBiggerThanZero < 0) {
              // It is needed here because we can edit an exercise which has a name of exactly 70 characters, so we need to slice it
              _maxAvailableExerciseNameText = controller.text.substring(0, LogicSettings.exerciseNameLength);
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
          // controller: controller,
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

    List<Widget> cupertinoPickerItems = [];
    bodyRegions.forEach((item) {
      cupertinoPickerItems.add(
        Center(child: Text(item['name']))
      );
    });

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 90,
            width: 100,
            child: Center(
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                scrollController: bodyRegionController,
                onSelectedItemChanged: (int index) => _pickerHandler(),
                // onSelectedItemChanged: (value) {
                //   setState(() {
                //     selectedValue = value;
                //   });
                // },
                itemExtent: 40,
                children: cupertinoPickerItems,
              )
            ),
          ),
          SizedBox(height: 10),
          _input(widget.exersiseNameController),
          SizedBox(height: 10),
          Text('Symbols remained: ${_symbolsRemains.toString()}')
        ]
      )
    );

  }
}