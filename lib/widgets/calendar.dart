import 'package:flutter/material.dart';

import 'package:FitLogger/constants/colors.dart' as ColorConstants;
import 'package:FitLogger/constants/ui_settings.dart' as UiSettings;
import 'package:FitLogger/helpers/index_walker.dart';

class Calendar {
  Map<int,Map<int,Map<int,int>>>trainings={2020:{1:{1:ColorConstants.YELLOW,3:ColorConstants.RED,5:ColorConstants.BLUE,7:ColorConstants.GREEN,9:ColorConstants.YELLOW,11:ColorConstants.RED,13:ColorConstants.BLUE,15:ColorConstants.GREEN,17:ColorConstants.YELLOW,19:ColorConstants.RED,21:ColorConstants.BLUE,23:ColorConstants.GREEN,25:ColorConstants.YELLOW,27:ColorConstants.RED,29:ColorConstants.BLUE,30:ColorConstants.GREEN},2:{2:ColorConstants.YELLOW,4:ColorConstants.RED,6:ColorConstants.BLUE,8:ColorConstants.GREEN,10:ColorConstants.YELLOW,12:ColorConstants.RED,14:ColorConstants.BLUE,16:ColorConstants.GREEN,18:ColorConstants.YELLOW,20:ColorConstants.RED,22:ColorConstants.BLUE,24:ColorConstants.GREEN,26:ColorConstants.YELLOW,27:ColorConstants.RED,},3:{1:ColorConstants.YELLOW,3:ColorConstants.RED,5:ColorConstants.BLUE,7:ColorConstants.GREEN,9:ColorConstants.YELLOW,11:ColorConstants.RED,13:ColorConstants.BLUE,15:ColorConstants.GREEN,17:ColorConstants.YELLOW,19:ColorConstants.RED,21:ColorConstants.BLUE,23:ColorConstants.GREEN,25:ColorConstants.YELLOW,27:ColorConstants.RED,},4:{2:ColorConstants.YELLOW,4:ColorConstants.RED,6:ColorConstants.BLUE,8:ColorConstants.GREEN,10:ColorConstants.YELLOW,12:ColorConstants.RED,14:ColorConstants.BLUE,16:ColorConstants.GREEN,18:ColorConstants.YELLOW,20:ColorConstants.RED,22:ColorConstants.BLUE,24:ColorConstants.GREEN,26:ColorConstants.YELLOW,28:ColorConstants.RED,30:ColorConstants.BLUE,},5:{1:ColorConstants.YELLOW,3:ColorConstants.RED,5:ColorConstants.BLUE,7:ColorConstants.GREEN,9:ColorConstants.YELLOW,11:ColorConstants.RED,13:ColorConstants.BLUE,15:ColorConstants.GREEN,17:ColorConstants.YELLOW,19:ColorConstants.RED,21:ColorConstants.BLUE,23:ColorConstants.GREEN,25:ColorConstants.YELLOW,27:ColorConstants.RED,},6:{2:ColorConstants.YELLOW,4:ColorConstants.RED,6:ColorConstants.BLUE,8:ColorConstants.GREEN,10:ColorConstants.YELLOW,12:ColorConstants.RED,14:ColorConstants.BLUE,16:ColorConstants.GREEN,18:ColorConstants.YELLOW,20:ColorConstants.RED,22:ColorConstants.BLUE,24:ColorConstants.GREEN,26:ColorConstants.YELLOW,28:ColorConstants.RED,30:ColorConstants.BLUE,},7:{1:ColorConstants.YELLOW,3:ColorConstants.RED,5:ColorConstants.BLUE,7:ColorConstants.GREEN,9:ColorConstants.YELLOW,11:ColorConstants.RED,13:ColorConstants.BLUE,15:ColorConstants.GREEN,17:ColorConstants.YELLOW,19:ColorConstants.RED,21:ColorConstants.BLUE,23:ColorConstants.GREEN,25:ColorConstants.YELLOW,27:ColorConstants.RED,},8:{2:ColorConstants.YELLOW,4:ColorConstants.RED,6:ColorConstants.BLUE,8:ColorConstants.GREEN,10:ColorConstants.YELLOW,12:ColorConstants.RED,14:ColorConstants.BLUE,16:ColorConstants.GREEN,18:ColorConstants.YELLOW,20:ColorConstants.RED,22:ColorConstants.BLUE,24:ColorConstants.GREEN,26:ColorConstants.YELLOW,28:ColorConstants.RED,30:ColorConstants.BLUE,},9:{2:ColorConstants.YELLOW,4:ColorConstants.RED,6:ColorConstants.BLUE,8:ColorConstants.GREEN,10:ColorConstants.YELLOW,12:ColorConstants.RED,14:ColorConstants.BLUE,16:ColorConstants.GREEN,18:ColorConstants.YELLOW,20:ColorConstants.RED,22:ColorConstants.BLUE,24:ColorConstants.GREEN,26:ColorConstants.YELLOW,28:ColorConstants.RED,30:ColorConstants.BLUE,},10:{2:ColorConstants.YELLOW,4:ColorConstants.RED,6:ColorConstants.BLUE,8:ColorConstants.GREEN,10:ColorConstants.YELLOW,12:ColorConstants.RED,14:ColorConstants.BLUE,16:ColorConstants.GREEN,18:ColorConstants.YELLOW,20:ColorConstants.RED,22:ColorConstants.BLUE,24:ColorConstants.GREEN,26:ColorConstants.YELLOW,28:ColorConstants.RED,30:ColorConstants.BLUE,},11:{2:ColorConstants.YELLOW,4:ColorConstants.RED,6:ColorConstants.BLUE,8:ColorConstants.GREEN,10:ColorConstants.YELLOW,12:ColorConstants.RED,14:ColorConstants.BLUE,16:ColorConstants.GREEN,18:ColorConstants.YELLOW,20:ColorConstants.RED,22:ColorConstants.BLUE,24:ColorConstants.GREEN,26:ColorConstants.YELLOW,28:ColorConstants.RED,30:ColorConstants.BLUE,},12:{2:ColorConstants.YELLOW,4:ColorConstants.RED,6:ColorConstants.BLUE,8:ColorConstants.GREEN,10:ColorConstants.YELLOW,12:ColorConstants.RED,14:ColorConstants.BLUE,16:ColorConstants.GREEN,18:ColorConstants.YELLOW,20:ColorConstants.RED,22:ColorConstants.BLUE,24:ColorConstants.GREEN,26:ColorConstants.YELLOW,28:ColorConstants.RED,30:ColorConstants.BLUE,}}};
  List<String> months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  List<String> daysOfTheWeekMonday = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  List<String> daysOfTheWeekSunday = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  Map<String, String> startWeekDay = {'Sunday': 'Sunday', 'Monday': 'Monday'};

  Map<dynamic, dynamic>workouts;
  Calendar({this.workouts});

  bool checkLeapYear(int year) {
    return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
  }
  
  List<int> getMonthDaysByYear(int year) {
    // Number of days in month [JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC]
    // FEB will have 28 or 29 days depending on the current year, if it is leap
    return [31, checkLeapYear(year) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  }

  // void _showTrainingDay(int year, int month, int day) {
  //   List<int> _date = [year, month, day];
  //   print(_date);
  //   // return TrainingDay(date: _date);
  // }

  // Table buildTableCalendar(int year, int month, String startWeekDaySundayMonday) {
  Table buildTableCalendar(int year, int month, String startWeekDaySundayMonday, Function callback) {
    DateTime selectedMonth = DateTime(year, month, 1);
    int startsWithWeekday = selectedMonth.weekday;

    DateTime prevMonth = DateTime(year, month - 1, 1);
    int daysInPrevMonth = getMonthDaysByYear(prevMonth.year)[prevMonth.month - 1];
    // 2 is like a constant, because we need to distract from first day of the current month, not from the last of the prev month
    int offsetDependingOnTheWeekStart = startWeekDaySundayMonday == startWeekDay['Sunday'] ? 1 : 2; // SUNDAY/MONDAY
    int restVisibleDaysFromPrevMonth = daysInPrevMonth - (startsWithWeekday - offsetDependingOnTheWeekStart);
    
    // If we chose Sunday as a startWeekDay and the month starts from the Sunday, we need to skip filling the previous month
    // In order to skip it, we just make restVisibleDaysFromPrevMonth bigger on one
    // In such way the for loop below about filling with days from the prev month will be skipped
    if(startsWithWeekday == 7 && startWeekDaySundayMonday == startWeekDay['Sunday']) restVisibleDaysFromPrevMonth = daysInPrevMonth + 1;  // SUNDAY/MONDAY

    int _counter = 0;
    Map<int, Map<String, dynamic>> allDaysInMonthsWithSiblingsMonths = {};
    // Fill with days from the previous month
    for(int i = restVisibleDaysFromPrevMonth; i <= daysInPrevMonth; i++) {
      allDaysInMonthsWithSiblingsMonths[_counter] = {
        'value': i.toString(),
        'backgroundColor': ColorConstants.TRANSPARENT,
        'color': ColorConstants.LIGHT_GREY
      };
      _counter++;
      // allDaysInMonthsWithSiblingsMonths.add(i);
    }
// print(workouts['2020']['11']['20']['color']);
    int offsetBecauseOfThePrevMonth = _counter;
    // Fill with days from the current month
    for(int i = 1; i <= getMonthDaysByYear(year)[month - 1]; i++) {
      // print(_counter - offsetBecauseOfThePrevMonth + 1);
      allDaysInMonthsWithSiblingsMonths[_counter] = {
        'value': i.toString(),
        // 'backgroundColor': trainings[2020][month][_counter - offsetBecauseOfThePrevMonth + 1] ?? ColorConstants.LIGHT_LIGHT_GREY,
        'backgroundColor': IndexWalker(workouts)[year.toString()][month.toString()][(_counter - offsetBecauseOfThePrevMonth + 1).toString()]['color'].value ?? ColorConstants.LIGHT_LIGHT_GREY,
        'color': ColorConstants.BLACK
      };
      _counter++;
      // allDaysInMonthsWithSiblingsMonths.add(i);
    }

    int weeksInMonth = (allDaysInMonthsWithSiblingsMonths.length / 7).ceil();
    int daysFromTheNextMonth = weeksInMonth * 7 - allDaysInMonthsWithSiblingsMonths.length;

    // Fill with days from the next month
    for(int i = 1; i <= daysFromTheNextMonth; i++) {
      allDaysInMonthsWithSiblingsMonths[_counter] = {
        'value': i.toString(),
        'backgroundColor': ColorConstants.TRANSPARENT,
        'color': ColorConstants.LIGHT_GREY
      };
      _counter++;
      // allDaysInMonthsWithSiblingsMonths.add(i);
    }

    // Draw days of the week
    List<TableCell> days = [];
    List<String> daysOfTheWeek = startWeekDaySundayMonday == startWeekDay['Sunday'] ? daysOfTheWeekSunday : daysOfTheWeekMonday; // SUNDAY/MONDAY
    for(int dayOfTheWeek = 0; dayOfTheWeek < daysOfTheWeek.length; dayOfTheWeek++) {
      days.add(
        TableCell(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Center(
              child: Text(
                daysOfTheWeek[dayOfTheWeek].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey
                )
              )
            )
          )
        )
      );
    }

    List<TableRow> rows = [];
    rows.add(TableRow(children: days));

    // Draw days of the month
    for(int row = 0; row < weeksInMonth; row++) {
      List<TableCell> cells = [];
      for(int cell = 0; cell < 7; cell++) {
        GlobalKey _key = GlobalKey();
        int index = row * 7 + cell;
        int offsetFromthefirstDayOfTheCurrentMonth = index + 1 - offsetBecauseOfThePrevMonth;
        int lastClickableDay = (month == DateTime.now().month && year == DateTime.now().year) ? DateTime.now().day : getMonthDaysByYear(year)[month - 1];
        cells.add(
          TableCell(
            child: 
            (offsetFromthefirstDayOfTheCurrentMonth > 0 && offsetFromthefirstDayOfTheCurrentMonth <= lastClickableDay)
            ?
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTapCancel: () {
                callback({
                  'day': null,
                  'clicked': false
                });
              },
              onTapDown: (TapDownDetails details) {
                RenderBox renderedWidget = _key.currentContext.findRenderObject();
                Offset widgetsPosition = renderedWidget.localToGlobal(Offset.zero);
                Size widgetsSize = renderedWidget.size; // to get width use widgetsSize.width, for height use widgetsSize.heigth
                callback({
                  'day': offsetFromthefirstDayOfTheCurrentMonth,
                  'dx': widgetsPosition.dx,
                  'dy': widgetsPosition.dy,
                  'width': widgetsSize.width,
                  'height': widgetsSize.height,
                  'clicked': false
                });
                // print(widgetsPosition);
              },
              onTap: () {
                callback({
                  'day': null,
                  'clicked': true,
                  'year': year,
                  'month': month,
                  'dayOfMonth': offsetFromthefirstDayOfTheCurrentMonth
                });
                // _showTrainingDay(year, month, offsetFromthefirstDayOfTheCurrentMonth);
              },
              child: Container(
                key: _key,
                decoration: BoxDecoration(
                  color: Color(allDaysInMonthsWithSiblingsMonths[index]['backgroundColor']),
                  shape: BoxShape.circle,
                  border: (
                      DateTime.now().year == year &&
                      DateTime.now().month == month &&
                      lastClickableDay == int.parse(allDaysInMonthsWithSiblingsMonths[index]['value'])
                    ) ? Border.all(color: Colors.black) : Border.all(color: Colors.transparent)
                ),
                margin: EdgeInsets.symmetric(vertical: UiSettings.marginCellDayCalendar),
                padding: EdgeInsets.symmetric(vertical: UiSettings.paddingCellDayCalendar),
                child: Center(
                  child: Text(
                    allDaysInMonthsWithSiblingsMonths[index]['value'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(allDaysInMonthsWithSiblingsMonths[index]['color']),
                    )
                  )
                )
              )
            )
            :
            Container(
              key: _key,
              decoration: BoxDecoration(
                color: Color(allDaysInMonthsWithSiblingsMonths[index]['backgroundColor']),
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.symmetric(vertical: UiSettings.marginCellDayCalendar),
              padding: EdgeInsets.symmetric(vertical: UiSettings.paddingCellDayCalendar),
              child: Center(
                child: Text(
                  allDaysInMonthsWithSiblingsMonths[index]['value'],
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(allDaysInMonthsWithSiblingsMonths[index]['color']),
                  )
                )
              )
            )
          )
        );
      }
      rows.add(TableRow(children: cells));
    }

    Table table = Table(children: rows);
    return table;
  }

}