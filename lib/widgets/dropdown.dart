import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dostapp/provider/dostProvider.dart';

class Dropdown extends StatefulWidget {
  final ValueChanged<List> onChanged;
  final bool isMember,isCase;
  final String defaultValue,dropDownHint;
  Dropdown({this.isCase,this.isMember,this.defaultValue,this.dropDownHint,this.onChanged});
  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String _value,emptyDataText;
  dynamic listData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.defaultValue!=null){
      _value=widget.defaultValue;
      print("_value= "+_value);
    }
    //print("IS NULL => _value= "+_value);
  }
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<DostProvider>(context);//listen=true means it will listen multiple times
    if(widget.isMember){
      listData=provider.allMembers;
      emptyDataText="No members!";
    }else if(widget.isCase){
      listData=provider.inProgressCases;
      //print("widget.defaultValue= "+widget.defaultValue);
      print("listData.length= "+listData.length.toString());
      //print("@@@@@@@@@@@@@@@@@@@ listData[0].caseId= "+listData[0].caseId);

      for(int i=0;i<listData.length;i++){
        print("listData="+listData[i].caseOrEventId);
      }
      emptyDataText="No active cases!";
    }else if(!widget.isMember && !widget.isCase){
      emptyDataText="No active events";
      listData=provider.inProgressEvents;
    }
    // print("HERE ===> provider.paidMembers.length "+provider.paidMembers.length.toString());
    // print("HERE ===> provider.unpaidMembers.length= "+provider.unpaidMembers.length.toString());
    // print("HERE ===> length.provider.allMembers="+provider.allMembers.length.toString());
    return listData.isEmpty? SizedBox(
        height: MediaQuery.of(context).size.height/50,
        child: FittedBox(
            child: Text(
                emptyDataText
            )
        )
    ):Container(
      width: !widget.isMember?MediaQuery.of(context).size.width*0.88: MediaQuery.of(context).size.width*0.72,
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
                return "Please select any Case Id\n";
              }
              return null;
            },
            hint: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.dropDownHint,
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            value: _value,//==null?widget.defaultValue:_value,
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
                _value = value;//">=2.7.0 <3.0.0"
                if(!value.contains("Select")){
                  widget.onChanged([value,true]);
                }else{
                  widget.onChanged([value,false]);
                }
              });
            },
            items: listData.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: widget.isMember?value.memName:value.caseOrEventId,
                child: Text(widget.isMember?value.memName:value.caseOrEventId),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
