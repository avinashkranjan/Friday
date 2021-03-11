import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void dataStoreInFireStore(BuildContext context, UserCredential _user) {
  FirebaseFirestore.instance
      .collection('googleSignInUsers')
      .where('email', isEqualTo: _user.user.email)
      .get()
      .then((querySnapShot) => {
            if (querySnapShot.docs.isEmpty){
                FirebaseFirestore.instance.collection('googleSignInUsers').add({
                  'email': _user.user.email,
                  'uid': _user.user.uid,
                  'name': _user.user.displayName,
                }).then((value) {
                  print("Google Log-In Successful");
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.black38,
                          title: Text(
                            "Waoo",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            "Google Log-In Successful",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      });
                }).catchError((e) => print(
                    "Google Sign In Authentication Problem....Try it Again"))
              }
            else
              {print("Data Already Exist")}
          });
}
