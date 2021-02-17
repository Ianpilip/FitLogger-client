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
            shape: CircleBorder(side: BorderSide(color: Colors.black87)),
            color: Colors.white,
            child: Icon(Icons.add, color: Colors.black87, size: 60),
            onPressed: () {},
          ),
        )
      )
    );
  }
}