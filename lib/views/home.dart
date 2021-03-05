import 'package:flutter/material.dart';
// import 'dart:ui';
import 'package:hive/hive.dart';

// import 'package:FitLogger/views/calendar.dart' as Calendar;
// import 'package:FitLogger/views/exercises.dart';
// import 'package:FitLogger/views/trainings.dart';
// import 'package:FitLogger/views/auth.dart';
// import 'package:FitLogger/sub-views/dialog.dart';
// import 'package:FitLogger/sub-views/info_auth_dialog.dart';
// import 'package:FitLogger/sub-views/show_general_dialog.dart';
import 'package:FitLogger/constants/start_page_enum.dart';
import 'package:FitLogger/requests/auth.dart';

import 'package:FitLogger/sub-views/home_page_common.dart';
import 'package:FitLogger/sub-views/home_page_auth.dart';

import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;

import 'dart:convert';
import 'package:http/http.dart';

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
      await Hive.openBox('user');
      Box<dynamic> userData = Hive.box('user');
      if(
        userData.get('tokenID') != null &&
        userData.get('lastUpdate') != null &&
        userData.get('userID') != null
      ) {
        int lastTokenUpdateInMilliseconds = DateTime.parse('2021-02-22T21:57:21.024+00:00').millisecondsSinceEpoch;
        int nowInMilliseconds = DateTime.now().millisecondsSinceEpoch;
        int maxPermissibleDifferenceInMilliseconds = LogicSettings.lastRefreshToken;
        int currentDifferenceInMilliseconds = (nowInMilliseconds - lastTokenUpdateInMilliseconds) - maxPermissibleDifferenceInMilliseconds;
        if(currentDifferenceInMilliseconds > 0) return StartPageEnum.Auth;
        
        // Not put it in await function, because there is no need in it
        AuthRequests authRequests = AuthRequests();
        authRequests.refreshToken(userData.get('userID')).then((user) {
          userData.putAll({
            'tokenID': user['tokenID'],
            'lastUpdate': user['tokenID'],
            'userID': user['userID'],
          });
        });

        return StartPageEnum.Home;
      } else {
        return StartPageEnum.Auth;
      }
  }

  @override
  Widget build(BuildContext context) {

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

    return getCommonHomePage(context, _tabController);
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