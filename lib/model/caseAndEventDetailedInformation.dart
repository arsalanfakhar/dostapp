
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CaseAndEventDetailedInformation{
  String caseOrEventId,caseOrEventStatus,caseOrEventDescription,caseOrEventRepresentative,startDate,deadlineDate,donationNeeded;
  String goodsNeeded,typeOfPayment,donationsCollected,goodsCollected,caseOrEventType,closingDate,isCaseOrEvent,caseOrEventTypeImageName,caseOrEventStatusImageName;
  List<String> caseOrEventAccountsToBeUsed;

  CaseAndEventDetailedInformation({this.caseOrEventId,this.caseOrEventStatus,this.caseOrEventAccountsToBeUsed,this.caseOrEventType, this.caseOrEventDescription,this.caseOrEventRepresentative,
    this.startDate, this.deadlineDate, this.donationNeeded,
    this.goodsNeeded, this.typeOfPayment, this.donationsCollected,
   this.goodsCollected, this.closingDate,this.isCaseOrEvent,this.caseOrEventTypeImageName,this.caseOrEventStatusImageName});

  static final Map getCaseOrEventTypeImage = {
    "Debt/Loan":"assets/debt.png",
    "Medical":"assets/medicalzakatacceptable.png",
    "Marriage":"assets/marriage.png",
    "Education":"assets/education.png",
    "Funeral":"assets/funeral.png",
    "Basic Needs":"assets/basicneeds.png",
    "Masjid":"assets/masjid.png",
    "Job":"assets/job.png",
    "Others":"assets/help.png"
  };
  static final Map<String,Color> getCaseOfEventTypeColor = {
    "Debt/Loan":Colors.yellow,
    "Medical":Colors.red,
    "Marriage":Colors.orange,
    "Education":Colors.green,
    "Funeral":Colors.blueGrey,
    "Basic Needs":Colors.deepOrange,
    "Masjid":Colors.lightBlue,
    "Job":Colors.purple,
    "Others":Colors.brown
  };

  static final Map getCaseOrEventStatusImage = {
    "In Progress":"assets/inprogress.png",
    "Completed":"assets/Completed.png",
    "Abandoned":"assets/abandon.png"
  };

  factory CaseAndEventDetailedInformation.fromJson(DocumentSnapshot json)=>CaseAndEventDetailedInformation(//Getting Data FROM Firebase
    caseOrEventId: json['caseOrEventId'],
    caseOrEventStatus: json['caseOrEventStatus'],
    caseOrEventAccountsToBeUsed:  List<String>.from(json["caseOrEventAccountsToBeUsed"].map((x) => x)),//json['caseAccountsToBeUsed'],
    caseOrEventDescription: json['caseOrEventDescription'],
    caseOrEventRepresentative: json['caseOrEventRepresentative'],
    startDate: json['startDate'],
    deadlineDate: json['deadlineDate'],
    donationNeeded: json['donationNeeded'],
    goodsNeeded: json['goodsNeeded'],
    typeOfPayment: json['typeOfPayment'],
    donationsCollected: json['donationsCollected'],
    goodsCollected: json['goodsCollected'],
    caseOrEventType: json['caseOrEventType'],
    closingDate: json['closingDate'],
    isCaseOrEvent: json['isCaseOrEvent'],
    caseOrEventTypeImageName: json['caseOrEventTypeImageName'],
    caseOrEventStatusImageName: json['caseOrEventStatusImageName']
  );

  Map<String,dynamic> toJson()=>{//Sending Data to Firebase IN JSON Format
    "caseOrEventId":caseOrEventId,
    "caseOrEventStatus":caseOrEventStatus,
    "caseOrEventAccountsToBeUsed":caseOrEventAccountsToBeUsed,
    "caseOrEventDescription":caseOrEventDescription,
    "caseOrEventRepresentative":caseOrEventRepresentative,
    "startDate":startDate,
    "deadlineDate":deadlineDate,
    "donationNeeded":donationNeeded,
    "goodsNeeded":goodsNeeded,
    "typeOfPayment":typeOfPayment,
    "donationsCollected":donationsCollected,
    "goodsCollected":goodsCollected,
    "caseOrEventType":caseOrEventType,
    "closingDate":closingDate,
    "isCaseOrEvent":isCaseOrEvent,
    "caseOrEventTypeImageName":caseOrEventTypeImageName,
    "caseOrEventStatusImageName":caseOrEventStatusImageName
  };
  Map<String,dynamic> toJsonForSheetsOnly()=>{
    "Case ID":caseOrEventId,
    "Case Description":caseOrEventDescription,
    "Case Representative":caseOrEventRepresentative,
    "Start Date":startDate,
    "Deadline":deadlineDate,
    "Donation Needed":donationNeeded,
    "Goods Needed":goodsNeeded,
    "Type Of Payment":typeOfPayment,
    "Donations Collected":donationsCollected,
    "Goods Collected":goodsCollected,
    "Case Type":caseOrEventType,
    "Closing Date":closingDate,
  };
}