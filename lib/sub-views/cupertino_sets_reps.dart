import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CupertinoSetsReps extends StatelessWidget {
  
  final int initialValue;
  final String type; // type can be only 'reps' or 'weights'
  FixedExtentScrollController cupertinoController;
  
  CupertinoSetsReps({this.initialValue, this.type});

  _pickerHandler() {
    // print(cupertinoController);
  }

  @override
  Widget build(BuildContext context) {
    // print([this.initialValue, this.type]);
    cupertinoController = FixedExtentScrollController(initialItem: this.initialValue);

    const List<Widget> reps = [
      Center(child: Text('1')),
      Center(child: Text('2')),
      Center(child: Text('3')),
      Center(child: Text('4')),
      Center(child: Text('5')),
      Center(child: Text('6')),
      Center(child: Text('7')),
      Center(child: Text('8')),
      Center(child: Text('9')),
      Center(child: Text('10')),
    ];

    const List<Widget> weights = [
      Center(child: Text('0.25')),
      Center(child: Text('0.5')),
      Center(child: Text('0.75')),
      Center(child: Text('1')),
      Center(child: Text('1.25')),
      Center(child: Text('1.5')),
      Center(child: Text('1.75')),
      Center(child: Text('2')),
      Center(child: Text('2.25')),
      Center(child: Text('2.5')),
      Center(child: Text('2.75')),
      Center(child: Text('3')),
    ];

    

    return Container(
      width: 60,
      child: CupertinoPicker(
        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          background: Colors.red.withOpacity(0.12)
        ),
        scrollController: cupertinoController,
        onSelectedItemChanged: (int index) => _pickerHandler(),
        itemExtent: 40,
        children: type == 'reps' ? reps : weights,
      )
    );
    
  }
}