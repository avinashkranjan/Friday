class Homework {
  final String title;
  final DateTime dueTime;
  bool isDone = false;

  Homework({this.title, this.dueTime});
}

List<Homework> recentHomeworks = [
  Homework(
    title: "Planimetric Exercises",
    dueTime: DateTime.parse("2020-06-08 10:30:00"),
  ),
  Homework(
    title: "Visicosity Exercises",
    dueTime: DateTime.parse("2020-06-09 14:30:00"),
  ),
];