import 'dart:io';
import 'dart:typed_data';

import 'package:dostapp/pages/caseDetails.dart';
import 'package:dostapp/pages/selectDonation.dart';
import 'package:dostapp/FirebaseApi/firebaseApi.dart';
import 'package:dostapp/login.dart';
import 'package:dostapp/model/caseAndEventDetailedInformation.dart';
import 'package:dostapp/pages/caseDetails.dart' as cd;
import 'package:dostapp/provider/dostProvider.dart';
import 'package:dostapp/utils.dart';
import 'package:dostapp/widgets/myappbar.dart';
import 'package:dostapp/widgets/myflexibleappbar.dart';
import 'package:dostapp/widgets/skeletonContainer.dart';
import 'package:dostapp/widgets/widgetToImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


class Home extends StatefulWidget {
final String nextRouteName;

Home({this.nextRouteName});
@override
_HomeState createState() => _HomeState(nextRouteName: this.nextRouteName);
}

class _HomeState extends State<Home> {
  GlobalKey activeCasesKey;
  Uint8List activeCasesBytesImage;
final String nextRouteName;
_HomeState({this.nextRouteName});
double pageIndex = 0;
Future myFuture;
String activeCases="Loading..";

activeStats(String activeText,String activeFigure){
return Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget> [
    Text(
      activeText.toUpperCase(),
      style: TextStyle(
          color: Colors.purple,
          fontSize: 15,
          fontWeight: FontWeight.bold
      ),
    ),
    Text(
      activeFigure,
      style: TextStyle(
          color: Colors.purple,
          fontSize: 26,
          fontWeight: FontWeight.bold
      ),
    )
  ],
);
}
eventCard(int eventNumber,int daysLeft,String eventImage,String eventName,List statFigure){
return Padding(
  padding: const EdgeInsets.all(10.0),
  child: Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
    ),
    child: Column(
      children: <Widget> [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            SizedBox(
              height: MediaQuery.of(context).size.height/50,
              child: FittedBox(
                child: Text(
                  "EVENT: "+eventNumber.toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/50,
              child: FittedBox(
                child: Text(
                  daysLeft.toString()+" days left",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Container(
              child: Image.asset("assets/"+eventImage),
              width: 110,
              height: 110,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 5.0),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text(
                      eventName,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      children: <Widget> [
                        eventStats(statFigure[0].toString(),"Donors"),
                        eventStats(statFigure[1].toString(),"Raised"),
                        eventStats(statFigure[2].toString(),"Goal"),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    ),
  ),
);
}
eventStats(statFigure,statTitle){
return Padding(
  padding: const EdgeInsets.all(8.0),
  child: Column(
    children: <Widget> [
      SizedBox(
        height: MediaQuery.of(context).size.height/55,
        child: FittedBox(
          child: Text(
            statFigure,
            style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height/60,
        child: FittedBox(
          child: Text(
            statTitle.toUpperCase(),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      )
    ],
  ),
);
}
middleRow(icon,iconText,donationType){
return Column(
  children: <Widget> [
    Container(
      width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.pink,
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: IconButton(
          icon: Icon(icon),
            color: Colors.purple,
          onPressed: (){
            //Navigator.of(context).pushNamed(nextRouteName);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectDonation(donationType:donationType,caseAndEventDetailedInformation: null,)));
          },
        )
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        iconText,
        style: TextStyle(
            fontSize: 10,
            color: Colors.black
        ),
      ),
    )
  ],
);
}
myCaseItems(CaseAndEventDetailedInformation caseAndEventDetailedInformation,String caseStatusImage,String imageName, String caseId, String caseDesc, String amountRaised, String totalAmount,nextRouteName) {
return Padding(
  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
  child: InkWell(
    onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>CaseDetails(caseAndEventDetailedInformation: caseAndEventDetailedInformation,nextRouteName: "PageOne",)),),//Navigator.of(context).pushNamed(nextRouteName),
    child: Container(
        height: 100,
        child: Material(
          color: Colors.white,
          elevation: 14.0,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: Container(
                      height: 80,
                      width: 60,
                      child: Image.asset(imageName),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0,right: 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0 ,bottom: 5.0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height/50,
                                    child: FittedBox(
                                      child: Text(
                                        "CASE ID: "+ caseId,
                                        style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ),
                          Text(
                            caseDesc,//+"dwdweofheuifh wfkebefgeui efbweifbwei fkebfiwebfiw wehfbweifbbbwyfyuwbfyuwbfyuwbvf wfbgwuifbwuifb jh iefhwiufbhdwdweofheuifh wfkebefgeui efbweifbwei fkebfiwebfiw wehfbweifbbbwyfyuwbfyuwbfyuwbvf wfbgwuifbwuifb jh iefhwiufbh",
                            style: TextStyle(color: Colors.black,fontSize: 12),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    "RS."+amountRaised.toString()+" ",//+" lhkhuigbuibvujkbuigu yufyufyuf ufyuf uf ufu fyuivuiv",
                                    style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "donations raised from Rs."+totalAmount.toString(),//+".jkguifvyufguigghvyujfvyuv jftydfy76dftyf76f tyd56d56tydtydy",
                                    style: TextStyle(color: Colors.grey,fontSize: 10),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    height: 82,
                    width: 40,
                    //color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Container(
                        height: 25,
                        width: 25,
                        child: Image.asset(caseStatusImage),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
  ),
);
}
Widget buildSkeleton(BuildContext context) => Padding(
  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
  child: InkWell(
    onTap:()=> Navigator.of(context).pushNamed(nextRouteName),
    child: Container(
        height: 100,
        child: Material(
          color: Colors.white,
          elevation: 14.0,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: SkeletonContainer.square(
                      height: 80,
                      width: 60,
                      //child: Image.asset(imageName),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0,right: 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0 ,bottom: 5.0),
                            child: SkeletonContainer.square(
                              height: MediaQuery.of(context).size.height/50,
                              width: MediaQuery.of(context).size.width/1.75,
                            ),
                          ),
                          Expanded(
                            child: SkeletonContainer.square(
                              height: MediaQuery.of(context).size.height/50,
                              width: MediaQuery.of(context).size.width/1.75,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0 ,bottom: 10.0),
                            child: SkeletonContainer.square(
                              height: MediaQuery.of(context).size.height/50,
                              width: MediaQuery.of(context).size.width/1.75,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SkeletonContainer.square(
                        //alignment: Alignment.topRight,
                        height: 40,
                        width: 40,
                        //color: Colors.red,
                        //child: Padding(
                          //padding: const EdgeInsets.only(right: 12.0),
                          //child: Icon(Icons.star,color: Colors.yellow),
                        //),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
  ),
);
final double appBarHeight = 66.0;

@override
void initState() {
  // TODO: implement initState
  super.initState();
  myFuture=FirebaseApi.readCaseAndEventDetailedInformationInProgressCasesOrEvents("Case").then((value) {
    final provider=Provider.of<DostProvider>(context,listen: false);
    provider.setCaseDetailedInformationInProgressCases(value);
    setState(() {
      activeCases=value.length<10?"0"+value.length.toString():""+value.length.toString();
    });
    print("Value= "+value.toString());
  }).onError((error, stackTrace) => error);
}

Future<String> saveActiveCasesImage(Uint8List activeCasesImage) async{
  await [Permission.storage].request();

  final time = DateTime.now().toIso8601String().replaceAll(".", "-").replaceAll(":", "-");
  final activeCasesImageName = "activeCases_$time";
  final result = await ImageGallerySaver.saveImage(activeCasesImage,name: activeCasesImageName);
  return result['filePath'];
}

  Future shareImageToSocialMedia(Uint8List activeCasesImage) async{
  final directory = await getApplicationDocumentsDirectory();
  final image = File('${directory.path}/flutter.png');
  image.writeAsBytesSync(activeCasesImage);
  final text= "Auto-generated Image powered by DOST Foundation";
  await Share.shareFiles([image.path],text: text);
  }

@override
Widget build(BuildContext context) {
final double statusBarHeight = MediaQuery
    .of(context)
    .padding
    .top;
return Scaffold(
  resizeToAvoidBottomInset: false,
  // appBar: AppBar(title: Text("Dashboard", style: TextStyle(fontSize: 20))),
  // bottomNavigationBar: BottomNavigationBar(items: [
  //   BottomNavigationBarItem(
  //       icon: Icon(Icons.home),
  //       label: "Home",
  //       backgroundColor: Colors.blue),
  //   BottomNavigationBarItem(
  //       icon: Icon(Icons.perm_contact_calendar),
  //       label: "Contact Us",
  //       backgroundColor: Colors.redAccent),
  //   BottomNavigationBarItem(
  //       icon: Icon(Icons.assignment_returned),
  //       label: "Sign Out",
  //       backgroundColor: Colors.redAccent)
  // ]),
  body: CustomScrollView(
    slivers: [
      SliverAppBar(
        backgroundColor: Color.fromRGBO(246, 196, 169, 1.0),//Color(0xF6C4A9),//Color(0xE87F4700),//Color(0xff013db7),//Color(0xf6d3bf),
        title: Text(
          "Home"
        ),
        pinned: true,
        expandedHeight: 180.0,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            padding: new EdgeInsets.only(top: statusBarHeight),
            height: statusBarHeight + appBarHeight,
            child: new Center(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 20,right: 20, top: 25,bottom: 10),//temporarily top = 60. Original top = 40
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget> [
                      activeStats("Active Donations", "RS. 50,000.00"),
                      Container(
                        height: 60,
                        width: 1,
                        color: Colors.purple,
                      ),
                      activeStats("Active Cases", activeCases),
                    ],
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg.png"),
                  fit: BoxFit.cover,
                  alignment: AlignmentDirectional.topStart
              ),
            ),
            // decoration: new BoxDecoration(
            //   color: Color(0xff013db7),
            // ),
          ),
          //background: MyFlexiableAppBar(),
        ),
      ),
      // SliverAppBar(
      //   backgroundColor: Color(0xf6d3bf),//f6d3bf//0xff3a2483
      //   expandedHeight: 180,
      //   pinned: true,
      //   title: Container(
      //     height: 66.0,
      //     child: Text(
      //       "Home",
      //     ),
      //   ),
      //   flexibleSpace: FlexibleSpaceBar(
      //     background: Container(
      //       height: 66.0 +66.0,
      //       decoration: BoxDecoration(
      //         image: DecorationImage(
      //             image: AssetImage("assets/bg.png"),
      //             fit: BoxFit.fitWidth,
      //             alignment: AlignmentDirectional.topStart
      //         ),
      //       ),
      //       child: Padding(
      //         padding: EdgeInsets.only(left: 20,right: 20, top: 60,bottom: 10),//temporarily top = 60. Original top = 40
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: <Widget> [
      //             activeStats("Active Donations", "RS. 50,000.00"),
      //             Container(
      //               height: 60,
      //               width: 1,
      //               color: Colors.purple,
      //             ),
      //             activeStats("Active Cases", "07"),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      SliverToBoxAdapter(
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/bg.png"),
          //     fit: BoxFit.fitWidth,
          //     alignment: AlignmentDirectional.topStart
          //   ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Padding(
              //   padding: EdgeInsets.only(left: 20,right: 20, top: 60,bottom: 10),//temporarily top = 60. Original top = 40
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: <Widget> [
              //       activeStats("Active Donations", "RS. 50,000.00"),
              //       Container(
              //         height: 60,
              //         width: 1,
              //         color: Colors.purple,
              //       ),
              //       activeStats("Active Cases", "07"),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 20.0,left: 20.0, bottom: 12.0),
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.pink
                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    controller: PageController(viewportFraction: 1),
                    pageSnapping: true,
                    onPageChanged: (double) {
                      setState(() {
                        pageIndex = double.toDouble();
                      });
                    },
                    children: <Widget>[
                      eventCard(04, 11, "donate.png", "Ramadan Rashan", [07,11,100]),
                      eventCard(05, 30, "donate.png", "Iftar Drive", [07,11,100]),
                      eventCard(06, 180, "donate.png", "Winter Drive", [07,11,100])
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: DotsIndicator(
                  dotsCount: 3,
                  position: pageIndex,
                  decorator:
                  DotsDecorator(
                      spacing: EdgeInsets.all(2),
                      size: Size(15, 2),
                      activeSize: Size(15,2),
                      color: Colors.pink.shade300,
                      activeColor: Colors.pink.shade600,
                      shape: const Border(),
                      activeShape: const Border()
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    middleRow(Icons.event_note,"Add Cases Donation","Cases Donation"),
                    middleRow(Icons.account_circle,"Add Member Donation","Members Donation"),
                    middleRow(Icons.calendar_today_outlined,"Add Events Donation","Events Donation"),
                  ]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex:3,
                      child: Text(
                          "Active Cases",
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                    IconButton(icon: Icon(Icons.camera_alt,color: Colors.grey), onPressed: () async {
                      final activeCasesImage = await Utils.captureActiveCases(activeCasesKey);
                      if(activeCasesImage == null) return;
                      await saveActiveCasesImage(activeCasesImage).then((value) => Fluttertoast.showToast(msg: "Active Cases Image saved to gallery",backgroundColor: Colors.grey,));//share wala lazmi karna hai
                    }),
                    IconButton(icon: Icon(Icons.share,color: Colors.grey), onPressed: () async {
                      final activeCasesImage = await Utils.captureActiveCases(activeCasesKey);
                      if(activeCasesImage == null) return;
                      await shareImageToSocialMedia(activeCasesImage);
                    })
                  ],
                )
              ),
              WidgetToImage(
                builder:(key){
                  this.activeCasesKey = key;
                  return FutureBuilder(
                  future: myFuture,
                  builder: (context,snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context,index){
                            return buildSkeleton(context);
                            // return myCaseItems(/*provider.inProgressCases[index].caseType=="Debt"?*/"assets/debt.png", provider.inProgressCases[index].caseId, provider.inProgressCases[index].caseDescription,
                            //     provider.inProgressCases[index].donationsCollected, provider.inProgressCases[index].donationNeeded, nextRouteName);
                          },
                        );
                      default:
                        if(snapshot.hasError){
                          return Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height/50,
                                child: FittedBox(
                                  child: Text(
                                    snapshot.error.toString(),
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              )
                          );
                        }else{
                          final provider=Provider.of<DostProvider>(context,listen:true);
                          return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: provider.inProgressCases.length,
                            itemBuilder: (context,index){
                              //return buildSkeleton(context);
                               return myCaseItems(provider.inProgressCases[index],provider.inProgressCases[index].caseOrEventStatusImageName,/*provider.inProgressCases[index].caseType=="Debt"?*/provider.inProgressCases[index].caseOrEventTypeImageName, provider.inProgressCases[index].caseOrEventId, provider.inProgressCases[index].caseOrEventDescription,
                                   provider.inProgressCases[index].donationsCollected, provider.inProgressCases[index].donationNeeded, nextRouteName);
                            },
                          );
                        }
                    }
                  },
                );
                },
              ),

               //myCaseItems("assets/dostlogo.png", "0205-20k", "Sole earner, daughter is sick. In hospital, need...", "3000", "60000",nextRouteName),
               //myCaseItems("assets/dostlogo.png", "2904-50k", "Lost job due to COVID, need to pay 3 months r...", "24000", "75000",nextRouteName),
              // myCaseItems("assets/dostlogo.png", "0105-50k", "Sole earner, daughter is sick. In hospital, need...", 12000, 20000,nextRouteName),
              // myCaseItems("assets/dostlogo.png", "0105-50k", "Sole earner, daughter is sick. In hospital, need...", 12000, 20000,nextRouteName),
              // myCaseItems("assets/dostlogo.png", "0105-50k", "Sole earner, daughter is sick. In hospital, need...", 12000, 20000,nextRouteName),
              // myCaseItems("assets/dostlogo.png", "0105-50k", "Sole earner, daughter is sick. In hospital, need...", 12000, 20000,nextRouteName),

            ],
          ),
        ),
      ),
    ],
  ),
  /* */
);
}
}
