import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {

    Widget _input(TextEditingController controller) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
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
      child: _input(widget.exersiseNameController),
    );

  }
}