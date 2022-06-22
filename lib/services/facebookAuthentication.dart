import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:friday/screens/signup_additional_details_screen.dart';
import 'package:friday/services/user_info_services.dart';
import 'package:friday/widgets/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class FacebookAuth {
  FacebookLogin facebookSignIn;
  BuildContext _context;

  FacebookAuth(this._context) {
    facebookSignIn = new FacebookLogin();
  }

  void logInViaFacebook() async {
    // Log In Via Fb Registered Email
    final FacebookLoginResult result = await facebookSignIn.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    try {
      // For Firebase Authentication With Facebook
      final credential =
          FacebookAuthProvider.credential(result.accessToken.token);
      final fbUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Facebook Authentication Successful");
      print(fbUser.additionalUserInfo);

      // Data Fetch From Firestore to verify
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: fbUser.user.email)
          .get()
          .then((querySnapShot) {
        if (querySnapShot.docs.isEmpty) {
          // Set essential details to [UserInfoServices]
          Provider.of<UserInfoServices>(this._context, listen: false)
              .setEssentialDetailsOfUser(
                  fbUser.user.displayName, fbUser.user.email);

          // Navigate to Additional Details Form
          Navigator.push(this._context,
              MaterialPageRoute(builder: (_) => SignUpAdditionalDetails()));
        } else {
          // Navigate to the Bottom Navigation Page
          Navigator.push(this._context,
              MaterialPageRoute(builder: (_) => BottomNavigation()));

          // Log-in Successful Notification
          messageShow(this._context, "Logged In", "Enjoy this app");
        }
      });
    } catch (e) {
      messageShow(this._context, "Log In Error",
          "Log-in not Completed or\nEmail of this Account Already Present With Other Credentials");
    }
  }

  Future<bool> logOut() async {
    try {
      await facebookSignIn.logOut();
      print("Logged out");
      return true;
    } catch (e) {
      return false;
    }
  }
}

Future<dynamic> messageShow(
    BuildContext _context, String _title, String _content) {
  return showDialog(
      context: _context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black38,
          title: Text(
            _title,
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            _content,
            style: TextStyle(color: Colors.white),
          ),
        );
      });
}
