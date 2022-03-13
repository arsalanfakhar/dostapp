import 'package:auto_size_text/auto_size_text.dart';
import 'package:dostapp/pages/viewAllTransactions.dart';
import 'package:flutter/material.dart';

class ViewSingleTransaction extends StatefulWidget {
  //tDate,tDesc,beneficiaryName,tAmount,widget.caseId,provider.allCaseTransactions[index].receiverName,provider.allCaseTransactions[index].receiverMobileNumber,provider.allCaseTransactions[index].createdAt
  final String transactionDate,description,accountHolderName,amount,caseId,receiverName,receiverMobileNumber;
  final DateTime createdAt;
  ViewSingleTransaction({@required this.transactionDate,@required this.description,@required this.accountHolderName,@required  this.amount,@required this.caseId ,@required  this.receiverName,@required  this.receiverMobileNumber,@required  this.createdAt});
  @override
  _ViewSingleTransactionState createState() => _ViewSingleTransactionState();
}

class _ViewSingleTransactionState extends State<ViewSingleTransaction> {

  tDetails(headingText,subHeadingText){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height/45,
            //width: MediaQuery.of(context).size.width,
            child: FittedBox(
              child: Text(
                headingText,
                style: TextStyle(
                  //fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height/45,
              //width: MediaQuery.of(context).size.width,
              child: FittedBox(
                child: Text(
                  subHeadingText.toString(),
                  style: TextStyle(
                    //fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Transaction"
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height-160,//264 //160 is final so far, 136 in MOTO E4
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            /*children: [
              Text(
                "Wamiq",
              ),
              Text(
                "Wamiq",
              ),
              Text(
                "Wamiq",
              )
            ],*/
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height/45,
                      child: FittedBox(
                        child: Text(
                          "CASE ID: "+widget.caseId,
                          style: TextStyle(
                              color: Colors.grey,
                              //fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/40,
                    //width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: SizedBox(
                        child: FittedBox(
                          child: Text(
                            widget.description,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              //fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  tDetails("Account Holder", widget.accountHolderName),
                  tDetails("Amount", widget.amount),
                  tDetails("Receiver Name", widget.receiverName),
                  tDetails("Receiver Mobile Number", widget.receiverMobileNumber),
                  tDetails("Transaction Date", widget.transactionDate),
                  tDetails("Created At ", widget.createdAt),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: ElevatedButton(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: <Widget>[
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              Center(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height/40,
                                  child: FittedBox(
                                    child: Text(
                                      "EDIT",
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
                          minimumSize: Size(MediaQuery.of(context).size.width/2,40)
                      ),
                      onPressed: () {
                        print("Pressed");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllTransactions()),);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                color: Colors.purple,
                              ),
                              Center(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height/40,
                                  child: FittedBox(
                                    child: Text(
                                      "SHARE",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          //fontSize: 20,
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
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          minimumSize: Size(MediaQuery.of(context).size.width/2,40)
                      ),
                      onPressed: () {
                        print("Pressed");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllTransactions()),);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
