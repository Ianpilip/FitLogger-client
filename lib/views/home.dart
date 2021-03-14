import 'package:flutter/material.dart';
// import 'dart:ui';
import 'package:hive/hive.dart';
import 'dart:collection';

// import 'package:FitLogger/views/calendar.dart' as Calendar;
// import 'package:FitLogger/views/exercises.dart';
// import 'package:FitLogger/views/trainings.dart';
// import 'package:FitLogger/views/auth.dart';
// import 'package:FitLogger/sub-views/dialog.dart';
// import 'package:FitLogger/sub-views/info_auth_dialog.dart';
// import 'package:FitLogger/sub-views/show_general_dialog.dart';
import 'package:FitLogger/constants/start_page_enum.dart';
import 'package:FitLogger/requests/auth.dart';
import 'package:FitLogger/requests/exercises.dart';
import 'package:FitLogger/requests/calendar.dart';

import 'package:FitLogger/sub-views/home_page_common.dart';
import 'package:FitLogger/sub-views/home_page_auth.dart';

import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;
import 'package:FitLogger/constants/hive_boxes_names.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  Future<StartPageEnum> getUserData() async {
    print(4);
    Box<dynamic> userData = Hive.box(userDataBoxName);
    Box<dynamic> calendarData = Hive.box(calendarDataBoxName);
    Box<dynamic> exercisesData = Hive.box(exercisesDataBoxName);
    if(
      userData.get('tokenID') != null &&
      userData.get('lastUpdate') != null &&
      userData.get('userID') != null
    ) {
      print(5);
      int lastTokenUpdateInMilliseconds = DateTime.parse(userData.get('lastUpdate')).millisecondsSinceEpoch;
      int nowInMilliseconds = DateTime.now().millisecondsSinceEpoch;
      int maxPermissibleDifferenceInMilliseconds = LogicSettings.lastRefreshToken;
      int currentDifferenceInMilliseconds = (nowInMilliseconds - lastTokenUpdateInMilliseconds) - maxPermissibleDifferenceInMilliseconds;
      if(currentDifferenceInMilliseconds > 0) return StartPageEnum.Auth;
      
      // Not put it in await function, because there is no need in it
      AuthRequests authRequests = AuthRequests();
      CalendarRequests calendarRequests = CalendarRequests();
      ExercisesRequests exercisesRequests = ExercisesRequests();

      Map<String, dynamic> user = {
        'tokenID': userData.get('tokenID'),
        'lastUpdate': userData.get('lastUpdate'),
        'userID': userData.get('userID')
      };

      // This check is needed defined if we was returned here after auth page
      // To avoid infinite loop (if we'll always refresh the token),
      // we need to check if the token is older than 10 seconds
      // Why 10 seconds? It is for cases, if we'll have a delay of server response
      if(nowInMilliseconds - lastTokenUpdateInMilliseconds > 10000) {
        user = await authRequests.refreshToken(userData.get('userID'));
        user = user['body'];
        // authRequests.refreshToken(userData.get('userID')).then((res) {
          userData.putAll({
            'tokenID': user['tokenID'],
            'lastUpdate': user['lastUpdate'],
            'userID': user['userID'],
          });
        // });
      }
      

      List<Map<String, dynamic>> result = await Future.wait<Map<String, dynamic>>([
        calendarRequests.getAllWorkouts(user['userID'], user['tokenID']),
        exercisesRequests.getAllBodyRegions(),
        exercisesRequests.getAllExercises(user['userID'], user['tokenID'])
      ]);
      print(['result', result]);

      // Map<String, dynamic> calendar = await calendarRequests.getAllWorkouts(user['userID'], user['tokenID']);
      // Map<String, dynamic> bodyRegions = await exercisesRequests.getAllBodyRegions();
      // Map<String, dynamic> exercises = await exercisesRequests.getAllExercises(user['userID'], user['tokenID']);



      return StartPageEnum.Home;
    } else {
      print(6);
      return StartPageEnum.Auth;
    }
  }

  bool isInvalidBoxData(dynamic iterableboxData) {
    bool ifSomethingIsNull = false;
    void iterateUserData(value) {
      if(value == null) {
        ifSomethingIsNull = true;
      }
    }
    iterableboxData.forEach(iterateUserData);
    return ifSomethingIsNull;
  }

  @override
  Widget build(BuildContext context) {

      // final ValueNotifier<Box<dynamic>> userDataMain = ValueNotifier<Box<dynamic>>(Hive.box('user1'));
      
    // return FutureBuilder<Box<dynamic>>(
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        Hive.openBox(userDataBoxName),
        Hive.openBox(calendarDataBoxName),
        Hive.openBox(exercisesDataBoxName),
      ]),
      // future: Hive.openBox('user2'),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return ValueListenableBuilder(
            valueListenable: Hive.box(userDataBoxName).listenable(),
            builder: (BuildContext context, Box<dynamic> userDataBox, Widget child) {
              print(1);
              Box<dynamic> calendarDataBox = Hive.box(calendarDataBoxName);
              Box<dynamic> exercisesDataBox = Hive.box(exercisesDataBoxName);
              // If we have some some box empty or we have `null` as one of the value of one of the box
              print(calendarDataBox.values);
              print(userDataBox.values);
              if(
                userDataBox.values.length == 0 ||
                calendarDataBox.values.length == 0 ||
                exercisesDataBox.values.length == 0 ||
                (userDataBox.values.length > 0 && isInvalidBoxData(userDataBox.values) == true) || 
                (calendarDataBox.values.length > 0 && isInvalidBoxData(calendarDataBox.values) == true) || 
                (exercisesDataBox.values.length > 0 && isInvalidBoxData(exercisesDataBox.values) == true)
              ) {
                print(2);
                return FutureBuilder<StartPageEnum>(
                  future: getUserData(),
                  builder: (BuildContext context, AsyncSnapshot<StartPageEnum> snapshot) {
                    Widget _show;
                    if (snapshot.hasData) {
                      _show = snapshot.data == StartPageEnum.Home ? getCommonHomePage(context, _tabController) : getAuthHomePage(context);
                    } else if (snapshot.hasError) {
                      _show = Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          )
                        ],
                      );
                    } else {
                      // _show = Scaffold(backgroundColor: Colors.black);
                      _show = Scaffold(
                        body: Container(
                          child: Align(
                            child: FlutterLogo(size: 70.0),
                          ),
                        )
                      );
                    }
                    return _show;
                  },
                );            
              } else {
                print(3);
                return getCommonHomePage(context, _tabController);
              }
            },
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ],
          );
        } else {
          // return Scaffold(backgroundColor: Colors.orange);
          return Scaffold(
            body: Container(
              child: Align(
                child: FlutterLogo(size: 70.0),
              ),
            )
          );
        }
      },
    );

      // return FutureBuilder<StartPageEnum>(
      //   future: getUserData(),
      //   builder: (BuildContext context, AsyncSnapshot<StartPageEnum> snapshot) {
      //     Widget _show;
      //     if (snapshot.hasData) {
      //       print(snapshot.data);
      //       _show = snapshot.data == StartPageEnum.Home ? getCommonHomePage(context, _tabController) : getAuthHomePage(context);
      //     } else if (snapshot.hasError) {
      //       _show = Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Icon(
      //             Icons.error_outline,
      //             color: Colors.red,
      //             size: 60,
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.only(top: 16),
      //             child: Text('Error: ${snapshot.error}'),
      //           )
      //         ],
      //       );
      //     } else {
      //       _show = Scaffold(backgroundColor: Colors.black);
      //     }
      //     return _show;
      //   },
      // );

    // return getCommonHomePage(context, _tabController);
    // return getAuthHomePage(context);


    // BlurryDialog alert = getInfoAuthDialog(context);
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   // appBar: AppBar(
    //   //   title: Row(
    //   //     children: [
    //   //       SizedBox(width: 40.0,),
    //   //       Expanded(child: Center(child: Text('FitLogger', style: TextStyle(fontSize: 24)))),
    //   //       GestureDetector(
    //   //         child: Icon(Icons.info, size: 40.0, color: Colors.amber,),
    //   //         onTap: () {
    //   //           callShowGeneralDialog(context, alert);
    //   //         }
    //   //       )
    //   //     ],
    //   //   )
    //   // ),
    //   // body: AuthorizationPage(),
    //   appBar: AppBar(title: Text('FitLogger', style: TextStyle(fontSize: 24))),
    //   body: TabBarView(
    //     physics: NeverScrollableScrollPhysics(),
    //     controller: _tabController,
    //     children: <Widget>[
    //       Calendar.CalendarPage(),
    //       Exercises(),
    //       Trainings(),
    //     ],
    //   ),
    //   bottomNavigationBar: BottomAppBar(
    //     child: Container(
    //       color: Colors.white,
    //       height: 60.0,
    //       child: TabBar(
    //         // indicator: BoxDecoration(color: Colors.white),
    //         indicator: BoxDecoration(
    //           border: Border(
    //             top: BorderSide(
    //               color: Colors.grey[900],
    //               width: 2.0,
    //             ),
    //           ),
    //         ),
    //         labelColor: Colors.grey[900],
    //         unselectedLabelColor: Colors.grey[600],
    //         tabs: <Widget>[
    //           Tab(
    //             child: Container(
    //               padding: EdgeInsets.only(top: 5.0),
    //               child: Column(
    //                 children: <Widget>[
    //                   RichText(
    //                     text: TextSpan(
    //                       children: [
    //                         WidgetSpan(
    //                           child: Icon(Icons.today)
    //                         ),
    //                       ],
    //                     )
    //                   ),
    //                   Text('Calendar')
    //                 ]
    //               )
    //             )
    //           ),
    //           Tab(
    //             child: Container(
    //               padding: EdgeInsets.only(top: 5.0),
    //               child: Column(
    //                 children: <Widget>[
    //                   RichText(
    //                     text: TextSpan(
    //                       children: [
    //                         WidgetSpan(
    //                           child: Icon(Icons.fitness_center)
    //                         ),
    //                       ],
    //                     )
    //                   ),
    //                   Text('Exercises')
    //                 ]
    //               )
    //             )
    //           ),
    //           Tab(
    //             child: Container(
    //               padding: EdgeInsets.only(top: 5.0),
    //               child: Column(
    //                 children: <Widget>[
    //                   RichText(
    //                     text: TextSpan(
    //                       children: [
    //                         WidgetSpan(
    //                           child: Icon(Icons.format_list_numbered)
    //                         ),
    //                       ],
    //                     )
    //                   ),
    //                   Text('Trainings')
    //                 ]
    //               )
    //             )
    //           ),
    //         ],
    //         controller: _tabController,
    //       ),
    //     )  
    //   ),
    // );
  }
}