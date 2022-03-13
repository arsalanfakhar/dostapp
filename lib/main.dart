import 'package:dostapp/FirebaseApi/googleSheetsApi.dart';
import 'package:dostapp/pages/splashScreen.dart';
import 'package:dostapp/provider/dostProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GoogleSheetsApi.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => DostProvider(),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
  title: "DOST Foundation Management",
  theme: new ThemeData(
      brightness: Brightness.light),
  home: SplashScreen(),
  color: Colors.orange,
)
);
}