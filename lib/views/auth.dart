import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hive/hive.dart';

import 'package:FitLogger/requests/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:FitLogger/constants/hive_boxes_names.dart';
import 'package:FitLogger/sub-views/show_general_dialog.dart';
import 'package:FitLogger/sub-views/dialog.dart';
import 'package:FitLogger/constants/logic_settings.dart' as LogicSettings;

class AuthorizationPage extends StatefulWidget {
  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;

  String _emailValidationError;
  String _passwordValidationError;

  bool _restorePassword = false;

  @override
  Widget build(BuildContext context) {

    Widget _logo() {
      return Padding(
        padding: EdgeInsets.only(top: 50),
        child: Container(
          child: Align(
            child: FlutterLogo(size: 70.0),
          ),
        )
      );
    }

    // obscure param is needed to show/hide entered value (for passwords)
    Widget _input(Icon icon, String hint, TextEditingController controller, bool obscure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
            hintText: hint,
            // Field decoration when it is IN focus
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.black87, width: 2)
            ),
            // Field decoration when it is NOT IN focus
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.black54, width: 1)
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: IconThemeData(color: Colors.grey),
                child: icon,
              ),
            )
          ),
        ),
      );
    }

    Widget _button(String label, Function func) {
      return RaisedButton(
        // highlightColor: Theme.of(context).primaryColor,
        // color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 20)
        ),
        onPressed: () {
          func();
        }
      );
    }

    Widget _form(Function func) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 50),
              child: Column(
                children: <Widget>[
                  _input(Icon(Icons.email), 'EMAIL', _emailController, false),
                  _emailValidationError != null ? Text(_emailValidationError, style: TextStyle(fontSize: 16, color: Colors.red)) : Text('')
                ]
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: <Widget>[
                  _input(Icon(Icons.lock), 'PASSWORD', _passwordController, true),
                  _passwordValidationError != null ? Text(_passwordValidationError, style: TextStyle(fontSize: 16, color: Colors.red)) : Text('')
                ]
              )
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: _button('SEND', func),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Restore password'),
                  Checkbox(
                    activeColor: Colors.black54,
                    value: _restorePassword,
                    onChanged: (newValue) {
                      setState(() {
                        _restorePassword = newValue;
                      });
                    },
                  ),
                ]
              )
            ),
          ],
        ),
      );
    }

    // Form handler
    _authUser() async {
      FocusScope.of(context).unfocus(); // Hide the keyboard
      _email = _emailController.text;
      _password = _passwordController.text;

      AuthRequests authRequests = AuthRequests();

      // SHOW PROCESSING WHILE AUTH
      // BlurryDialog alert = BlurryDialog(
      //   title: '',
      //   content: SizedBox(
      //     // child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),),
      //     // child: ColorFiltered(
      //     //   colorFilter: ColorFilter.mode(Colors.red, BlendMode.modulate),
      //     //   child: CupertinoActivityIndicator(radius: 50,),
      //     // ),
      //     child: CupertinoActivityIndicator(radius: 50,),
      //     width: 60,
      //     height: 60,
      //   ),
      //   callbackConfirm: () {},
      //   callbackCancel: () {},
      //   options: {
      //     LogicSettings.dialogShowCancelButton: false,
      //     LogicSettings.dialogSaveButtonName : LogicSettings.textOK
      //   }
      // );
      // callShowGeneralDialog(context, alert, false);

      AlertDialog dialog = AlertDialog(
        elevation: 0,
        content: CupertinoActivityIndicator(radius: 50,),
        backgroundColor: Colors.transparent,
      );
      callShowDialogAuth(context, dialog, false);
      //
      
      Map<String, dynamic> response = await authRequests.auth(_email, _password, _restorePassword);
      
      // Navigator.pop(context); // HIDE PROCESSING AFTER AUTH

      setState(() {
        _emailValidationError = response['validationErrors']['email'];
        _passwordValidationError = response['validationErrors']['password'];
      });

      if(response['validationErrors'].length == 0) {
        if(response['body']['userTokenID'] != null && response['body']['userID'] != null) {
          // _emailController.clear();
          // _passwordController.clear();

          Box<dynamic> userData = Hive.box(userDataBoxName);
          // Not put it in await function, because there is no need in it
          AuthRequests authRequests = AuthRequests();
          authRequests.refreshToken(response['body']['userID']).then((user) {
            userData.putAll({
              'tokenID': user['body']['tokenID'],
              'lastUpdate': user['body']['lastUpdate'],
              'userID': user['body']['userID'],
            });
            Navigator.pop(context); // HIDE PROCESSING AFTER AUTH
            // print(['Update Hive with userTokenID!', user]);
          });
        }
        if(response['body']['text'] != null) {
          _emailController.clear();
          _passwordController.clear();
          setState(() {
            _restorePassword = false;
          });
          	
          Fluttertoast.showToast(
              msg: response['body']['text'],
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.black87
          );
          print('Check email to restore the password');
        }
      }

      
    }

    return Container(
      child: InkWell(
        onTap: () {
          // Hide keyboard and make textField unfocused after click in the area of the alert
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _logo(),
                Column(
                children: <Widget>[
                  _form(_authUser),
                  // Padding(
                  //   padding: EdgeInsets.all(10),
                  //   child: GestureDetector(
                  //     child: Text('Forgot your password? Restore!', style: TextStyle(fontSize: 16, color: Colors.black87),),
                  //     onTap: () {
                  //       print('Restore password');
                  //     }
                  //   ),
                  // )
                ],
              )
            ],
          )
        )
      )
    );
  }
}