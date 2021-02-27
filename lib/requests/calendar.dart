import 'dart:convert';

import 'package:http/http.dart';
class CalendarRequests {
  final Map<String, int> date;

  CalendarRequests({this.date});

  Future<Map<String, int>> fetchData() async{

    // Working get all regions
    // Response response = await get('http://localhost:3000/region/get-all');
    // Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    // print(jsonDecoded);

    // Working get all exercises
    // Response response = await get('http://localhost:3000/exercise/get-all/602c45852d220516f33f20db/1159shx8634lxyix8do8mqs');
    // Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    // print(jsonDecoded);

    // Working get all workout days
    // Response response = await get('http://localhost:3000/calendar/get-all/602c45852d220516f33f20db/1159shx8634lxyix8do8mqs');
    // Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    // print(jsonDecoded);

    // Working create/update exercise
    // String json = jsonEncode(<String, dynamic>{
    //   'name': 'Bicep curls with barbell',
    //   'exerciseID': '603ad849062e81496105d6dc',
    //   'regionID': '603ac277df746a381172f18f',
    //   'userID': '602c45852d220516f33f20db',
    //   'update': true
    // });
    // String url = 'http://localhost:3000/exercise/new-exercise';
    // Map<String, String> headers = {"Content-type": "application/json"};
    // Response response = await post(url, headers: headers, body: json);
    // Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    // print(jsonDecoded);

    // Working Create/Update/Delete new workout day
    // String json = jsonEncode(<String, dynamic>{
    //   'year': 2021,
    //   'month': 2,
    //   'day': 23,
    //   'userID': '602c45852d220516f33f20db',
    //   'exercises': [
    //     {
    //       'exerciseID': '60357cf0f959429284bf107b',
    //       'reps': [12, 10, 9],
    //       'weights': [80, 75, 72.5]
    //     },
    //     {
    //       'exerciseID': '60357dccf959429284bf107c',
    //       'reps': [10, 10, 6],
    //       'weights': [25, 20, 20]
    //     }
    //   ],
    //   'color': 4290833407,
    //   'comment': 'some text',
    //   'update': true
    // });
    // String url = 'http://localhost:3000/calendar/new-training-day';
    // Map<String, String> headers = {"Content-type": "application/json"};
    // Response response = await post(url, headers: headers, body: json);
    // Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    // print(jsonDecoded);

    // return Future.delayed(Duration(milliseconds: 300), () => this.date);
    return this.date;
  }

}