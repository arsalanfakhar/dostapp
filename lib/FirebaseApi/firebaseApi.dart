import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dostapp/model/accountsForDonations.dart';
import 'package:dostapp/model/caseAndEventDetailedInformation.dart';
import 'package:dostapp/model/caseAndEventTransactions.dart';
import 'package:dostapp/model/members.dart';

class FirebaseApi{

  static Future<String> createCaseAndEventTransactions(CaseAndEventTransactions caseAndEventTransactions)async{
    print("Creating Case OR Event Transaction..");
    final docCaseAndEvent=FirebaseFirestore.instance.collection("createCaseAndEventTransactions").doc();
    caseAndEventTransactions.caseOrEventTransactionId=docCaseAndEvent.id;
    await docCaseAndEvent.set(caseAndEventTransactions.toJson());
    print("docCaseOrEvent.id"+docCaseAndEvent.id);
    return docCaseAndEvent.id;
  }
  static Future<String> createCaseAndEventDetailedInformation(CaseAndEventDetailedInformation caseAndEventDetailedInformation,String customCaseOrEventId) async{
    print("Creating Case Detailed Information..");
    final docCaseOrEvent=FirebaseFirestore.instance.collection("CaseAndEventDetailedInformation").doc(customCaseOrEventId);
    caseAndEventDetailedInformation.caseOrEventId=docCaseOrEvent.id;
    await docCaseOrEvent.set(caseAndEventDetailedInformation.toJson());
    print("docCase.id"+docCaseOrEvent.id);
    return docCaseOrEvent.id;
  }
  static Future<String> createMembers(Members members)async{
    print("Creating...");
    final docMem=FirebaseFirestore.instance.collection('Members').doc();
    members.memId=docMem.id;
    await docMem.set(members.toJson());
    print("docMem.id"+docMem.id);
    return docMem.id;
  }

  static Future<List<CaseAndEventTransactions>> readCaseAndEventTransactions(caseId,isCaseOrEvent)async{
    print("Reading Case OR Event Transactions...");
    List<CaseAndEventTransactions> newCaseAndEventTransactionsList=[];
    QuerySnapshot result=await FirebaseFirestore.instance.collection("CaseTransactions").where("caseId",isEqualTo:caseId).where("isCaseOrEvent",isEqualTo: isCaseOrEvent)/*.orderBy("createdAt",descending: false)*/.get();
    List<DocumentSnapshot> documents=result.docs;
    documents.forEach((DocumentSnapshot doc) {
      CaseAndEventTransactions caseAndEventTransactions=CaseAndEventTransactions.fromJson(doc);
      newCaseAndEventTransactionsList.add(caseAndEventTransactions);
      print("newCaseAndEventTransactionsList= "+newCaseAndEventTransactionsList.toString());
    });
    return newCaseAndEventTransactionsList;
  }
  static Future<List<CaseAndEventDetailedInformation>> readCaseAndEventDetailedInformation(isCaseOrEvent) async{
    print("isCaseOrEvent= "+isCaseOrEvent);
    List<CaseAndEventDetailedInformation> newCaseAndEventDetailedInformationList=[];
    QuerySnapshot result=await FirebaseFirestore.instance.collection("CaseAndEventDetailedInformation").where("isCaseOrEvent",isEqualTo: isCaseOrEvent).get();
    List<DocumentSnapshot> documents=result.docs;
    documents.forEach((DocumentSnapshot doc) {
      CaseAndEventDetailedInformation caseAndEventDetailedInformation =CaseAndEventDetailedInformation.fromJson(doc);
      newCaseAndEventDetailedInformationList.add(caseAndEventDetailedInformation);
      print("newCaseAndEventDetailedInformationList= "+newCaseAndEventDetailedInformationList.toString());
    });
    return newCaseAndEventDetailedInformationList;
  }
  static Future<List<CaseAndEventDetailedInformation>> readCaseAndEventDetailedInformationInProgressCasesOrEvents(isCaseOrEvent) async{
    List<CaseAndEventDetailedInformation> newCaseAndEventDetailedInformationInProgressCasesOrEventsList=[];
    QuerySnapshot result=await FirebaseFirestore.instance.collection("CaseAndEventDetailedInformation").where("caseOrEventStatus",isEqualTo: "In Progress").where("isCaseOrEvent",isEqualTo: isCaseOrEvent).get();
    List<DocumentSnapshot> documents=result.docs;
    documents.forEach((DocumentSnapshot doc) {
      CaseAndEventDetailedInformation caseDetailedInformationInProgressCasesOrEvents=CaseAndEventDetailedInformation.fromJson(doc);
      newCaseAndEventDetailedInformationInProgressCasesOrEventsList.add(caseDetailedInformationInProgressCasesOrEvents);
      print("newCaseAndEventDetailedInformationInProgressCasesOrEventsList= "+newCaseAndEventDetailedInformationInProgressCasesOrEventsList.toString());
    });
    return newCaseAndEventDetailedInformationInProgressCasesOrEventsList;
  }
  
  static Future<List<AccountsForDonations>> readAccountsForDonations()async{
    List<AccountsForDonations> newAccounts=[];
    QuerySnapshot result=await FirebaseFirestore.instance.collection("AccountsForDonations").get();
    List<DocumentSnapshot> documents=result.docs;
    documents.forEach((DocumentSnapshot doc) {
      AccountsForDonations accountsForDonations=AccountsForDonations.fromJson(doc);
      newAccounts.add(accountsForDonations);
      print("new Accounts= "+newAccounts.toString());
    });
    return newAccounts;
  }

  static Future updateCaseAndEventDetailedInformation(CaseAndEventDetailedInformation caseDetailedInformation) async{
    print("Updating Case Detailed Information Transactions...");
    final docCaseDetailedInformation=FirebaseFirestore.instance.collection("CaseAndEventDetailedInformation").doc(caseDetailedInformation.caseOrEventId);
    await docCaseDetailedInformation.update(caseDetailedInformation.toJson());
  }

  static Future updateCaseAndEventTransactions(CaseAndEventTransactions caseAndEventTransactions) async {
    final docCaseTransactions=FirebaseFirestore.instance.collection("CaseTransactions").doc(caseAndEventTransactions.caseOrEventId);
    await docCaseTransactions.update(caseAndEventTransactions.toJson());
  }
  static Future deleteCaseAndEventTransactions(CaseAndEventTransactions caseAndEventTransactions) async{
    final docCaseTransactions=FirebaseFirestore.instance.collection("CaseTransactions").doc(caseAndEventTransactions.caseOrEventId);
    await docCaseTransactions.delete();
  }
  // static Stream<List<Members>> readMembers() => FirebaseFirestore.instance.
  //     collection('Members')
  //     .snapshots()
  //     .transform(Utils.transformer(Members.fromJson));

  // static Future <List<Members>>readMember() async{
  //   var firestore=FirebaseFirestore.instance;
  //   QuerySnapshot querySnapshot=await firestore.collection("Members").get();
  //   return querySnapshot.docs;
  // }
  static Future<List<Members>> read() async{
    List<Members> newMembersList = [];

    QuerySnapshot result = await FirebaseFirestore.instance.collection('Members').get();
    List<DocumentSnapshot> documents = result.docs;
    documents.forEach((DocumentSnapshot doc) {
      //Game game = new Game.fromDocument(doc);
      Members members= Members.fromJson(doc);
      newMembersList.add(members);
      print("newMembersList="+newMembersList.toString());
    });

    return newMembersList;
  }

  static Future updateMembers(Members members) async{
    final docMem=FirebaseFirestore.instance.collection("Members").doc(members.memId);
    await docMem.update(members.toJson());
  }
  static Future deleteMembers(Members members) async{
    final docMem=FirebaseFirestore.instance.collection("Members").doc(members.memId);
    await docMem.delete();
  }
}