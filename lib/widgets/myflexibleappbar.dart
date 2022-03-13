import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MyFlexiableAppBar extends StatelessWidget {

  final double appBarHeight = 66.0;

  const MyFlexiableAppBar();

  activeStats(String activeText,String activeFigure){
    return Column(
      children: <Widget> [
        Text(
          activeText.toUpperCase(),
          style: TextStyle(
              color: Colors.purple,
              fontSize: 15,
              fontWeight: FontWeight.bold
          ),
        ),
        Text(
          activeFigure,
          style: TextStyle(
              color: Colors.purple,
              fontSize: 26,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: new Center(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(left: 20,right: 20, top: 60,bottom: 10),//temporarily top = 60. Original top = 40
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  activeStats("Active Donations", "RS. 50,000.00"),
                  Container(
                    height: 60,
                    width: 1,
                    color: Colors.purple,
                  ),
                  activeStats("Active Cases", "07"),
                ],
              ),
            ),
          ),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
            alignment: AlignmentDirectional.topStart
        ),
      ),
      // decoration: new BoxDecoration(
      //   color: Color(0xff013db7),
      // ),
    );
  }
}