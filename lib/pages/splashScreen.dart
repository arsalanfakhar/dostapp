import 'package:dostapp/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget
{
  _splashScreenState createState()=> _splashScreenState();
}
class _splashScreenState extends State<SplashScreen>
{
  String _email,_password;
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  Widget build(BuildContext context)
  {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("PracticeApp1"),
      //   backgroundColor: Colors.orange,
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height/10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/15,
              child: FittedBox(
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    //fontSize: 50,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/25,
              child: FittedBox(
                child: Text(
                  "Lets help our dost in need",
                  style: TextStyle(
                    //fontSize: 25,
                      color: Colors.orange,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/15,
            ),
            Container(
                child: Image.asset("assets/donate.png",width:MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height/2.8,)
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/8,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    child: Container(
                        width: MediaQuery.of(context).size.width/1.45,
                        child: Stack(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height/30,
                                child: FittedBox(
                                  child: Text(
                                    "Login",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      //fontSize: 20,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        primary: Colors.purple,
                        onPrimary: Colors.pink,
                        minimumSize: Size(MediaQuery.of(context).size.width/2,50)
                    ),
                    onPressed: () {
                      print("Pressed");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()),);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/40),
                  OutlinedButton(
                    child: Container(
                        width: MediaQuery.of(context).size.width/1.45,
                        child: Stack(
                          children: <Widget>[
                            Icon(
                              Icons.login_outlined,
                              color: Colors.purple,
                            ),
                            Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height/30,
                                child: FittedBox(
                                  child: Text(
                                    "Sign Up",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.purple
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.purple),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        onPrimary: Colors.purple,
                        minimumSize: Size(MediaQuery.of(context).size.width/2,50)
                    ),
                    onPressed: () {print('Pressed');},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}