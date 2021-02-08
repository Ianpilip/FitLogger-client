import 'package:flutter/material.dart';
import 'package:FitLogger/views/home.dart';
import 'package:FitLogger/constants/colors.dart' as ColorConstants;
import 'package:FitLogger/helpers/custom_material_color.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: customMaterialColor(Color(ColorConstants.GHOST_WHITE))[200],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}