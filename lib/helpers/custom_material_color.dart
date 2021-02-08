/*
CREATING CUSTOM DYNAMIC MaterialColor

If you want to use custom color and return type MaterialColor, for example,
for the property `primarySwatch` of `ThemeData` class

Usage:
customMaterialColor(Color(0xFF174378))[50]
customMaterialColor(Color(0xFF174378))[200]
customMaterialColor(Color(0xFF174378))[900]
or you can use another integer for `Color` class:
customMaterialColor(Color(4290833407))[50]
customMaterialColor(Color(4290833407))[400]
customMaterialColor(Color(4290833407))[800]
*/

import 'package:flutter/material.dart';

Map<int, MaterialColor> customMaterialColor(Color customColor) {
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
  List<int> shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  Map<int, MaterialColor> customColorMap = {
    for(int i = 0; i < shades.length; i++) shades[i]: createMaterialColor(createMaterialColor(customColor)[shades[i]])
  };
  return customColorMap;
}