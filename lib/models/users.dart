import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

enum Gender { Male, Female, Other }
enum Mode { Online, Offline }

class Users {
  String uid,
      name,
      email,
      profilePictureUrl,
      university,
      course,
      department,
      collegeID;
  int age, year;
  Gender gender;

  Users({
    this.uid,
    @required this.name,
    @required this.email,
    this.profilePictureUrl,
    @required this.university,
    @required this.course,
    @required this.year,
    @required this.department,
    @required this.collegeID,
    @required this.age,
    @required this.gender,
  });

  Users.setEsssentialDetails(
    String _name,
    String _email,
  ) {
    this.name = _name;
    this.email = _email;
  }

  void setAdditionalDetails(String _course, String _dept, String _college,
      int _year, Gender _gender, int _age,
      [String _profilePicUrl = ""]) {
    this.course = _course;
    this.department = _dept;
    this.university = _college;
    this.year = _year;
    this.gender = _gender;
    this.age = _age;
    this.profilePictureUrl = _profilePicUrl;
  }

  factory Users.fromJson(DocumentSnapshot _snapshot) {
    Map<String, dynamic> json = _snapshot.data();
    Gender _gender = stringToEnum(json["gender"]);
    return new Users(
      uid: _snapshot.id,
      name: json["name"],
      email: json["email"],
      profilePictureUrl: json["profilePictureUrl"],
      university: json["university"],
      course: json["course"],
      year: json["year"],
      department: json["department"],
      collegeID: json['collegeID'],
      age: json["age"],
      gender: _gender,
    );
  }

  Map<String, dynamic> toJson() {
    String _gen = enumToString(gender);
    return {
      "name": name,
      "email": email,
      "profilePictureUrl": profilePictureUrl,
      "university": university,
      "course": course,
      "year": year,
      "department": department,
      "age": age,
      "gender": _gen,
      "classes": {},
    };
  }
}

// Function to convert Gender enum to String
String enumToString(Gender _gen) {
  switch (_gen) {
    case Gender.Male:
      return "Male";
      break;
    case Gender.Female:
      return "Female";
      break;
    default:
      return "Other";
      break;
  }
}

// Function to convert Mode enum to String
String modeEnumToString(Mode _currMode) {
  switch (_currMode) {
    case Mode.Online:
      return "Online";
      break;
    default:
      return "Offline";
      break;
  }
}

// Function to convert Gender enum to String
Gender stringToEnum(String _gen) {
  switch (_gen) {
    case "Male":
      return Gender.Male;
      break;
    case "Female":
      return Gender.Female;

      break;
    default:
      return Gender.Other;
      break;
  }
}
