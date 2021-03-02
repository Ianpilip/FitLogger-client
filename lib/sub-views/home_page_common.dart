import 'package:flutter/material.dart';
import 'package:FitLogger/views/calendar.dart' as Calendar;
import 'package:FitLogger/views/exercises.dart';
import 'package:FitLogger/views/trainings.dart';

Scaffold getCommonHomePage(BuildContext context, TabController _tabController) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(title: Text('FitLogger', style: TextStyle(fontSize: 24))),
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
                    Text('Calendar')
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
                            child: Icon(Icons.format_list_numbered)
                          ),
                        ],
                      )
                    ),
                    Text('Trainings')
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