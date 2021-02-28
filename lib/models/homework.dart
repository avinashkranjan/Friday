import 'package:cloud_firestore/cloud_firestore.dart';

class Homework {
  final String title;
  final DateTime dueTime;
  bool isDone = false;

  Homework({this.title, this.dueTime});
}

// List<Homework> recentHomeworks = [
//   Homework(
//     title: "Planimetric Exercises",
//     dueTime: DateTime.parse("2020-06-08 10:30:00"),
//   ),
//   Homework(
//     title: "Visicosity Exercises",
//     dueTime: DateTime.parse("2020-06-09 14:30:00"),
//   ),
// ];

Future<List<dynamic>> getHomeworkList() async {
  List<dynamic> homeworkMap = [];
  await FirebaseFirestore.instance
      .collection('homework')
      .doc('dummyCollege')
      .get()
      .then((data) {
    homeworkMap = data.data()['homework'];
  });
  return homeworkMap;
}
