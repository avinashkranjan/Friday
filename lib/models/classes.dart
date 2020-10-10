class Classes {
  final String subject;
  final String type;
  final String teacherName;
  final DateTime time;
  bool isPassed = false;
  bool isHappening = false;

  Classes({this.subject, this.type, this.teacherName, this.time});
}

List<Classes> classes = [
  Classes(
    subject: "Math",
    type: "Online Class",
    teacherName: "Julie Raybon",
    time: DateTime.parse("2020-06-04 10:30:00"),
  ),
  Classes(
    subject: "Physics",
    type: "Online Class",
    teacherName: "Robert Murray",
    time: DateTime.parse("2020-06-04 14:30:00"),
  ),
  Classes(
    subject: "German",
    type: "Online Class",
    teacherName: "Mary Peterson",
    time: DateTime.parse("2020-06-06 06:30:00"),
  ),
  Classes(
    subject: "History",
    type: "Online Class",
    teacherName: "Jim Brooke",
    time: DateTime.parse("2020-06-06 07:30:00"),
  ),
];