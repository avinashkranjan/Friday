import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Project Imports
import 'package:class_manager/screens/welcome_screen.dart';
import 'package:class_manager/widgets/bottom_navigation.dart';

class AuthenticationService {
  /// Handles Authentication Login
  static Future<dynamic> handlelogin(
      String email, String password, BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String errorMsg;
    try {
      UserCredential userCred = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = userCred.user;
      final User currentUser = auth.currentUser;

      if ((user != null) &&
          (currentUser != null) &&
          (user.uid == currentUser.uid)) {
        print(
            "Login succeeded \n Credentials of user=>Email: ${user.email} and  UID: ${user.uid}");
        // Navigate to Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => BottomNavigation()),
          ModalRoute.withName('/'),
        );
      } else {
        print("Login Error: Undefined Error!");
        errorMsg = "Undefined Error Occured";
      }
    } on FirebaseAuthException catch (err) {
      print("Login Error: Code: ${err.code}\nMsg: ${err.message}");
      if (err.code == 'user-not-found')
        errorMsg = "User does not exist";
      else
        errorMsg = err.message;
    }

    return errorMsg;
  }

  /// Handles Authentication Sign Up
  static Future<dynamic> handleSignUp({
    @required String name,
    @required String email,
    @required String password,
    @required BuildContext context,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String errorMsg;
    try {
      UserCredential userCred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User user = userCred.user;
      final User currentUser = auth.currentUser;

      if ((user != null) &&
          (currentUser != null) &&
          (user.uid == currentUser.uid)) {
        print(
            "signUpEmail succeeded \n Credentials of user=>Email: ${user.email} and  UID: ${user.uid}");
        // Navigate to Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => BottomNavigation()),
          ModalRoute.withName('/'),
        );
      } else {
        print("SignUp Error: Undefined Error!");
        errorMsg = "Undefined Error Occured";
      }
    } on FirebaseAuthException catch (err) {
      print("SignUp Error: Code: ${err.code}\nMsg: ${err.message}");
      errorMsg = err.message;
    }

    return errorMsg;
  }

  static Future<bool> signout(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    print("Signing Out: " + auth.currentUser.uid);
    await auth.signOut();
    Navigator.of(context).pop();

    // Navigate to Onboarding Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
    return true;
  }
}
