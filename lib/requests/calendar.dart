import 'dart:convert';

import 'package:http/http.dart';
class CalendarRequests {
  final Map<String, int> date;

  CalendarRequests({this.date});

  Future<Map<String, int>> fetchData() async{

    // Working example! Don't forget to launch node js process!
    // Response response = await get('http://localhost:3000/calendar/get-all/601fff79b2752168327800fa');
    // Response response = await post('http://localhost:3000/calendar/new-training-day');
    // print(response.body);

    return Future.delayed(Duration(milliseconds: 300), () => this.date);
  }

}