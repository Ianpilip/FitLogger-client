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
import 'package:FitLogger/constants/hive_box_status_enum.dart';

import 'package:FitLogger/sub-views/home_page_common.dart';
import 'package:FitLogger/sub-views/home_page_auth.dart';

// import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;

import 'dart:convert';
import 'package:http/http.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  // int _currentTab = 0;
  // HiveBoxStatusEnum userDataStatus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    // _tabController.addListener(() => setState(() => _currentTab = _tabController.index));
    // _checkIfUserDataExists();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // _checkIfUserDataExists() async{
  //   bool userDataExists = await Hive.boxExists('asd');
  //   if(userDataExists == false) {
  //     setState(() {
  //       userDataStatus = HiveBoxStatusEnum.Closed;
  //     });
  //   }
  // }

    Future<Box<dynamic>> getUserData() async {
      // Date date = new DateTime.utc('2021-02-22T21:57:21.024+00:00');
      DateTime old = DateTime.parse('2021-02-22T21:57:21.024+00:00');
      String now = DateTime.now().toIso8601String();
      print(old.compareTo(DateTime.now()));

      await Hive.openBox('user');
      Box<dynamic> userData = Hive.box('user');
      print(userData.get('token'));
      return userData;

    // String url = 'http://localhost:3000/user/auth';
    // Map<String, String> headers = {"Content-type": "application/json"};
    // String json = jsonEncode(<String, dynamic>{
    //   'email': email,
    //   'password': password,
    //   'restorePassword': restorePassword
    // });
    // Response response = await post(url, headers: headers, body: json);



    // Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    // return jsonDecoded;
  }

  @override
  Widget build(BuildContext context) {

    // BlurryDialog alert = getInfoAuthDialog(context);

      return FutureBuilder<Box<dynamic>>(
        future: getUserData(),
        builder: (BuildContext context, AsyncSnapshot<Box<dynamic>> snapshot) {
          Widget _show;
          if (snapshot.hasData) {
            _show = Scaffold(backgroundColor: Colors.orange);
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
            _show = Scaffold(backgroundColor: Colors.black);
          }
          return _show;
        },
      );

    // return getCommonHomePage(context, _tabController);
    // return getAuthHomePage(context);

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