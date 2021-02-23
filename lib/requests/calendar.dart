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

    // Response response = await get('http://localhost:3000/user/get-token/601fff79b2752168327800fa');
    // Response response = await post('http://localhost:3000/user/new-token/601fff79b2752168327800fa');
    // print(response.body);

    // String url = 'http://localhost:3000/user/auth';
    // Map<String, String> headers = {"Content-type": "application/json"};
    // String json = '{"email": "ianpilip@gmail.com", "password": "qweasd"}';
    // Response response = await post(url, headers: headers, body: json);
    // print(response.body);

    // String url = 'http://localhost:3000/user/send-restore-password-code';
    // Map<String, String> headers = {"Content-type": "application/json"};
    // String json = '{"email": "ianpilip@gmail.com", "password": "qweasd"}';
    // Response response = await post(url, headers: headers, body: json);
    // print(response.body);

    // return Future.delayed(Duration(milliseconds: 300), () => this.date);
    
    // Response response = await get('http://localhost:3000/exercise/get-all/602c45852d220516f33f20db/1159shx8634lxyix8do8mqs');
    
    // Working example
    // Response response = await get('http://localhost:3000/region/get-all');
    // Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    // print(jsonDecoded);

    return this.date;
  }

}