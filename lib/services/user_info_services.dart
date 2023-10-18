import 'package:friday/models/users.dart';
import 'package:friday/services/user_db_services.dart';
import 'package:flutter/material.dart';

class UserInfoServices extends ChangeNotifier {
  Users? _user;
  bool hasData = false;

  Users? get user => _user;
  Future<bool> fetchUserDetailsFromDatabase(BuildContext context) async {
    bool isUserExists = await UserDBServices.fetchUserData(context);
    if (!isUserExists) {
      print("user details not present in firestore");
    }
    notifyListeners();
    return isUserExists;
  }

  Future<void> addUserToDatabase() async {
    if (_user != null) {
      await UserDBServices.addUser(_user!);
      notifyListeners();
    }
  }

  Future<void> upateProfilePictureUrl() async {
    if (_user != null) {
      await UserDBServices.updateProfilePictureUrl(
          _user!.uid, _user!.profilePictureUrl);
      // notifyListeners();
    }
  }

  void setUser(Users user) {
    this._user = user;
    this.hasData = true;
    notifyListeners();
  }

  void setEssentialDetailsOfUser(String name, String email) {
    if (_user != null) {
      _user!.setEssentialDetails(name, email);
    }
  }

  void setAdditionalDetailsOfUser(String _course, String _dept, String _college,
      int _year, Gender _gender, int _age,
      [String? _profilePicUrl]) {
    if (_user != null) {
      this
          ._user!
          .setAdditionalDetails(_course, _dept, _college, _year, _gender, _age);
      notifyListeners();
    }
  }
}
