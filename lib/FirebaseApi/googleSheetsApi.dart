import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi{
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "dostapp",
  "private_key_id": "64e0e4d8f96a447742041836b89107ee6a063909",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDZ+kGB9LhahovQ\nn4KVG64na1ZRujbG71O/axsCs2zxp7RlWAnb2EHXW4bGo6h0LH8jerIS7eV6XhN3\nUjyBr7rwsfTKRP4lqt7edo9xI1Skv9ZtqGNsOgV7IuAjH5r4QLS2daZfK+aqzPzu\nHQk642KDkppt6VaZI+bxAWL/oLWBF8+dUTdODU6I2ST4EN85dCeFNqi3RdzhlYk6\nNTngvt6R6nGUAWSaw6WOmmyOCKeekYQmhgV9XiJ+S31uv7p0Nkk+5WA/qZIIxyM8\nv9GEK9im5ecG0sJs2ZuiUcqXk06VihjyzVgEw4Ztzpip4Q5glyp4F9hLRX9hyQ5P\n9wP8oSVFAgMBAAECggEACYuNunjyvmAS7PVMh2auvHd/pao1A4bFEOZJ81cpEkye\nN9aK7qTB1AI5h3xGKvmB2GtjMzSrWQLtRksvGXIOX8ON18en+2fymiTwnhXb0IUS\ns5BCnkwiI6TA0jjsP9URihs3yFtzSTpwaaWS2xB2/BJQ5Iw/EwtWmGok9tMHmln8\nYxdSwNRQ2NmDxOqdmWdBoBhAoFe0p9O+3HWP3EEyjpA7RJQch/Q3oIRP1x2T/yCf\nbaL3NKjSVp2T79RnqGk/HtFPl4HbEo0eO2AbM+Q/uBsGBPQGzyQX5zma5nqagoCs\noaYBc02yFJyq2yqwQmmjffx2QAV1AuSZQ5fHvvyhMQKBgQDuU7g20b3Iz+IW1/+B\nFh8DeSCQJ3IMaN0rYod0/dE743UMT/93ZvxNtzOWVMi8XYd1CBubIFTSm2R38RF3\nBU6hYBU8+77NUBjH52SBqx+KY62PrwEuTkFc4JcvvJU+ZNTMyFEjWHpth6joEthD\nud8FSa8fc4V7W2V57tS7hNY8fQKBgQDqJDt0tFqsBVIqjsPgwqnWVZJHErgd4fWx\nNwPHEsu5oNB82OY/riEW+/dBcC1AIMRAi1fNAvuTKp1opjF/h0Qc1y1ojFrvYkzJ\ng/rnxuZAG2YP1VqhtUiRPeorSKNu5n00xAmKU122s+sSJiw2S9wHTT95VMfJ1TaI\nVa6hPxmOaQKBgFBUs8D2jWvEdkaQ47RVCnsXNtygDxcTuYjIGzRZ4U64almOFWPf\nuKdRWvgO9+JV/DR8WSG+khiy+/hZrzNY/Jn0UvRNPpDhsJig7AWw8l6pHnVR3aoI\nAowVv5/9hqiTQA8Obhrl1c5ZbZtbzr11RzD3FyoYvCNKOTgSQm46ZiPZAoGARmRk\nN57tT6A95quLOixsERMi6hk3n0xKqF+o1BXTh9hQNeijuGtqaVWRLWxDPm9bcSgz\nWmBWMBV0w3yLjxKkqKMMdM0VnbiI62CxczM6D/Xsxj/XgpxU182sdBzffbzv0YhK\ncfrERuRqfMdbLWu7F7ripWCWvBhMz8oquTGWRlkCgYAqVwUX6IDur9gH7cKKimAh\nN2whxBhxzxgxZ1gUepC+Rt1sQgpENnmccdYq7zINY9U0SHhl1g0T73RrVmnbDmpL\nRqopROUslNK0IWumTmgHFNKjWb2S9Bp555XFLBMykqB3yhDvXNaneFwWhqgNjhG0\ny7RYsSvHLdAKsdkhKRGA5g==\n-----END PRIVATE KEY-----\n",
  "client_email": "dostapp@dostapp.iam.gserviceaccount.com",
  "client_id": "104365267960988171766",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/dostapp%40dostapp.iam.gserviceaccount.com"
}
  ''';
  static final _spreadsheetId = "19RLUu6BNVzH2mCmu7FfuylxrswGtIth3ziJGd6k4dqc";
  static final _gSheets = GSheets(_credentials);
  static Worksheet _userSheet;

  static Future init() async{
    try {
      final spreadsheet = await _gSheets.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorksheet(spreadsheet,title: "Cases");

      final firstRow = ["Case ID","Case Description","Case Representative","Start Date","Deadline","Donation Needed","Goods Needed","Type Of Payment","Donations Collected",
      "Goods Collected","Case Type","Closing Date"];
      //final firstRow = ["caseOrEventId","caseOrEventStatus","caseOrEventDescription","caseOrEventRepresentative","startDate",
        //"deadlineDate","donationNeeded","goodsNeeded","typeOfPayment","donationsCollected","goodsCollected","caseOrEventType","closingDate","isCaseOrEvent","caseOrEventAccountsToBeUsed"];
      _userSheet.values.insertRow(1, firstRow);
    }catch (e) {
     print("Init Error: $e");
    }
  }

  static Future<Worksheet> _getWorksheet(
      Spreadsheet spreadsheet,{
        @required String title
    }) async {
    try{
      return await spreadsheet.addWorksheet(title);
    }catch(e){
      return spreadsheet.worksheetByTitle(title);
    }
  }

  static Future insert(List<Map<String,dynamic>> rowList) async{
    if(_userSheet == null){
      print("_userSheet is null while inserting");
      return;
    }
    _userSheet.values.map.appendRows(rowList);
  }
}