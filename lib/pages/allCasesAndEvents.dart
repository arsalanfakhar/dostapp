import 'dart:math';

import 'package:dostapp/pages/caseDetails.dart';
import 'package:dostapp/FirebaseApi/firebaseApi.dart';
import 'package:dostapp/model/caseAndEventDetailedInformation.dart';
import 'package:dostapp/provider/dostProvider.dart';
import 'package:dostapp/widgets/skeletonContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCasesAndEvents extends StatefulWidget {
  final String nextRouteName,isCaseOrEvent;

  AllCasesAndEvents({this.nextRouteName,this.isCaseOrEvent});
  @override
  _AllCasesAndEventsState createState() => _AllCasesAndEventsState(nextRouteName: this.nextRouteName);
}

class _AllCasesAndEventsState extends State<AllCasesAndEvents> {
  Future myFuture;
  final String nextRouteName;
  _AllCasesAndEventsState({this.nextRouteName});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture=FirebaseApi.readCaseAndEventDetailedInformation(widget.isCaseOrEvent).then((value) {
      final provider=Provider.of<DostProvider>(context,listen: false);
      widget.isCaseOrEvent=="Case"?provider.setCaseDetailedInformation(value):provider.setEventDetailedInformation(value);
      print("Value= "+value.toString());
    }).onError((error, stackTrace) => error);
  }
  myCaseAndEventItems(CaseAndEventDetailedInformation caseAndEventDetailedInformation,String caseStatusImage,String imageName, String caseOrEventId, String caseOrEventDesc, String amountRaised, String totalAmount,nextRouteName) {
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
                                      widget.isCaseOrEvent+" ID: "+ caseOrEventId,
                                      style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                caseOrEventDesc,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Case"
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: Row(
                  children: <Widget> [
                    Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: Icon(Icons.search),
                          labelText: "Search",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          hintText: "Search",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/5,
                      child: Image.asset("assets/dostlogo.png"),
                    )
                  ],
                ),
              ),
              FutureBuilder(
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
                        var allCasesOrEvents=widget.isCaseOrEvent=="Case"?provider.allCasesDetailedInformation:provider.allEventsDetailedInformation;
                        //print("inProgressCaseOrEvent= "+inProgressCaseOrEvent[0].toString());
                        //print("provider.inProgressEvents= "+provider.inProgressEvents[0].toString());
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allCasesOrEvents.length,
                          itemBuilder: (context,index){
                            //return buildSkeleton(context);
                            return myCaseAndEventItems(allCasesOrEvents[index],allCasesOrEvents[index].caseOrEventStatusImageName,allCasesOrEvents[index].caseOrEventTypeImageName, allCasesOrEvents[index].caseOrEventId, allCasesOrEvents[index].caseOrEventDescription,
                                allCasesOrEvents[index].donationsCollected, allCasesOrEvents[index].donationNeeded, nextRouteName);
                          },
                        );
                      }
                  }
                },
              ),
              // myCaseItems("assets/dostlogo.png", "0205-20k", "Sole earner, daughter is sick. In hospital, need...", 3000, 60000),
              // myCaseItems("assets/dostlogo.png", "2904-50k", "Lost job due to COVID, need to pay 3 months r...", 24000, 75000),
              // myCaseItems("assets/dostlogo.png", "0105-50k", "Sole earner, daughter is sick. In hospital, need...", 12000, 20000),
              // myCaseItems("assets/dostlogo.png", "0205-20k", "Sole earner, daughter is sick. In hospital, need...", 3000, 60000),
              // myCaseItems("assets/dostlogo.png", "2904-50k", "Lost job due to COVID, need to pay 3 months r...", 24000, 75000),
              // myCaseItems("assets/dostlogo.png", "0105-50k", "Sole earner, daughter is sick. In hospital, need...", 12000, 20000),
              // myCaseItems("assets/dostlogo.png", "0205-20k", "Sole earner, daughter is sick. In hospital, need...", 3000, 60000),
              // myCaseItems("assets/dostlogo.png", "2904-50k", "Lost job due to COVID, need to pay 3 months r...", 24000, 75000),
              // myCaseItems("assets/dostlogo.png", "0105-50k", "Sole earner, daughter is sick. In hospital, need...", 12000, 20000),
              // myCaseItems("assets/dostlogo.png", "0205-20k", "Sole earner, daughter is sick. In hospital, need...", 3000, 60000),
              // myCaseItems("assets/dostlogo.png", "2904-50k", "Lost job due to COVID, need to pay 3 months r...", 24000, 75000),
              // myCaseItems("assets/dostlogo.png", "0105-50k", "Sole earner, daughter is sick. In hospital, need...", 12000, 20000),
            ],
          ),
        ),
      ),
    );
  }
}
