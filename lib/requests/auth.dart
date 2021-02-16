import 'dart:convert';
import 'package:http/http.dart';

class AuthRequests {

  Future<Map<String, dynamic>> auth(String email, String password) async{

    String url = 'http://localhost:3000/user/auth';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = jsonEncode(<String, String>{
      'email': email,
      'password': password
    });
    Response response = await post(url, headers: headers, body: json);



    Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
    // return {
    //   'validationErrors': {
    //     'email': jsonDecoded['validationErrors']['email'],
    //     'password': jsonDecoded['validationErrors']['password']
    //   },
    //   'body': jsonDecoded['body']['userTokenID']
    // };
    return jsonDecoded;
  }

}