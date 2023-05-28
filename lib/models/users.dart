import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

enum Gender { Male, Female, Other }
enum Mode { Online, Offline }

class User {
  final String uid;
  String name;
  String email;
  String profilePictureUrl;
  String university;
  String course;
  String department;
  int age;
  int year;
  Gender gender;

  User({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePictureUrl = "",
    required this.university,
    required this.course,
    required this.department,
    required this.age,
    required this.year,
    required this.gender,
  });

  void setEssentialDetails(String name, String email) {
    this.name = name;
    this.email = email;
  }

  void setAdditionalDetails(
    String course,
    String department,
    String university,
    int year,
    Gender gender,
    int age, [
    String profilePictureUrl = "",
    ]) {
    this.course = course;
    this.department = department;
    this.university = university;
    this.year = year;
    this.gender = gender;
    this.age = age;
    this.profilePictureUrl = profilePictureUrl;
  }

  factory User.fromJson(DocumentSnapshot snapshot) {
    Map<String, dynamic>? json = snapshot.data() as Map<String, dynamic>?;
    Gender gender = stringToEnum(json?["gender"] as String);
     return new User(
      uid: snapshot.id,
      name: json?["name"] as String? ?? "",
      email: json?["email"] as String? ?? "",
      profilePictureUrl: json?["profilePictureUrl"] as String? ?? "",
      university: json?["university"] as String? ?? "",
      course: json?["course"] as String? ?? "",
      year: json?["year"] as int? ?? 0,
      department: json?["department"] as String? ?? "",
      age: json?["age"] as int? ?? 0,
      gender: gender,
    );
  }

  Map<String, dynamic> toJson() {
    String gen = enumToString(gender);
    return {
      "name": name,
      "email": email,
      "profilePictureUrl": profilePictureUrl,
      "university": university,
      "course": course,
      "year": year,
      "department": department,
      "age": age,
      "gender": gen,
      "classes": {},
    };
  }
}

// Function to convert Gender enum to String
String enumToString(Gender gender) {
  switch (gender) {
    case Gender.Male:
      return "Male";

    case Gender.Female:
      return "Female";

    default:
      return "Other";

  }
}

// Function to convert Mode enum to String
String modeEnumToString(Mode currMode) {
  switch (currMode) {
    case Mode.Online:
      return "Online";

    default:
      return "Offline";

  }
}

// Function to convert Gender string to enum
Gender stringToEnum(String gen) {
  switch (gen) {
    case "Male":
      return Gender.Male;

    case "Female":
      return Gender.Female;


    default:
      return Gender.Other;

  }
}

