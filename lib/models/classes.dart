class Classes {
  final String subject;
  final String type;
  final String teacherName;
  final String joinLink;
  final DateTime time;
  bool isPassed = false;
  bool isHappening = false;

  Classes({
    required this.subject,
    required this.type,
    required this.teacherName,
    required this.joinLink,
    required this.time,
  });

  factory Classes.fromMap(Map<String, dynamic> snapshot) => Classes(
        subject: snapshot['subject'],
        type: snapshot['type'],
        teacherName: snapshot['teacherName'],
        joinLink: snapshot['joinLink'],
        time: (snapshot['time'] != null)
            ? DateTime.parse(snapshot['time'])
            : DateTime.now(),
      );

  toMap() => {
        'subject': subject,
        'type': type,
        'teacherName': teacherName,
        'joinLink': joinLink,
        'time': time,
      };
}

List<Classes> classes = [
  Classes(
    subject: "Math",
    type: "Online Class",
    teacherName: "Julie Raybon",
    joinLink: "https://example.com",
    time: DateTime.parse("2020-06-04 10:30:00"),
  ),
  Classes(
    subject: "Physics",
    type: "Online Class",
    teacherName: "Robert Murray",
    joinLink: "https://example.com",
    time: DateTime.parse("2020-06-04 14:30:00"),
  ),
  Classes(
    subject: "German",
    type: "Online Class",
    teacherName: "Mary Peterson",
    joinLink: "https://example.com",
    time: DateTime.parse("2020-06-06 06:30:00"),
  ),
  Classes(
    subject: "History",
    type: "Online Class",
    teacherName: "Jim Brooke",
    joinLink: "https://example.com",
    time: DateTime.parse("2020-06-06 07:30:00"),
  ),
];
