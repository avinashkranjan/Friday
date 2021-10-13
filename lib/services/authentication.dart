import 'package:friday/screens/login_page.dart';
import 'package:friday/screens/signup_additional_details_screen.dart';
import 'package:friday/services/user_info_services.dart';
import 'package:friday/widgets/auth_handling_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Project Imports
import 'package:friday/screens/onboarding_page.dart';
import 'package:friday/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class AuthenticationService {
  /// Handles and Decides Entry Point of App by checking current active session
  static Widget handleEntryPoint(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    print("Handling Auth");
    User _currUser = auth.currentUser;
    if (_currUser == null) {
      return OnboardingPage();
    } else {
      return AuthHandlingWidget(
          name: _currUser.displayName, email: _currUser.email);
    }
  }

  /// Handles Authentication Login
  static Future<String> handleLogin(
      String email, String password, BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String errorMsg;
    try {
      UserCredential userCred = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = userCred.user;
      final User currentUser = auth.currentUser;

      if (user.emailVerified) {
        if ((user != null) &&
            (currentUser != null) &&
            (user.uid == currentUser.uid)) {
          UserInfoServices userInfoServices =
              Provider.of<UserInfoServices>(context, listen: false);
          userInfoServices.fetchUserDetailsFromDatabase(context);
          print(
              "Login succeeded \n Credentials of user=>Email: ${user.email} and  UID: ${user.uid}");
          print("User Logged In");

          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
              .doc("users/${FirebaseAuth.instance.currentUser.uid}")
              .get();

          if (documentSnapshot.data() == null) {
            print("Data Empty");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => SignUpAdditionalDetails()),
              (Route<dynamic> route) => false,
            );

            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      backgroundColor: Colors.black38,
                      title: Text(
                        "You are one step away from successful Log-In",
                        style: TextStyle(color: Colors.white),
                      ),
                      content: Text(
                        "Please Fill the Form to Complete Log-in",
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
          } else {
            // Navigate to Dashboard
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => BottomNavigation()),
              (Route<dynamic> route) => false,
            );

            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      backgroundColor: Colors.black38,
                      title: Text(
                        "Log-in Complete",
                        style: TextStyle(color: Colors.white),
                      ),
                      content: Text(
                        "Enjoy this app",
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
          }
        } else {
          print("Login Error: Undefined Error!");
          errorMsg = "Undefined Error Occured";
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    backgroundColor: Colors.black38,
                    title: Text(
                      "Log-in Error",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Text(
                      "Undefined Error Occured",
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
        }
      } else {
        auth.signOut();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: Colors.black38,
                  title: Text(
                    "Log-in Error",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    "Email not verified.... \nA email with verification link is send to the registered email\nPlease verify at first then log-in",
                    style: TextStyle(color: Colors.white),
                  ),
                ));
      }
    } on FirebaseAuthException catch (_err) {
      print("Login Error: Code: ${_err.code}\nMsg: ${_err.message}");
      errorMsg = _handleLoginError(_err);
    } catch (unknownError) {
      print("Unknown Error: " + unknownError.toString());
      errorMsg = "Undefined Error Occured";
    }

    return errorMsg;
  }

  /// Handles Authentication Sign Up
  static Future<String> handleSignUp({
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

        // Add the name of user
        await user.updateProfile(displayName: name);
        // Set essential details to [UserInfoServices]
        Provider.of<UserInfoServices>(context, listen: false)
            .setEssentialDetailsOfUser(name, email);
        // Navigate to Addtional Details Form

        user.sendEmailVerification(); // Send Email Verification

        FirebaseAuth.instance
            .signOut(); // Without that, If User Sign-Up, then close and reopen the app, can navigate to the
        //bottom_navigation screen

        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
      } else {
        print("SignUp Error: Undefined Error!");
        errorMsg = "Undefined Error Occured";
      }
    } on FirebaseAuthException catch (_err) {
      print("SignUp Error: Code: ${_err.code}\nMsg: ${_err.message}");
      errorMsg = _handleSignUpError(_err);
    } catch (unknownError) {
      print("Unknown Error: " + unknownError.toString());
      errorMsg = "Undefined Error Occured";
    }

    return errorMsg;
  }

  // Function to Sign User out of the App
  static Future<String> signout(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User _currUser = auth.currentUser;
    print("Signing Out: " + _currUser.uid);
    if (_currUser != null) {
      await auth.signOut();
      // Navigate to Onboarding Page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => OnboardingPage()),
        (Route<dynamic> route) => false,
      );
      return "Signing Out";
    } else {
      return "Error Signing out. Try again later";
    }
  }

  /// Function for FirebaseAuthException Handling while Signing Up
  static String _handleSignUpError(FirebaseAuthException _err) {
    String _errorMsg = "Undefined Error Occured";
    if (_err.code == 'email-already-in-use')
      _errorMsg = "User already exist. Try Logging in.";
    else if (_err.code == 'invalid-email')
      _errorMsg = "Invalid Email";
    else if (_err.code == 'weak-password')
      _errorMsg = "Provided password is too weak.";
    return _errorMsg;
  }

  /// Function for FirebaseAuthException Handling while Logging in
  static String _handleLoginError(FirebaseAuthException _err) {
    String _errorMsg = "Undefined Error Occured";
    if (_err.code == 'user-not-found' || _err.code == 'user-disabled')
      _errorMsg = "User does not exist";
    else if (_err.code == 'invalid-email' || _err.code == 'wrong-password')
      _errorMsg = "Invalid Email/Password";
    return _errorMsg;
  }
}
