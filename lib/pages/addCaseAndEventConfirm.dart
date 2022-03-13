import 'package:dostapp/FirebaseApi/firebaseApi.dart';
import 'package:dostapp/FirebaseApi/googleSheetsApi.dart';
import 'package:dostapp/model/accountsForDonations.dart';
import 'package:dostapp/model/caseAndEventDetailedInformation.dart';
import 'package:dostapp/provider/dostProvider.dart';
import 'package:dostapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddCaseAndEventConfirm extends StatefulWidget {
  final String nextRouteName,caseId,caseStatus,caseDescription,caseRepresentative,startDate,deadlineDate,donationNeeded;
  final String goodsNeeded,typeOfPayment,donationsCollected,goodsCollected,caseType,closingDate,isCaseOrEvent;

  AddCaseAndEventConfirm({this.nextRouteName,@required this.caseType,@required  this.caseDescription,@required  this.caseRepresentative,
    @required  this.startDate,@required  this.deadlineDate,@required  this.donationNeeded,
    @required  this.goodsNeeded,@required  this.typeOfPayment,@required  this.donationsCollected,
    @required  this.goodsCollected,@required  this.closingDate, this.caseId, this.caseStatus,this.isCaseOrEvent});
  @override
  _AddCaseAndEventConfirmState createState() => _AddCaseAndEventConfirmState();
}

class _AddCaseAndEventConfirmState extends State<AddCaseAndEventConfirm> {
  bool firstTimeLoad;
  Future accountsFuture;
  List<AccountsForDonations> selectedAccounts=[];
  List<AccountsForDonations> unselectedAccounts=[];
  List<AccountsForDonations> easypaisaSelectedAccounts=[];
  List<AccountsForDonations> bankSelectedAccounts=[];
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstTimeLoad=true;
    //selectedAccounts.clear();
    //unselectedAccounts.clear();
    accountsFuture=FirebaseApi.readAccountsForDonations();
    accountsFuture.then((value) {
      print("init AddCaseConfirm");
      final provider=Provider.of<DostProvider>(context,listen:false);
      provider.setAccounts(value);
    }).onError((error, stackTrace) => error);
  }

  createCaseAndEvent(List<String> caseAccountsToBeUsed) async{
    final caseDetailedInformation=CaseAndEventDetailedInformation(
      caseOrEventId: widget.caseId,
      caseOrEventStatus: widget.caseStatus,
      caseOrEventDescription: widget.caseDescription,
      caseOrEventRepresentative: widget.caseRepresentative,
      caseOrEventType: widget.caseType,
      donationNeeded: widget.donationNeeded,
      donationsCollected: widget.donationsCollected,
      goodsNeeded: widget.goodsNeeded,
      goodsCollected: widget.goodsCollected,
      typeOfPayment: widget.typeOfPayment,
      startDate: widget.startDate,
      deadlineDate: widget.deadlineDate,
      closingDate: "",
      caseOrEventAccountsToBeUsed: caseAccountsToBeUsed,
      isCaseOrEvent: widget.isCaseOrEvent, //Takes first letter -> C from Case and E from Event
      caseOrEventTypeImageName: CaseAndEventDetailedInformation.getCaseOrEventTypeImage[widget.caseType],
      caseOrEventStatusImageName: CaseAndEventDetailedInformation.getCaseOrEventStatusImage[widget.caseStatus],
    );
    final provider=Provider.of<DostProvider>(context,listen: false);
    await Future.wait([
      provider.addCaseAndEventDetailedInformation(caseDetailedInformation, widget.caseId),
      GoogleSheetsApi.insert([caseDetailedInformation.toJsonForSheetsOnly()])
    ]).then((value) {
      btnController.success();
      Future.delayed(Duration(seconds: 2)).then((value) => showDialog(
          context: context,
          builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                height: 480,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(15),
                    color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 80,
                      color: CaseAndEventDetailedInformation.getCaseOfEventTypeColor[widget.caseType],
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height/40,
                                child: FittedBox(
                                    child:Text(
                                        "Share or Save the poster!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                )
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(icon: Icon(Icons.camera_alt,color: Colors.white), onPressed: () async {
                                //final activeCasesImage = await Utils.captureActiveCases(activeCasesKey);
                                //if(activeCasesImage == null) return;
                                //await saveActiveCasesImage(activeCasesImage).then((value) => Fluttertoast.showToast(msg: "Active Cases Image saved to gallery",backgroundColor: Colors.grey,));//share wala lazmi karna hai
                              }),
                              IconButton(icon: Icon(Icons.share,color: Colors.white), onPressed: () async {
                                //final activeCasesImage = await Utils.captureActiveCases(activeCasesKey);
                                //if(activeCasesImage == null) return;
                                //await shareImageToSocialMedia(activeCasesImage);
                              })
                            ],
                          ),
                        ],
                      )
                    ),
                    Container(
                        width: double.infinity,
                        height: 320,
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(15),
                            color: Colors.white
                        ),
                        //padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width/2.8,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: CaseAndEventDetailedInformation.getCaseOfEventTypeColor[widget.caseType],
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomRight: Radius.circular(20)
                                            )
                                        ),
                                        child: Center(child: Text(widget.caseId,style: TextStyle(fontSize: 15,color: Colors.black),)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5,left: 5),
                                        child: Text("Kindly mention Case ID while donating",style: TextStyle(fontSize: 8,color: Colors.black),),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right:8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: widget.typeOfPayment=="Zakaat and Sadqa NOT Acceptable, Qarz E Hasana",
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check_box,color: CaseAndEventDetailedInformation.getCaseOfEventTypeColor[widget.caseType],size:MediaQuery.of(context).size.height/55 ,),
                                              SizedBox(width:3),
                                              SizedBox(
                                                  height: MediaQuery.of(context).size.height/60,
                                                  child: FittedBox(
                                                      child: Text("Qarz E Hasana")
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(widget.typeOfPayment=="Zakaat Acceptable" || widget.typeOfPayment=="Zakaat and Sadqa Acceptable" ?
                                            Icons.check_box:Icons.clear,color: CaseAndEventDetailedInformation.getCaseOfEventTypeColor[widget.caseType],size:MediaQuery.of(context).size.height/55 ,),
                                            SizedBox(width:3),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height/60,
                                              child: FittedBox(
                                                child: Text("Zakaat Acceptable")
                                              )
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(widget.typeOfPayment=="Sadqa Acceptable" || widget.typeOfPayment=="Zakaat and Sadqa Acceptable" || widget.typeOfPayment=="Zakaat NOT Acceptable, Sadqa Acceptable"?
                                            Icons.check_box:Icons.clear,color: CaseAndEventDetailedInformation.getCaseOfEventTypeColor[widget.caseType],size:MediaQuery.of(context).size.height/55 ,),
                                            SizedBox(width:3),
                                            SizedBox(
                                                height: MediaQuery.of(context).size.height/60,
                                                child: FittedBox(
                                                    child: Text("Sadqa Acceptable")
                                                )
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                  child: Image.asset("assets/dostlogo.png",width:MediaQuery.of(context).size.width/5,)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 9.0),
                              child: Text(
                                "This is a test description which means it should be long enough to fit the text length needed to test the poster content.the text length needed to test the poster content.",
                                //overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 9.0,right: 12.0, top: 15,bottom:9.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Accounts for donations:",
                                          style: TextStyle(
                                              color: CaseAndEventDetailedInformation.getCaseOfEventTypeColor[widget.caseType],
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            "Bank Account:",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                            height: MediaQuery.of(context).size.height/10, // Change as per your requirement
                                            width: MediaQuery.of(context).size.width/1.5, // Change as per your requirement
                                            child: ListView.builder(
                                              itemCount: bankSelectedAccounts.length,//caseAccountsToBeUsed.length,
                                              itemBuilder: (context,index)=>Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "IBAN: "+bankSelectedAccounts[index].iban,
                                                        style: TextStyle(
                                                        fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                      "ACCOUNT TITLE: "+bankSelectedAccounts[index].accountTitle,
                                                        style: TextStyle(
                                                        fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            "Easypaisa Accounts:",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                            height: MediaQuery.of(context).size.height/10, // Change as per your requirement
                                            width: MediaQuery.of(context).size.width/1.5, // Change as per your requirement
                                            child: ListView.builder(
                                              //shrinkWrap: true,
                                              itemCount: easypaisaSelectedAccounts.length,//caseAccountsToBeUsed.length,
                                              itemBuilder: (context,index)=>Text(
                                                easypaisaSelectedAccounts[index].accountTitle+", "+easypaisaSelectedAccounts[index].accountNumber,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                    Container(
                                        child: Image.asset(CaseAndEventDetailedInformation.getCaseOrEventTypeImage[widget.caseType],width:MediaQuery.of(context).size.width/5,)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 15,
                                  color: Colors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 2.0),
                                              child: Icon(
                                                FontAwesomeIcons.instagram,
                                                color: Colors.white,
                                                size: 10.0,
                                                //semanticLabel: 'Text to announce in accessibility modes',
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height/60,
                                              child: FittedBox(
                                                child: Text(
                                                  "dost.foundation",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 2.0),
                                              child: Icon(
                                                FontAwesomeIcons.facebook,
                                                color: Colors.white,
                                                size: 10.0,
                                                //semanticLabel: 'Text to announce in accessibility modes',
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height/60,
                                              child: FittedBox(
                                                child: Text(
                                                  "Dost Foundation",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 2.0),
                                              child: Icon(
                                                FontAwesomeIcons.phone,
                                                color: Colors.white,
                                                size: 10.0,
                                                //semanticLabel: 'Text to announce in accessibility modes',
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height/65,
                                              child: FittedBox(
                                                child: Text(
                                                  "+92 304 9774367",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            )
                          ],
                        )
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: CaseAndEventDetailedInformation.getCaseOfEventTypeColor[widget.caseType],width: 3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();//Navigate directly to home screen
                            },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            //side: BorderSide(color: Color),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            primary: CaseAndEventDetailedInformation.getCaseOfEventTypeColor[widget.caseType],
                            onPrimary: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          )
      ));
      btnController.reset();

    }).onError((error, stackTrace) {
      btnController.error();
      Future.delayed(Duration(seconds: 2)).then((value) => btnController.reset());
    });
    // provider.addCaseAndEventDetailedInformation(caseDetailedInformation, widget.caseId)
    //     .then((value) async {
    //       await GoogleSheetsApi.insert([caseDetailedInformation.toJsonForSheetsOnly()])
    //           .then((value) {
    //         btnController.success();
    //         Future.delayed(Duration(seconds: 2)).then((value) => btnController.reset());
    //       }).onError((error, stackTrace) {
    //         btnController.error();
    //         Future.delayed(Duration(seconds: 2)).then((value) => btnController.reset());
    //       });
    // })
    //     .onError((error, stackTrace){
    //   btnController.error();
    //   Future.delayed(Duration(seconds: 2)).then((value) => btnController.reset());
    //   //Display toast
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New "+widget.isCaseOrEvent
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height/35,
                      child: FittedBox(
                        child: Text(
                            "Accounts for donations",
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Card(
                              color: Colors.purple,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height/40,
                                  child: FittedBox(
                                    child: Text(
                                        "Unselected Accounts",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Swipe right to Select >",
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FutureBuilder<List<AccountsForDonations>>(
                                future: accountsFuture,
                                builder: (context,snapshot){
                                  switch(snapshot.connectionState){
                                    case ConnectionState.waiting:
                                      return Center(child: CircularProgressIndicator());
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
                                        //final accounts=snapshot.data;
                                        print("firstTimeLoad= "+firstTimeLoad.toString());
                                        if(firstTimeLoad){
                                          final provider=Provider.of<DostProvider>(context,listen:true);
                                          //provider.setAccounts(accounts);
                                          unselectedAccounts=provider.allAccountsForDonations;
                                          // provider.allAccountsForDonations.forEach((element) {
                                          //   print("element= "+element.accountHeader);
                                          //   unselectedAccounts.add(element.accountHeader);
                                          // });
                                        }
                                        return ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: unselectedAccounts.length,
                                            itemBuilder: (context,index){
                                              return Dismissible(
                                                key: Key(unselectedAccounts[index].accountHeader),
                                                direction: DismissDirection.startToEnd,
                                                onDismissed: (direction){
                                                  setState(() {
                                                    firstTimeLoad=false;
                                                    selectedAccounts.add(unselectedAccounts[index]);
                                                    unselectedAccounts.removeAt(index);
                                                    //items.removeAt(index);
                                                  });
                                                },
                                                background: Container(
                                                  color: Colors.green,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Align(alignment:Alignment.centerLeft,child: Icon(Icons.arrow_forward,color: Colors.white,size: 30)),
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.grey,
                                                      )
                                                    )
                                                  ),
                                                  child: ListTile(
                                                    title: Text("${unselectedAccounts[index].accountHeader}"),
                                                  ),
                                                ),
                                              );
                                            }
                                        );
                                      }
                                  }
                                }
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6,),
                      Expanded(
                        child: Column(
                          children: [
                            Card(
                              color: Colors.purple,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height/40,
                                  child: FittedBox(
                                    child: Text(
                                        "Selected Accounts",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "< Swipe left to Deselect",
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: selectedAccounts.length,
                              itemBuilder:(context,index){
                                return Dismissible(
                                  key: Key(selectedAccounts[index].accountHeader),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction){
                                    setState(() {
                                      firstTimeLoad=false;
                                      unselectedAccounts.add(selectedAccounts[index]);
                                      selectedAccounts.removeAt(index);
                                      //items.removeAt(index);
                                    });
                                  },
                                  background: Container(
                                    color: Colors.red.shade700,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(alignment:Alignment.centerRight,child: Icon(Icons.arrow_back,color: Colors.white,size: 30)),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                        )
                                      )
                                    ),
                                    child: ListTile(
                                      title:Text("${selectedAccounts[index].accountHeader}"),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: RoundedLoadingButton(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              "CONFIRM",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ),
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                color: Colors.purple,
                successColor: Colors.green.shade800,
                errorColor: Colors.red,
                onPressed: () {
                  if(selectedAccounts.isEmpty || selectedAccounts.length<2){
                    final snackBar = SnackBar(content: Text("Please select at least 2 accounts",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),padding: EdgeInsets.only(left: 20.0 ,bottom: 20.0),);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    btnController.reset();
                    return;
                  }else if(!selectedAccounts.contains("Easypaisa") && !selectedAccounts.contains("Bank Account")){
                    final snackBar = SnackBar(content: Text(selectedAccounts.contains("Easypaisa").toString()+" <= Easypaisa Please select at least 1 Easypaisa account and at least one Bank Account . Bank =>",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),padding: EdgeInsets.only(left: 20.0 ,bottom: 20.0),);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    btnController.reset();
                    return;
                  }else if(selectedAccounts.length>3){
                    final snackBar = SnackBar(content: Text("You cannot select more than 3 accounts!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),padding: EdgeInsets.only(left: 20.0 ,bottom: 20.0),);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    btnController.reset();
                    return;
                  }
                  print("Pressed");
                  List<String> selectedAccountsHeader=[];
                  selectedAccounts.forEach((element) {
                    print("selectedAccountsHeader= "+element.accountHeader);
                    selectedAccountsHeader.add(element.accountHeader);
                    print("selectedAccountsHeader= "+selectedAccountsHeader.elementAt(0));
                  });
                  easypaisaSelectedAccounts=selectedAccounts.where((element) => element.accountHeader.contains("Easypaisa")).toList();
                  bankSelectedAccounts=selectedAccounts.where((element) => element.accountHeader.contains("Bank Account")).toList();
                  createCaseAndEvent(selectedAccountsHeader);
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()),);
                }, controller: btnController,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
