import 'package:class_manager/models/users.dart';
import 'package:class_manager/services/user_db_services.dart';
import 'package:flutter/material.dart';

class UserInfoServices extends ChangeNotifier {
  Users _user;
  // = // For testing Purpose
  //     Users(
  //   name: "John Doe",
  //   email: "johndoe@gmail.com",
  //   university: "Stanford University",
  //   course: "Bachelor of Science",
  //   year: 3,
  //   department: "CSE",
  //   age: 21,
  //   gender: Gender.Male,
  // );
  bool hasData = false;

  Users get user => _user;
  Future<void> fetchUserDetailsFromDatabase(context) async {
    // Write the code to fetch from Firestore Collection `users`
    bool isUserExists = await UserDBServices.fetchUserData(context);
    if (!isUserExists) {
      // TODO: Collect user info by showing form
      await UserDBServices.addUser(_user);
      await UserDBServices.fetchUserData(context);
    }
    // notifyListeners();
  }

  Future<void> addUserToDatabase() async {
    await UserDBServices.addUser(_user);
  }

  void setUser(Users _usr) {
    this._user = _usr;
    this.hasData = true;
    notifyListeners();
  }

  void setEssentialDetailsOfUser(String name, String email) {
    this._user.setEsssentialDetails(name, email);
    notifyListeners();
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
