/// FORM FOR CREATING NEW EXERCISE

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;
import 'package:FitLogger/constants/hive_boxes_names.dart';

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
  
  FixedExtentScrollController bodyRegionController;
  Box<dynamic> exercisesData;
  List<dynamic> exercises;
  List<dynamic> bodyRegions;

  @override
  void initState() {
    super.initState();
    exercisesData = Hive.box(exercisesDataBoxName);
    exercises = exercisesData.get('exercises');
    bodyRegions = exercisesData.get('bodyRegions');
    bodyRegionController = FixedExtentScrollController(initialItem: 0);
  }

  @override
  void dispose() {
    super.dispose();
    bodyRegionController.dispose();
  }

  void _pickerHandler() {
    // print(bodyRegionController.selectedItem);
    print(bodyRegions[bodyRegionController.selectedItem]['name']);
  }


  int _symbolsRemains = LogicSettings.exerciseNameLength;
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

    List<Widget> items = [
      Text("First Item"),
      Text("Second Item"),
      Text("Third Item"),
      Text("Forth Item"),
      Text("Fifth Item"),
      Text("Sixth Item")
    ];

    List<DropdownMenuItem> dropdownMenuItems = [];
    items.asMap().forEach((key, item) {
      dropdownMenuItems.add(DropdownMenuItem(
        child: Container(
          width: 200,
          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
          // padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            // color: Colors.transparent,
            // border: Border.all()
            boxShadow: [
              BoxShadow(color: Colors.green)
            ]
          ),
          child: item
        ),
        value: ++key,
      ));
    });
    int selectedValue;

    List<Widget> cupertinoPickerItems = [];
    bodyRegions.forEach((item) {
      cupertinoPickerItems.add(
        Center(child: Text(item['name']))
      );
    });

    return Container(
      child: Column(
        children: <Widget>[
          /*Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              color: Colors.transparent,
              // color: Colors.orange,
              // border: Border.all()
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                // selectedItemBuilder: (BuildContext context) {
                //   return dropdownMenuItems.map<DropdownMenuItem>((DropdownMenuItem item) {
                //     return DropdownMenuItem(
                //       child: Container(
                //         padding: const EdgeInsets.all(13.0),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10.0),
                //           color: Colors.transparent,
                //           border: Border.all()
                //         ),
                //         child: Text('asdasdasd')
                //       ),
                //     );
                //   }).toList();
                // },
                elevation: 0,
                dropdownColor: Colors.yellow,
                iconEnabledColor: Colors.orange,
                iconDisabledColor: Colors.green,
                focusColor: Colors.blue,
                icon: Icon(Icons.keyboard_arrow_down),
                value: _value,
                // items: dropdownMenuItems,

                // items: items.map((Widget item) {
                //   return DropdownMenuItem<String>(
                //     child: item,
                //     value: item,
                //   );
                // }).toList(),

                items: [
                  DropdownMenuItem(
                    child: Text("First Item"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("Second Item"),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text("Third Item"),
                    value: 3
                  ),
                  DropdownMenuItem(
                    child: Text("Forth Item"),
                      value: 4
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                })
            ),
          ),*/

          Container(
            height: 110,
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