import 'dart:convert';
import 'package:http/http.dart';
import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;

class ExercisesRequests {

  Future<Map<String, dynamic>> getAllBodyRegions() async{
    String url = LogicSettings.urlAddressToSendRequests + '/region/get-all';
    Response response = await get(url);
    Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    return jsonDecoded;
  }

  Future<Map<String, dynamic>> getAllExercises(String userID, String tokenID) async{
    String url = LogicSettings.urlAddressToSendRequests + '/exercise/get-all/$userID/$tokenID';
    Response response = await get(url);
    Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    return jsonDecoded;
  }

  Future<Map<String, dynamic>> createUpdateDeleteExercise(
    String name,
    String exerciseID,
    String regionID,
    String userID,
    bool showInUI,
    bool delete
  ) async{
    String json = jsonEncode(<String, dynamic>{
      'name': name,
      'exerciseID': exerciseID,
      'regionID': regionID,
      'userID': userID,
      'showInUI' : showInUI,
      'delete': delete
    });
    String url = 'http://localhost:3000/exercise/create-update-delete-exercise';
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url, headers: headers, body: json);
    Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    return jsonDecoded;
  }

}