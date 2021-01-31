import 'package:class_manager/models/users.dart';
import 'package:flutter/material.dart';

// TODO: Update it when connected with Firestore
class UserInfoServices extends ChangeNotifier {
  Users _user = // For testing Purpose
      Users(
    name: "John Doe",
    email: "johndoe@gmail.com",
    university: "Stanford University",
    course: "Bachelor of Science",
    year: 3,
    department: "CSE",
    age: 21,
    gender: Gender.Male,
  );
  bool hasData = true;

  Users get user => _user;
  // TODO: Implement this
  Future<void> fetchUserDetails() async {
    // Write the code to fetch from Firestore Collection `users`
    notifyListeners();
  }
}
