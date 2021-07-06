import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SetsRepsForm extends StatefulWidget {
  final List<dynamic> exercises;

  const SetsRepsForm({Key key, this.exercises}): super(key: key);

  @override
  _SetsRepsFormState createState() => _SetsRepsFormState();
}

class _SetsRepsFormState extends State<SetsRepsForm> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              primary: Colors.white,
              side: BorderSide(width: 1.0, color: Colors.black87),
            ),
            child: Icon(Icons.add, color: Colors.black87, size: 40),
            onPressed: () {
              print(widget.exercises);
              // setState(() {
              // });
            }
          )
        )
      )
    );
  }


}