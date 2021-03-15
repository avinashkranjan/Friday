import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

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

  toMap() => {
        'subject': subject,
        'type': type,
        'teacherName': teacherName,
        'time': time,
      };
}

Future<List<Classes>> getClassList() async {
  List<Classes> classesList = [];
  return FirebaseFirestore.instance
      .collection('colleges')
      .doc('USICT-BTECH-CSE-3')
      .get()
      .then((documentSnapshot) {
    if (documentSnapshot.exists) {
      final classesMap = documentSnapshot.data()['classes'] as Map;

      classesMap.forEach((key, value) {
        classesList.add(Classes.fromMap(value));
      });
    }
    return classesList;
  });
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

Map<String, Classes> generateDummyClasses() {
  final uuid = Uuid();

  Map<String, Classes> data = {};

  classes.forEach((element) {
    data[uuid.v4()] = element;
  });

  return data;
}

Future<void> addDummyClassesToFirestore() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DocumentReference documentReference =
      _firestore.collection('colleges').doc('USICT-BTECH-CSE-3');
  final Map<String, Classes> classesData = generateDummyClasses();

  documentReference.update({
    'classes': classesData.map((key, value) {
      return MapEntry(key, value.toMap());
    })
  });
}
