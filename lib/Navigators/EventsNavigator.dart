import 'package:dostapp/pages/allCasesAndEvents.dart';
import 'package:flutter/material.dart';

class EventsNavigator extends StatelessWidget {
  final pages = {
    "/": () => MaterialPageRoute(
        builder: (context) => AllCasesAndEvents(nextRouteName: "CaseDetails",isCaseOrEvent: "Event",)
    ),
    // "CaseDetails": () => MaterialPageRoute(
    //     builder: (context) => CaseDetails(title: "None",nextRouteName: "PageOne",)
    // ),
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateRoute: (route) {
      return pages[route.name]();
    },
  );
}