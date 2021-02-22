import 'package:flutter/material.dart';
import 'package:FitLogger/views/calendar.dart' as Calendar;
import 'package:FitLogger/views/exercises.dart';
import 'package:FitLogger/views/trainings.dart';
import 'package:FitLogger/views/auth.dart';
import 'package:FitLogger/sub-views/dialog.dart';
import 'package:FitLogger/sub-views/info_auth_dialog.dart';
import 'package:FitLogger/sub-views/show_general_dialog.dart';
import 'dart:ui';

import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  // int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    // _tabController.addListener(() => setState(() => _currentTab = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    BlurryDialog alert = getInfoAuthDialog(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       SizedBox(width: 40.0,),
      //       Expanded(child: Center(child: Text('FitLogger', style: TextStyle(fontSize: 24)))),
      //       GestureDetector(
      //         child: Icon(Icons.info, size: 40.0, color: Colors.amber,),
      //         onTap: () {
      //           callShowGeneralDialog(context, alert);
      //         }
      //       )
      //     ],
      //   )
      // ),
      // body: AuthorizationPage(),
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
}