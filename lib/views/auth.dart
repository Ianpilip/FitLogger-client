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
        padding: EdgeInsets.only(top: 100),
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
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white30),
            hintText: hint,
            // Field decoration when it is IN focus
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3)
            ),
            // Field decoration when it is NOT IN focus
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54, width: 1)
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: IconThemeData(color: Colors.white),
                child: icon,
              ),
            )
          ),
        ),
      );
    }

    Widget _button(String label, Function func) {
      return RaisedButton(
        highlightColor: Theme.of(context).primaryColor,
        color: Colors.white,
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 20)
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
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 50,
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
    }

    return Column(
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
                  child: Text('Not registered yet? Register!', style: TextStyle(fontSize: 20, color: Colors.white),),
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
                    child: Text('Already registered? Login!', style: TextStyle(fontSize: 20, color: Colors.white),),
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
    );
  }
}