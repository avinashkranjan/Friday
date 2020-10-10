class Alert {
  final String title;
  final String subject;
  final DateTime time;

  Alert({this.title, this.subject, this.time});
}

List<Alert> recentAlerts = [
  Alert(
    title: "Math Test",
    subject: "Trigonometry",
    time: DateTime.parse("2020-10-11 12:30:00"),
  ),
  Alert(
    title: "Physics Test",
    subject: "Gravitation",
    time: DateTime.parse("2020-10-12 14:30:00"),
  ),
];
