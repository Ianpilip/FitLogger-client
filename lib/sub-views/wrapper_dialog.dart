import 'dart:ui';
import 'package:flutter/material.dart';


class WrapperBlurryDialog extends StatelessWidget {

  final Widget child;

  WrapperBlurryDialog({this.child});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: this.child
    );
  }
}