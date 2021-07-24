import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FitLogger/views/home.dart';
import 'package:FitLogger/constants/colors.dart' as ColorConstants;
import 'package:FitLogger/helpers/custom_material_color.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:FitLogger/constants/hive_boxes_names.dart';

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

// Hive.box(userDataBoxName).clear();
// Hive.box(exercisesDataBoxName).clear();
// Hive.box(calendarDataBoxName).clear();

    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          barBackgroundColor: Colors.orange,
          primaryContrastingColor: Colors.red,
          scaffoldBackgroundColor: Colors. green,
        ),
        primarySwatch: customMaterialColor(Color(ColorConstants.GHOST_WHITE))[200],
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // textTheme: GoogleFonts.balsamiqSansTextTheme(
        //   Theme.of(context).textTheme,
        // ),
        textTheme: GoogleFonts.balsamiqSansTextTheme(textTheme).copyWith(
          // headline1: GoogleFonts.balsamiqSans(textStyle: textTheme.headline1),
          // headline2: GoogleFonts.balsamiqSans(textStyle: textTheme.headline2),
          // headline3: GoogleFonts.balsamiqSans(textStyle: textTheme.headline3),
          // headline4: GoogleFonts.balsamiqSans(textStyle: textTheme.headline4),
          // headline5: GoogleFonts.balsamiqSans(textStyle: textTheme.headline5),
          // headline6: GoogleFonts.balsamiqSans(textStyle: textTheme.headline6),
          // subtitle1: GoogleFonts.balsamiqSans(textStyle: textTheme.subtitle1),
          // subtitle2: GoogleFonts.balsamiqSans(textStyle: textTheme.subtitle2),
          // bodyText1: GoogleFonts.balsamiqSans(textStyle: textTheme.bodyText1),
          // bodyText2: GoogleFonts.balsamiqSans(textStyle: textTheme.bodyText2),
          // button: GoogleFonts.balsamiqSans(textStyle: textTheme.button),
          // caption: GoogleFonts.balsamiqSans(textStyle: textTheme.caption),
          // overline: GoogleFonts.balooThambi(textStyle: textTheme.overline),
        ),
      ),
      home: MyHomePage()
      // home: FutureBuilder<List<dynamic>>(
      //   future: Future.wait([
      //     Hive.openBox('user'),
      //     Hive.openBox('calendar'),
      //     Hive.openBox('bodyRegions'),
      //     Hive.openBox('exercises'),
      //   ]),
      //   builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      //     Widget _show;
      //     if (snapshot.hasData == true) {
      //       _show = MyHomePage();
      //     } else if (snapshot.hasError) {
      //       _show = Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Icon(
      //             Icons.error_outline,
      //             color: Colors.red,
      //             size: 60,
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.only(top: 16),
      //             child: Text('Error: ${snapshot.error}'),
      //           )
      //         ],
      //       );
      //     } else {
      //       _show = Scaffold();
      //     }
      //     return _show;
      //   },
      // )
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