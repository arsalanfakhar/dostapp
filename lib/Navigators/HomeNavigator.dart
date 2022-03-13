import 'package:dostapp/pages/home.dart';
import 'package:flutter/material.dart';

class HomeNavigator extends StatelessWidget {
  final pages = {
    "/": () => MaterialPageRoute(
        builder: (context) => Home(nextRouteName: "CaseDetails",)
    ),
    // "CaseDetails": () => MaterialPageRoute(
    //     builder: (context) => CaseDetails(caseDetailedInformation: ,nextRouteName: "PageOne",)
    // ),
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateRoute: (route) {
      return pages[route.name]();
    },
  );
}