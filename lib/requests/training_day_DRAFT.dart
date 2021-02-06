import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/src/widgets/framework.dart';

import 'package:FitLogger/widgets/alert.dart';

class TrainingDay extends StatelessWidget {

  final List<int> date;
  TrainingDay({this.date});

  Future<List<int>> fetchData(List<int> date) {
    return Future.delayed(Duration(milliseconds: 200), () => date);
  }

  @override
  Widget build(BuildContext context) {

    VoidCallback callbackConfirm = () => {
      // Navigator.of(context).pop(),
      print('callbackConfirm'),
      // _exersiseNameController.clear()
    };

    VoidCallback callbackCancel = () => {
      // Navigator.of(context).pop(),
      print('callbackCancel'),
      // _exersiseNameController.clear()
    };

    return Container(
      child: FutureBuilder<List<int>>(
        future: fetchData(this.date), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {

    return AlertDialog(
        title: new Text('title'),
        content: Container(
          child: Text('asda'),
          width: MediaQuery.of(context).size.width,
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Continue"),
            onPressed: () {
              callbackConfirm();
            },
          ),
          new FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              callbackCancel();
            },
          ),
        ],
      );


            // Widget content = Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: children,
            //   ),
            // );

            // BlurryDialog alert = BlurryDialog(
            //   title: "Trainig day data",
            //   content: content,
            //   callbackConfirm: callbackConfirm,
            //   callbackCancel: callbackCancel
            // );

            // return showGeneralDialog(
            //   barrierDismissible: true,
            //   barrierLabel: '',
            //   barrierColor: Colors.black38,
            //   transitionDuration: Duration(milliseconds: 100),
            //   pageBuilder: (ctx, anim1, anim2) => alert,
            //   transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
            //       filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
            //           child: FadeTransition(
            //               child: child,
            //               opacity: anim1,
            //           ),
            //       ),
            //   context: context,
            // );


          //   children = <Widget>[
          //     Icon(
          //       Icons.check_circle_outline,
          //       color: Colors.green,
          //       size: 60,
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(top: 16),
          //       child: Text('Result: ${snapshot.data[0]} year ${snapshot.data[1]} month ${snapshot.data[2]} day'),
          //     )
          //   ];
          // } else if (snapshot.hasError) {
          //   children = <Widget>[
          //     Icon(
          //       Icons.error_outline,
          //       color: Colors.red,
          //       size: 60,
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(top: 16),
          //       child: Text('Error: ${snapshot.error}'),
          //     )
          //   ];
          // } else {
          //   children = <Widget>[
          //     SizedBox(
          //       child: CircularProgressIndicator(),
          //       width: 60,
          //       height: 60,
          //     ),
          //     const Padding(
          //       padding: EdgeInsets.only(top: 16),
          //       child: Text('Awaiting result...'),
          //     )
          //   ];
          }


        },
      )
    );
  }


  // @override
  // Widget build(BuildContext context) {
      
  //   VoidCallback callbackConfirm = () => {
  //     // Navigator.of(context).pop(),
  //     print('callbackConfirm'),
  //     // _exersiseNameController.clear()
  //   };

  //   VoidCallback callbackCancel = () => {
  //     // Navigator.of(context).pop(),
  //     print('callbackCancel'),
  //     // _exersiseNameController.clear()
  //   };

  //   BlurryDialog alert = BlurryDialog(
  //     title: "Add new exercises",
  //     content: ExerciseForm(
  //       hint: "Bench press",
  //       exersiseNameController: _exersiseNameController
  //     ),
  //     callbackConfirm: callbackConfirm,
  //     callbackCancel: callbackCancel
  //   );

  // }
}