import 'package:dostapp/pages/caseDetails.dart';
import 'package:dostapp/pages/allCasesAndEvents.dart';
import 'package:flutter/material.dart';

class SimpleNavigationWidget extends StatelessWidget {
  final pages = {
    "/": () => MaterialPageRoute(
      builder: (context) => PageWidget(
        title: "Page 0",
        nextRouteName: "PageOne",
      ),
    ),
    "PageOne": () => MaterialPageRoute(
      builder: (context) => PageWidget()
    ),
    "PageTwo": () => MaterialPageRoute(
      builder: (context) => PageWidget(
        title: "Page 2",
        nextRouteName: "PageThree",
      ),
    ),
    "PageThree": () => MaterialPageRoute(
      builder: (context) => PageWidget(
        title: "Page 3",
        nextRouteName: "/",
      ),
    ),
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateRoute: (route) {
      return pages[route.name]();
    },
  );
}

class PageWidget extends StatefulWidget {
  final String title;
  final String nextRouteName;

  PageWidget({this.title, this.nextRouteName});
  @override
  _PageWidgetState createState() => _PageWidgetState(title: this.title,nextRouteName: this.nextRouteName);
}

class _PageWidgetState extends State<PageWidget> {
  final String title;
  final String nextRouteName;
  _PageWidgetState({this.title, this.nextRouteName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text(title),
          onPressed: () => Navigator.of(context).pushNamed(nextRouteName),
        ),
      ),
    );
  }
}

// class PageWidget extends StatelessWidget {
//   final String title;
//   final String nextRouteName;
//
//   PageWidget({this.title, this.nextRouteName});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: Center(
//       child: TextButton(
//         child: Text(title),
//         onPressed: () => Navigator.of(context).pushNamed(nextRouteName),
//       ),
//     ),
//   );
// }