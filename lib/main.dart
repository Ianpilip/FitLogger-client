import 'dart:io';

import 'package:flutter/material.dart';
import 'package:FitLogger/views/home.dart';
import 'package:FitLogger/constants/colors.dart' as ColorConstants;
import 'package:FitLogger/helpers/custom_material_color.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
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
      home: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          Hive.openBox('user'),
          Hive.openBox('calendar'),
          Hive.openBox('bodyRegions'),
          Hive.openBox('exercises'),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget _show;
          if (snapshot.hasData == true) {
            _show = MyHomePage();
          } else if (snapshot.hasError) {
            _show = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            );
          } else {
            _show = Scaffold();
          }
          return _show;
        },
      )
    );
  }
}

// Future<bool> openHiveBoxes() {
//   return Future.wait([
//     Hive.openBox('user'),
//     Hive.openBox('calendar'),
//     Hive.openBox('bodyRegions'),
//     Hive.openBox('exercises'),
//   ])
//   .then((List values) {
//       return true;
//   })
//   .catchError((error) {
//     Text(error);
//   });
// }