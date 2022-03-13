import 'package:dostapp/pages/viewSingleTransaction.dart';
import 'package:dostapp/FirebaseApi/firebaseApi.dart';
import 'package:dostapp/provider/dostProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllTransactions extends StatefulWidget {
  final String caseId;
  ViewAllTransactions({@required this.caseId});
  @override
  _ViewAllTransactionsState createState() => _ViewAllTransactionsState();
}

class _ViewAllTransactionsState extends State<ViewAllTransactions> {
  Future myFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("started");
    print("widget.caseId= "+widget.caseId);
    myFuture=FirebaseApi.readCaseAndEventTransactions(widget.caseId,"Case").then((value) {
      final provider=Provider.of<DostProvider>(context,listen: false);
      provider.setCaseTransactions(value);
      print("Value= "+value.toString());
    }).onError((error, stackTrace) => error);
  }
  static bool _checkVisible=false;
  static int _checkCount=0;
  static final AppBar _defaultBar = AppBar(
    title: Text("View All Transactions"),
    leading: IconButton(
      icon: Icon(Icons.arrow_back,color: Colors.white,),
      //onPressed: () => ,  // And this!
    ),
    //actions: <Widget>[Icon(Icons.search), Icon(Icons.more_vert)],
    backgroundColor: Colors.pinkAccent,
  );


  static final AppBar _selectBar = AppBar(
    title: Text(_checkCount.toString()),
    leading: Icon(Icons.close),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Icon(Icons.edit),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Icon(Icons.share),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Icon(Icons.delete),
      )
    ],
    backgroundColor: Colors.deepPurple,
  );

  functions(){
    setState(() {
      _checkVisible = !_checkVisible;
      _appBar = _appBar == _defaultBar
          ? _selectBar
          : _defaultBar;
    });
  }
  AppBar _appBar = _defaultBar;
  allTransactionItems(String tDate, String tDesc, String beneficiaryName, String tAmount,String receiverName,String receiverMobileNumber,DateTime createdAt) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
        child: Container(
            height: 120,
            child: Material(
              color: Colors.white,
              elevation: 14.0,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onLongPress: (){
                  setState(() {
                    _checkVisible = !_checkVisible;
                    _appBar = _appBar == _defaultBar
                        ? _selectBar
                        : _defaultBar;
                  });
                },
                child: Container(
                  height: 120,
                    padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Visibility(
                          visible: _checkVisible,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Icon(Icons.check_circle,color: Colors.purple,size: 30),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                tDate,
                                style: TextStyle(color: Colors.grey, fontSize: 12,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  tDesc,
                                  style: TextStyle(color: Colors.black,fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  beneficiaryName,
                                  style: TextStyle(color: Colors.grey, fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Rs. "+ tAmount,
                              style: TextStyle(color: Colors.purple, fontSize: 14,fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewSingleTransaction(transactionDate: tDate,description: tDesc,accountHolderName: beneficiaryName,amount: tAmount,caseId: widget.caseId,receiverName: receiverName,receiverMobileNumber: receiverMobileNumber,createdAt: createdAt)));
                              },
                              child: Container(
                                width: 30,
                                child: Center(
                                  child: Text(
                                    "VIEW",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(88,30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)
                                ),
                                primary: Colors.purple,
                                onPrimary: Colors.pink,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                ),
              ),
            )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "CASE ID: "+widget.caseId,
                style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
            ),
            FutureBuilder(
              future: myFuture,
              builder: (context, snapshot){
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
                      final provider=Provider.of<DostProvider>(context,listen:true);
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.allCaseTransactions.length,
                        itemBuilder: (context,index){
                          return allTransactionItems(provider.allCaseTransactions[index].transactionDate, "Money Transfer - "+provider.allCaseTransactions[index].accountHolderName.split("- ").last, provider.allCaseTransactions[index].accountHolderName.split("- ").first, provider.allCaseTransactions[index].amount.toString(), provider.allCaseTransactions[index].receiverName, provider.allCaseTransactions[index].receiverMobileNumber, provider.allCaseTransactions[index].createdAt);
                        },
                      );
                    }
                }
              },
            ),
             //allTransactionItems("10-May-2021", "Money Transfer - Easypaisa", "Muhammad Sameer Amir Khan Chishti ", "6,000.00"),
            // allTransactionItems("15-May-2021", "Money Transfer - Bank Account", "Hayder Alam Chand Nawab Shaheed", "7,500.00"),
            // allTransactionItems("22-May-2021", "Money Transfer - JazzCash", "Arsalan Fakhar E Alam Ghafoor", "2,000.00"),
            // allTransactionItems("10-May-2021", "Money Transfer - Easypaisa", "Muhammad Sameer Amir Khan Chishti ", "6,000.00"),
            // allTransactionItems("15-May-2021", "Money Transfer - Bank Account", "Hayder Alam Chand Nawab Shaheed", "7,500.00"),
            // allTransactionItems("22-May-2021", "Money Transfer - JazzCash", "Arsalan Fakhar E Alam Ghafoor", "2,000.00"),
            // allTransactionItems("10-May-2021", "Money Transfer - Easypaisa", "Muhammad Sameer Amir Khan Chishti ", "6,000.00"),
            // allTransactionItems("15-May-2021", "Money Transfer - Bank Account", "Hayder Alam Chand Nawab Shaheed", "7,500.00"),
            // allTransactionItems("22-May-2021", "Money Transfer - JazzCash", "Arsalan Fakhar E Alam Ghafoor", "2,000.00"),
          ],
        ),
      ),
    );
  }
}
