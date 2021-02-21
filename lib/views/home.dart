import 'package:flutter/material.dart';
import 'package:FitLogger/views/calendar.dart' as Calendar;
import 'package:FitLogger/views/exercises.dart';
import 'package:FitLogger/views/trainings.dart';
import 'package:FitLogger/views/auth.dart';
import 'package:FitLogger/sub-views/dialog.dart';
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

    VoidCallback callbackConfirm = () => {
      Navigator.of(context).pop()
    };

    VoidCallback callbackCancel = () => {
      Navigator.of(context).pop()
    };

    BlurryDialog alert = BlurryDialog(
      title: null,
      content: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black87, fontSize: 18),
          children: <TextSpan>[
            TextSpan(text: 'If '),
            TextSpan(text: 'you are not registered yet', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ', type email and password and you will be both registered and logged in at the same time.'),
            TextSpan(text: '\n\n'),
            TextSpan(text: 'If '),
            TextSpan(text: 'you are registered, but not logged in', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ', type your email and password as usual.'),
            TextSpan(text: '\n\n'),
            TextSpan(text: 'If '),
            TextSpan(text: 'you are registered, but you lost your password', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ', type your email,'),
            TextSpan(text: ' new password', style: TextStyle(decoration: TextDecoration.underline)),
            TextSpan(text: ' and click on checkbox '),
            TextSpan(text: 'Restore password', style: TextStyle(decoration: TextDecoration.underline)),
            TextSpan(text: ' under submit button. '),
            TextSpan(text: 'Then you will have 10 minutes to follow instructions we sent you on your email.'),
          ],
        ),
      ),
      callbackConfirm: callbackConfirm,
      callbackCancel: callbackCancel,
      options: {LogicSettings.dialogCancelButton: false}
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 40.0,),
            Expanded(child: Center(child: Text('FitLogger', style: TextStyle(fontSize: 24)))),
            GestureDetector(
              child: Icon(Icons.info, size: 40.0, color: Colors.amber,),
              onTap: () {
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
              }
            )
          ],
        )
      ),
      body: AuthorizationPage(),
      // appBar: AppBar(title: Text('FitLogger', style: TextStyle(fontSize: 24))),
      // body: TabBarView(
      //   physics: NeverScrollableScrollPhysics(),
      //   controller: _tabController,
      //   children: <Widget>[
      //     Calendar.CalendarPage(),
      //     Exercises(),
      //     Trainings(),
      //   ],
      // ),
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