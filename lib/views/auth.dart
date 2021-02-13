import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthorizationPage extends StatefulWidget {
  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;
  bool showLogin = true;

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

    Widget _form(String label, Function func) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 50),
              child: _input(Icon(Icons.email), 'EMAIL', _emailController, false),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: _input(Icon(Icons.lock), 'PASSWORD', _passwordController, true),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: _button(label, func),
              ),
            )
          ],
        ),
      );
    }

    // Form handler
    void _authUser() {
      _email = _emailController.text;
      _password = _passwordController.text;

      _emailController.clear();
      _passwordController.clear();

      FocusScope.of(context).unfocus();
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _logo(),
          (
            showLogin
            ?
            Column(
              children: <Widget>[
                _form('LOGIN', _authUser),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    child: Text('Not registered yet? Register!', style: TextStyle(fontSize: 16, color: Colors.black87),),
                    onTap: () {
                      setState(() {
                        showLogin = false;
                      });
                    }
                  ),
                )
              ],
            )
            :
            Column(
              children: <Widget>[
                _form('REGISTER', _authUser),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                      child: Text('Already registered? Login!', style: TextStyle(fontSize: 16, color: Colors.black87),),
                      onTap: () {
                        setState(() {
                          showLogin = true;
                        });
                      }
                  ),
                )
              ],
            )
          )
        ],
      )
    );
  }
}