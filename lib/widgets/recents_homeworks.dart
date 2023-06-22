import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:friday/constants.dart';
import 'package:friday/models/homework.dart';

class RecentHomeworks extends StatefulWidget {
  @override
  _RecentHomeworksState createState() => _RecentHomeworksState();
}

class _RecentHomeworksState extends State<RecentHomeworks> {
  DateFormat dateFormat = DateFormat("hh:mm a");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getHomeworkList(),
        builder: (context, list) {
          if (!list.hasData) return Center(child: CircularProgressIndicator());
          return homeworkListBuilder(list.data!);
        });
  }

  Widget homeworkListBuilder(List<dynamic> homeworkMap) {
    if (homeworkMap != null) {
      if (homeworkMap.isEmpty)
        return Center(
          child: Text(
            "No Homework",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      else {
        List<Homework> recentHomeworks = [];
        homeworkMap.forEach((element) {
          recentHomeworks.add(Homework(
              title: element['title'],
              dueTime: DateTime.parse(element['dueDate'])));
        });
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recentHomeworks.length,
          itemBuilder: (BuildContext context, int index) {
            Homework homework = recentHomeworks[index];
            return Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 30.0),
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
                  width: MediaQuery.of(context).size.width - 70,
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              homework.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            children: <Widget>[
                              Icon(
                                AntDesign.clockcircle,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 17.0,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                "${DateTime.now().weekday == homework.dueTime.weekday ? "Today" : DateFormat.EEEE().format(homework.dueTime)}, ${dateFormat.format(homework.dueTime)}",
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      _todoButton(homework),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }
    }
    return Text('NULL');
  }

  _todoButton(Homework homework) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          homework.isDone = !homework.isDone;
        });
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        primary: homework.isDone
            ? Theme.of(context).colorScheme.secondary
            : Colors.transparent,
      ),
      child: homework.isDone ? Icon(Icons.check, color: Colors.white) : null,
    );
  }
}
