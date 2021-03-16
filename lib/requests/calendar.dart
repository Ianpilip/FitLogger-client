import 'dart:convert';
import 'package:http/http.dart';
import 'package:hive/hive.dart';

import 'package:FitLogger/constants/hive_boxes_names.dart';
import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;
class CalendarRequests {
  final Map<String, int> date;
  Box<dynamic> userDataBox = Hive.box(userDataBoxName);

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

    // Working refresh user's token
    // String json = jsonEncode(<String, dynamic>{
    //   'userID': '602c45852d220516f33f20db'
    // });
    // String url = 'http://localhost:3000/user/refresh-token';
    // Map<String, String> headers = {"Content-type": "application/json"};
    // Response response = await post(url, headers: headers, body: json);
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

    // return Future.delayed(Duration(milliseconds: 600), () => this.date);
    return this.date;
  }

  Future<Map<String, dynamic>> createUpdateDeleteWorkout(
    int year,
    int month,
    int day,
    List<Map<String, dynamic>> exercises,
    int color,
    String comment,
    String action
  ) async{
    String json = jsonEncode(<String, dynamic>{
      'year': year,
      'month': month,
      'day': day,
      'userID': userDataBox.get('userID'),
      'exercises': exercises,
      'color': color,
      'comment': comment,
      'action': action
    });
    String url = 'http://localhost:3000/calendar/new-training-day';
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url, headers: headers, body: json);
    Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    return jsonDecoded;
  }

  Future<Map<String, dynamic>> getAllWorkouts(String userID, String tokenID) async{
    String url = LogicSettings.urlAddressToSendRequests + '/calendar/get-all/$userID/$tokenID';
    Response response = await get(url);
    Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    return jsonDecoded;
  }

}