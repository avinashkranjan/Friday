import 'package:flutter/cupertino.dart';

enum Gender { Male, Female, Other }

class Users {
  String uid, name, email, profilePictureUrl, university, course, department;
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
    @required this.age,
    @required this.gender,
  });

  factory Users.fromJson(_snapshot) {
    //DocumentSnapshot
    Map<String, dynamic> json = _snapshot.data();
    Gender _gender = stringToEnum(json["gender"]);
    return new Users(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      profilePictureUrl: json["profilePictureUrl"],
      university: json["university"],
      course: json["course"],
      year: json["year"],
      department: json["department"],
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
