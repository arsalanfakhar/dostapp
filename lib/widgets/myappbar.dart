import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MyAppBar extends StatelessWidget {

  //final double barHeight = 66.0;

  const MyAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Text(
          "Home",
        ),
      ),

    ),);
  }
}