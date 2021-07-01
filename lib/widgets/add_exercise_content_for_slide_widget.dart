import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:FitLogger/constants/hive_boxes_names.dart';
import 'package:FitLogger/helpers/custom_material_color.dart';
import 'package:FitLogger/constants/colors.dart' as ColorConstants;
import 'package:FitLogger/constants/logic_settings.dart' as LogicConstants;
import 'package:FitLogger/constants/ui_settings.dart' as UIConstants;

class AddExerciseContentForSlideWidget extends StatefulWidget {

final Function addNewExerciseHandler;
final Function closeSlideWidget;
final dynamic data;

const AddExerciseContentForSlideWidget({Key key, this.addNewExerciseHandler, this.closeSlideWidget, this.data}): super(key: key);

  @override
  _AddExerciseContentForSlideWidgetState createState() => _AddExerciseContentForSlideWidgetState();
}


class _AddExerciseContentForSlideWidgetState extends State<AddExerciseContentForSlideWidget> {

  Box<dynamic> exercisesDataBox = Hive.box(exercisesDataBoxName);
  String _currentTabBodyRegion = LogicConstants.allItems;
  String _chosenExerciseID;

  @override
  Widget build(BuildContext context) {

    Container _getBodyRegionsAsTabs() {

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
          // margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 40.0,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: bodyRegions,
        )
      );

    }

    Container _getListOfExercises() {
      List<GestureDetector> exercises = [];
      // @TODO: Investigate why here comes null in two cases (splash red screen):
      // 1. When we login
      // 2. When we logout
      if(exercisesDataBox.get('exercises') != null) {
        List<dynamic> exercisesData = [];
        if(_currentTabBodyRegion == LogicConstants.allItems) {
          exercisesData = exercisesDataBox.get('exercises');
        } else {
          for(int e = 0; e < exercisesDataBox.get('exercises').length; e++) {
            if(exercisesDataBox.get('exercises')[e]['regionID'] == _currentTabBodyRegion) exercisesData.add(exercisesDataBox.get('exercises')[e]);
          }
        }
        for (int i = 0; i < exercisesData.length; i++) {
          // if(_showAllExercises == false && exercisesData[i]['showInUI'] == false) continue;
          exercises.add(

            GestureDetector(
              child: Card(
                color: exercisesData[i]['_id'] == _chosenExerciseID ? Colors.orange : Colors.white,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                ),
                borderOnForeground: true,
                elevation: 0,
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                child: ListTile(
                  // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  title: Text(exercisesData[i]['name'])
                ),
              ),
              onTap: () {
                setState(() {
                  _chosenExerciseID = exercisesData[i]['_id'];
                  Future.delayed(Duration(milliseconds: 250), () => _chosenExerciseID = '');
                });
                if(widget.data['exercises'].length > 0) {
                  dynamic existingExercise = widget.data['exercises'].firstWhere(
                    (exercise) => exercise['_id'] == exercisesData[i]['_id'],
                    orElse: () => null,
                  );
                  print(['existingExercise', existingExercise]);
                  if(existingExercise == null) widget.data['exercises'].add(exercisesData[i]);
                } else {
                  widget.data['exercises'].add(exercisesData[i]);
                }
                widget.closeSlideWidget();
                widget.addNewExerciseHandler(DateTime.now().millisecondsSinceEpoch);
              },
            )

            // GestureDetector(
            //   child: ListTile(
            //     // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            //     title: Text(exercisesData[i]['name'])
            //   ),
            //   onTap: () {
            //     widget.data['ADDED'] = exercisesData[i]['name'];
            //     widget.closeSlideWidget();
            //     widget.addNewExerciseHandler(DateTime.now().millisecondsSinceEpoch);
            //   },
            // )

          
          );
        }
      }


      // If you put a widget before the ListView, you should wrap the ListView with a MediaQuery.removePadding widget (with removeTop: true).
      // Otherwise you will have a big padding-top by default under the hood
      return Container(
        // color: Colors.green,
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: exercises,
          )
        )
      );

    }

      return Container(
        child: Column(
          children: <Widget>[
            _getBodyRegionsAsTabs(),
            SizedBox(height: 20),
            _getListOfExercises(),
          ]
        )
      );

  }
}