import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;

class ExerciseForm extends StatefulWidget {
  final String hint;
  final TextEditingController exersiseNameController;

  const ExerciseForm({Key key, this.hint, this.exersiseNameController}): super(key: key);

  @override
  _ExerciseFormState createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {

  // TextEditingController _exersiseNameController = TextEditingController();

  // String _exersiseName;

  int _symbolsRemains = LogicSettings.exerciseNameLength;
  String _maxAvailableExerciseNameText;

  @override
  Widget build(BuildContext context) {

    Widget _input(TextEditingController controller) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          onChanged: (value) {
            int isSymbolsRemainsIsBiggerThanZero = LogicSettings.exerciseNameLength - value.length;
            // print({isSymbolsRemainsIsBiggerThanZero, controller.text});
            // _maxAvailableExerciseNameText = controller.text;
            setState(() {
              _symbolsRemains = isSymbolsRemainsIsBiggerThanZero;
            });
            // print(controller.text);
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
            hintStyle: TextStyle(fontSize: 14, color: Colors.black),
            hintText: widget.hint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 3)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26, width: 1)
            ),
          ),
        ),
      );
    }

    return Container(
      child: Column(
        children: <Widget>[
          _input(widget.exersiseNameController),
          Text(_symbolsRemains.toString())
        ]
      )
    );

  }
}