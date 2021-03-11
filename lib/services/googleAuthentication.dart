import 'package:class_manager/screens/loading_screen.dart';
import 'package:class_manager/widgets/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:class_manager/services/googleAuthDataFirebaseStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GoogleAuthenticate{
  var googleSignIn;
  BuildContext _context;

  GoogleAuthenticate(this._context){
      googleSignIn = GoogleSignIn();
  }

  Future login() async{
    if(!await googleSignIn.isSignedIn()){
      final user = await googleSignIn.signIn();
      if(user == null) {
        print("Google Sign In Not Completed");
      } else{
        final googleAuth = await user.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        var registeredUser = await FirebaseAuth.instance.signInWithCredential(credential);

        print("Log In Successful " + registeredUser.user.displayName);

        dataStoreInFireStore(this._context, registeredUser);

        Navigator.push(
            this._context,
            MaterialPageRoute(builder: (_) => BottomNavigation()));
      }
    }else {
      print("Already Signed In");
      Navigator.push(
        this._context,
        MaterialPageRoute(builder: (_) => BottomNavigation()));
    }
  }

  Future<bool> logOut() async{
    try {
      googleSignIn.disconnect();
      googleSignIn.signOut();
      FirebaseAuth.instance.signOut();
      return true;
    }catch(e){
      return false;
    }
  }
}