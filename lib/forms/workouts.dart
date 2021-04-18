/// FORM FOR CREATING/UPDATING/REMOVING WORKOUT DAY

import 'package:flutter/material.dart';

import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;

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

  @override
  Widget build(BuildContext context) {

    print(['WorkoutForm', widget.data]);

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

    return Container(
      child: Column(
        children: <Widget>[
          _textareaComment(widget.workoutCommentController),
          SizedBox(height: 10),
          Text('Symbols remained: ${_symbolsRemains.toString()}')
        ]
      )
    );

  }
}