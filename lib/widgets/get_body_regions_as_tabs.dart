import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:FitLogger/constants/hive_boxes_names.dart';
import 'package:FitLogger/helpers/custom_material_color.dart';
import 'package:FitLogger/constants/colors.dart' as ColorConstants;
import 'package:FitLogger/constants/logic_settings.dart' as LogicConstants;
import 'package:FitLogger/constants/ui_settings.dart' as UIConstants;

GlobalKey _key = GlobalKey();

class AddBodyRegionsAsTabs extends StatefulWidget {
  @override
  _AddBodyRegionsAsTabsState createState() => _AddBodyRegionsAsTabsState();
}


class _AddBodyRegionsAsTabsState extends State<AddBodyRegionsAsTabs> {

  Box<dynamic> exercisesDataBox = Hive.box(exercisesDataBoxName);
  String _currentTabBodyRegion = LogicConstants.allItems;

  @override
  Widget build(BuildContext context) {
    // We need to copy a list like that - List<String> clone = []..addAll(originalList);
    // Because if make just like that - List<dynamic> bodyRegionsData = exercisesDataBox.get('bodyRegions');
    // each change will be done in exercisesDataBox.get('bodyRegions') also and we will have 'All' body region in the exercise form
    List<dynamic> bodyRegionsData = []..addAll(exercisesDataBox.get('bodyRegions'));
    if(bodyRegionsData[0]['_id'] != LogicConstants.allItems) bodyRegionsData.insert(0, {'_id': LogicConstants.allItems, 'name': UIConstants.allItems});
    double horizontalMargin = 5.0;
    List<Widget> bodyRegions = [];
    for (int i = 0; i < bodyRegionsData.length; i++) {
      bodyRegions.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          // width: (MediaQuery.of(context).size.width - horizontalMargin * 5) / 2.5, // show third body region on the half so user can see that they are scrollable
          width: (MediaQuery.of(context).size.width - horizontalMargin * 7) / 3.5, // show forth body region on the half so user can see that they are scrollable
          child: ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent), // remove any shadow
              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
              side: MaterialStateProperty.all<BorderSide>(BorderSide(width: 1.0, color: bodyRegionsData[i]['_id'] == _currentTabBodyRegion ? customMaterialColor(Color(ColorConstants.BLUE))[100] : Colors.grey[400],)),
              backgroundColor: MaterialStateProperty.all<Color>(bodyRegionsData[i]['_id'] == _currentTabBodyRegion ? customMaterialColor(Color(ColorConstants.BLUE))[100] : Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                )
              )
            ),

            // style: ElevatedButton.styleFrom(
            //   side: BorderSide(width: 1.0, color: Colors.red,),
            //   shape: new RoundedRectangleBorder(
            //     borderRadius: new BorderRadius.circular(30.0),
            //   ),
            // ),

            child: Text(
              bodyRegionsData[i]['name'],
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 16)
            ),
            onPressed: () {
              setState(() {
                _currentTabBodyRegion = bodyRegionsData[i]['_id'];
              });
              
              // print(bodyRegionsData[i]['_id']);
            }
          )
        )
      );
    }

    return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 40.0,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: bodyRegions,
      )
    );

  }
}