import 'dart:io';

import 'package:dostapp/pages/addCaseAndEventConfirm.dart';
import 'package:dostapp/pages/caseDetails.dart';
import 'package:dostapp/pages/allCasesAndEvents.dart';
import 'package:dostapp/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AddCaseAndEvent extends StatefulWidget {
  final String isCaseOrEvent;
  final String nextRouteName;

  AddCaseAndEvent({
    @required this.nextRouteName,
    @required this.isCaseOrEvent,
  });

  @override
  _AddCaseAndEventState createState() => _AddCaseAndEventState();
}

class _AddCaseAndEventState extends State<AddCaseAndEvent> {

  String snackBarMessage="";
  List<String> typeOfPayment=[
    "Zakaat Acceptable",
    "Sadqa Acceptable",
    "Zakaat and Sadqa Acceptable",
    "Zakaat and Sadqa NOT Acceptable",
    "Zakaat NOT Acceptable, Sadqa Acceptable",
    "Zakaat and Sadqa NOT Acceptable, Qarz E Hasana",
    "Others"
  ];
  List<String> caseType=[
    "Debt/Loan", "Medical", "Marriage", "Education", "Funeral", "Basic Needs", "Masjid", "Job", "Others"
  ];
  GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  TextEditingController descriptionController=new TextEditingController();
  TextEditingController representativeController=new TextEditingController();
  TextEditingController donationNeededController=new TextEditingController();
  TextEditingController goodsNeededController=new TextEditingController();
  TextEditingController donationCollectedController=new TextEditingController();
  TextEditingController goodsCollectedController=new TextEditingController();

  Map months={"1":"01", "2":"02", "3":"03", "4":"04", "5":"05","6":"06","7":"07","8":"08","9":"09","10":"10","11":"11","12":"12"};
  String newTypeOfPaymentValue,newCaseTypeValue,runtimeId="";
  bool typeOfPaymentSelected=false,caseTypeSelected=false;
  String selectedStartDate="          ";
  String selectedDeadlineDate="          ";
  @override
  void initState() {
    // TODO: implement initStatex
    super.initState();
    //newTypeOfPaymentValue=typeOfPayment[0];
    //newCaseTypeValue=caseType[0];
    donationCollectedController.text="0";
    goodsNeededController.text="-";
    goodsCollectedController.text="-";
  }
  String autoGenerateCaseId(String requiredAmount){
    print("BEFORE Required Amount= "+requiredAmount);
    //String requiredAmount=Utils.convertToThousand(requiredAmount);
    var date=DateTime.now();
    print("date.day.toString()+date.month.toString()+date.year.toString()+amount.toString()= "+date.day.toString()+months[date.month.toString()]+date.year.toString().substring(2,4)+"-"+requiredAmount);
    return date.day.toString()+months[date.month.toString()]+date.year.toString().substring(2,4)+"-"+requiredAmount;
  }

  takeCaseInfo(){
    if(_formKey.currentState.validate()){
      // Navigator.pushNamed(context, widget.nextRouteName);
      if(selectedStartDate=="          " && selectedDeadlineDate=="          "){
        final snackBar = SnackBar(content: Text("Please Select the Start and Deadline Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),padding: EdgeInsets.only(left: 20.0 ,bottom: 20.0),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else if(selectedStartDate=="          "){
        final snackBar = SnackBar(content: Text("Please Select the Start Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),padding: EdgeInsets.only(left: 20.0 ,bottom: 20.0),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else if(selectedDeadlineDate=="          "){
        final snackBar = SnackBar(content: Text("Please Select the Deadline Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),padding: EdgeInsets.only(left: 20.0 ,bottom: 20.0),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else{
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddCaseAndEventConfirm(nextRouteName: "CaseDetails",
            caseId: autoGenerateCaseId(donationNeededController.text),caseStatus: "In Progress", caseType: newCaseTypeValue,
            caseDescription: descriptionController.text, caseRepresentative: representativeController.text,
            startDate: selectedStartDate, deadlineDate: selectedDeadlineDate,
            donationNeeded: donationNeededController.text, goodsNeeded: goodsNeededController.text,
            typeOfPayment: newTypeOfPaymentValue, donationsCollected: donationCollectedController.text,
            goodsCollected: goodsCollectedController.text, closingDate: "",isCaseOrEvent: widget.isCaseOrEvent)));
      }
    }else{
      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddCaseConfirm(nextRouteName: "CaseDetails",
      //           caseId: autoGenerateCaseId(donationNeededController.text),caseStatus: "In Progress", caseType: newCaseTypeValue,
      //           caseDescription: descriptionController.text, caseRepresentative: representativeController.text,
      //           startDate: selectedStartDate, deadlineDate: selectedDeadlineDate,
      //           donationNeeded: donationNeededController.text, goodsNeeded: goodsNeededController.text,
      //           typeOfPayment: newTypeOfPaymentValue, donationsCollected: donationCollectedController.text,
      //           goodsCollected: goodsCollectedController.text, closingDate: selectedClosingDate)));
      //Navigator.pushNamed(context, widget.nextRouteName,arguments: {descriptionController.text,representativeController.text,donationNeededController.text,goodsNeededController.text,});
      print("Not Validated");
    }
  }
  showDateDialog(dateType){
    print("Selected");
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: dateType=="StartDate"?DateTime(1900, 1, 1):DateTime.now(),
              maxTime: dateType=="StartDate"?DateTime.now():DateTime(2099,12,31),
              onChanged: (date) {
                print('change $date');
              },
              onConfirm: (date) {
            setState(() {
              if(dateType=="StartDate"){
                selectedStartDate=date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString();
              }else if(dateType=="DeadlineDate"){
                selectedDeadlineDate=date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString();
              }
            });
                print('confirm $date');
              },
              currentTime: DateTime.now(),
              locale: LocaleType.en);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Add New "+widget.isCaseOrEvent
        ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/45,
                    child: FittedBox(
                      child: Text(
                        widget.isCaseOrEvent + " ID: "+DateTime.now().day.toString()+months[DateTime.now().month.toString()]+DateTime.now().year.toString().substring(2,4)+"-"+runtimeId,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height/45,
                        child: FittedBox(
                          child: Text(
                            "Status:",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Container(
                          child: Image.asset("assets/Completed.png",width:MediaQuery.of(context).size.width/12,height: MediaQuery.of(context).size.height/20,)
                      ),
                      Container(
                          child: Image.asset("assets/inprogress.png",width:MediaQuery.of(context).size.width/12,height: MediaQuery.of(context).size.height/20,)
                      ),
                      Container(
                          child: Image.asset("assets/abandon.png",width:MediaQuery.of(context).size.width/12,height: MediaQuery.of(context).size.height/20,)
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (input){
                      if(input.isEmpty){
                        return "Kindly enter the "+ widget.isCaseOrEvent + " Description";
                      }
                      return null;
                    },
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLength: 256,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: widget.isCaseOrEvent+" Description",
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey
                        )
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey
                        )
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    /*inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9kK]")),
                      FilteringTextInputFormatter.deny(RegExp("[ ]")),
                    ],*/
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      if(string.isEmpty){
                        setState(() {
                          runtimeId="";
                        });
                      }
                      string = '${Utils.formatNumber(string.replaceAll(',', ''))}';
                      donationNeededController.value = TextEditingValue(
                        text: string,
                        selection: TextSelection.collapsed(offset: string.length),
                      );
                      setState(() {
                        runtimeId=donationNeededController.value.text;
                      });
                    },
                    validator: (input){
                      if(input.isEmpty){
                        return "Kindly enter the Donation Amount";
                      }
                      return null;
                    },
                    controller: donationNeededController,
                    //keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: "Rs ",
                      labelText: "Donation Needed",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (input){
                      if(input.isEmpty){
                        return "Kindly enter the " +widget.isCaseOrEvent+ " Representative";
                      }
                      return null;
                    },
                    controller: representativeController,
                    decoration: InputDecoration(
                      labelText: widget.isCaseOrEvent + " Representative",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        )
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey
                        )
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      showDateDialog("StartDate");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 12.0,bottom: 12.0,right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height/48,
                              child: FittedBox(
                                child: Text(
                                  "Select Start Date:  ",
                                  style: TextStyle(
                                    color: Colors.black87
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height/45,
                              child: FittedBox(
                                child: Text(
                                    selectedStartDate,
                                  style: TextStyle(
                                      color: Colors.purple,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.calendar_today,color: Colors.purple,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      showDateDialog("DeadlineDate");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 12.0,bottom: 12.0,right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height/48,
                              child: FittedBox(
                                child: Text(
                                  "Select Deadline Date:  ",
                                  style: TextStyle(
                                      color: Colors.black87
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height/45,
                              child: FittedBox(
                                child: Text(
                                  selectedDeadlineDate,
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.calendar_today,color: Colors.purple,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (input){
                      if(input.isEmpty){
                        return "Kindly enter the Goods Needed. If no goods are there just enter a '-' ";
                      }
                      return null;
                    },
                    controller: goodsNeededController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                        labelText: "Goods Needed",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            )
                        ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors.grey
                            )
                        ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,//: MediaQuery.of(context).size.width*0.72,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          validator: (input){
                            if(input==null){
                              return "Please select any type of payment";
                            }
                            return null;
                          },
                          hint: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Type of Payment",
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                          value: newTypeOfPaymentValue,
                          icon: const Icon(Icons.keyboard_arrow_down,color: Colors.purple,),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black87),
                          onTap: (){
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (String value) {
                            setState(() {
                              print("new="+value);
                              newTypeOfPaymentValue = value;//">=2.7.0 <3.0.0"
                              if(value=="Type of Payment"){
                                typeOfPaymentSelected=false;
                              }else{
                                typeOfPaymentSelected=true;
                              }
                            });
                          },
                          items: typeOfPayment.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = '${Utils.formatNumber(string.replaceAll(',', ''))}';
                      donationCollectedController.value = TextEditingValue(
                        text: string,
                        selection: TextSelection.collapsed(offset: string.length),
                      );
                    },
                    validator: (input){
                      if(input.isEmpty){
                        return "Kindly enter the Donation Collected Amount. If there is no amount collected yet, enter '0' ";
                      }else if(donationNeededController.text.isNotEmpty){
                        if(Utils.unFormatNumber(input)>Utils.unFormatNumber(donationNeededController.text)){
                        return "Your collected donation amount cannot be greater than needed amount";
                      }
                      }
                      return null;
                    },
                    controller: donationCollectedController,
                    decoration: InputDecoration(
                      prefixText: "Rs ",
                        labelText: "Donations Collected",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            )
                        ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors.grey
                            )
                        ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (input){
                      if(input.isEmpty){
                        return "Kindly enter the Goods Collected. If no goods are there just enter a '-' ";
                      }
                      return null;
                    },
                    controller: goodsCollectedController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Goods Collected",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            )
                        ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors.grey
                            )
                        ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,//: MediaQuery.of(context).size.width*0.72,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          validator: (input){
                            if(input==null){
                              return "Please select any "+ widget.isCaseOrEvent +" Type";
                            }
                            return null;
                          },
                          hint: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.isCaseOrEvent +" Type",
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                          value: newCaseTypeValue,
                          icon: const Icon(Icons.keyboard_arrow_down,color: Colors.purple,),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black87),
                          onTap: (){
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (String value) {
                            setState(() {
                              print("new="+value);
                              newCaseTypeValue = value;//">=2.7.0 <3.0.0"
                              if(value=="Case Type"){
                                caseTypeSelected=false;
                              }else{
                                caseTypeSelected=true;
                              }
                            });
                          },
                          items: caseType.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height/40,
                                child: FittedBox(
                                  child: Text(
                                    "Next",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
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
                      /*RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          ),*/
                      /*MaterialStateProperty.all<RoundedRectangleBorder>(

                      ),*/
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        primary: Colors.purple,
                        onPrimary: Colors.pink,
                        minimumSize: Size(MediaQuery.of(context).size.width/2,50)
                    ),
                    onPressed: () {
                      print("Pressed");
                      takeCaseInfo();
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()),);
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
