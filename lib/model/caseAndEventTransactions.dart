import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dostapp/utils.dart';

class CaseAndEventTransactions{
  String caseOrEventId,caseOrEventTransactionId,accountHolderName,receiverName,receiverMobileNumber,transactionDate;
  String amount,isCaseOrEvent;
  DateTime createdAt;

  CaseAndEventTransactions({this.caseOrEventTransactionId,this.caseOrEventId,this.accountHolderName,this.receiverName,this.amount,this.receiverMobileNumber,this.transactionDate,this.createdAt,this.isCaseOrEvent});
  
  factory CaseAndEventTransactions.fromJson(DocumentSnapshot json)=>CaseAndEventTransactions(//Getting Data FROM Firebase
    caseOrEventTransactionId: json['caseOrEventTransactionId'],
    caseOrEventId: json['caseOrEventId'],
    accountHolderName: json['accountHolderName'],
    receiverName: json['receiverName'],
    amount: json['amount'],
    receiverMobileNumber: json['receiverMobileNumber'],
      createdAt: Utils.fromJsonToDateTime(json['createdAt']),
    transactionDate: json['transactionDate'],//Utils.fromJsonToDateTime(json['transactionDate'])
    isCaseOrEvent: json['isCaseOrEvent']
  );
  
  Map<String,dynamic> toJson()=>{//Sending Data to Firebase IN JSON Format
    "caseOrEventTransactionId":caseOrEventTransactionId,
    "caseOrEventId":caseOrEventId,
    "accountHolderName":accountHolderName,
    "receiverName":receiverName,
    "amount":amount,
    "receiverMobileNumber":receiverMobileNumber,
    "createdAt":Utils.fromDateTimeToJson(createdAt),
    "transactionDate":transactionDate,//Utils.fromDateTimeToJson(transactionDate)
    "isCaseOrEvent":isCaseOrEvent
  };
}