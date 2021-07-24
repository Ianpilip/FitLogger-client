import 'package:flutter/material.dart';
import 'package:FitLogger/sub-views/dialog.dart';
import 'package:FitLogger/sub-views/info_auth_dialog.dart';
import 'package:FitLogger/sub-views/show_general_dialog.dart';
import 'package:FitLogger/views/auth.dart';
import 'package:google_fonts/google_fonts.dart';

Scaffold getAuthHomePage(BuildContext context) {
  BlurryDialog alert = getInfoAuthDialog(context);
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Row(
        children: [
          SizedBox(width: 40.0,),
          Expanded(
            child: Center(
              child: Text(
                'FitLogger',
                style: GoogleFonts.balsamiqSans(
                  textStyle: TextStyle(
                    fontSize: 24.0
                  ),
                )
              )
            )
          ),
          GestureDetector(
            child: Icon(Icons.info, size: 40.0, color: Colors.amber,),
            onTap: () {
              callShowGeneralDialog(context, alert);
            }
          )
        ],
      )
    ),
    body: AuthorizationPage(),
  );
}