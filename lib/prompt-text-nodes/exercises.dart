import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

RichText deleteExercise(Map<dynamic, dynamic>exercise) {
  return RichText(
      text: TextSpan(
        style: GoogleFonts.balsamiqSans(color: Colors.black87, fontSize: 18),
        children: <InlineSpan>[
          TextSpan(text: 'Are you sure you want to delete exercise '),
          TextSpan(text: exercise['name'], style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' forever?'),
          TextSpan(text: '\n\n'),
          TextSpan(text: 'Note, that you won\'t see it in workout day information anymore'),
          TextSpan(text: '\n\n'),
        ],
      ),
    );
}

RichText showHideExercise(Map<dynamic, dynamic>exercise) {
  return RichText(
      text: TextSpan(
        style: GoogleFonts.balsamiqSans(color: Colors.black87, fontSize: 18),
        children: <InlineSpan>[
          TextSpan(text: 'Are you sure you want to make exercise '),
          TextSpan(text: exercise['name'], style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' invisible?'),
          TextSpan(text: '\n\n'),
          TextSpan(text: 'You can still see it in '),
          TextSpan(text: 'See all exercises ', style: TextStyle(fontWeight: FontWeight.bold)),
          // WidgetSpan(child: Icon(Icons.preview)),
          TextSpan(text: ' mode'),
          TextSpan(text: '\n\n'),
        ],
      ),

    );
}