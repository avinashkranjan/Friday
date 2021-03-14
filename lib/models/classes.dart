import 'package:cloud_firestore/cloud_firestore.dart';

class Classes {
  final String subject;
  final String type;
  final String teacherName;
  final DateTime time;
  bool isPassed = false;
  bool isHappening = false;

  Classes({this.subject, this.type, this.teacherName, this.time});

  factory Classes.fromMap(Map<String, dynamic> snapshot) => Classes(
        subject: snapshot['subject'],
        type: snapshot['type'],
        teacherName: snapshot['teacherName'],
        time: (snapshot['time'] != null)
            ? DateTime.parse(snapshot['time'].toDate().toString())
            : null,
      );
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

Future<List<Classes>> getClassList() async {
  List classesMap = [];
  return FirebaseFirestore.instance
      .collection('homework')
      .doc('dummyClasses')
      .get()
      .then((documentSnapshot) {
    classesMap = documentSnapshot.data()['classes'] as List;
    return classesMap.map((e) {
      return Classes.fromMap(e);
    }).toList();
  });
}
