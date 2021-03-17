import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class CollegeChecker {
  String _enteredCollegeName;
  BuildContext context;

  CollegeChecker(this.context,this._enteredCollegeName);

  Future<bool> collegeEntryChecker() async {
    try {
      var _docTake = await FirebaseFirestore.instance
          .collection('colleges')
          .where(
            FieldPath.documentId,
            isEqualTo: this._enteredCollegeName.toLowerCase(),
          )
          .get();

      if (_docTake.docs.isNotEmpty) {
        print("Exist");
        await messageShow(           this.context, "College Already Exist", "Try Other College Name");
      } else {
        print("Not Exist");
        FirebaseFirestore.instance
            .collection('colleges')
            .doc("${this._enteredCollegeName.toLowerCase()}")
            .set({});
        Navigator.pop(context);
        await messageShow(this.context, "College Name Registered", "Forward");
      }
    } catch (e) {
      print("Fetching Error");
      await messageShow(this.context, "Can't Fetch Data",         "Make Sure your device connected to Internet");
    }
  }
}

Future<Widget> messageShow(
    BuildContext context, String _title, String _content) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black38,
          title: Text(_title, style: TextStyle(color: Colors.white),),
          content: Text(_content, style: TextStyle(color: Colors.white),),
        );
      });
}
