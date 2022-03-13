import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import "dart:ui" as ui;

class Utils{

  static const _locale = 'en';

  static Future captureActiveCases(GlobalKey key) async{
    if(key == null) return null;
    print("key= "+key.toString());
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData.buffer.asUint8List();

    return pngBytes;
  }
  static String formatNumber(String s){
    print("Before format: "+s);
    String formatted= NumberFormat.decimalPattern(_locale).format(int.parse(s));
    print("Formatted= "+formatted);
    return formatted;
  }
  

  static int unFormatNumber(String number){
    print("Before format: "+number);
    int converted = int.parse(number.replaceAll(",", ""));
    print("After format= "+converted.toString());
    return converted;
    // final format = NumberFormat("#,##0.00", "ko-KR");
    // final String str = format.format(20000);
    // print(str);
    // final num number = format.parse(str);
    // print(number);
  }

  static DateTime fromJsonToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }
  static Timestamp fromDateTimeToJson(DateTime date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
    //return date.toUtc();
  }

  /// Below function is saved for next scope
  // static String convertToThousand(String input){
  //   if(input.contains("k")||input.contains("K")){
  //     print("input BEFORE ===>"+input);
  //     input=input.substring(0,input.length-1);//4k is now 4
  //     print("input After substring ===>"+input);
  //     input=input+"000";
  //     print("input NOW ===>"+input);
  //     return input;
  //   }
  //   else return input;
  // }

  static String convertToKLM(String input){
    if(input!=null){
      if(input.length==6){

      }
    }
    return input;
  }

  static StreamTransformer transformer<T>(
      T Function(Map<String,dynamic> json) fromJson)=>
      StreamTransformer<QuerySnapshot,List<T>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<T>> sink){
          final snaps = data.docs.map((doc) => doc.data()).toList();
          final objects =snaps.map((json) => fromJson(json)).toList();
          sink.add(objects);
        },
      );
}