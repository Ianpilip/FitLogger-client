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


    // var response = await http.get('https://jsonplaceholder.typicode.com/users/7');
    // var map = json.decode(response.body) as Map;
    // print(map);

    // String url = "http://localhost:3000/get/calendar";
    // Map<String, String> data = {
    //   'apikey': '12345678901234567890'
    // };
    // var response = await http.post(url, body: data);
    // print(response);
    // return this.date;

    // http.post(url, body: data).then((response) {
    //   print("Response status: status");
    //   print("Response body: body}");
    //   return this.date;
    // });

    // Map<String, String> headers = {"Content-type": "application/json"};
    // String json = '{"title": "Hello", "body": "body text", "userId": 1}';
    // http.post(
    //   url,
    //   headers: headers,
    //   body: "smth=qwqwqw&btn="
    // );
    // return Future.delayed(Duration(milliseconds: 300), () => this.date);
    // return this.date;
  }

}