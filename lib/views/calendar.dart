import 'package:flutter/material.dart';
import 'package:FitLogger/widgets/calendar.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:FitLogger/constants/ui_settings.dart' as UiSettings;
import 'package:FitLogger/constants/colors.dart' as ColorConstants;
import 'package:FitLogger/sub-views/show_calendar_dialog.dart';
import 'package:FitLogger/requests/calendar.dart';
import 'package:FitLogger/constants/hive_boxes_names.dart';

import 'package:FitLogger/constants/build_form_type_enum.dart';
import 'package:FitLogger/widgets/build_form.dart';
import 'package:FitLogger/widgets/build_workout_form.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Calendar calendar = Calendar();
  int _showYear = DateTime.now().year;
  int _showMonth = DateTime.now().month;
  bool _showAlert = false;
  String _startWeekDay = Calendar().startWeekDay['Sunday'];
  int _currentMonthFromStartOfSecondMillennium = (DateTime.now().year - 2001) * 12 + DateTime.now().month;
  Map _previewDayData = {};

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentMonthFromStartOfSecondMillennium, keepPage: false);
    _pageController.addListener(_pageViewListener);
  }

  void _pageViewListener() {
    if(_pageController.page % 1.0 == 0) {
      _changeYear((((_pageController.page.toInt() - 1) ~/ 12) + 2001));
      _changeMonth(((_pageController.page.toInt() - 1) - ((_pageController.page.toInt() - 1) ~/ 12) * 12) + 1);
    }
    // if (_pageController.position.userScrollDirection == ScrollDirection.forward && _pageController.page % 1.0 < 0.002) { // swiped to left
    //   _changeYear((((_pageController.page.toInt() - 1) ~/ 12) + 2001));
    //   _changeMonth(((_pageController.page.toInt() - 1) - ((_pageController.page.toInt() - 1) ~/ 12) * 12) + 1);
    // } else if(_pageController.position.userScrollDirection == ScrollDirection.reverse && _pageController.page % 1.0 > 0.998) { // swiped to right
    //   _changeYear((((_pageController.page.toInt() + 1 - 1) ~/ 12) + 2001));
    //   _changeMonth(((_pageController.page.toInt() + 1 - 1) - ((_pageController.page.toInt() + 1 - 1) ~/ 12) * 12) + 1);
    // }
  }

  // void _onPageChanged(int page) {
    // _changeYear((((page - 1) ~/ 12) + 2001));
    // _changeMonth(((page - 1) - ((page - 1) ~/ 12) * 12) + 1);
  // }

  void _today() {
    setState(() {
      _showYear = DateTime.now().year;
      _showMonth = DateTime.now().month;
      _pageController.jumpToPage((_showYear - 2001) * 12 + _showMonth);
    });
  }

  void _previousYear() {
    setState(() {
      _showYear -= 1;
      _pageController.jumpToPage((_showYear - 2001) * 12 + _showMonth);
    });
  }

  void _currentYear() {
    setState(() {
      _showYear = DateTime.now().year;
      if(_showMonth > DateTime.now().month) _showMonth = DateTime.now().month;
      _pageController.jumpToPage((_showYear - 2001) * 12 + _showMonth);
    });
  }

  void _nextYear() {
    setState(() {
      int ifShowYearIsBiggerThanCurrent = _showYear + 1;
      if(ifShowYearIsBiggerThanCurrent >= DateTime.now().year) {
        _showYear = DateTime.now().year;
        _showMonth = DateTime.now().month;
      } else {
        _showYear += 1;
      }
      _pageController.jumpToPage((_showYear - 2001) * 12 + _showMonth);
      
    });
  }

  void _currentMonth() {
    setState(() {
      _showMonth = DateTime.now().month;
      _pageController.jumpToPage((_showYear - 2001) * 12 + _showMonth);
    });
  }

  void _changeStartWeekDay(String value) {
    setState(() {
      _startWeekDay = value;
    });
  }

  void _changeYear(int year) {
    setState(() {
      _showYear = year;
    });
  }

  void _changeMonth(int month) {
    setState(() {
      _showMonth = month;
    });
  }

  void _changePreviewDayHint(Map<String, dynamic> previewDayData) {
    setState(() {
      _previewDayData = previewDayData;
      _showAlert = previewDayData['clicked'];
    });
  }

  void afterBuild(BuildContext context) {
    // print([_showAlert, _previewDayData]);
    if(_showAlert) {



      //////////////////////////////////////////////////////////////////////////////////////////

      /* USE FOR A WHILE MORE SIMPLE APPROACH AS OTHERS FORMS IN THIS APP */
      // @TODO: CREATE MORE APPROPRIATE WAY TO SET ALL THE STUFF BELOW (callbacks, showDialog functions etc.)
      // Use Dependency Injection
      // CalendarRequests calendarRequests = CalendarRequests(date: {
      //   'year': _previewDayData['year'],
      //   'month': _previewDayData['month'],
      //   'dayOfMonth': _previewDayData['dayOfMonth']
      // });
      // ShowCalendarDialog(calendarRequests: calendarRequests).show(context);
      // */
      
      Map<String, dynamic> data = {
        'year': _previewDayData['year'],
        'month': _previewDayData['month'],
        'day': _previewDayData['dayOfMonth'],
        'exercises': [],
        'callbackFunction': () {
          setState(() {
            print('Close day form');
            _showAlert = false;
          });
        }
      };

      // BuildForm(formType: BuildFormTypeEnum.Workout, data: data).show(context);
      // BuildForm(formType: 'workout', data: data).show(context);
      BuildWorkoutForm(data: data).build(context);

      // showGeneralDialog(
      //   barrierDismissible: true,
      //   barrierLabel: '',
      //   barrierColor: Colors.black38,
      //   transitionDuration: Duration(milliseconds: 100),
      //   pageBuilder: (ctx, anim1, anim2) => BuildWorkoutForm(data: data),
      //   transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      //       filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      //           child: FadeTransition(
      //               child: child,
      //               opacity: anim1,
      //           ),
      //       ),
      //   context: context,
      // );

      // BuildWorkoutForm(data: data);

    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////



  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
    // print(Scaffold.of(context).appBarMaxHeight); // height of the appBar
    return Container(
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Center(child: Text('$_showYear', style: TextStyle(fontSize: 20)))
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(child: Text(calendar.months[_showMonth - 1], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Center(child: Text('Today', style: TextStyle(fontSize: 16, color: Colors.grey))),
                        onTap: () {
                          _today();
                        },
                      )
                    ),
                  ],
                ),
              ),

              // Expanded(
              //   flex: 1,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: <Widget>[
              //       Expanded(
              //         flex: 1,
              //         child: Center(
              //           child: GestureDetector(
              //             child: Icon(Icons.arrow_drop_down, size: 40.0),
              //             onTap: () {
              //               _previousYear();
              //             }
              //           )
              //         ),
              //       ),
              //       Expanded(
              //         flex: 1,
              //         child: Center(child: Text('$_showYear', style: TextStyle(fontSize: 20))),
              //       ),
              //       Expanded(
              //         flex: 1,
              //         child: Center(
              //           child: GestureDetector(
              //             child: Icon(Icons.arrow_drop_up, size: 40.0),
              //             onTap: () {
              //               _nextYear();
              //             }
              //           )
              //         ),
              //       ),
              //       Expanded(
              //         flex: 4,
              //         child: GestureDetector(
              //           child: Center(child: Text('Current year', style: TextStyle(fontSize: 16, color: Colors.grey))),
              //           onTap: () {
              //             _currentYear();
              //           }
              //         )
              //       )
              //     ],
              //   ),
              // ),
              // Expanded(
              //   flex: 1,
              //   child: Row(
              //     children: <Widget>[
              //       Expanded(
              //         flex: 3,
              //         child: Center(child: Text(calendar.months[_showMonth - 1], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              //       ),
              //       Expanded(
              //         flex: 4,
              //         child: GestureDetector(
              //           child: Center(child: Text('Current month', style: TextStyle(fontSize: 16, color: Colors.grey))),
              //           onTap: () {
              //             _currentMonth();
              //           },
              //           // onHorizontalDragStart: (DragStartDetails details) {
              //           //   _changePreviewDayHint({'day': null});
              //           // }
              //         )
              //       )
              //     ],
              //   ),
              // ),
              Expanded(
                flex: 7,
                child: PageView.builder(
                  itemCount: _currentMonthFromStartOfSecondMillennium + 1, // +1 because itemCount takes integer -1 for some reason
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  // onPageChanged: _onPageChanged,
                  physics: const CustomPageViewScrollPhysics(),
                  itemBuilder: (context, index) {
                    int _year = (((index - 1) ~/ 12) + 2001);
                    int _month = ((index - 1) - ((index - 1) ~/ 12) * 12) + 1;
                    // if(_year != _showYear) _year = _showYear; // It is needed when we switch only years by arrows
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        child: 
                          ValueListenableBuilder(
                            valueListenable: Hive.box(calendarDataBoxName).listenable(),
                            builder: (BuildContext context, Box<dynamic> calendarDataBox, Widget child) {
                              return Calendar(workouts: calendarDataBox.get('workouts')).buildTableCalendar(_year, _month, _startWeekDay, _changePreviewDayHint);
                            },
                          )
                        // calendar.buildTableCalendar(_year, _month, _startWeekDay, _changePreviewDayHint)
                      )
                    );
                  },
                )
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Week starts with'),
                    Radio(
                      activeColor: Colors.black54,
                      value: calendar.startWeekDay['Sunday'],
                      groupValue: _startWeekDay,
                      autofocus: true,
                      onChanged: _changeStartWeekDay,
                    ),
                    Text(
                      calendar.startWeekDay['Sunday'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      activeColor: Colors.black54,
                      value: calendar.startWeekDay['Monday'],
                      groupValue: _startWeekDay,
                      onChanged: _changeStartWeekDay,
                    ),
                    Text(
                      calendar.startWeekDay['Monday'],
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          (_previewDayData['day'] != null)
          ?
          Positioned(
            // left: _previewDayData['dx'] - UiSettings.marginCellDayCalendar,
            left: (_previewDayData['width'] < 60) ? _previewDayData['dx'] - (60 - _previewDayData['width']) / 2 : _previewDayData['dx'] - (_previewDayData['width'] - 60) / 2,
            top: _previewDayData['dy'] - Scaffold.of(context).appBarMaxHeight - 90,
            // child: Container(
            //   width: 60,
            //   height: 80,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.red,
            //   ),
            //   child: Center(child: Text(_previewDayData['day'].toString())),
            // ),
            child: CustomPaint(
              painter: BoxShadowPainter(),
              child: ClipPath(
                child: Container(
                  width: 60,
                  height: 80,
                  color: Color(ColorConstants.SNOW),
                  child: Center(
                    child: Text(
                      _previewDayData['day'].toString(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                ),
                clipper: CustomClipPath(),
              )
            )
          )
          :
          SizedBox()
        ],
      )
    );
  }

}


class BoxShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    // here are my custom shapes
    path.moveTo(0, 40);
    path.cubicTo(-2, -2, 62, -2, 60, 40);
    path.quadraticBezierTo(55, 50, 30, 80);
    path.quadraticBezierTo(5, 50, 0, 40);
    path.close();

    canvas.drawShadow(path, Colors.black, 8.0, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class CustomClipPath extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 40);
    path.cubicTo(0, 0, 60, 0, 60, 40);
    path.quadraticBezierTo(60, 55, 30, 80);
    path.quadraticBezierTo(0, 55, 0, 40);
    path.close();

    // path.moveTo(0, 25);
    // path.arcToPoint(Offset(50, 25),radius: Radius.circular(20));
    // path.lineTo(25, 50);

    // path.moveTo(25, 0);
    // path.lineTo(0, 50);
    // path.quadraticBezierTo(25, 25, 50, 50);
    // path.lineTo(25, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    damping: 0.6,
    mass: 170.0,
    stiffness: 1.0,
  );
}

// mass: 80,
// stiffness: 100,
// damping: 1,
// https://stackoverflow.com/questions/65325496/flutter-pageview-how-to-make-faster-animations-on-swipe