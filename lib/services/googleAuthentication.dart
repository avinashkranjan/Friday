import 'package:class_manager/screens/signup_additional_details_screen.dart';
import 'package:class_manager/widgets/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:class_manager/services/user_info_services.dart';

class GoogleAuthenticate {
  var googleSignIn;
  BuildContext _context;

  GoogleAuthenticate(this._context) {
    googleSignIn = GoogleSignIn();
  }

  Future loginViaGoogle() async {

    try {
      if (!await googleSignIn
          .isSignedIn()) { // Checking If Already Sign In With Google
        final user = await googleSignIn.signIn();
        if (user == null) {
          print("Google Sign In Not Completed");
        } else {
          final googleAuth = await user.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          var registeredUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

          print("Log In Successful " + registeredUser.user.displayName);

          // Data Fetch From Firestore to verify
          FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: registeredUser.user.email)
              .get()
              .then((querySnapShot) {
            if (querySnapShot.docs.isEmpty) {
              // Set essential details to [UserInfoServices]
              Provider.of<UserInfoServices>(this._context, listen: false)
                  .setEssentialDetailsOfUser(
                  registeredUser.user.displayName, registeredUser.user.email);

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
        }
      } else {
        print("Already Signed In");
        Navigator.push(
            this._context,
            MaterialPageRoute(builder: (_) => BottomNavigation()));
      }
    }catch(e){
      messageShow(this._context, "Log In Error", "Log-in not Completed or\nEmail of this Account Already Present With Other Credentials");
    }
  }

  Future<bool> logOut() async {
    try {
      googleSignIn.disconnect();
      googleSignIn.signOut();
      FirebaseAuth.instance.signOut();
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
