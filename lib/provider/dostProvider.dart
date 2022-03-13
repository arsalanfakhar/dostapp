import 'package:dostapp/FirebaseApi/firebaseApi.dart';
import 'package:dostapp/model/accountsForDonations.dart';
import 'package:dostapp/model/caseAndEventDetailedInformation.dart';
import 'package:dostapp/model/caseAndEventTransactions.dart';
import 'package:dostapp/model/members.dart';
import 'package:flutter/cupertino.dart';

class DostProvider extends ChangeNotifier{
  List<Members> _members=[];
  List<CaseAndEventTransactions> _caseTransactions=[];
  List<AccountsForDonations> _accountsForDonations=[];
  List<CaseAndEventDetailedInformation> _caseDetailedInformation=[];
  List<CaseAndEventDetailedInformation> _eventDetailedInformation=[];
  List<CaseAndEventDetailedInformation> _inProgressCases=[];
  List<CaseAndEventDetailedInformation> _inProgressEvents=[];

  List<CaseAndEventDetailedInformation> get allCasesDetailedInformation => _caseDetailedInformation;
  List<CaseAndEventDetailedInformation> get allEventsDetailedInformation => _eventDetailedInformation;
  List<CaseAndEventTransactions> get allCaseTransactions => _caseTransactions;
  List<Members> get allMembers => _members;
  List<AccountsForDonations> get allAccountsForDonations => _accountsForDonations;
  //List<CaseTransactions> get completedCases => _caseTransactions.where((dfCase)=> dfCase.caseStatus=="Completed").toList();
  /// When Case whole payment will be done, it will be marked Completed by calling two services; CaseTransactions and CaseDetailedInformation.
  List<CaseAndEventDetailedInformation> get inProgressCases => _inProgressCases; // _caseTransactions.where((dfCase)=> dfCase.caseStatus=="In Progress").toList();
  List<CaseAndEventDetailedInformation> get inProgressEvents => _inProgressEvents;
  //List<CaseTransactions> get abandonedCases => _caseTransactions.where((dfCase)=> dfCase.caseStatus=="Abandoned").toList();
  //List<CaseTransactions> get transferredCases => _caseTransactions.where((dfCase)=> dfCase.caseStatus=="Transferred").toList();
  List<Members> get paidMembers => _members.where((member) => member.donatedCurrentMonth==true).toList();
  List<Members> get unpaidMembers => _members.where((member) => member.donatedCurrentMonth==false).toList();
  /*void setMembers(List<Members> members)=> WidgetsBinding.instance.addPostFrameCallback((_) {
    _members=members;
    print("members.length= "+members.length.toString());
    print("_members.length= "+_members.length.toString());
    notifyListeners();
  });*/

  Future<String> addCaseAndEventDetailedInformation(CaseAndEventDetailedInformation caseAndEventDetailedInformation,String customCaseOrEventId) async {
    return await FirebaseApi.createCaseAndEventDetailedInformation(caseAndEventDetailedInformation,customCaseOrEventId);
  }

  Future updateCaseAndEventDetailedInformation(CaseAndEventDetailedInformation caseAndEventDetailedInformation) async{
    // members.memName=memName;
    // members.memMobileNumber=memMobileNumber;
    // members.currentMonthAmount=currentMonthAmount;
    // members.currentMonthTransactionDate=currentMonthTransactionDate;
    await FirebaseApi.updateCaseAndEventDetailedInformation(caseAndEventDetailedInformation);
  }

  void setEventDetailedInformationInProgressEvents(List<CaseAndEventDetailedInformation> caseDetailedInformationInProgressEvents) =>
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _inProgressEvents=caseDetailedInformationInProgressEvents;
        notifyListeners();
      });
  void setCaseDetailedInformationInProgressCases(List<CaseAndEventDetailedInformation> caseDetailedInformationInProgressCases) =>
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _inProgressCases=caseDetailedInformationInProgressCases;
        notifyListeners();
      });
  void setEventDetailedInformation(List<CaseAndEventDetailedInformation> eventDetailedInformation)=>
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _eventDetailedInformation=eventDetailedInformation;
        notifyListeners();
      });
  void setCaseDetailedInformation(List<CaseAndEventDetailedInformation> caseDetailedInformation)=>
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _caseDetailedInformation=caseDetailedInformation;
        notifyListeners();
      });
  void setAccounts(List<AccountsForDonations> accounts)=>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _accountsForDonations=accounts;
        notifyListeners();
      });

  void setCaseTransactions(List<CaseAndEventTransactions> caseTransactions) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _caseTransactions=caseTransactions;
        notifyListeners();
      });
  Future<String> addCasesAndEventsTransactions(CaseAndEventTransactions caseAndEventTransactions) async{
    return await FirebaseApi.createCaseAndEventTransactions(caseAndEventTransactions);
  }

  void removeCases(CaseAndEventTransactions caseAndEventTransactions) => FirebaseApi.deleteCaseAndEventTransactions(caseAndEventTransactions);

  // String toggleCaseStatus(CaseTransactions dfCaseTransactions,String dfCaseValue){
  //   dfCaseTransactions.caseStatus=dfCaseValue;
  //   FirebaseApi.updateCaseTransactions(dfCaseTransactions);
  //   return dfCaseTransactions.caseStatus;
  // }

  // void updateCase(Cases cases, ) /* Yet to be created */
  void setMembers(List<Members> members) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _members = members;
        print("members.length= "+members.length.toString());
        print("_members.length= "+_members.length.toString());
        notifyListeners();
      });
  Future<String> addMembers(Members members) async{
    return await FirebaseApi.createMembers(members);
  }

  void removeMembers(Members members) => FirebaseApi.deleteMembers(members);

  bool togglePayingStatus(Members member){
    member.donatedCurrentMonth = !member.donatedCurrentMonth;
    FirebaseApi.updateMembers(member);
    return member.donatedCurrentMonth;
  }

  void updateMember(Members members, String memName,String memMobileNumber,int currentMonthAmount,DateTime currentMonthTransactionDate){
    members.memName=memName;
    members.memMobileNumber=memMobileNumber;
    members.currentMonthAmount=currentMonthAmount;
    members.currentMonthTransactionDate=currentMonthTransactionDate;
    FirebaseApi.updateMembers(members);
  }

}