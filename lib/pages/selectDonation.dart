import 'package:dostapp/FirebaseApi/firebaseApi.dart';
import 'package:dostapp/model/caseAndEventDetailedInformation.dart';
import 'package:dostapp/model/caseAndEventTransactions.dart';
import 'package:dostapp/model/members.dart';
import 'package:dostapp/provider/dostProvider.dart';
import 'package:dostapp/utils.dart';
import 'package:dostapp/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


class SelectDonation extends StatefulWidget {
  final CaseAndEventDetailedInformation caseAndEventDetailedInformation;
  final String donationType;
  SelectDonation({@required this.donationType,this.caseAndEventDetailedInformation});
  @override
  _SelectDonationState createState() => _SelectDonationState();
}

class _SelectDonationState extends State<SelectDonation> {
  GlobalKey<FormState> formKey=new GlobalKey<FormState>();
  CaseAndEventDetailedInformation caseAndEventDetailedInformation;
  Future myFuture;
  bool isMember,isCase,isNewMember=false;
  double listBoxWidth;
  List<String> list;
  String idText=" ",valueSelected,_accountHolderNameListValue,transactionDate="          ",donationNeeded,donationsCollected,caseOrEventId;
  String remainingStringText="";
  int initialRemainingIntText,remainingIntText;
  List<String> caseAccountsToBeUsed=[];
  _SelectDonationState();
  RoundedLoadingButtonController _roundedLoadingButtonController=new RoundedLoadingButtonController();
  TextEditingController _nameController =new TextEditingController();
  TextEditingController _amountController=new TextEditingController();
  TextEditingController _receiverNameController=new TextEditingController();
  TextEditingController _mobileNumberController=new TextEditingController();
  TextEditingController _transactionDateController=new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Utils.unFormatNumber("1,000,000");
    //Utils.formatNumber("1000000");
    myFuture=setSelectedValue()[3];
    isMember=setSelectedValue()[1];
    isCase=setSelectedValue()[2];
    if(widget.caseAndEventDetailedInformation!=null){
      caseOrEventId=widget.caseAndEventDetailedInformation.caseOrEventId;
      idText=isCase?"CASE ID: "+caseOrEventId:!isCase && !isMember?"Event: "+caseOrEventId:"";
      caseAccountsToBeUsed=widget.caseAndEventDetailedInformation.caseOrEventAccountsToBeUsed;
      donationsCollected=widget.caseAndEventDetailedInformation.donationsCollected;
      donationNeeded=widget.caseAndEventDetailedInformation.donationNeeded;
      caseAndEventDetailedInformation=widget.caseAndEventDetailedInformation;
      initialRemainingIntText=Utils.unFormatNumber(donationNeeded)-Utils.unFormatNumber(donationsCollected);
      remainingIntText=initialRemainingIntText;
      remainingStringText=Utils.formatNumber(remainingIntText.toString());
    }else{
      idText=isCase?"CASE ID: ":!isCase && !isMember?"Event: ":"";
    }
    if(isCase || !isMember){//Case OR Event
      _receiverNameController.text="DOST";
      _mobileNumberController.text="+923341667949";
      valueSelected=caseOrEventId;
    }
  }

  afterThen(value){
    _roundedLoadingButtonController.success();
    Future.delayed(Duration(seconds: 2)).then((value) => _roundedLoadingButtonController.reset());
  }
  onErrors(error, stackTrace){
    _roundedLoadingButtonController.error();
    Future.delayed(Duration(seconds: 2)).then((value) => _roundedLoadingButtonController.reset());
    //Display toast
  }

  void addDonations() async{
    if(formKey.currentState.validate()){
      if(transactionDate=="          "){
        final snackBar = SnackBar(content: Text("Please Select the Transaction Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),padding: EdgeInsets.only(left: 20.0 ,bottom: 20.0),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _roundedLoadingButtonController.stop();
      }else{
        print("Validated");
        final provider=Provider.of<DostProvider>(context,listen: false);
        if(isMember){
          final member=Members(
            currentMonthTransactionDate: DateTime.now(),
            currentMonthAmount: int.parse(_amountController.text),
            donatedCurrentMonth: true,
            memMobileNumber: _mobileNumberController.text,
            memName: _nameController.text,
          );
          final provider=Provider.of<DostProvider>(context,listen: false);
          provider.addMembers(member).then((value){
            afterThen(value);
          })
              .onError((error, stackTrace){
            onErrors(error, stackTrace);
          });
        }else /*if(isCase)*/{
          print("IsCase Or Event");
          print("_amountController.text= "+_amountController.text);
          final caseAndEventTransaction=CaseAndEventTransactions(caseOrEventId: valueSelected,amount: _amountController.text,
              receiverMobileNumber: _mobileNumberController.text,isCaseOrEvent: isCase?"Case":!isMember?"Event":null,
              receiverName: _receiverNameController.text,transactionDate: transactionDate,
              accountHolderName: _accountHolderNameListValue,createdAt: DateTime.now());
          int latestDonation = Utils.unFormatNumber(donationsCollected)+ Utils.unFormatNumber(_amountController.text);
          caseAndEventDetailedInformation.donationsCollected=Utils.formatNumber(latestDonation.toString());
          caseAndEventDetailedInformation.caseOrEventStatus=remainingIntText==0?"Completed":"In Progress";
          caseAndEventDetailedInformation.closingDate=remainingIntText==0?DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString():"";
          // final caseDetailedInformation=CaseDetailedInformation(
          //     caseId: valueSelected,
          //     donationsCollected: Utils.formatNumber(latestDonation.toString()),
          //     caseStatus: remainingIntText==0?"Completed":"In Progress",
          //     closingDate: remainingIntText==0?DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString():""
          // );

          await Future.wait([
            provider.addCasesAndEventsTransactions(caseAndEventTransaction),
            provider.updateCaseAndEventDetailedInformation(caseAndEventDetailedInformation)
          ]).then((value){
            afterThen(value);
          }).onError((error, stackTrace){
            onErrors(error, stackTrace);
          });

          // provider.addCasesTransactions(caseTransaction).then((value){
          //   afterThen(value);
          // })
          //     .onError((error, stackTrace){
          //   onErrors(error, stackTrace);
          // });
          //
          // provider.updateCaseDetailedInformation(caseDetailedInformation);
        }/*else if(!isMember && !isCase){

      }*/
      }
    }else{
      _roundedLoadingButtonController.stop();
      print("Not validated");
    }
  }
  setSelectedValue(){
    if(widget.donationType=="Events Donation"){
      return ["Select Event",false,false,FirebaseApi.readCaseAndEventDetailedInformationInProgressCasesOrEvents("Event")];
    }else if(widget.donationType=="Members Donation"){
      return ["Select Member",true,false,FirebaseApi.read()];
    }else if(widget.donationType=="Cases Donation"){
      return ["Select Case",false,true,FirebaseApi.readCaseAndEventDetailedInformationInProgressCasesOrEvents("Case")];
    }
  }
  showDateDialog(){
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(),
        onChanged: (date) {
          print('change $date');
        },
        onConfirm: (date) {
          setState(() {
              transactionDate=date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString();
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
          "Add "+widget.donationType
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<List<dynamic>>(
                          future: myFuture,
                          builder: (context, snapshot){
                            print("Reading....................................");
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
                                }
                                else{
                                  final dynamic listData=snapshot.data;
                                  print("DATA ====> "+snapshot.data.toString());
                                  print("Length="+snapshot.data.length.toString());
                                  final provider=Provider.of<DostProvider>(context,listen:false);//listen=false means it will listen only once
                                  if(isMember){
                                    provider.setMembers(listData);
                                    //listData=provider.allMembers;
                                    //emptyDataText="No members!";
                                  }else if(isCase){
                                    print("isCase true");
                                    provider.setCaseDetailedInformationInProgressCases(listData);
                                    //listData=provider.inProgressCases;
                                    //emptyDataText="No active cases!";
                                  }else if(!isMember && !isCase){
                                    //emptyDataText="No active events";
                                    provider.setEventDetailedInformationInProgressEvents(listData);
                                  }
                                  // print('data ${snapshot.data[0].memName}');
                                  // print("provider.paidMembers.length "+provider.paidMembers.length.toString());
                                  // print("provider.unpaidMembers.length= "+provider.unpaidMembers.length.toString());
                                  // print("length.provider.allMembers="+provider.allMembers.length.toString());
                                  return Dropdown(
                                    isMember: isMember,
                                    isCase: isCase,
                                    defaultValue: caseOrEventId,
                                    dropDownHint: setSelectedValue()[0],
                                    onChanged: (value){
                                      print("Selected Value= "+value[0]);
                                      setState(() {
                                          int j=0;
                                          if(isMember){
                                            for(int i=0;i<provider.allMembers.length;i++){
                                              if(provider.allMembers[i].memName==value[0]){
                                                j=i;
                                                break;
                                              }
                                            }
                                            isNewMember=false;
                                            _nameController.text=value[0];
                                            _mobileNumberController.text=provider.allMembers[j].memMobileNumber.toString();
                                          }else if(isCase){
                                            print("provider.inProgressCases.length= "+provider.inProgressCases.length.toString());
                                            for(int i=0;i<provider.inProgressCases.length;i++){
                                              if(provider.inProgressCases[i].caseOrEventId==value[0]){
                                                j=i;
                                                break;
                                              }
                                            }
                                            idText="CASE ID: "+value[0];
                                            caseAccountsToBeUsed=provider.inProgressCases[j].caseOrEventAccountsToBeUsed;
                                            donationNeeded=provider.inProgressCases[j].donationNeeded;
                                            donationsCollected=provider.inProgressCases[j].donationsCollected;
                                            caseAndEventDetailedInformation=provider.inProgressCases[j];
                                            setState(() {
                                              initialRemainingIntText=Utils.unFormatNumber(donationNeeded)-Utils.unFormatNumber(donationsCollected);
                                              remainingIntText=initialRemainingIntText;
                                              remainingStringText=Utils.formatNumber(remainingIntText.toString());
                                            });
                                            //_nameController.text=provider.inProgressCases[j]. .caseType.toString();
                                            //_mobileNumberController.text=provider.inProgressCases[j].caseType.toString();
                                          }else if(!isCase && !isMember){
                                            print("provider.inProgressCases.length= "+provider.inProgressEvents.length.toString());
                                            for(int i=0;i<provider.inProgressEvents.length;i++){
                                              if(provider.inProgressEvents[i].caseOrEventId==value[0]){
                                                j=i;
                                                break;
                                              }
                                            }
                                            idText="EVENT ID: "+value[0];
                                            caseAccountsToBeUsed=provider.inProgressEvents[j].caseOrEventAccountsToBeUsed;
                                            donationNeeded=provider.inProgressEvents[j].donationNeeded;
                                            donationsCollected=provider.inProgressEvents[j].donationsCollected;
                                            caseAndEventDetailedInformation=provider.inProgressEvents[j];
                                            setState(() {
                                              initialRemainingIntText=Utils.unFormatNumber(donationNeeded)-Utils.unFormatNumber(donationsCollected);
                                              remainingIntText=initialRemainingIntText;
                                              remainingStringText=Utils.formatNumber(remainingIntText.toString());
                                            });
                                          }

                                          valueSelected=value[0];
                                      });
                                    },
                                  );
                                }
                            }
                          },
                        ),
                        Visibility(
                          visible: isMember,
                          child: Padding(
                            padding: const EdgeInsets.only(left:5.0),
                            child: FloatingActionButton(
                              mini: true,
                                backgroundColor: Colors.purple,
                                child: Icon(Icons.add,color: Colors.white,),//keeptrucking  //creative chaos
                                tooltip: "Add new Member",
                                onPressed: (){
                                setState(() {
                                  isNewMember=true;
                                  _nameController.text="";
                                  _amountController.text="";
                                  _mobileNumberController.text="";
                                  _transactionDateController.text="";
                                  //valueSelected="Select Memberssss";
                                });
                                  print("Icon Button="+isMember.toString());
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                      visible: valueSelected!=null && !isMember?true:false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height/50,
                            child: FittedBox(
                              child: Text(
                                  idText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/50,
                            child: FittedBox(
                              child: Text(
                                "Remaining: "+remainingStringText,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  Visibility(
                    visible: valueSelected!=null && !isMember?true:false,
                    child: Padding(
                      padding: EdgeInsets.only(bottom:10),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.88,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.purple),
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
                                  return "Please select any account holder name\n";
                                }
                                return null;
                              },
                              hint: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Select Account Holder Name",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                              value: _accountHolderNameListValue,//==null?widget.caseDetailedInformation.caseId:_value,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              onTap: (){
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (String value) {
                                setState(() {
                                  print("new="+value);
                                    _accountHolderNameListValue = value;
                                  formKey.currentState.validate();
                                });
                              },
                              isExpanded: true,
                              items: caseAccountsToBeUsed.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                      value,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    )
                  ),
                  Visibility(
                      visible: valueSelected!=null/*valueSelected*/ && isMember?true:false,//valueSelected,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (input) {
                            if (input.isNotEmpty) {
                              return null;
                            } else {
                              return "Kindly enter name";
                            }
                          },
                          //onSaved: (input) => _email = input,
                          //onChanged: (input) => _email = input.trim(),
                          decoration: InputDecoration(
                            //isDense: true,
                            // contentPadding: EdgeInsets.all(8),
                            labelText: "Member name",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            hintText: "",
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
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
                      )
                  ),
                  Visibility(
                      visible: valueSelected!=null?true:false,//valueSelected,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          onChanged: (string) {
                            if(string.length>0){
                              string = '${Utils.formatNumber(string.replaceAll(',', ''))}';
                              _amountController.value = TextEditingValue(
                                text: string,
                                selection: TextSelection.collapsed(offset: string.length),
                              );
                            }
                            if(!isMember){
                              setState(() {
                                if(_amountController.text.length==0){
                                  remainingIntText=initialRemainingIntText-0; //2000-20
                                  remainingStringText=Utils.formatNumber(remainingIntText.toString());
                                }else{
                                  remainingIntText=initialRemainingIntText-Utils.unFormatNumber(_amountController.text); //2000-20
                                  remainingStringText=Utils.formatNumber(remainingIntText.toString());
                                }
                              });
                            }
                          },
                          validator: (input) {
                            //String pattern = r'([0-9])';
                            //RegExp regExp = new RegExp(pattern);
                            if (input.length == 0) {
                              return 'Please enter the amount';
                            }else if(remainingIntText<0){//(Utils.unFormatNumber(input)>remainingIntText)
                              print("remainingIntText= "+remainingIntText.toString());
                              return 'Your amount cannot be greater than the required amount';
                            }
                            // else if (!regExp.hasMatch(input)) {
                            //   return 'Please enter valid mobile number';
                            // }
                            return null;
                          },
                          decoration: InputDecoration(
                            //isDense: true,
                            // contentPadding: EdgeInsets.all(8),
                            prefixText: "Rs ",
                            labelText: "Amount",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            hintText: "",
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
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
                      )
                  ),
                  Visibility(
                      visible: valueSelected!=null/*valueSelected*/ && !isMember?true:false,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          validator: (input){
                            if(input.isEmpty){
                              return "Please enter Receiver Name";
                            }
                            return null;
                          },
                          controller: _receiverNameController,
                          decoration: InputDecoration(
                            labelText: "Receiver Name",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            hintText: "",
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
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
                      )
                  ),
                  Visibility(
                      visible: valueSelected!=null?true:false,//valueSelected,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _mobileNumberController,
                          enabled: isNewMember || isCase,
                          //keyboardType: TextInputType.phone,
                          inputFormatters: [//RegExp(r'([A-Z]{5}[0-9]{4}[A-Z]{1}$)|([A-Z]{5}[0-9]{1,4}$)|[A-Z]{1,5}$')
                            //FilteringTextInputFormatter.allow(RegExp(r'[0-9]{1,10}[+]')),
                            //FilteringTextInputFormatter.allow(RegExp(r'([+]{1}[0-9]{2}[3]{1}$)|([0]{1}[3]{1}$)[0-9]{9}$')),
                            //FilteringTextInputFormatter.allow(RegExp(r'([+]{1}[0-9]$)')),
                            //FilteringTextInputFormatter.allow(RegExp(r'^[5]{1}')),
                            //FilteringTextInputFormatter.allow(RegExp("([+]{1}[0-9]{2}[3]{1}|[0]{1}[3]{1})[0-9]{9}")),
                            //FilteringTextInputFormatter.allow(RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)'))
                            // FilteringTextInputFormatter.allow(RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)'))
                          ],
                          validator: (input) {
                            String pattern = "([+]{1}[0-9]{2}[3]{1}|[0]{1}[3]{1})[0-9]{9}";
                            RegExp regExp = new RegExp(pattern);
                            if (input.length == 0) {
                              return 'Please enter mobile number';
                            }
                            else if (!regExp.hasMatch(input)) {
                              return 'INVALID! Number format: +(2 digit country code) OR 03';
                            }
                            return null;
                          },
                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: isMember?"Mobile Number":"Receiver Mobile Number",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            hintText: "",
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                  Visibility(
                    visible: valueSelected!=null?true:false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: InkWell(
                        onTap: (){
                          FocusScope.of(context).unfocus();
                          showDateDialog();
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
                                      "Select Transaction Date:  ",
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
                                      transactionDate,
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
                    ),
                  ),
                  Visibility(
                    visible: valueSelected!=null?true:false,
                    child: Padding(
                      padding: EdgeInsets.only(bottom:20),
                      child: RoundedLoadingButton(
                        borderRadius: 10,
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
                                      "CONFIRM DONATION",
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
                          print("Pressed");
                          addDonations();
                        }, controller: _roundedLoadingButtonController,
                      ),
                    )
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
