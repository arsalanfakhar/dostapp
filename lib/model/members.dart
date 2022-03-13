import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../utils.dart';

class Members{
  String memId;
  String memName;
  String memMobileNumber;
  bool donatedCurrentMonth;
  int currentMonthAmount;
  DateTime currentMonthTransactionDate;

  Members({
    this.memId,
    this.memName,
    this.memMobileNumber,
    this.donatedCurrentMonth,
    this.currentMonthAmount,
    this.currentMonthTransactionDate
});

  // static Members fromJson(Map<String,dynamic> json)=>Members(
  //   memId: json['memId'],
  //   memName: json['memName'],
  //   memMobileNumber: json['memMobileNumber'],
  //   donatedCurrentMonth: json['donatedCurrentMonth'],
  //   currentMonthAmount: json['currentMonthAmount'],
  //   currentMonthTransactionDate: Utils.fromJsonToDateTime(json['currentMonthTransactionDate']) // json['currentMonthTransactionDate']
  // );
  factory Members.fromJson(DocumentSnapshot json)=>Members(
      memId: json['memId'],
      memName: json['memName'],
      memMobileNumber: json['memMobileNumber'],
      donatedCurrentMonth: json['donatedCurrentMonth'],
      currentMonthAmount: json['currentMonthAmount'],
      currentMonthTransactionDate: Utils.fromJsonToDateTime(json['currentMonthTransactionDate']) // json['currentMonthTransactionDate']
  );

  Map<String,dynamic> toJson()=>{
    'memId': memId,
    'memName':memName,
    'memMobileNumber':memMobileNumber,
    'donatedCurrentMonth':donatedCurrentMonth,
    'currentMonthAmount':currentMonthAmount,
    'currentMonthTransactionDate': Utils.fromDateTimeToJson(currentMonthTransactionDate),
  };
}