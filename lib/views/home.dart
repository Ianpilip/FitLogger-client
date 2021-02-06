import 'package:flutter/material.dart';
import 'package:FitLogger/views/calendar.dart' as Calendar;
import 'package:FitLogger/views/exercises.dart';
import 'package:FitLogger/views/trainings.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('FitLogger')),
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
          color: Colors.blue,
          height: 60.0,
          child: TabBar(
            indicator: BoxDecoration(color: Colors.white),
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.white,
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