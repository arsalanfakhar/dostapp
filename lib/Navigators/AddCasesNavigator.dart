import 'package:dostapp/pages/addCaseAndEvent.dart';
import 'package:dostapp/pages/allCasesAndEvents.dart';
import 'package:dostapp/pages/caseDetails.dart';
import 'package:flutter/material.dart';

class AddCasesNavigator extends StatelessWidget {
  final String isCaseOrEvent;
  AddCasesNavigator({this.isCaseOrEvent});
  final pages = {
    "/": () => MaterialPageRoute(
        builder: (context) => AddCaseAndEvent(nextRouteName: "AddCaseConfirm",isCaseOrEvent: "Case",)
    ),
    /*"AddCaseConfirm": () => MaterialPageRoute(
        builder: (context) => AddCaseConfirm(caseType: caseType, caseDescription: caseDescription, caseRepresentative: caseRepresentative, startDate: startDate, deadlineDate: deadlineDate, donationNeeded: donationNeeded, goodsNeeded: goodsNeeded, typeOfPayment: typeOfPayment, donationsCollected: donationsCollected, goodsCollected: goodsCollected, closingDate: closingDate)
    ),*/
    "Cases": () => MaterialPageRoute(
        builder: (context) => AllCasesAndEvents(nextRouteName: "CaseDetails",)
    ),
    "CaseDetails":()=>MaterialPageRoute(builder: (context)=>CaseDetails()),
  };
  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateRoute: (route) {
      print("route====? "+route.name);
      return pages[route.name]();
    },
  );
}