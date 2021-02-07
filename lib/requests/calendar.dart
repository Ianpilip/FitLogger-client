import 'dart:convert';

import 'package:http/http.dart' as http;
class CalendarRequests {
  final Map<String, int> date;

  CalendarRequests({this.date});

  Future<Map<String, int>> fetchData() async{

    var response = await http.get('https://jsonplaceholder.typicode.com/users/7');
    var map = json.decode(response.body) as Map;
    print(map);

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
    return this.date;
  }

}