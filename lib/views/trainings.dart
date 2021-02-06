import 'package:flutter/material.dart';

class Trainings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: RaisedButton(
            shape: CircleBorder(),
            color: Colors.blue,
            child: Icon(Icons.add, color: Colors.white, size: 60),
            onPressed: () {},
          ),
        )
      )
    );
  }
}