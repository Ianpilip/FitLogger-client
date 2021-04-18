import 'package:flutter/material.dart';

import 'package:FitLogger/constants/build_form_type_enum.dart';
import 'package:FitLogger/widgets/build_workout_form.dart';

class BuildForm {
  final BuildFormTypeEnum formType;
  final Map<String, dynamic> data;

  BuildForm({this.formType, this.data});

  build(BuildContext context) {
    if(formType == BuildFormTypeEnum.Workout) {
      return BuildWorkoutForm(data: data).build(context);
    }
  }

}