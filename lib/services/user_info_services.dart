import 'package:friday/models/users.dart';
import 'package:friday/services/user_db_services.dart';
import 'package:flutter/material.dart';

class User {
  late String uid;
  late String profilePictureUrl;
  late String name;
  late String email;
  late String course;
  late String dept;
  late String college;
  late int year;
  late Gender gender;
  late int age;

  User({
    required this.uid,
    required this.profilePictureUrl,
    required this.name,
    required this.email,
    required this.course,
    required this.dept,
    required this.college,
    required this.year,
    required this.gender,
    required this.age,
  });

  User setEssentialDetails(String name, String email) {
    return User(
      uid: this.uid,
      profilePictureUrl: this.profilePictureUrl,
      name: name,
      email: email,
      course: this.course,
      dept: this.dept,
      college: this.college,
      year: this.year,
      gender: this.gender,
      age: this.age,
    );
  }

  void setAdditionalDetails(String course, String dept, String college, int year, Gender gender, int age) {}
}
class UserInfoServices extends ChangeNotifier {
  late User _user;
  bool hasData = false;

  User get user => _user;
  Future<bool> fetchUserDetailsFromDatabase(BuildContext context) async {
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
        _user.uid,
        _user.profilePictureUrl
    );
    // notifyListeners();
  }

  void setUser(User user) {
    this._user = user;
    this.hasData = true;
    notifyListeners();
  }

  void setEssentialDetailsOfUser(String name, String email) {
    this._user = _user.setEssentialDetails(name, email);
  }

  void setAdditionalDetailsOfUser(
    String _course, 
    String _dept, 
    String _college,
    int _year, 
    Gender _gender, 
    int _age,
    [String? _profilePicUrl]) {

    this._user.setAdditionalDetails(_course, _dept, _college, _year, _gender, _age);
    notifyListeners();
  }
}
