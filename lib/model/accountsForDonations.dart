
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountsForDonations{
  String accountHeader,accountTitle,accountNumber,iban;

  AccountsForDonations({this.accountHeader,this.accountTitle,this.accountNumber,this.iban});

  factory AccountsForDonations.fromJson(DocumentSnapshot json)=>AccountsForDonations(//Getting Data FROM Firebase
      accountNumber: json['accountNumber'],
      accountHeader: json['accountHeader'],
      accountTitle: json['accountTitle'],
      iban: json['iban'],
  );

  Map<String,dynamic> toJson()=>{//Sending Data to Firebase IN JSON Format
    "accountNumber":accountNumber,
    "accountHeader":accountHeader,
    "accountTitle":accountTitle,
    "iban":iban,
  };
}