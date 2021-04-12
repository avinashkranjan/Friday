import 'package:class_manager/models/users.dart';
import 'package:class_manager/services/user_db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoServices extends ChangeNotifier {
  Users _user;
  bool hasData = false;

  Users get user => _user;
  Future<bool> fetchUserDetailsFromDatabase(context) async {
    // Write the code to fetch from Firestore Collection `users`
    bool isUserExists = await UserDBServices.fetchUserData(context);
    if (!isUserExists) {
      print("user details not present in firestore");
    }
    notifyListeners();
    return isUserExists;
  }

  Future<void> addUserToDatabase() async {
    await UserDBServices.addUser(_user);
    notifyListeners();
  }

  Future<void> upateProfilePictureUrl() async {
    await UserDBServices.updateProfilePictureUrl(
        _user.uid, _user.profilePictureUrl);
    // notifyListeners();
  }

  void setUser(Users _usr) {
    this._user = _usr;
    this.hasData = true;
    notifyListeners();
  }

  void setEssentialDetailsOfUser(String name, String email) {
    this._user = Users.setEsssentialDetails(name, email);
  }

  void setAdditionalDetailsOfUser(String _course, String _dept, String _college,
      int _year, Gender _gender, int _age,
      [String _profilePicUrl]) {
    this
        ._user
        .setAdditionalDetails(_course, _dept, _college, _year, _gender, _age);
    notifyListeners();
  }
}
