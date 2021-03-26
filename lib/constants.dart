import 'package:flutter/material.dart';

const kCardColor = Color(0xFF282B30);
const kHourColor = Color(0xFFF5C35A);
const kBGColor = Color(0xFF343537);

const kTextColor = Color(0xFF6C7174);

const kCalendarDay = TextStyle(
  color: kTextColor,
  fontSize: 16.0,
);

const kInputTextStyle = TextStyle(
  color: Colors.white70,
);

// Authentication Constants
const kAuthThemeColor = Colors.deepPurpleAccent;
const int MIN_PASSWORD_LENGTH = 8;
//For canvas designs
const double smallestCircleRadius = 13,
    mediumCircleRadius = 20,
    largestCircleRadius = 30;

// Profile Constants
const double profilePictureDiameter = 120;

// Firestore Constants

const String usersCollection = "users";

UnderlineInputBorder _inputBorderStyle = const UnderlineInputBorder(
  borderSide: BorderSide(
    color: Colors.white70,
  ),
);

InputDecoration dropdownDecoration = InputDecoration(
  isDense: true,
  labelText: "College",
  border: _inputBorderStyle,
  focusedBorder: _inputBorderStyle,
  enabledBorder: _inputBorderStyle,
  focusedErrorBorder: _inputBorderStyle,
  focusColor: Colors.white,
  hintStyle: kInputTextStyle,
  labelStyle: kInputTextStyle,
);
