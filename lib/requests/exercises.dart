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

}