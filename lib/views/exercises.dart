import 'package:flutter/material.dart';
import 'dart:ui';

// import 'package:FitLogger/widgets/alert.dart';
import 'package:FitLogger/sub-views/dialog.dart';
import 'package:FitLogger/forms/exercises.dart';


class Exercises extends StatelessWidget {
  
  TextEditingController _exersiseNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

  // Navigator.of(context).pop() removes alert dialog
  VoidCallback callbackConfirm = () => {
    Navigator.of(context).pop(),
    print(_exersiseNameController.text),
    _exersiseNameController.clear()
  };

  VoidCallback callbackCancel = () => {
    Navigator.of(context).pop(),
    print(_exersiseNameController.text),
    _exersiseNameController.clear()
  };

  BlurryDialog alert = BlurryDialog(
    title: "Add new exercises",
    content: ExerciseForm(
      hint: "Bench press",
      exersiseNameController: _exersiseNameController
    ),
    callbackConfirm: callbackConfirm,
    callbackCancel: callbackCancel
  );

    return Container(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: RaisedButton(
            shape: CircleBorder(),
            color: Colors.blue,
            child: Icon(Icons.add, color: Colors.white, size: 60),
            onPressed: () {
              return showGeneralDialog(
                barrierDismissible: true,
                barrierLabel: '',
                barrierColor: Colors.black38,
                transitionDuration: Duration(milliseconds: 100),
                pageBuilder: (ctx, anim1, anim2) => alert,
                transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                        child: FadeTransition(
                            child: child,
                            opacity: anim1,
                        ),
                    ),
                context: context,
              );
            },
          ),
        )
      )
    );
  }
}