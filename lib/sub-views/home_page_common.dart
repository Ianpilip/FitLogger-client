import 'package:flutter/material.dart';
import 'package:FitLogger/views/calendar.dart' as Calendar;
import 'package:FitLogger/views/exercises.dart';
import 'package:FitLogger/views/trainings.dart';
import 'package:hive/hive.dart';
import 'package:FitLogger/constants/hive_boxes_names.dart';

Scaffold getCommonHomePage(BuildContext context, TabController _tabController) {
  return Scaffold(
    backgroundColor: Colors.white,
    // appBar: AppBar(title: Text('FitLogger', style: TextStyle(fontSize: 24))),
    appBar: AppBar(
      title: Row(
        children: [
          SizedBox(width: 30.0,),
          Expanded(child: Center(child: Text('FitLogger', style: TextStyle(fontSize: 24)))),
          GestureDetector(
            child: Icon(Icons.logout, size: 30.0, color: Colors.black87,),
            onTap: () {
              Hive.box(userDataBoxName).clear();
              Hive.box(exercisesDataBoxName).clear();
              Hive.box(calendarDataBoxName).clear();
              // Box<dynamic> userData = Hive.box(userDataBoxName);
              // userData.putAll({
              //   'tokenID': null,
              //   'lastUpdate': null,
              //   'userID': null,
              // });
            }
          )
        ],
      )
    ),
    body: TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: <Widget>[
        Calendar.CalendarPage(),
        Exercises(),
        Trainings(),
      ],
    ),
    bottomNavigationBar: BottomAppBar(
      child: Container(
        color: Colors.white,
        height: 60.0,
        child: TabBar(
          // indicator: BoxDecoration(color: Colors.white),
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey[900],
                width: 2.0,
              ),
            ),
          ),
          labelColor: Colors.grey[900],
          unselectedLabelColor: Colors.grey[600],
          tabs: <Widget>[
            Tab(
              child: Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.today)
                          ),
                        ],
                      )
                    ),
                    Text('Workouts')
                  ]
                )
              )
            ),
            Tab(
              child: Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.fitness_center)
                          ),
                        ],
                      )
                    ),
                    Text('Exercises')
                  ]
                )
              )
            ),
            Tab(
              child: Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.show_chart)
                          ),
                        ],
                      )
                    ),
                    Text('Progress')
                  ]
                )
              )
            ),
          ],
          controller: _tabController,
        ),
      )  
    ),
  );
}